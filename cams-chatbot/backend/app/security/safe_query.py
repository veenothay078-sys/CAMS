import re
import logging
from typing import Tuple, List, Set, Optional

logger = logging.getLogger("cams_chatbot.safe_query")

# Set of destructive or disallowed SQL keywords
FORBIDDEN_KEYWORDS = {
    "INSERT", "UPDATE", "DELETE", "DROP", "ALTER", "TRUNCATE",
    "EXEC", "EXECUTE", "CREATE", "GRANT", "REVOKE", "MERGE",
    "REPLACE", "CALL", "VACUUM", "ANALYZE", "EXPLAIN",
    "COPY", "LOCK", "COMMENT", "DISCARD", "RESET", "SET"
}

# Dangerous PostgreSQL functions often used in SQL injection/exploits
FORBIDDEN_PATTERNS = [
    r";\s*\w+",                    # Multi-statement queries via semicolon
    r"pg_sleep\s*\(",              # Time-based blind SQLi
    r"pg_read_file\s*\(",          # Arbitrary file read
    r"pg_write_file\s*\(",         # Arbitrary file write
    r"dblink\s*\(",                # Out of band connection
    r"inet_client_addr\s*\(",      # Host reconnaissance
    r"system\s*\(",                # System calls
    r"currval\s*\(",
    r"nextval\s*\(",
    r"setval\s*\(",
    r"--\s*",                      # Inline comments used for SQL bypass
    r"/\*.*?\*/"                   # Block comments used for obfuscation
]

# Allowlisted tables permitted for natural language chatbot querying
ALLOWED_CHATBOT_TABLES = {
    # Students
    "students", "parent_student_map", "student_interactions", "student_papers",
    # Attendance
    "attendance", "attendance_corrections", "staff_attendance",
    # Examinations & Marks
    "exams", "marks", "internal_marks", "student_subject_grades", "student_semester_gpa_records", "student_cgpa_records",
    # Courses & Curriculum
    "courses", "course_enrollments", "sections", "batch_sections", "subject_allocations", "degrees", "departments",
    # Timetable
    "timetable", "timetable_approvals", "timetable_templates",
    # Faculty
    "faculty_profiles", "faculty_absences", "leaves",
    # Fees
    "fee_records", "fee_structure", "payments",
    # Notices & Calendar
    "notices", "notifications", "academic_calendars", "academic_calendar_events", "academic_years",
    # Public Users info
    "users"
}

# Tables strictly forbidden from natural language querying (credentials, system internals)
STRICTLY_FORBIDDEN_TABLES = {
    "system_settings", "system_setting_history", "backup_configurations", "backup_history",
    "audit_logs", "user_sessions", "session_summaries", "salary", "payroll_runs", "salary_slips"
}


class SafeQueryValidator:
    """Enterprise Safe Query Layer validating and sanitizing queries before execution."""

    @classmethod
    def validate_query(cls, sql: str, max_limit: int = 100) -> Tuple[bool, Optional[str], List[str], Optional[str]]:
        """
        Validates SQL query.
        Returns: (is_valid, sanitized_sql, tables_detected, error_message)
        """
        if not sql or not sql.strip():
            return False, None, [], "Query cannot be empty"

        cleaned_sql = sql.strip().rstrip(";")

        # 1. Reject multi-statement queries
        if ";" in cleaned_sql:
            return False, None, [], "Multiple SQL statements are strictly prohibited"

        # 2. Check for dangerous functions / patterns
        for pattern in FORBIDDEN_PATTERNS:
            if re.search(pattern, cleaned_sql, re.IGNORECASE | re.DOTALL):
                return False, None, [], f"Query contains disallowed pattern or comment: {pattern}"

        # 3. Must begin with SELECT or WITH (for CTEs leading to SELECT)
        tokens = cleaned_sql.split()
        if not tokens:
            return False, None, [], "Empty query token sequence"

        first_token = tokens[0].upper()
        if first_token not in ("SELECT", "WITH"):
            return False, None, [], f"Only read-only SELECT queries are permitted (received '{first_token}')"

        # 4. Check for any forbidden destructive keywords anywhere in query
        upper_query = cleaned_sql.upper()
        words = set(re.findall(r"\b[A-Z_]+\b", upper_query))
        forbidden_found = words.intersection(FORBIDDEN_KEYWORDS)
        if forbidden_found:
            return False, None, [], f"Query contains forbidden operation keyword(s): {', '.join(forbidden_found)}"

        # 5. Extract tables accessed (FROM and JOIN targets)
        tables_detected = cls._extract_tables(cleaned_sql)
        if not tables_detected:
            return False, None, [], "Could not identify table in query"

        # 6. Check tables against allowlist & blocklist
        for tbl in tables_detected:
            tbl_lower = tbl.lower().replace('"', '')
            if tbl_lower in STRICTLY_FORBIDDEN_TABLES:
                return False, None, tables_detected, f"Access to restricted internal table '{tbl}' is forbidden"
            if tbl_lower not in ALLOWED_CHATBOT_TABLES:
                return False, None, tables_detected, f"Table '{tbl}' is not in the approved chatbot query allowlist"

        # 7. Check / Enforce LIMIT clause
        sanitized_sql = cls._enforce_limit(cleaned_sql, max_limit)

        return True, sanitized_sql, tables_detected, None

    @classmethod
    def _extract_tables(cls, sql: str) -> List[str]:
        """Extracts table names from FROM and JOIN clauses."""
        pattern = r"\b(?:FROM|JOIN)\s+(?:public\.)?([\"a-zA-Z0-9_]+)"
        matches = re.findall(pattern, sql, re.IGNORECASE)
        # Filter out subquery aliases if mistaken
        tables = []
        for m in matches:
            clean_m = m.strip('"').lower()
            if clean_m not in ("select", "lateral", "where", "group", "order", "values"):
                tables.append(clean_m)
        return list(set(tables))

    @classmethod
    def _enforce_limit(cls, sql: str, max_limit: int) -> str:
        """Injects or clamps LIMIT clause to ensure result size is strictly bounded."""
        limit_match = re.search(r"\bLIMIT\s+(\d+)\b", sql, re.IGNORECASE)
        if limit_match:
            existing_limit = int(limit_match.group(1))
            if existing_limit > max_limit:
                # Clamp down to max_limit
                return re.sub(r"\bLIMIT\s+\d+\b", f"LIMIT {max_limit}", sql, flags=re.IGNORECASE)
            return sql
        else:
            # Append LIMIT max_limit
            return f"{sql} LIMIT {max_limit}"
