from typing import Set, Dict, List
from app.security.rbac import UserRole

# Default bounds for memory and latency safety
MAX_QUERY_ROW_LIMIT = 100
STATEMENT_TIMEOUT_MS = 10000

# Strictly forbidden SQL keywords that modify schema or data, or permit UNION injection
FORBIDDEN_KEYWORDS: Set[str] = {
    "INSERT", "UPDATE", "DELETE", "DROP", "ALTER", "TRUNCATE",
    "CREATE", "GRANT", "REVOKE", "MERGE", "REPLACE", "CALL",
    "VACUUM", "ANALYZE", "EXPLAIN", "COPY", "LOCK", "COMMENT",
    "DISCARD", "RESET", "SET", "EXEC", "EXECUTE", "UNION"
}

# Dangerous PostgreSQL functions and SQLi bypass constructs
FORBIDDEN_PATTERNS: List[str] = [
    r";\s*\w+",                    # Multi-statement injection
    r"pg_sleep\s*\(",              # Time-based blind SQLi
    r"pg_read_file\s*\(",          # Local file reading
    r"pg_write_file\s*\(",         # Local file writing
    r"dblink\s*\(",                # Out-of-band network queries
    r"inet_client_addr\s*\(",      # Host discovery
    r"current_setting\s*\(",       # Server configuration sniffing
    r"system\s*\(",                # OS command execution
    r"--\s*",                      # Single line comment bypass
    r"/\*.*?\*/",                  # Multi-line comment bypass
    r"'\s*or\s+['\d\w]+\s*=\s*['\d\w]+",  # Tautology injection (e.g. 1' OR '1'='1)
    r"\bor\s+\d+\s*=\s*\d+\b",     # Tautology injection (e.g. OR 1=1)
    r"\bunion\s+(?:all\s+)?select\b"  # Union injection
]

# Sensitive columns that must be masked or excluded from general queries
SENSITIVE_COLUMNS: Set[str] = {
    "hashed_password", "aadhaar_number", "pan_number", "passport_number",
    "parent_annual_income", "document_aadhaar_url", "document_income_url"
}

# Approved tables for CAMS Chatbot querying
ALLOWED_CHATBOT_TABLES: Set[str] = {
    # 1. Student Information
    "students", "parent_student_map", "student_interactions", "student_papers",
    # 2. Attendance
    "attendance", "attendance_corrections", "staff_attendance",
    # 3. Examinations
    "exams", "exam_hall_tickets", "exam_seating_arrangements",
    # 4. Marks & Grades
    "marks", "internal_marks", "student_subject_grades", "student_semester_gpa_records", "student_cgpa_records",
    # 5. Courses & Curriculum
    "courses", "course_enrollments", "sections", "batch_sections", "subject_allocations", "degrees", "departments",
    # 6. Timetable
    "timetable", "timetable_approvals", "timetable_templates",
    # 7. Faculty
    "faculty_profiles", "faculty_absences", "leaves",
    # 8. Fees
    "fee_records", "fee_structure", "payments",
    # 9. Notices & Announcements
    "notices", "notifications",
    # 10. Academic Calendar
    "academic_calendars", "academic_calendar_events", "academic_years",
    # User identity (public info only)
    "users"
}

# Internal or sensitive tables that are strictly forbidden from chatbot querying
STRICTLY_FORBIDDEN_TABLES: Set[str] = {
    "system_settings", "system_setting_history", "backup_configurations", "backup_history",
    "audit_logs", "user_sessions", "session_summaries", "salary", "payroll_runs", "salary_slips",
    "salary_revisions", "salary_allowances", "salary_structures", "deductions", "employee_salary_assignments"
}

# Table access policy by user role
ROLE_TABLE_PERMISSIONS: Dict[str, Set[str]] = {
    UserRole.SUPER_ADMIN.value: ALLOWED_CHATBOT_TABLES,
    UserRole.ADMIN.value: ALLOWED_CHATBOT_TABLES,
    UserRole.PRINCIPAL.value: ALLOWED_CHATBOT_TABLES,
    UserRole.HOD.value: ALLOWED_CHATBOT_TABLES - {"fee_records", "payments"},
    UserRole.FACULTY.value: {
        "students", "courses", "sections", "subject_allocations", "attendance", "attendance_corrections",
        "timetable", "internal_marks", "marks", "exams", "exam_hall_tickets", "exam_seating_arrangements",
        "faculty_profiles", "leaves", "notices", "academic_years", "academic_calendar_events", "academic_calendars", "degrees", "users"
    },
    UserRole.STUDENT.value: {
        "students", "courses", "sections", "attendance", "attendance_corrections",
        "timetable", "internal_marks", "marks", "exams", "exam_hall_tickets", "exam_seating_arrangements",
        "fee_records", "fee_structure", "notices", "academic_years", "academic_calendar_events", "academic_calendars", "degrees", "faculty_profiles", "users"
    },
    UserRole.PARENT.value: {
        "students", "parent_student_map", "attendance", "internal_marks", "marks", "exams", "fee_records", "fee_structure", "notices", "academic_years", "academic_calendar_events"
    }
}


class QueryPolicy:
    """Central authority on what SQL structures and tables are allowed for each role."""

    @staticmethod
    def is_table_allowed(table_name: str, user_role: str = "STUDENT") -> bool:
        tbl = table_name.lower().replace('"', '')
        if tbl in STRICTLY_FORBIDDEN_TABLES:
            return False
        allowed_for_role = ROLE_TABLE_PERMISSIONS.get(user_role, ROLE_TABLE_PERMISSIONS[UserRole.STUDENT.value])
        return tbl in allowed_for_role

    @staticmethod
    def get_max_row_limit() -> int:
        return MAX_QUERY_ROW_LIMIT

    @staticmethod
    def get_statement_timeout_ms() -> int:
        return STATEMENT_TIMEOUT_MS
