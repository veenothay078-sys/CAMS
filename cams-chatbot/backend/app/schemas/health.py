from datetime import datetime
from typing import Optional
from pydantic import BaseModel

class HealthResponse(BaseModel):
    status: str
    environment: str
    timestamp: datetime
    version: str
    database_connected: bool
    database_tables_count: int
    database_error: Optional[str] = None
