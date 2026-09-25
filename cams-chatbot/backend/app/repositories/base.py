from typing import Dict, Any, List, Optional
from sqlalchemy.orm import Session
from app.services.safe_query_service import SafeQueryService

class BaseRepository:
    """Base repository providing standardized read-only queries through SafeQueryService."""

    def __init__(self, db: Session):
        self.db = db
        self.safe_service = SafeQueryService(db)

    def execute_query(self, sql: str, params: Optional[Dict[str, Any]] = None, user_role: str = "STUDENT") -> List[Dict[str, Any]]:
        result = self.safe_service.execute_safe_query(sql, params, user_role=user_role)
        if not result["success"]:
            raise RuntimeError(f"Repository query failed: {result['error']}")
        return result["data"]
