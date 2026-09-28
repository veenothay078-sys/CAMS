import uuid
from typing import Dict, Any, Optional, List
from sqlalchemy.orm import Session
from app.chatbot.query_orchestrator import QueryOrchestrator
from app.chatbot.intent_parser import IntentParserInterface

class ChatService:
    """
    High-level Chat Service managing conversational sessions, session context,
    and invoking QueryOrchestrator for message processing.
    """

    _sessions: Dict[str, Dict[str, Any]] = {}

    def __init__(
        self,
        db: Session,
        intent_parser: Optional[IntentParserInterface] = None,
        nim_service: Optional[Any] = None,
        e2b_service: Optional[Any] = None
    ):
        self.db = db
        self.orchestrator = QueryOrchestrator(
            db,
            intent_parser=intent_parser,
            nim_service=nim_service,
            e2b_service=e2b_service
        )

    def process_message(
        self,
        session_id: Optional[str],
        message: str,
        user_context: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        # 1. Resolve or create session_id
        session_id = session_id or str(uuid.uuid4())
        session = self._get_or_create_session(session_id)
        session_context = session["context"]

        # 2. Record user message in history
        session["history"].append({
            "sender": "user",
            "message": message
        })

        # 3. Process via QueryOrchestrator
        response = self.orchestrator.process_query(
            session_id=session_id,
            message=message,
            user_context=user_context,
            session_context=session_context
        )

        # 4. Extract internal metadata to update conversational context
        entities = response.pop("_entities", {})
        plan = response.pop("_plan", {})
        intent = response.pop("_intent", "unknown")

        self._update_session_context(session_context, entities, plan, response, intent)

        # 5. Record assistant response in history (capped to last 30 turns for memory safety)
        session["history"].append({
            "sender": "assistant",
            "message": response.get("message"),
            "response_type": response.get("response_type"),
            "data": response.get("data"),
            "chart": response.get("chart"),
            "calculation": response.get("calculation")
        })
        if len(session["history"]) > 30:
            session["history"] = session["history"][-30:]

        return response

    def get_session_history(self, session_id: str) -> List[Dict[str, Any]]:
        session = self._sessions.get(session_id)
        if not session:
            return []
        return session.get("history", [])

    def _get_or_create_session(self, session_id: str) -> Dict[str, Any]:
        if session_id not in self._sessions:
            self._sessions[session_id] = {
                "session_id": session_id,
                "context": {},
                "history": []
            }
        return self._sessions[session_id]

    def _update_session_context(
        self,
        session_context: Dict[str, Any],
        entities: Dict[str, Any],
        plan: Dict[str, Any],
        response: Dict[str, Any],
        intent: Optional[str] = None
    ) -> None:
        """
        Updates session context so conversational follow-ups ('his', 'her', 'their', 'the student')
        correctly inherit prior entities across turns, while cleanly resetting prior student IDs
        when a different student is introduced.
        """
        if intent and intent != "unknown":
            session_context["last_intent"] = intent

        # Student Name Switch Detection
        new_name = entities.get("student_name")
        if new_name:
            if session_context.get("last_student_name") and session_context["last_student_name"].lower() != new_name.lower():
                # Switch student: clear previously associated roll number & student ID
                session_context.pop("last_roll_no", None)
                session_context.pop("last_student_id", None)
            session_context["last_student_name"] = new_name

        # Roll Number Switch Detection
        new_roll = entities.get("roll_no")
        if new_roll:
            if session_context.get("last_roll_no") and session_context["last_roll_no"].upper() != new_roll.upper():
                session_context.pop("last_student_name", None)
                session_context.pop("last_student_id", None)
            session_context["last_roll_no"] = new_roll

        if entities.get("student_id"):
            session_context["last_student_id"] = entities["student_id"]
        if entities.get("semester"):
            session_context["last_semester"] = entities["semester"]

        # If database result returned student details, update session context
        data = response.get("data")
        if data and isinstance(data, list) and len(data) > 0 and isinstance(data[0], dict):
            first_row = data[0]
            if first_row.get("roll_no"):
                session_context["last_roll_no"] = first_row["roll_no"]
            if first_row.get("student_name") or first_row.get("full_name"):
                session_context["last_student_name"] = first_row.get("student_name") or first_row.get("full_name")
            if first_row.get("student_id"):
                session_context["last_student_id"] = first_row["student_id"]
            if first_row.get("semester"):
                session_context["last_semester"] = first_row["semester"]
