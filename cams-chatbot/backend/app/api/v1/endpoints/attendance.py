from typing import Optional, Dict, Any, List
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from app.database.session import get_db
from app.security.auth import get_current_user
from app.repositories.attendance_repository import AttendanceRepository

router = APIRouter()

@router.get("/summary")
def get_attendance_summary(
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Returns real, authoritative summary metrics calculated from PostgreSQL records.
    Enforces RBAC scoping per authenticated user role.
    """
    repo = AttendanceRepository(db)
    user_role = current_user.get("role", "STUDENT")
    user_id = current_user.get("id")
    return repo.get_summary(user_role=user_role, user_id=user_id)


@router.get("/records")
def get_attendance_records(
    search: Optional[str] = Query(None, description="Search by member name, status, or date"),
    status: Optional[str] = Query("ALL", description="Filter by status (e.g. PRESENT, ABSENT, SUNDAY, REST LEAVE)"),
    date_from: Optional[str] = Query(None, description="Start date (YYYY-MM-DD)"),
    date_to: Optional[str] = Query(None, description="End date (YYYY-MM-DD)"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(15, ge=1, le=100, description="Records per page"),
    sort_by: str = Query("date", description="Field to sort by (date, name, status, source)"),
    sort_order: str = Query("DESC", description="Sort direction (ASC, DESC)"),
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Returns server-side filtered, paginated, and sorted attendance records from PostgreSQL.
    """
    repo = AttendanceRepository(db)
    user_role = current_user.get("role", "STUDENT")
    user_id = current_user.get("id")

    records, total_count = repo.list_records(
        user_role=user_role,
        user_id=user_id,
        search=search,
        status_filter=status,
        date_from=date_from,
        date_to=date_to,
        page=page,
        page_size=page_size,
        sort_by=sort_by,
        sort_order=sort_order
    )

    total_pages = max(1, (total_count + page_size - 1) // page_size)

    return {
        "records": records,
        "total_count": total_count,
        "page": page,
        "page_size": page_size,
        "total_pages": total_pages
    }


@router.get("/risk-panel")
def get_attendance_risk_panel(
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> List[Dict[str, Any]]:
    """
    Returns list of members requiring attendance attention with categorized risk levels.
    """
    repo = AttendanceRepository(db)
    user_role = current_user.get("role", "STUDENT")
    user_id = current_user.get("id")
    return repo.get_risk_panel(user_role=user_role, user_id=user_id)


@router.get("/analytics")
def get_attendance_analytics(
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Returns structured datasets for Bar, Line, and Donut/Pie charts.
    """
    repo = AttendanceRepository(db)
    user_role = current_user.get("role", "STUDENT")
    user_id = current_user.get("id")
    return repo.get_analytics_charts(user_role=user_role, user_id=user_id)


@router.get("/detail/{entity_id}")
def get_attendance_member_detail(
    entity_id: str,
    db: Session = Depends(get_db),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Returns detailed attendance history and statistics for a specific member.
    Enforces privacy and RBAC permissions.
    """
    repo = AttendanceRepository(db)
    user_role = current_user.get("role", "STUDENT")
    user_id = current_user.get("id")

    detail = repo.get_detail(entity_id=entity_id, user_role=user_role, user_id=user_id)
    if not detail:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Member attendance details not found or access is unauthorized."
        )
    return detail
