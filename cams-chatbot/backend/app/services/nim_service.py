import json
import time
import re
from typing import Dict, Any, Optional, List, Tuple
import httpx
from app.core.config import settings
from app.core.logging import logger
from app.chatbot.nim_prompts import INTENT_EXTRACTION_SYSTEM_PROMPT, RESPONSE_SYNTHESIS_SYSTEM_PROMPT

class NIMService:
    """
    NVIDIA NIM (Inference Microservice) integration service.
    Handles communication with OpenAI-compatible NVIDIA NIM endpoints for:
    1. Structured Intent & Entity Extraction (natural language -> controlled JSON)
    2. Natural Language Response Synthesis (database results -> polite, truthful summary)
    """

    SUPPORTED_INTENTS = {
        "student_information",
        "attendance",
        "examination_schedule",
        "marks",
        "courses",
        "timetable",
        "faculty",
        "fees",
        "notices",
        "academic_calendar",
        "unknown"
    }

    ALLOWED_ENTITY_KEYS = {
        "student_name", "roll_no", "student_id", "semester",
        "weekday", "date", "exam_type", "section"
    }

    def __init__(
        self,
        api_key: Optional[str] = None,
        base_url: Optional[str] = None,
        model: Optional[str] = None,
        timeout: Optional[float] = None
    ):
        self.api_key = api_key or settings.NVIDIA_API_KEY or settings.NVIDIA_NIM_API_KEY
        self.base_url = (base_url or settings.NVIDIA_NIM_BASE_URL).rstrip("/")
        self.model = model or settings.NVIDIA_MODEL or settings.NVIDIA_NIM_MODEL
        self.timeout = timeout or settings.NVIDIA_NIM_TIMEOUT_SEC

    @property
    def is_configured(self) -> bool:
        """Checks whether a valid non-empty API key is present."""
        return bool(self.api_key and self.api_key.strip())

    def parse_intent(
        self,
        message: str,
        session_context: Optional[Dict[str, Any]] = None
    ) -> Tuple[Dict[str, Any], Optional[str]]:
        """
        Sends user inquiry to NVIDIA NIM and receives validated structured intent representation.
        Returns: (parsed_intent_dict, error_message)
        """
        if not message or not message.strip():
            return {
                "intent": "unknown",
                "entities": {},
                "requested_output": "summary",
                "requires_clarification": True,
                "clarification_prompt": "Please enter a question or command."
            }, None

        # Build user prompt with conversational context for pronoun resolution
        context_str = ""
        if session_context:
            context_items = []
            if session_context.get("last_student_name"):
                context_items.append(f"Previously mentioned student: {session_context['last_student_name']}")
            if session_context.get("last_roll_no"):
                context_items.append(f"Previously mentioned roll number: {session_context['last_roll_no']}")
            if session_context.get("last_semester"):
                context_items.append(f"Active semester: {session_context['last_semester']}")
            if context_items:
                context_str = f"\n[Session Context: {', '.join(context_items)}]"

        user_content = f"User Question: {message}{context_str}"

        # If API key is not configured, signal configuration error
        if not self.is_configured:
            return {}, "NVIDIA_API_KEY is not configured in environment."

        payload = {
            "model": self.model,
            "messages": [
                {"role": "system", "content": INTENT_EXTRACTION_SYSTEM_PROMPT},
                {"role": "user", "content": user_content}
            ],
            "temperature": 0.1,
            "max_tokens": 512,
            "response_format": {"type": "json_object"}
        }

        start_time = time.perf_counter()
        try:
            headers = {
                "Authorization": f"Bearer {self.api_key}",
                "Content-Type": "application/json"
            }
            with httpx.Client(timeout=self.timeout) as client:
                resp = client.post(f"{self.base_url}/chat/completions", json=payload, headers=headers)

            elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)

            if resp.status_code == 401 or resp.status_code == 403:
                logger.error(f"NVIDIA NIM authentication failure ({resp.status_code}) in {elapsed_ms}ms")
                return {}, "NVIDIA API authentication failed. Please verify your NVIDIA_API_KEY."

            if resp.status_code == 429:
                logger.warning(f"NVIDIA NIM rate limit exceeded in {elapsed_ms}ms")
                return {}, "NVIDIA AI service is temporarily busy (rate limit). Please retry shortly."

            if resp.status_code != 200:
                logger.error(f"NVIDIA NIM returned HTTP {resp.status_code} in {elapsed_ms}ms: {resp.text[:200]}")
                return {}, f"NVIDIA NIM service error (HTTP {resp.status_code})."

            data = resp.json()
            raw_content = data["choices"][0]["message"]["content"]
            logger.info(f"NVIDIA NIM intent parsed successfully in {elapsed_ms}ms using model [{self.model}]")

            # Validate and sanitize LLM JSON output
            validated_output = self._validate_and_sanitize_intent_json(raw_content)
            return validated_output, None

        except httpx.TimeoutException:
            elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)
            logger.error(f"NVIDIA NIM request timed out after {elapsed_ms}ms (timeout={self.timeout}s)")
            return {}, f"NVIDIA AI service timed out ({self.timeout}s limit). Please try again."

        except httpx.ConnectError:
            logger.error("Unable to connect to NVIDIA NIM endpoint.")
            return {}, "Unable to connect to NVIDIA NIM endpoint. Please check network connectivity."

        except Exception as e:
            logger.error(f"Unexpected error calling NVIDIA NIM: {e}")
            return {}, f"Failed to process inquiry with NVIDIA NIM: {str(e)}"

    def synthesize_response(
        self,
        question: str,
        intent: str,
        database_data: List[Dict[str, Any]],
        target_entity: Optional[str] = None
    ) -> Optional[str]:
        """
        Synthesizes a truthful, natural-language explanation of database results via NVIDIA NIM.
        Returns None if API is unavailable, falling back to rule-based formatting.
        """
        if not self.is_configured:
            return None

        # Clamp records to avoid huge context payloads
        clamped_data = database_data[:10] if database_data else []

        user_content = (
            f"User Question: {question}\n"
            f"Query Intent: {intent}\n"
            f"Target Entity: {target_entity or 'N/A'}\n"
            f"Database Records Count: {len(database_data)}\n"
            f"Verified Database Data: {json.dumps(clamped_data, default=str)}"
        )

        payload = {
            "model": self.model,
            "messages": [
                {"role": "system", "content": RESPONSE_SYNTHESIS_SYSTEM_PROMPT},
                {"role": "user", "content": user_content}
            ],
            "temperature": 0.2,
            "max_tokens": 400
        }

        try:
            headers = {
                "Authorization": f"Bearer {self.api_key}",
                "Content-Type": "application/json"
            }
            with httpx.Client(timeout=self.timeout) as client:
                resp = client.post(f"{self.base_url}/chat/completions", json=payload, headers=headers)

            if resp.status_code == 200:
                data = resp.json()
                return data["choices"][0]["message"]["content"].strip()
            return None
        except Exception as e:
            logger.warning(f"NVIDIA NIM response synthesis failed, falling back to standard formatter: {e}")
            return None

    def _validate_and_sanitize_intent_json(self, raw_json_str: str) -> Dict[str, Any]:
        """
        Strictly validates LLM output against the CAMS intent schema.
        Never trusts raw LLM output.
        """
        # Strip potential markdown formatting if model wrapped in ```json ... ```
        cleaned = re.sub(r"^```(?:json)?\s*", "", raw_json_str.strip(), flags=re.IGNORECASE)
        cleaned = re.sub(r"\s*```$", "", cleaned).strip()

        try:
            parsed = json.loads(cleaned)
        except json.JSONDecodeError:
            logger.warning(f"NVIDIA NIM returned malformed JSON: {raw_json_str[:150]}")
            return {
                "intent": "unknown",
                "entities": {},
                "requested_output": "summary",
                "requires_clarification": True,
                "clarification_prompt": "Could you please rephrase your request? I had trouble understanding the specific CAMS domain."
            }

        if not isinstance(parsed, dict):
            return {
                "intent": "unknown",
                "entities": {},
                "requested_output": "summary",
                "requires_clarification": True,
                "clarification_prompt": "I couldn't parse your request. Please try asking about attendance, marks, timetable, or courses."
            }

        # Validate intent
        intent = parsed.get("intent", "unknown")
        if not isinstance(intent, str) or intent.lower() not in self.SUPPORTED_INTENTS:
            intent = "unknown"
        else:
            intent = intent.lower()

        # Validate and sanitize entities
        raw_entities = parsed.get("entities", {})
        sanitized_entities: Dict[str, Any] = {}
        if isinstance(raw_entities, dict):
            for k, v in raw_entities.items():
                if k in self.ALLOWED_ENTITY_KEYS and v is not None and v != "":
                    # Normalize semester
                    if k == "semester":
                        try:
                            sanitized_entities[k] = int(v)
                        except (ValueError, TypeError):
                            pass
                    elif k in ("roll_no", "student_id", "student_name", "weekday", "section", "exam_type", "date"):
                        sanitized_entities[k] = str(v).strip()

        requested_output = parsed.get("requested_output", "summary")
        if requested_output not in ("summary", "table", "text"):
            requested_output = "summary"

        requires_clarification = bool(parsed.get("requires_clarification", False))
        clarification_prompt = parsed.get("clarification_prompt")
        if clarification_prompt and not isinstance(clarification_prompt, str):
            clarification_prompt = str(clarification_prompt)

        return {
            "intent": intent,
            "entities": sanitized_entities,
            "requested_output": requested_output,
            "requires_clarification": requires_clarification,
            "clarification_prompt": clarification_prompt
        }
