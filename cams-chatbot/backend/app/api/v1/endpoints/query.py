from typing import List, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database.session import get_db
from app.schemas.query import (
    QueryValidationRequest, QueryValidationResponse,
    SafeQueryExecuteRequest, SafeQueryExecuteResponse,
    AllowedTableInfo
)
from app.security.auth import get_current_user
from app.security.safe_query import ALLOWED_CHATBOT_TABLES
from app.services.query_validator import QueryValidatorService
from app.services.database_service import DatabaseService
from app.chatbot.domains import CHATBOT_DOMAINS

router = APIRouter()


@router.post("/validate", response_model=QueryValidationResponse)
def validate_query(
    request: QueryValidationRequest,
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Audits and validates a candidate SQL query against Safe Query Layer rules."""
    result = QueryValidatorService.validate(request.sql)
    return QueryValidationResponse(**result)


@router.post("/execute", response_model=SafeQueryExecuteResponse)
def execute_safe_query(
    request: SafeQueryExecuteRequest,
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Executes a validated read-only SQL query through Safe Query Layer."""
    db_service = DatabaseService(db)
    result = db_service.execute_safe_query(request.sql, request.params)
    return SafeQueryExecuteResponse(**result)


@router.get("/tables", response_model=List[AllowedTableInfo])
def list_allowed_tables(current_user: Dict[str, Any] = Depends(get_current_user)):
    """Lists all approved CAMS tables accessible for natural language querying."""
    tables_list = []
    for tbl in sorted(ALLOWED_CHATBOT_TABLES):
        tables_list.append(
            AllowedTableInfo(
                table_name=tbl,
                domain="Academic / Administrative",
                row_count=0,
                primary_key="id",
                accessible_roles=["SUPER_ADMIN", "ADMIN", "PRINCIPAL", "HOD", "FACULTY", "STUDENT", "PARENT"]
            )
        )
    return tables_list


@router.get("/domains")
def list_chatbot_domains(current_user: Dict[str, Any] = Depends(get_current_user)):
    """Returns the 10 priority chatbot domains and sample prompts."""
    return CHATBOT_DOMAINS
