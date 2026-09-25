from typing import Optional, Dict, Any, List
from app.repositories.base import BaseRepository

class TimetableRepository(BaseRepository):
    """Data access repository for class timetables domain."""

    def list_by_weekday(self, weekday: str, user_role: str = "STUDENT") -> List[Dict[str, Any]]:
        sql = """
            SELECT t.weekday, t.start_time, t.end_time, t.room,
                   c.name AS subject_name, c.code AS subject_code,
                   sec.section_name, u.full_name AS faculty_name
            FROM timetable t
            JOIN courses c ON t.subject_id = c.id
            JOIN sections sec ON t.section_id = sec.id
            JOIN users u ON t.faculty_id = u.id
            WHERE t.is_deleted = false AND t.weekday = :weekday
            ORDER BY t.start_time
        """
        return self.execute_query(sql, {"weekday": weekday.upper()}, user_role=user_role)
