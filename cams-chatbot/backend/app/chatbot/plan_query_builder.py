from typing import Tuple, Dict, Any, Optional
from app.chatbot.query_plan import QueryPlan

class PlanQueryBuilder:
    """
    Constructs safe, parameterized SQL statements exclusively from validated QueryPlan structures.
    Uses strictly parameterized values (:param) to prevent SQL injection.
    Applies 'is_deleted = false' and respects CAMS foreign key schemas.
    """

    @classmethod
    def build_query(cls, plan: QueryPlan) -> Tuple[Optional[str], Dict[str, Any]]:
        """
        Returns (parameterized_sql, params_dict).
        If plan is invalid or requires clarification, returns (None, {}).
        """
        if plan.requires_clarification or not plan.tables:
            return None, {}

        intent = plan.intent
        filters = plan.filters or {}
        params: Dict[str, Any] = {}

        if intent == "student_information":
            sql = (
                "SELECT s.id as student_id, s.roll_no, u.full_name, s.semester, s.cgpa, "
                "s.batch_year, u.email, d.name as degree_name "
                "FROM students s "
                "JOIN users u ON u.id = s.user_id "
                "LEFT JOIN degrees d ON d.id = s.degree_id "
                "WHERE s.is_deleted = false"
            )
            if "roll_no" in filters:
                sql += " AND UPPER(s.roll_no) = UPPER(:roll_no)"
                params["roll_no"] = str(filters["roll_no"])
            elif "student_id" in filters:
                sql += " AND s.id = :student_id"
                params["student_id"] = str(filters["student_id"])
            elif "student_name" in filters:
                sql += " AND (LOWER(u.full_name) LIKE LOWER(:student_name) OR LOWER(u.email) LIKE LOWER(:student_name))"
                params["student_name"] = f"%{filters['student_name']}%"

            return sql, params

        elif intent == "attendance":
            # Target student attendance
            sql = (
                "SELECT a.id, a.date, a.hour, a.absentee_ids, a.approval_status, "
                "c.name as course_name, c.code as course_code "
                "FROM attendance a "
                "LEFT JOIN courses c ON c.id = a.subject_id "
                "WHERE a.is_deleted = false"
            )
            if "date" in filters:
                sql += " AND a.date = :date"
                params["date"] = str(filters["date"])

            return sql, params

        elif intent == "examination_schedule":
            sql = (
                "SELECT e.id as exam_id, e.date as exam_date, e.start_time, e.end_time, "
                "CAST(e.type AS TEXT) as exam_type, e.center, c.name as course_name, c.code as course_code, c.semester "
                "FROM exams e "
                "JOIN courses c ON c.id = e.course_id "
                "WHERE e.is_deleted = false"
            )
            if "semester" in filters:
                sql += " AND c.semester = :semester"
                params["semester"] = int(filters["semester"])
            if "exam_type" in filters:
                sql += " AND UPPER(CAST(e.type AS TEXT)) LIKE UPPER(:exam_type)"
                params["exam_type"] = f"%{filters['exam_type']}%"

            sql += " ORDER BY e.date ASC"
            return sql, params

        elif intent == "marks":
            sql = (
                "SELECT u.full_name as student_name, s.roll_no, c.name as course_name, c.code as course_code, "
                "im.internal_exam_mark, im.assignment_mark, im.presentation_mark, im.viva_voice_mark, "
                "im.attendance_mark, im.total_mark, im.semester "
                "FROM internal_marks im "
                "JOIN students s ON s.id = im.student_id "
                "JOIN users u ON u.id = s.user_id "
                "JOIN courses c ON c.id = im.subject_id "
                "WHERE im.is_deleted = false"
            )
            if "roll_no" in filters:
                sql += " AND UPPER(s.roll_no) = UPPER(:roll_no)"
                params["roll_no"] = str(filters["roll_no"])
            elif "student_id" in filters:
                sql += " AND s.id = :student_id"
                params["student_id"] = str(filters["student_id"])
            elif "student_name" in filters:
                sql += " AND (LOWER(u.full_name) LIKE LOWER(:student_name) OR LOWER(u.email) LIKE LOWER(:student_name))"
                params["student_name"] = f"%{filters['student_name']}%"

            if "semester" in filters:
                sql += " AND (im.semester = :sem_str OR CAST(c.semester AS TEXT) = :sem_str)"
                params["sem_str"] = str(filters["semester"])

            return sql, params

        elif intent == "timetable":
            sql = (
                "SELECT CAST(t.weekday AS TEXT) as weekday, t.start_time, t.end_time, t.room, "
                "c.name as course_name, c.code as course_code, c.semester, sec.section_name "
                "FROM timetable t "
                "JOIN courses c ON c.id = t.subject_id "
                "LEFT JOIN sections sec ON sec.id = t.section_id "
                "WHERE t.is_deleted = false"
            )
            if "weekday" in filters:
                sql += " AND UPPER(CAST(t.weekday AS TEXT)) = UPPER(:weekday)"
                params["weekday"] = str(filters["weekday"])
            if "semester" in filters:
                sql += " AND c.semester = :semester"
                params["semester"] = int(filters["semester"])
            if "section" in filters:
                sql += " AND UPPER(sec.section_name) LIKE UPPER(:section)"
                params["section"] = f"%{filters['section']}%"

            sql += " ORDER BY t.start_time ASC"
            return sql, params

        elif intent == "courses":
            sql = (
                "SELECT c.code, c.name, c.credits, c.semester, d.name as degree_name "
                "FROM courses c "
                "LEFT JOIN degrees d ON d.id = c.degree_id "
                "WHERE c.is_deleted = false"
            )
            if "semester" in filters:
                sql += " AND c.semester = :semester"
                params["semester"] = int(filters["semester"])

            sql += " ORDER BY c.semester ASC, c.code ASC"
            return sql, params

        elif intent == "faculty":
            sql = (
                "SELECT u.full_name, f.designation, f.specialization, u.email "
                "FROM faculty_profiles f "
                "JOIN users u ON u.id = f.user_id "
                "WHERE f.is_deleted = false"
            )
            if "name" in filters:
                sql += " AND (LOWER(u.full_name) LIKE LOWER(:name) OR LOWER(f.specialization) LIKE LOWER(:name))"
                params["name"] = f"%{filters['name']}%"

            sql += " ORDER BY u.full_name ASC"
            return sql, params

        elif intent == "fees":
            sql = (
                "SELECT u.full_name as student_name, s.roll_no, fs.fee_type, fs.amount, fs.due_date, CAST(fr.status AS TEXT) as status "
                "FROM fee_records fr "
                "JOIN fee_structure fs ON fs.id = fr.fee_structure_id "
                "JOIN students s ON s.id = fr.student_id "
                "JOIN users u ON u.id = s.user_id "
                "WHERE fr.is_deleted = false"
            )
            if "roll_no" in filters:
                sql += " AND UPPER(s.roll_no) = UPPER(:roll_no)"
                params["roll_no"] = str(filters["roll_no"])
            elif "student_id" in filters:
                sql += " AND s.id = :student_id"
                params["student_id"] = str(filters["student_id"])
            elif "student_name" in filters:
                sql += " AND LOWER(u.full_name) LIKE LOWER(:student_name)"
                params["student_name"] = f"%{filters['student_name']}%"

            return sql, params

        elif intent == "notices":
            sql = (
                "SELECT title, category, priority, publish_date, body "
                "FROM notices "
                "WHERE is_deleted = false "
                "ORDER BY publish_date DESC"
            )
            return sql, params

        elif intent == "academic_calendar":
            sql = (
                "SELECT title, category, start_date, end_date, description, is_holiday, event_type "
                "FROM academic_calendar_events "
                "WHERE is_deleted = false "
                "ORDER BY start_date ASC"
            )
            return sql, params

        return None, {}
