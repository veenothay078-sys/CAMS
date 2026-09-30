from abc import ABC, abstractmethod
from typing import Optional, Dict, Any, Tuple
import re
from app.core.logging import logger
from app.services.nim_service import NIMService

class IntentParseResult:
    """
    Standardized result from intent parsing, containing intent, entities,
    clarification requirements, and error flags.
    """
    def __init__(
        self,
        intent: str,
        confidence: float = 1.0,
        entities: Optional[Dict[str, Any]] = None,
        requested_output: str = "summary",
        requires_clarification: bool = False,
        clarification_prompt: Optional[str] = None,
        error: Optional[str] = None
    ):
        self.intent = intent
        self.confidence = confidence
        self.entities = entities or {}
        self.requested_output = requested_output
        self.requires_clarification = requires_clarification
        self.clarification_prompt = clarification_prompt
        self.error = error

    def to_tuple(self) -> Tuple[str, float]:
        """Provides backwards compatibility with methods expecting (intent, confidence)."""
        return self.intent, self.confidence


class IntentParserInterface(ABC):
    """
    Abstract interface for intent extraction.
    """

    @abstractmethod
    def parse_intent(self, text: str, session_context: Optional[Dict[str, Any]] = None) -> IntentParseResult:
        """
        Parses user query and returns IntentParseResult.
        """
        pass


class TemporaryIntentParser(IntentParserInterface):
    """
    TEMPORARY / DETERMINISTIC INTENT PROVIDER.
    Used for offline testing and baseline verification without LLM calls.
    Maps natural language patterns to the 10 initial supported CAMS intents.
    """

    INTENT_PATTERNS = [
        # 1. Attendance
        (
            "attendance",
            re.compile(r"\b(attendance|present|absent|absentee|attendance percentage|attended)\b", re.IGNORECASE)
        ),
        # 2. Examination Schedule
        (
            "examination_schedule",
            re.compile(r"\b(exam|exams|examination|examinations|exam schedule|hall ticket|seating|test schedule)\b", re.IGNORECASE)
        ),
        # 3. Marks & Assessment
        (
            "marks",
            re.compile(r"\b(mark|marks|grade|grades|gpa|cgpa|score|scores|internal mark|internal marks|assessment)\b", re.IGNORECASE)
        ),
        # 4. Timetable
        (
            "timetable",
            re.compile(r"\b(timetable|schedule|class schedule|period|periods|monday|tuesday|wednesday|thursday|friday|saturday)\b", re.IGNORECASE)
        ),
        # 5. Courses & Curriculum
        (
            "courses",
            re.compile(r"\b(course|courses|subject|subjects|curriculum|syllabus|credits|credit)\b", re.IGNORECASE)
        ),
        # 6. Faculty
        (
            "faculty",
            re.compile(r"\b(faculty|teacher|teachers|professor|professors|staff|instructor|instructors|hod|principal)\b", re.IGNORECASE)
        ),
        # 7. Fees
        (
            "fees",
            re.compile(r"\b(fee|fees|dues|payment|payments|tuition|paid|pending fee)\b", re.IGNORECASE)
        ),
        # 8. Notices & Circulars
        (
            "notices",
            re.compile(r"\b(notice|notices|notification|notifications|announcement|announcements|circular|circulars|bulletin)\b", re.IGNORECASE)
        ),
        # 9. Academic Calendar
        (
            "academic_calendar",
            re.compile(r"\b(calendar|holiday|holidays|working day|academic year|vacation|semester break|events)\b", re.IGNORECASE)
        ),
        # 10. Student Information
        (
            "student_information",
            re.compile(r"\b(student|students|user|users|profile|roll no|roll number|enrollment|who is|details of)\b", re.IGNORECASE)
        ),
    ]

    def parse_intent(self, text: str, session_context: Optional[Dict[str, Any]] = None) -> IntentParseResult:
        if not text or not text.strip():
            return IntentParseResult(
                intent="unknown",
                confidence=0.0,
                requires_clarification=True,
                clarification_prompt="Please provide a query."
            )

        cleaned = text.strip()
        for intent_name, pattern in self.INTENT_PATTERNS:
            if pattern.search(cleaned):
                return IntentParseResult(intent=intent_name, confidence=0.95)

        return IntentParseResult(
            intent="unknown",
            confidence=0.0,
            requires_clarification=True,
            clarification_prompt=(
                "I couldn't identify what you're asking for. You can ask about "
                "student information, attendance, exam schedules, marks, courses, "
                "timetable, faculty, fees, notices, or the academic calendar."
            )
        )


class NvidiaNimIntentParser(IntentParserInterface):
    """
    NVIDIA NIM Intent Provider.
    Calls NVIDIA NIM LLM to convert natural language inquiries into validated structured intents.
    """

    def __init__(
        self,
        nim_service: Optional[NIMService] = None,
        fallback_on_missing_key: bool = True
    ):
        self.nim_service = nim_service or NIMService()
        self.fallback_on_missing_key = fallback_on_missing_key
        self._fallback_parser = TemporaryIntentParser()

    def parse_intent(
        self,
        text: str,
        session_context: Optional[Dict[str, Any]] = None
    ) -> IntentParseResult:
        # Check if NIM API key is configured
        if not self.nim_service.is_configured:
            if self.fallback_on_missing_key:
                logger.info("NVIDIA_API_KEY is not configured; using deterministic parser fallback.")
                return self._fallback_parser.parse_intent(text, session_context)
            return IntentParseResult(
                intent="unknown",
                error="NVIDIA AI configuration missing: Please set NVIDIA_API_KEY in your environment."
            )

        # Call NVIDIA NIM
        parsed_data, err = self.nim_service.parse_intent(text, session_context)
        if err:
            return IntentParseResult(intent="unknown", error=err)

        return IntentParseResult(
            intent=parsed_data.get("intent", "unknown"),
            confidence=0.95,
            entities=parsed_data.get("entities", {}),
            requested_output=parsed_data.get("requested_output", "summary"),
            requires_clarification=parsed_data.get("requires_clarification", False),
            clarification_prompt=parsed_data.get("clarification_prompt")
        )
