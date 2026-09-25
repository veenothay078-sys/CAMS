from typing import Optional, Dict, Any, List
from app.repositories.base import BaseRepository

class CoursesRepository(BaseRepository):
    """Data access repository for courses & curriculum domain."""

    def list_all(self, semester: Optional[int] = None, user_role: str = "STUDENT") -> List[Dict[str, Any]]:
        sql = """
            SELECT c.code, c.name, c.credits, c.semester, d.name AS degree_name
            FROM courses c
            JOIN degrees d ON c.degree_id = d.id
            WHERE c.is_deleted = false
        """
        params = {}
        if semester:
            sql += " AND c.semester = :semester"
            params["semester"] = semester
        sql += " ORDER BY c.semester, c.code"
        return self.execute_query(sql, params, user_role=user_role)
