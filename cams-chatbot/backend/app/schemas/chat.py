from datetime import datetime
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field

class ChatMessageCreate(BaseModel):
    content: str = Field(..., min_length=1, max_length=4000)

class ChatMessageResponse(BaseModel):
    id: str
    session_id: str
    role: str
    content: str
    created_at: datetime
    metadata: Optional[Dict[str, Any]] = None

    class Config:
        from_attributes = True

class ChatSessionCreate(BaseModel):
    title: Optional[str] = "New Conversation"

class ChatSessionResponse(BaseModel):
    id: str
    user_id: str
    title: str
    is_active: bool
    created_at: datetime
    updated_at: datetime
    message_count: Optional[int] = 0

    class Config:
        from_attributes = True

class ChatQueryResponse(BaseModel):
    session_id: str
    user_message: ChatMessageResponse
    assistant_message: ChatMessageResponse
    intent: Optional[str] = None
    domain: Optional[str] = None
    generated_sql: Optional[str] = None
    rows_retrieved: Optional[int] = 0
    execution_time_ms: Optional[float] = 0.0
