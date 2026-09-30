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

        # 1. STUDENT INFORMATION & ENROLLMENT
        if intent == "student_information":
            # Check if an aggregation / grouping is requested
            if plan.operation_type in ("count", "grouping", "comparison") and "department" in str(plan.operation_type):
                sql = (
                    "SELECT COALESCE(d.name, 'Law General') as department_name, count(s.id) as student_count "
                    "FROM students s "
                    "LEFT JOIN degrees d ON d.id = s.degree_id "
                    "WHERE s.is_deleted = false "
                    "GROUP BY d.name "
                    "ORDER BY student_count DESC"
                )
                return sql, params

            # Query all users if specifically targetting users table
            if filters.get("target_table") == "users" or (plan.tables == ["users"]):
                sql = (
                    "SELECT u.id as user_id, u.full_name, u.email, CAST(u.role AS TEXT) as role, u.phone, u.is_active "
                    "FROM users u "
                    "WHERE u.is_deleted = false"
                )
                if "user_name" in filters or "name" in filters:
                    nm = filters.get("user_name") or filters.get("name")
                    sql += " AND (LOWER(u.full_name) LIKE LOWER(:user_name) OR LOWER(u.email) LIKE LOWER(:user_name))"
                    params["user_name"] = f"%{nm}%"
                sql += " ORDER BY u.role ASC, u.full_name ASC LIMIT 50"
                return sql, params

            sql = (
                "SELECT s.id as student_id, s.roll_no, u.full_name, s.semester, s.cgpa, "
                "s.batch_year, u.email, COALESCE(d.name, 'B.A. LL.B.') as degree_name "
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

            sql += " ORDER BY s.semester ASC, s.roll_no ASC LIMIT 50"
            return sql, params

        # 2. ATTENDANCE DOMAIN (STAFF & CLASS ATTENDANCE)
        elif intent == "attendance":
            # 1. Multi-student attendance comparison chart / table (all students, low attendance, at-risk defaulters)
            is_students_comparison = (
                filters.get("target_type") in ("students_at_risk", "students")
                or "below" in (plan.target_entity or "").lower()
                or "75" in (plan.target_entity or "").lower()
                or "risk" in (plan.target_entity or "").lower()
                or "low" in (plan.target_entity or "").lower()
                or ("student" in (plan.target_entity or "").lower() and not filters.get("student_name") and not filters.get("name"))
            )

            if is_students_comparison:
                sql = (
                    "SELECT u.id as student_id, u.full_name as student_name, "
                    "COUNT(*) as total_classes, "
                    "SUM(CASE WHEN LOWER(sa.status) IN ('present', 'sunday') THEN 1 ELSE 0 END) as classes_attended, "
                    "ROUND((SUM(CASE WHEN LOWER(sa.status) IN ('present', 'sunday') THEN 1.0 ELSE 0.0 END) / COUNT(*)) * 100, 1) as attendance_percentage "
                    "FROM staff_attendance sa "
                    "JOIN users u ON u.id = sa.faculty_id "
                    "WHERE sa.is_deleted = false "
                    "GROUP BY u.id, u.full_name "
                )
                if filters.get("target_type") == "students_at_risk" or "below" in (plan.target_entity or "").lower() or "75" in (plan.target_entity or "").lower() or "risk" in (plan.target_entity or "").lower() or "low" in (plan.target_entity or "").lower():
                    sql += "HAVING (SUM(CASE WHEN LOWER(sa.status) IN ('present', 'sunday') THEN 1.0 ELSE 0.0 END) / COUNT(*)) < 0.75 "
                sql += "ORDER BY attendance_percentage ASC LIMIT 50"
                return sql, params

            # 2. Single specific student attendance breakdown for charts
            if (plan.output_type in ("chart", "calculation") or plan.operation_type in ("pie", "grouping")) and (filters.get("name") or filters.get("student_name") or filters.get("faculty_name")):
                n = filters.get("name") or filters.get("student_name") or filters.get("faculty_name")
                sql = (
                    "SELECT sa.status as attendance_status, count(*) as record_count "
                    "FROM staff_attendance sa "
                    "JOIN users u ON u.id = sa.faculty_id "
                    "WHERE sa.is_deleted = false AND LOWER(u.full_name) LIKE LOWER(:name) "
                    "GROUP BY sa.status "
                    "ORDER BY record_count DESC"
                )
                params["name"] = f"%{n}%"
                return sql, params

            # 3. Overall campus attendance breakdown for charts / pie
            if plan.output_type in ("chart", "calculation") or plan.operation_type in ("pie", "grouping"):
                sql = (
                    "SELECT sa.status as attendance_status, count(*) as record_count "
                    "FROM staff_attendance sa "
                    "WHERE sa.is_deleted = false "
                    "GROUP BY sa.status "
                    "ORDER BY record_count DESC"
                )
                return sql, params

            # 4. Detailed staff / student attendance records
            sql = (
                "SELECT sa.date, sa.status, u.full_name as faculty_name, u.email, sa.source "
                "FROM staff_attendance sa "
                "JOIN users u ON u.id = sa.faculty_id "
                "WHERE sa.is_deleted = false"
            )
            if "date" in filters:
                sql += " AND sa.date = :date"
                params["date"] = str(filters["date"])
            if "name" in filters or "faculty_name" in filters or "student_name" in filters:
                n = filters.get("name") or filters.get("faculty_name") or filters.get("student_name")
                sql += " AND LOWER(u.full_name) LIKE LOWER(:name)"
                params["name"] = f"%{n}%"

            sql += " ORDER BY sa.date DESC LIMIT 50"
            return sql, params

        # 3. EXAMINATION SCHEDULE
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

        # 4. MARKS & INTERNAL ASSESSMENT
        elif intent == "marks":
            # Subject-wise marks average for charts
            if plan.output_type in ("chart", "calculation") or plan.operation_type in ("average", "comparison"):
                sql = (
                    "SELECT c.name as subject_name, ROUND(AVG(im.total_mark)::numeric, 2) as average_marks "
                    "FROM internal_marks im "
                    "JOIN courses c ON c.id = im.subject_id "
                    "WHERE im.is_deleted = false "
                    "GROUP BY c.name "
                    "ORDER BY average_marks DESC"
                )
                return sql, params

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

        # 5. TIMETABLE DOMAIN
        elif intent == "timetable":
            sql = (
                "SELECT CAST(t.weekday AS TEXT) as weekday, t.start_time, t.end_time, t.room, "
                "c.name as course_name, c.code as course_code, c.semester, "
                "COALESCE(sec.section_name, 'Section A') as section_name, "
                "COALESCE(u.full_name, 'Faculty') as faculty_name "
                "FROM timetable t "
                "JOIN courses c ON c.id = t.subject_id "
                "LEFT JOIN sections sec ON sec.id = t.section_id "
                "LEFT JOIN users u ON u.id = t.faculty_id "
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

            sql += " ORDER BY t.weekday ASC, t.start_time ASC"
            return sql, params

        # 6. COURSES & CURRICULUM
        elif intent == "courses":
            # Course count per semester for charts
            if plan.output_type in ("chart", "calculation") or plan.operation_type in ("count", "grouping"):
                sql = (
                    "SELECT CONCAT('Semester ', c.semester) as semester_label, count(c.id) as course_count "
                    "FROM courses c "
                    "WHERE c.is_deleted = false "
                    "GROUP BY c.semester "
                    "ORDER BY c.semester ASC"
                )
                return sql, params

            sql = (
                "SELECT c.code, c.name, c.credits, c.semester, COALESCE(d.name, 'B.A. LL.B.') as degree_name "
                "FROM courses c "
                "LEFT JOIN degrees d ON d.id = c.degree_id "
                "WHERE c.is_deleted = false"
            )
            if "semester" in filters:
                sql += " AND c.semester = :semester"
                params["semester"] = int(filters["semester"])

            sql += " ORDER BY c.semester ASC, c.code ASC"
            return sql, params

        # 7. FACULTY DIRECTORY
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

        # 8. FEES
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

        # 9. NOTICES & ANNOUNCEMENTS
        elif intent == "notices":
            sql = (
                "SELECT title, category, priority, publish_date, body "
                "FROM notices "
                "WHERE is_deleted = false "
                "ORDER BY publish_date DESC"
            )
            return sql, params

        # 10. ACADEMIC CALENDAR
        elif intent == "academic_calendar":
            sql = (
                "SELECT title, category, start_date, end_date, description, is_holiday, event_type "
                "FROM academic_calendar_events "
                "WHERE is_deleted = false "
                "ORDER BY start_date ASC"
            )
            return sql, params

        return None, {}
