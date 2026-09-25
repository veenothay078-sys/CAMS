import uuid
from typing import List, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database.session import get_db
from app.models.chat import ChatSession, ChatMessage
from app.schemas.chat import (
    ChatSessionCreate, ChatSessionResponse,
    ChatMessageCreate, ChatMessageResponse,
    ChatQueryResponse
)
from app.security.auth import get_current_user
from app.services.query_orchestrator import QueryOrchestrator

router = APIRouter()


@router.post("/sessions", response_model=ChatSessionResponse)
def create_session(
    request: ChatSessionCreate,
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Creates a new conversational chat session in CAMS chat_sessions table."""
    session = ChatSession(
        id=f"cs_{uuid.uuid4().hex[:12]}",
        user_id=current_user.get("id", "usr_admin"),
        title=request.title or "New Conversation"
    )
    db.add(session)
    db.commit()
    db.refresh(session)

    return ChatSessionResponse(
        id=session.id,
        user_id=session.user_id,
        title=session.title,
        is_active=session.is_active,
        created_at=session.created_at,
        updated_at=session.updated_at,
        message_count=0
    )


@router.get("/sessions", response_model=List[ChatSessionResponse])
def list_sessions(
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Retrieves all chat sessions for the authenticated user."""
    sessions = db.query(ChatSession).filter(
        ChatSession.user_id == current_user.get("id"),
        ChatSession.is_deleted == False
    ).order_by(ChatSession.updated_at.desc()).all()

    response = []
    for s in sessions:
        count = db.query(ChatMessage).filter(
            ChatMessage.session_id == s.id,
            ChatMessage.is_deleted == False
        ).count()
        response.append(
            ChatSessionResponse(
                id=s.id,
                user_id=s.user_id,
                title=s.title,
                is_active=s.is_active,
                created_at=s.created_at,
                updated_at=s.updated_at,
                message_count=count
            )
        )
    return response


@router.get("/sessions/{session_id}/messages", response_model=List[ChatMessageResponse])
def get_session_messages(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Retrieves all messages for a specific session."""
    session = db.query(ChatSession).filter(
        ChatSession.id == session_id,
        ChatSession.is_deleted == False
    ).first()

    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Chat session not found"
        )

    messages = db.query(ChatMessage).filter(
        ChatMessage.session_id == session_id,
        ChatMessage.is_deleted == False
    ).order_by(ChatMessage.created_at.asc()).all()

    return [
        ChatMessageResponse(
            id=m.id,
            session_id=m.session_id,
            role="ASSISTANT" if (m.role.value if hasattr(m.role, 'value') else m.role) == "MODEL" else (m.role.value if hasattr(m.role, 'value') else m.role),
            content=m.content,
            created_at=m.created_at
        )
        for m in messages
    ]


@router.post("/sessions/{session_id}/messages", response_model=ChatQueryResponse)
async def send_message(
    session_id: str,
    message: ChatMessageCreate,
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Processes user question through Query Orchestrator and returns AI response."""
    orchestrator = QueryOrchestrator(db)
    result = await orchestrator.process_user_query(
        session_id=session_id,
        user_message_content=message.content,
        user_context=current_user
    )
    return result


@router.delete("/sessions/{session_id}")
def delete_session(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Soft deletes a chat session."""
    session = db.query(ChatSession).filter(
        ChatSession.id == session_id,
        ChatSession.user_id == current_user.get("id"),
        ChatSession.is_deleted == False
    ).first()

    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")

    session.is_deleted = True
    db.commit()
    return {"message": "Session deleted successfully"}
