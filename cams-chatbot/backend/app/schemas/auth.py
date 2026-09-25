from typing import Optional, List
from pydantic import BaseModel, EmailStr

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    email: str
    role: str
    full_name: str

class UserContext(BaseModel):
    id: str
    email: str
    full_name: str
    role: str
    degree_id: Optional[str] = None
    is_active: bool = True

class DemoUserTokenRequest(BaseModel):
    email: str
