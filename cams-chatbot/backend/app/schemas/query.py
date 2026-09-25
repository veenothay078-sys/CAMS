from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field

class QueryValidationRequest(BaseModel):
    sql: str = Field(..., description="SQL SELECT query to validate")

class QueryValidationResponse(BaseModel):
    is_valid: bool
    sanitized_sql: Optional[str] = None
    tables_accessed: List[str] = []
    error: Optional[str] = None
    warnings: List[str] = []

class SafeQueryExecuteRequest(BaseModel):
    sql: str = Field(..., description="SQL SELECT query to execute through Safe Query Layer")
    params: Optional[Dict[str, Any]] = None

class SafeQueryExecuteResponse(BaseModel):
    success: bool
    row_count: int
    columns: List[str]
    data: List[Dict[str, Any]]
    execution_time_ms: float
    error: Optional[str] = None

class AllowedTableInfo(BaseModel):
    table_name: str
    domain: str
    row_count: int
    primary_key: str
    accessible_roles: List[str]
