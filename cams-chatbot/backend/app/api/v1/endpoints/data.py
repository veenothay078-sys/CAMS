from typing import List, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database.session import get_db
from app.security.auth import get_current_user
from app.services.safe_query_service import SafeQueryService
from app.services.structured_intent import StructuredQueryIntent, IntentQueryBuilder
from app.security.query_validator import QueryValidator
from app.chatbot.domains import CHATBOT_DOMAINS
from app.repositories.student_repository import StudentRepository
from app.repositories.notices_repository import NoticesRepository
from app.repositories.calendar_repository import CalendarRepository

router = APIRouter()


@router.get("/domains")
def get_supported_domains(current_user: Dict[str, Any] = Depends(get_current_user)):
    """Returns the 10 priority CAMS domains and their capabilities."""
    return CHATBOT_DOMAINS


@router.post("/query")
def execute_structured_intent_query(
    intent_req: StructuredQueryIntent,
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """
    Controlled query execution.
    Translates StructuredQueryIntent into parameterized safe SQL scoped to current user.
    """
    sql, params = IntentQueryBuilder.build_query(intent_req, current_user)
    user_role = current_user.get("role", "STUDENT")

    safe_service = SafeQueryService(db)
    result = safe_service.execute_safe_query(sql, params, user_role=user_role)

    if not result["success"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=result["error"]
        )

    return {
        "domain": intent_req.domain,
        "intent": intent_req.intent,
        "row_count": result["row_count"],
        "columns": result["columns"],
        "data": result["data"],
        "execution_time_ms": result["execution_time_ms"]
    }


@router.post("/validate-sql")
def validate_candidate_sql(
    payload: Dict[str, str],
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Diagnostic tool to test candidate SQL against Safe Query Layer policies."""
    sql = payload.get("sql", "")
    user_role = current_user.get("role", "STUDENT")
    is_valid, sanitized, tables, error = QueryValidator.validate(sql, user_role=user_role)

    return {
        "is_valid": is_valid,
        "sanitized_sql": sanitized,
        "tables_detected": tables,
        "error": error
    }


@router.get("/students/me")
def get_my_student_profile(
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Safe read-only endpoint returning student profile for the authenticated user."""
    repo = StudentRepository(db)
    profile = repo.get_by_user_id(current_user.get("id"), user_role=current_user.get("role", "STUDENT"))
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Student profile not found for this user account"
        )
    return profile


@router.get("/notices/recent")
def get_recent_notices(
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Safe read-only endpoint returning published campus notices."""
    repo = NoticesRepository(db)
    return repo.list_published(user_role=current_user.get("role", "STUDENT"))


@router.get("/calendar/years")
def get_academic_years(
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """Safe read-only endpoint returning academic year terms."""
    repo = CalendarRepository(db)
    return repo.list_academic_years(user_role=current_user.get("role", "STUDENT"))
