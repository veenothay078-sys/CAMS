import time
import uuid
from typing import Dict, Any, Optional
from sqlalchemy.orm import Session
from app.core.logging import logger
from app.models.chat import ChatSession, ChatMessage
from app.services.llm_service import LLMServiceInterface, get_llm_service
from app.services.database_service import DatabaseService
from app.services.response_formatter import ResponseFormatter

class QueryOrchestrator:
    """
    Coordinates the end-to-end conversational query flow:
    User Prompt -> Intent / Domain Identification -> Safe SQL Generation -> Safe Query Layer -> PostgreSQL -> Response Formatting -> Persistence.
    """

    def __init__(self, db: Session, llm_service: Optional[LLMServiceInterface] = None):
        self.db = db
        self.llm = llm_service or get_llm_service()
        self.db_service = DatabaseService(db)

    async def process_user_query(
        self,
        session_id: str,
        user_message_content: str,
        user_context: Dict[str, Any]
    ) -> Dict[str, Any]:
        start_time = time.perf_counter()

        # 1. Verify or create session
        session = self.db.query(ChatSession).filter(
            ChatSession.id == session_id,
            ChatSession.is_deleted == False
        ).first()

        if not session:
            session = ChatSession(
                id=session_id,
                user_id=user_context.get("id", "usr_admin"),
                title=user_message_content[:40]
            )
            self.db.add(session)
            self.db.commit()

        # 2. Persist user message in chat_messages table
        user_msg = ChatMessage(
            id=f"cm_{uuid.uuid4().hex[:12]}",
            session_id=session.id,
            role="USER",
            content=user_message_content
        )
        self.db.add(user_msg)
        self.db.commit()

        # 3. AI Intent & Safe SQL generation via LLM Service
        user_role = user_context.get("role", "STUDENT")
        user_id = user_context.get("id", "usr_student1")
        llm_plan = await self.llm.generate_sql(
            user_prompt=user_message_content,
            user_role=user_role,
            user_id=user_id
        )

        domain = llm_plan.get("domain", "general")
        intent = llm_plan.get("intent", "inquiry")
        sql_to_execute = llm_plan.get("sql")
        explanation = llm_plan.get("explanation", "")

        # 4. Safe Query Execution
        query_result = self.db_service.execute_safe_query(sql_to_execute)

        # 5. Format natural language response
        if query_result["success"]:
            assistant_content = ResponseFormatter.format_chat_response(
                domain=domain,
                intent=intent,
                records=query_result["data"],
                explanation=explanation
            )
        else:
            assistant_content = f"I encountered an error querying the CAMS database: {query_result.get('error')}"

        # 6. Persist assistant message in chat_messages table (matching PostgreSQL enum 'MODEL')
        assistant_msg = ChatMessage(
            id=f"cm_{uuid.uuid4().hex[:12]}",
            session_id=session.id,
            role="MODEL",
            content=assistant_content
        )
        self.db.add(assistant_msg)
        self.db.commit()

        elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)

        return {
            "session_id": session.id,
            "user_message": {
                "id": user_msg.id,
                "session_id": session.id,
                "role": "USER",
                "content": user_msg.content,
                "created_at": user_msg.created_at
            },
            "assistant_message": {
                "id": assistant_msg.id,
                "session_id": session.id,
                "role": "ASSISTANT",
                "content": assistant_msg.content,
                "created_at": assistant_msg.created_at,
                "metadata": {
                    "domain": domain,
                    "intent": intent,
                    "columns": query_result["columns"],
                    "data": query_result["data"]
                }
            },
            "intent": intent,
            "domain": domain,
            "generated_sql": sql_to_execute,
            "rows_retrieved": query_result["row_count"],
            "execution_time_ms": elapsed_ms
        }
