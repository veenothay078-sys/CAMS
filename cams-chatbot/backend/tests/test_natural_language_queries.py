import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.chatbot.chat_service import ChatService
from app.schema_catalog.catalog import SchemaCatalog

client = TestClient(app)

@pytest.fixture
def auth_headers():
    res = client.post("/api/v1/auth/demo-token", json={"email": "admin@gmail.com"})
    assert res.status_code == 200
    token = res.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}

@pytest.fixture
def student_auth_headers():
    res = client.post("/api/v1/auth/demo-token", json={"email": "student1@gmail.com"})
    assert res.status_code == 200
    token = res.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}

# 1. Schema Catalog Discovery
def test_schema_catalog_discovery():
    catalog = SchemaCatalog.load()
    assert catalog["total_tables"] == 122
    assert "students" in catalog["tables"]
    assert "courses" in catalog["tables"]
    assert "timetable" in catalog["tables"]
    assert "staff_attendance" in catalog["tables"]
    assert "faculty_profiles" in catalog["tables"]

# 2. Schema Retrieval for Natural Queries
def test_schema_retrieval_ranking():
    retrieved = SchemaCatalog.retrieve_schema_for_query("Show all courses for semester 2")
    assert "courses" in retrieved["relevant_tables"]
    assert len(retrieved["schemas"]) >= 1

# 3. Query 1: List Courses
def test_nl_list_courses(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show me all courses"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] == "table"
    assert len(data["data"]) == 16

# 4. Query 2: List Users
def test_nl_list_users(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show me faculty"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] == "table"
    assert len(data["data"]) >= 1

# 5. Query 3: Student Lookup
def test_nl_student_lookup(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show student profile for student1"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] in ("text", "table")
    assert "student1" in data["message"].lower() or len(data.get("data") or []) > 0

# 6. Query 4: Attendance Lookup
def test_nl_attendance_lookup(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show staff attendance records"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] in ("table", "text")
    assert len(data.get("data") or []) > 0

# 7. Query 5: Timetable Lookup
def test_nl_timetable_lookup(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show today timetable"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] == "table"
    assert len(data["data"]) == 28

# 8. Query 6: Marks Lookup
def test_nl_marks_lookup(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show internal examination marks"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] in ("table", "text")

# 9. Query 7: Faculty Details
def test_nl_faculty_details(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show faculty members and designations"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] == "table"
    assert len(data["data"]) == 8

# 10. Query 8: Notices Lookup
def test_nl_notices_lookup(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show latest notifications"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] in ("table", "text")

# 11. Query 9: Aggregation / Count
def test_nl_aggregation_count(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "How many courses are available?"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] in ("calculation", "text", "table")

# 12. Query 10: Bar Chart Generation
def test_nl_bar_chart(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show average marks by subject as a bar chart"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] == "chart"
    assert data["chart"]["type"] == "bar"
    assert len(data["chart"]["data"]) > 0

# 13. Query 11: Pie Chart Generation
def test_nl_pie_chart(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show attendance status distribution as a pie chart"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] == "chart"
    assert data["chart"]["type"] == "pie"
    assert len(data["chart"]["data"]) > 0

# 14. Query 12: Line Chart Generation
def test_nl_line_chart(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show attendance trends over time as a line chart"}, headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] == "chart"
    assert data["chart"]["type"] in ("line", "bar")

# 15. Query 13: Follow-up Pronoun Resolution
def test_nl_follow_up_context(auth_headers):
    # Session step 1
    s_res = client.post("/api/v1/chat/sessions", json={"title": "Test Follow-up"}, headers=auth_headers)
    session_id = s_res.json()["id"]

    res1 = client.post("/api/v1/chat", json={"session_id": session_id, "message": "Show student profile for student1"}, headers=auth_headers)
    assert res1.status_code == 200

    # Session step 2 (Follow-up pronoun 'his')
    res2 = client.post("/api/v1/chat", json={"session_id": session_id, "message": "What about his marks?"}, headers=auth_headers)
    assert res2.status_code == 200
    assert res2.json()["response_type"] in ("table", "text")

# 16. Security Test: SQL Injection Attempt
def test_security_sql_injection(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Show courses' OR '1'='1"}, headers=auth_headers)
    assert res.status_code == 200
    # Should not execute injection or crash
    assert res.json()["response_type"] in ("table", "text", "clarification")

# 17. Security Test: Destructive Query Blocked
def test_security_destructive_query(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "DROP TABLE students;"}, headers=auth_headers)
    assert res.status_code == 200
    assert res.json()["response_type"] in ("clarification", "error")

# 18. General / Out of domain Question
def test_out_of_domain_question(auth_headers):
    res = client.post("/api/v1/chat", json={"message": "Who will win the World Cup?"}, headers=auth_headers)
    assert res.status_code == 200
    assert res.json()["response_type"] in ("clarification", "text")
