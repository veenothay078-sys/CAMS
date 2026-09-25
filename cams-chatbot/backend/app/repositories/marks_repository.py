from typing import Optional, Dict, Any, List
from app.repositories.base import BaseRepository

class MarksRepository(BaseRepository):
    """Data access repository for marks and internal assessment domain."""

    def get_by_student_user_id(self, student_user_id: str, user_role: str = "STUDENT") -> List[Dict[str, Any]]:
        sql = """
            SELECT im.academic_year, im.semester, c.name AS subject_name, c.code AS subject_code,
                   im.internal_exam_mark, im.assignment_mark, im.presentation_mark,
                   im.viva_voice_mark, im.attendance_mark, im.total_mark, im.status
            FROM internal_marks im
            JOIN courses c ON im.subject_id = c.id
            WHERE im.is_deleted = false AND im.student_id = :student_user_id
        """
        return self.execute_query(sql, {"student_user_id": student_user_id}, user_role=user_role)
