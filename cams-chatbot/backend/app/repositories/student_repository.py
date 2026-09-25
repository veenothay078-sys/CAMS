from typing import Optional, Dict, Any, List
from sqlalchemy.orm import Session
from app.repositories.base import BaseRepository

class StudentRepository(BaseRepository):
    """Data access repository for student information domain."""

    def get_by_user_id(self, user_id: str, user_role: str = "STUDENT") -> Optional[Dict[str, Any]]:
        sql = """
            SELECT s.roll_no, s.full_name, s.semester, s.cgpa, s.academic_status,
                   d.name AS degree_name, d.code AS degree_code, u.email, u.phone
            FROM students s
            JOIN users u ON s.user_id = u.id
            LEFT JOIN degrees d ON s.degree_id = d.id
            WHERE s.is_deleted = false AND s.user_id = :user_id
        """
        rows = self.execute_query(sql, {"user_id": user_id}, user_role=user_role)
        return rows[0] if rows else None

    def get_by_roll_no(self, roll_no: str, user_role: str = "FACULTY") -> Optional[Dict[str, Any]]:
        sql = """
            SELECT s.roll_no, s.full_name, s.semester, s.cgpa, s.academic_status,
                   d.name AS degree_name, u.email
            FROM students s
            JOIN users u ON s.user_id = u.id
            LEFT JOIN degrees d ON s.degree_id = d.id
            WHERE s.is_deleted = false AND s.roll_no = :roll_no
        """
        rows = self.execute_query(sql, {"roll_no": roll_no}, user_role=user_role)
        return rows[0] if rows else None

    def list_by_semester(self, semester: int, user_role: str = "FACULTY", limit: int = 50) -> List[Dict[str, Any]]:
        sql = """
            SELECT s.roll_no, s.full_name, s.semester, s.cgpa, d.name AS degree_name
            FROM students s
            LEFT JOIN degrees d ON s.degree_id = d.id
            WHERE s.is_deleted = false AND s.semester = :semester
            ORDER BY s.roll_no
        """
        return self.execute_query(sql, {"semester": semester}, user_role=user_role)
