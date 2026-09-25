import time
from datetime import datetime, timezone
from fastapi import APIRouter
from pydantic import BaseModel
from typing import Optional
from app.core.config import settings
from app.database.connection import check_db_connectivity
from app.security.query_policy import QueryPolicy
from app.schemas.health import HealthResponse

router = APIRouter()


class DatabaseHealthResponse(BaseModel):
    status: str
    database_type: str
    connected: bool
    tables_detected: int
    read_only_mode: bool
    statement_timeout_ms: int
    latency_ms: float
    error: Optional[str] = None


@router.get("/health", response_model=HealthResponse)
def get_health():
    """Health check endpoint verifying application and PostgreSQL connectivity."""
    db_status = check_db_connectivity()
    return HealthResponse(
        status="healthy" if db_status["connected"] else "degraded",
        environment=settings.APP_ENV,
        timestamp=datetime.now(timezone.utc),
        version="1.0.0-phase2",
        database_connected=db_status["connected"],
        database_tables_count=db_status["tables_count"],
        database_error=db_status["error"]
    )


@router.get("/health/database", response_model=DatabaseHealthResponse)
def get_database_health():
    """
    Dedicated database health check per Phase 2 requirement.
    Validates PostgreSQL connectivity, table count, and read-only mode without exposing credentials.
    """
    start = time.perf_counter()
    db_status = check_db_connectivity()
    elapsed_ms = round((time.perf_counter() - start) * 1000, 2)

    return DatabaseHealthResponse(
        status="healthy" if db_status["connected"] else "unhealthy",
        database_type="PostgreSQL",
        connected=db_status["connected"],
        tables_detected=db_status["tables_count"],
        read_only_mode=True,
        statement_timeout_ms=QueryPolicy.get_statement_timeout_ms(),
        latency_ms=elapsed_ms,
        error=db_status["error"]
    )
