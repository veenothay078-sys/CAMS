from typing import Optional, Dict, Any, List
from app.repositories.base import BaseRepository

class CalendarRepository(BaseRepository):
    """Data access repository for academic calendar & years domain."""

    def list_academic_years(self, user_role: str = "STUDENT") -> List[Dict[str, Any]]:
        sql = """
            SELECT ay.name AS academic_year, ay.start_date, ay.end_date,
                   ay.current_semester, ay.is_active, d.name AS degree_name
            FROM academic_years ay
            LEFT JOIN degrees d ON ay.degree_id = d.id
            WHERE ay.is_deleted = false
            ORDER BY ay.start_date DESC
        """
        return self.execute_query(sql, user_role=user_role)
