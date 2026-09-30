import requests
import json
import sys

API_BASE = "http://127.0.0.1:8000/api/v1"
HEALTH_URL = "http://127.0.0.1:8000/health"

def run_checks():
    print("========================================")
    print("CAMS 2.0 REDESIGN API & REAL DATA VERIFICATION")
    print("========================================")
    
    # 1. Health
    res = requests.get(HEALTH_URL)
    assert res.status_code == 200, f"Health check failed: {res.text}"
    health_data = res.json()
    print(f"[PASS] Health Check: Connected={health_data.get('database_connected')}, Tables={health_data.get('database_tables_count')}")

    # 2. Auth Demo Token
    res = requests.post(f"{API_BASE}/auth/demo-token", json={"email": "admin@gmail.com"})
    assert res.status_code == 200, f"Auth token failed: {res.text}"
    token_data = res.json()
    token = token_data["access_token"]
    headers = {"Authorization": f"Bearer {token}"}
    print(f"[PASS] Auth Token: Role={token_data.get('role')}, User={token_data.get('full_name')}")

    # 3. Attendance Summary
    res = requests.get(f"{API_BASE}/attendance/summary", headers=headers)
    assert res.status_code == 200, f"Attendance summary failed: {res.text}"
    summary = res.json()
    print(f"[PASS] Attendance Summary: Overall={summary.get('overall_percentage')}%, Present={summary.get('total_present')}, Absent={summary.get('total_absent')}, Total Classes={summary.get('total_classes')}")

    # 4. Attendance Risk Panel
    res = requests.get(f"{API_BASE}/attendance/risk-panel", headers=headers)
    assert res.status_code == 200, f"Risk panel failed: {res.text}"
    risk_list = res.json()
    print(f"[PASS] Attendance Risk Panel: {len(risk_list)} at-risk students identified")

    # 5. Courses Query
    res = requests.post(f"{API_BASE}/data/query", json={
        "domain": "courses",
        "intent": "list_courses",
        "entities": {},
        "requested_output": "table"
    }, headers=headers)
    assert res.status_code == 200, f"Courses query failed: {res.text}"
    courses = res.json().get("data", [])
    print(f"[PASS] Courses Catalog: {len(courses)} active courses retrieved")

    # 6. Users / Demo Users
    res = requests.get(f"{API_BASE}/auth/demo-users")
    assert res.status_code == 200, f"Demo users failed: {res.text}"
    users = res.json()
    print(f"[PASS] Users Directory: {len(users)} institutional accounts retrieved")

    # 7. Timetable Query
    res = requests.post(f"{API_BASE}/data/query", json={
        "domain": "timetable",
        "intent": "weekly_schedule",
        "entities": {},
        "requested_output": "table"
    }, headers=headers)
    assert res.status_code == 200, f"Timetable query failed: {res.text}"
    periods = res.json().get("data", [])
    print(f"[PASS] Timetable Schedule: {len(periods)} period slots retrieved")

    # 8. Notices
    res = requests.get(f"{API_BASE}/data/notices/recent", headers=headers)
    assert res.status_code == 200, f"Notices failed: {res.text}"
    notices = res.json()
    print(f"[PASS] Notifications & Circulars: {len(notices)} notices retrieved")

    # 9. AI Assistant Chat Query
    session_res = requests.post(f"{API_BASE}/chat/sessions", json={"title": "Verification Test Session"}, headers=headers)
    assert session_res.status_code == 200, f"Create session failed: {session_res.text}"
    session_id = session_res.json()["id"]

    chat_res = requests.post(f"{API_BASE}/chat", json={
        "session_id": session_id,
        "message": "Show students below 75% attendance"
    }, headers=headers)
    assert chat_res.status_code == 200, f"Chat query failed: {chat_res.text}"
    chat_data = chat_res.json()
    print(f"[PASS] AI Assistant Response: Domain={chat_data.get('domain')}, Type={chat_data.get('response_type')}, HasData={bool(chat_data.get('data'))}")

    print("========================================")
    print("ALL 9 BACKEND & DATA INTELLIGENCE INTEGRITY CHECKS PASSED!")
    print("========================================")

if __name__ == "__main__":
    run_checks()
