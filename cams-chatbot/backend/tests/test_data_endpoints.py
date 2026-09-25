import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.security.auth import create_access_token

client = TestClient(app)

def test_get_domains_endpoint():
    """Verifies that all 10 priority domains are returned via /api/v1/data/domains."""
    response = client.get("/api/v1/data/domains")
    assert response.status_code == 200
    domains = response.json()
    assert "student" in domains
    assert "attendance" in domains
    assert "marks" in domains
    assert "courses" in domains
    assert "timetable" in domains
    assert "faculty" in domains
    assert "fees" in domains
    assert "notices" in domains
    assert "academic_calendar" in domains
    assert "examinations" in domains

def test_structured_intent_query_student():
    """Tests executing a controlled StructuredQueryIntent for student profile."""
    token = create_access_token({
        "id": "usr_student1",
        "email": "student1@gmail.com",
        "role": "STUDENT"
    })
    headers = {"Authorization": f"Bearer {token}"}
    payload = {
        "domain": "student",
        "intent": "student_profile",
        "entities": {},
        "requested_output": "summary"
    }
    response = client.post("/api/v1/data/query", json=payload, headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert data["domain"] == "student"
    assert data["intent"] == "student_profile"
    assert "data" in data

def test_validate_sql_diagnostic_endpoint():
    """Tests /api/v1/data/validate-sql endpoint."""
    valid_payload = {"sql": "SELECT name, code FROM courses"}
    res = client.post("/api/v1/data/validate-sql", json=valid_payload)
    assert res.status_code == 200
    assert res.json()["is_valid"] is True

    invalid_payload = {"sql": "DROP TABLE courses"}
    res_inv = client.post("/api/v1/data/validate-sql", json=invalid_payload)
    assert res_inv.status_code == 200
    assert res_inv.json()["is_valid"] is False

def test_recent_notices_endpoint():
    """Tests /api/v1/data/notices/recent endpoint."""
    response = client.get("/api/v1/data/notices/recent")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_academic_years_endpoint():
    """Tests /api/v1/data/calendar/years endpoint."""
    response = client.get("/api/v1/data/calendar/years")
    assert response.status_code == 200
    years = response.json()
    assert len(years) > 0
    assert "academic_year" in years[0]
