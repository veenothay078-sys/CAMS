import pytest
from sqlalchemy import text
from app.database.connection import engine, check_db_connectivity
from app.models.cams import User, Student, Course, AcademicYear

def test_database_connectivity_live():
    """Verifies live PostgreSQL engine connects and detects exactly 122 tables."""
    status = check_db_connectivity()
    assert status["connected"] is True
    assert status["tables_count"] == 122
    assert status["error"] is None

def test_read_real_cams_users():
    """Queries actual CAMS users table without modifying anything."""
    with engine.connect() as conn:
        result = conn.execute(text("SELECT email, role, is_active FROM users WHERE is_deleted = false LIMIT 5;"))
        rows = result.fetchall()
        assert len(rows) > 0
        roles = [r[1] for r in rows]
        assert any(r in ("ADMIN", "PRINCIPAL", "HOD", "FACULTY", "STUDENT", "PARENT") for r in roles)

def test_read_real_cams_students():
    """Queries actual CAMS students table."""
    with engine.connect() as conn:
        result = conn.execute(text("SELECT roll_no, full_name, semester FROM students WHERE is_deleted = false LIMIT 5;"))
        rows = result.fetchall()
        assert len(rows) > 0

def test_read_real_cams_courses():
    """Queries actual CAMS courses table."""
    with engine.connect() as conn:
        result = conn.execute(text("SELECT code, name, credits FROM courses WHERE is_deleted = false LIMIT 5;"))
        rows = result.fetchall()
        assert len(rows) > 0
