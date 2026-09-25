from typing import Optional, Dict, Any, List
from app.repositories.base import BaseRepository

class AttendanceRepository(BaseRepository):
    """Data access repository for attendance tracking domain."""

    def list_recent(self, user_role: str = "STUDENT", limit: int = 20) -> List[Dict[str, Any]]:
        sql = """
            SELECT a.date, a.hour, c.name AS subject_name, c.code AS subject_code,
                   sec.section_name, a.approval_status
            FROM attendance a
            JOIN courses c ON a.subject_id = c.id
            JOIN sections sec ON a.section_id = sec.id
            WHERE a.is_deleted = false
            ORDER BY a.date DESC, a.hour ASC
        """
        return self.execute_query(sql, user_role=user_role)
