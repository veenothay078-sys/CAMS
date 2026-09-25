import pytest
from app.security.query_validator import QueryValidator
from app.security.query_policy import QueryPolicy
from app.services.safe_query_service import SafeQueryService
from app.database.connection import SessionLocal

# 1. Valid SELECT query
def test_valid_select_query():
    sql = "SELECT roll_no, full_name FROM students WHERE semester = 1"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is True
    assert error is None
    assert "students" in tables
    assert "LIMIT 100" in sanitized

# 2. INSERT rejection
def test_insert_rejection():
    sql = "INSERT INTO students (id, roll_no) VALUES ('fake', 'fake')"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "Only read-only SELECT queries are permitted" in error

# 3. UPDATE rejection
def test_update_rejection():
    sql = "UPDATE students SET cgpa = 10.0 WHERE id = 's1'"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "Only read-only SELECT queries are permitted" in error

# 4. DELETE rejection
def test_delete_rejection():
    sql = "DELETE FROM students WHERE id = 's1'"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "Only read-only SELECT queries are permitted" in error

# 5. DROP rejection
def test_drop_rejection():
    sql = "DROP TABLE students;"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "Only read-only SELECT queries are permitted" in error

# 6. ALTER rejection
def test_alter_rejection():
    sql = "ALTER TABLE students ADD COLUMN hacked TEXT;"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "Only read-only SELECT queries are permitted" in error

# 7. TRUNCATE rejection
def test_truncate_rejection():
    sql = "TRUNCATE TABLE students;"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "Only read-only SELECT queries are permitted" in error

# 8. CREATE rejection
def test_create_rejection():
    sql = "CREATE TABLE malicious (id INT);"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "Only read-only SELECT queries are permitted" in error

# 9. GRANT rejection
def test_grant_rejection():
    sql = "GRANT ALL PRIVILEGES ON students TO public;"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False

# 10. REVOKE rejection
def test_revoke_rejection():
    sql = "REVOKE ALL PRIVILEGES ON students FROM public;"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False

# 11. Unauthorized table rejection (internal system tables)
def test_unauthorized_internal_table_rejection():
    sql = "SELECT * FROM system_settings"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "restricted internal table" in error

def test_unauthorized_audit_table_rejection():
    sql = "SELECT * FROM audit_logs"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "restricted internal table" in error

# 12. Unauthorized role table rejection
def test_role_based_table_authorization():
    # Students cannot query faculty leaves
    sql = "SELECT * FROM leaves"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql, user_role="STUDENT")
    assert is_valid is False
    assert "not authorized to query table" in error

    # Faculty CAN query leaves
    is_valid_fac, _, _, _ = QueryValidator.validate(sql, user_role="FACULTY")
    assert is_valid_fac is True

# 13. Result-size protection (enforcing limit 100)
def test_result_size_protection_clamping():
    # Query with huge LIMIT 100000 must be clamped to 100
    sql = "SELECT * FROM courses LIMIT 100000"
    is_valid, sanitized, tables, error = QueryValidator.validate(sql)
    assert is_valid is True
    assert "LIMIT 100" in sanitized
    assert "100000" not in sanitized

# 14. Invalid query handling
def test_empty_query_rejected():
    is_valid, _, _, error = QueryValidator.validate("")
    assert is_valid is False
    assert "cannot be empty" in error

def test_multi_statement_semicolon_rejected():
    sql = "SELECT * FROM students; SELECT * FROM users"
    is_valid, _, _, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "Multiple SQL statements" in error

def test_sql_injection_sleep_rejected():
    sql = "SELECT * FROM students WHERE id = '1' AND pg_sleep(5)"
    is_valid, _, _, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "disallowed pattern" in error

def test_comment_bypass_rejected():
    sql = "SELECT * FROM students -- DROP TABLE users"
    is_valid, _, _, error = QueryValidator.validate(sql)
    assert is_valid is False
    assert "disallowed pattern" in error

# 15. Query timeout protection & read-only execution on live DB
def test_execution_read_only_and_timeout():
    db = SessionLocal()
    try:
        service = SafeQueryService(db)
        # Verify valid SELECT executes and returns sanitized data
        res = service.execute_safe_query("SELECT count(*) AS student_count FROM students;")
        assert res["success"] is True
        assert res["row_count"] == 1
        assert "student_count" in res["columns"]

        # Verify password columns are masked/stripped if users table queried
        user_res = service.execute_safe_query("SELECT id, email, hashed_password FROM users LIMIT 1;", user_role="STUDENT")
        assert user_res["success"] is True
        if user_res["data"]:
            assert "hashed_password" not in user_res["data"][0]
    finally:
        db.close()
