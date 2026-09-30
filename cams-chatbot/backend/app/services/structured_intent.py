from typing import Dict, Any, Optional, Tuple, Literal
from pydantic import BaseModel, Field

class StructuredQueryIntent(BaseModel):
    """
    Controlled query abstraction.
    NVIDIA NIM translates natural language into this structured format instead of raw SQL.
    """
    domain: Literal[
        "student", "attendance", "examinations", "marks",
        "courses", "timetable", "faculty", "fees",
        "notices", "academic_calendar"
    ]
    intent: str = Field(..., description="Action/Intent code, e.g. student_profile, my_attendance, marks_summary")
    entities: Dict[str, Any] = Field(default_factory=dict, description="Extracted parameters, e.g. semester, course_code, date")
    requested_output: Literal["summary", "detailed", "table"] = "summary"


class IntentQueryBuilder:
    """
    Translates a StructuredQueryIntent into a strictly parameterized, pre-approved SQL query.
    Enforces user authorization and tenant/identity scoping based on authenticated UserContext.
    """

    @classmethod
    def build_query(cls, intent_req: StructuredQueryIntent, user_context: Dict[str, Any]) -> Tuple[str, Dict[str, Any]]:
        domain = intent_req.domain
        intent = intent_req.intent
        entities = intent_req.entities
        role = user_context.get("role", "STUDENT")
        user_id = user_context.get("id")

        params: Dict[str, Any] = {}

        # 1. STUDENT INFORMATION DOMAIN
        if domain == "student":
            if role in ("STUDENT", "PARENT"):
                # Student can ONLY query their own profile
                sql = """
                    SELECT s.roll_no, s.full_name, s.semester, s.cgpa, s.academic_status,
                           d.name AS degree_name, u.email
                    FROM students s
                    JOIN users u ON s.user_id = u.id
                    LEFT JOIN degrees d ON s.degree_id = d.id
                    WHERE s.is_deleted = false AND s.user_id = :user_id
                """
                params["user_id"] = user_id
            else:
                # Faculty / Admin can filter by roll number or semester
                sql = """
                    SELECT s.roll_no, s.full_name, s.semester, s.cgpa, s.academic_status,
                           d.name AS degree_name, u.email
                    FROM students s
                    JOIN users u ON s.user_id = u.id
                    LEFT JOIN degrees d ON s.degree_id = d.id
                    WHERE s.is_deleted = false
                """
                if "roll_no" in entities:
                    sql += " AND s.roll_no = :roll_no"
                    params["roll_no"] = entities["roll_no"]
                elif "semester" in entities:
                    sql += " AND s.semester = :semester"
                    params["semester"] = int(entities["semester"])

            return sql.strip(), params

        # 2. ATTENDANCE DOMAIN
        elif domain == "attendance":
            sql = """
                SELECT sa.date, sa.status, u.full_name AS faculty_name, sa.source
                FROM staff_attendance sa
                JOIN users u ON sa.faculty_id = u.id
                WHERE sa.is_deleted = false
            """
            if role == "FACULTY":
                sql += " AND sa.faculty_id = :user_id"
                params["user_id"] = user_id
            if "date" in entities:
                sql += " AND sa.date = :query_date"
                params["query_date"] = entities["date"]

            sql += " ORDER BY sa.date DESC LIMIT 50"
            return sql.strip(), params

        # 3. MARKS & INTERNAL ASSESSMENT DOMAIN
        elif domain == "marks":
            sql = """
                SELECT im.academic_year, im.semester, c.name AS subject_name,
                       im.internal_exam_mark, im.assignment_mark, im.presentation_mark,
                       im.attendance_mark, im.total_mark, im.status
                FROM internal_marks im
                JOIN courses c ON im.subject_id = c.id
                WHERE im.is_deleted = false
            """
            if role == "STUDENT":
                # Scoped to student
                sql += " AND im.student_id = :user_id"
                params["user_id"] = user_id
            elif "semester" in entities:
                sql += " AND im.semester = :semester"
                params["semester"] = str(entities["semester"])

            return sql.strip(), params

        # 4. COURSES & CURRICULUM DOMAIN
        elif domain == "courses":
            sql = """
                SELECT c.code, c.name, c.credits, c.semester, d.name AS degree_name
                FROM courses c
                JOIN degrees d ON c.degree_id = d.id
                WHERE c.is_deleted = false
            """
            if "semester" in entities:
                sql += " AND c.semester = :semester"
                params["semester"] = int(entities["semester"])
            if "code" in entities:
                sql += " AND c.code = :course_code"
                params["course_code"] = entities["code"]

            sql += " ORDER BY c.semester, c.code"
            return sql.strip(), params

        # 5. TIMETABLE DOMAIN
        elif domain == "timetable":
            sql = """
                SELECT CAST(t.weekday AS TEXT) as weekday, t.start_time, t.end_time, t.room,
                       c.name AS subject_name, COALESCE(sec.section_name, 'Section A') as section_name,
                       COALESCE(u.full_name, 'Faculty') AS faculty_name
                FROM timetable t
                JOIN courses c ON t.subject_id = c.id
                LEFT JOIN sections sec ON t.section_id = sec.id
                LEFT JOIN users u ON t.faculty_id = u.id
                WHERE t.is_deleted = false
            """
            if role == "FACULTY":
                sql += " AND t.faculty_id = :user_id"
                params["user_id"] = user_id
            if "weekday" in entities:
                sql += " AND UPPER(CAST(t.weekday AS TEXT)) = UPPER(:weekday)"
                params["weekday"] = entities["weekday"].upper()

            sql += " ORDER BY t.weekday, t.start_time"
            return sql.strip(), params

        # 6. FACULTY DIRECTORY DOMAIN
        elif domain == "faculty":
            sql = """
                SELECT fp.faculty_id, u.full_name, u.email, fp.designation,
                       fp.specialization, fp.employment_status
                FROM faculty_profiles fp
                JOIN users u ON fp.user_id = u.id
                WHERE fp.is_deleted = false
            """
            if "designation" in entities:
                sql += " AND fp.designation = :designation"
                params["designation"] = entities["designation"]

            return sql.strip(), params

        # 7. FEES & DUE DATES DOMAIN
        elif domain == "fees":
            sql = """
                SELECT fs.fee_type, fs.semester, fs.amount, fs.due_date,
                       fr.status AS payment_status
                FROM fee_records fr
                JOIN fee_structure fs ON fr.fee_structure_id = fs.id
                WHERE fr.is_deleted = false
            """
            if role in ("STUDENT", "PARENT"):
                sql += " AND fr.student_id = :user_id"
                params["user_id"] = user_id

            return sql.strip(), params

        # 8. NOTICES DOMAIN
        elif domain == "notices":
            sql = """
                SELECT n.title, n.body, n.category, n.priority, n.publish_date,
                       u.full_name AS published_by
                FROM notices n
                JOIN users u ON n.created_by = u.id
                WHERE n.is_deleted = false AND n.status = 'PUBLISHED'
            """
            if "priority" in entities:
                sql += " AND n.priority = :priority"
                params["priority"] = entities["priority"]

            sql += " ORDER BY n.publish_date DESC"
            return sql.strip(), params

        # 9. ACADEMIC CALENDAR DOMAIN
        elif domain == "academic_calendar":
            sql = """
                SELECT ay.name AS academic_year, ay.start_date, ay.end_date,
                       ay.current_semester, ay.is_active
                FROM academic_years ay
                WHERE ay.is_deleted = false
            """
            return sql.strip(), params

        # 10. EXAMINATIONS DOMAIN
        elif domain == "examinations":
            sql = """
                SELECT e.type, e.center, e.date, e.start_time, e.end_time,
                       c.name AS course_name, c.code AS course_code
                FROM exams e
                JOIN courses c ON e.course_id = c.id
                WHERE e.is_deleted = false
                ORDER BY e.date ASC
            """
            return sql.strip(), params

        # Fallback safe count query
        return "SELECT count(*) AS total_students FROM students WHERE is_deleted = false", {}
