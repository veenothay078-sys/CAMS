import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

@pytest.fixture
def admin_headers():
    res = client.post("/api/v1/auth/demo-token", json={"email": "admin@gmail.com"})
    assert res.status_code == 200
    token = res.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}

@pytest.fixture
def faculty_headers():
    res = client.post("/api/v1/auth/demo-token", json={"email": "palani@gmail.com"})
    assert res.status_code == 200
    token = res.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}

@pytest.fixture
def student_headers():
    res = client.post("/api/v1/auth/demo-token", json={"email": "student1@gmail.com"})
    assert res.status_code == 200
    token = res.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}


# 1. Test Attendance Summary from Real Database
def test_attendance_summary_endpoint(admin_headers):
    res = client.get("/api/v1/attendance/summary", headers=admin_headers)
    assert res.status_code == 200
    data = res.json()
    assert "overall_attendance_pct" in data
    assert data["total_members_tracked"] == 8
    assert data["total_records_logged"] == 56
    assert data["total_days_recorded"] == 7
    assert data["absent_count"] == 40
    assert data["sunday_count"] == 8
    assert data["leave_count"] == 8


# 2. Test Attendance Risk Panel
def test_attendance_risk_panel_endpoint(admin_headers):
    res = client.get("/api/v1/attendance/risk-panel", headers=admin_headers)
    assert res.status_code == 200
    data = res.json()
    assert isinstance(data, list)
    assert len(data) == 8
    first = data[0]
    assert "entity_id" in first
    assert "attendance_pct" in first
    assert "status" in first
    assert first["status"] in ("Healthy", "Monitor", "Attention Required")


# 3. Test Attendance Analytics Charts Data
def test_attendance_analytics_endpoint(admin_headers):
    res = client.get("/api/v1/attendance/analytics", headers=admin_headers)
    assert res.status_code == 200
    data = res.json()
    assert "by_subject" in data
    assert "trend" in data
    assert "distribution" in data
    assert len(data["by_subject"]) == 8
    assert len(data["trend"]) == 7
    assert len(data["distribution"]) >= 3


# 4. Test Paginated & Filtered Attendance Records
def test_attendance_records_pagination_and_filter(admin_headers):
    # Page 1 with page size 10
    res = client.get("/api/v1/attendance/records?page=1&page_size=10", headers=admin_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["total_count"] == 56
    assert len(data["records"]) == 10
    assert data["total_pages"] == 6

    # Filter by status: SUNDAY
    res_sun = client.get("/api/v1/attendance/records?status=SUNDAY", headers=admin_headers)
    assert res_sun.status_code == 200
    data_sun = res_sun.json()
    assert data_sun["total_count"] == 8
    assert all(r["status"].upper() == "SUNDAY" for r in data_sun["records"])

    # Filter by search: Palani
    res_search = client.get("/api/v1/attendance/records?search=Palani", headers=admin_headers)
    assert res_search.status_code == 200
    data_search = res_search.json()
    assert data_search["total_count"] == 7
    assert all("Palani" in r["member_name"] for r in data_search["records"])


# 5. Test Member Detail View
def test_attendance_member_detail(admin_headers):
    res = client.get("/api/v1/attendance/detail/usr_palani", headers=admin_headers)
    assert res.status_code == 200
    detail = res.json()
    assert detail["member_id"] == "usr_palani"
    assert detail["full_name"] == "Palani"
    assert detail["total_days"] == 7
    assert len(detail["recent_logs"]) == 7


# 6. Test AI Assistant Query for Attendance
def test_ai_attendance_query(admin_headers):
    res = client.post("/api/v1/chat", json={"message": "Show staff attendance status breakdown as a chart"}, headers=admin_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["response_type"] in ("chart", "table", "text")
