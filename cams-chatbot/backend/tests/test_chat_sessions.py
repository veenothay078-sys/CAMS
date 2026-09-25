import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_chat_session_lifecycle():
    """Tests creating session, listing sessions, sending a query, and checking messages."""
    # 1. Create a session
    create_res = client.post("/api/v1/chat/sessions", json={"title": "Test Inquiry"})
    assert create_res.status_code == 200
    session_data = create_res.json()
    session_id = session_data["id"]
    assert session_id.startswith("cs_")

    # 2. List sessions
    list_res = client.get("/api/v1/chat/sessions")
    assert list_res.status_code == 200
    sessions = list_res.json()
    assert any(s["id"] == session_id for s in sessions)

    # 3. Send a message asking about student profiles
    msg_res = client.post(
        f"/api/v1/chat/sessions/{session_id}/messages",
        json={"content": "Show student profile information"}
    )
    assert msg_res.status_code == 200
    msg_data = msg_res.json()
    assert msg_data["session_id"] == session_id
    assert msg_data["user_message"]["role"] == "USER"
    assert msg_data["assistant_message"]["role"] == "ASSISTANT"
    assert "Found" in msg_data["assistant_message"]["content"] or "student" in msg_data["assistant_message"]["content"].lower()

    # 4. Retrieve message history
    history_res = client.get(f"/api/v1/chat/sessions/{session_id}/messages")
    assert history_res.status_code == 200
    history = history_res.json()
    assert len(history) >= 2
    assert history[0]["role"] == "USER"
    assert history[1]["role"] == "ASSISTANT"


def test_query_domains_endpoint():
    """Verifies that all 10 priority domains are returned."""
    res = client.get("/api/v1/query/domains")
    assert res.status_code == 200
    domains = res.json()
    expected = ["student", "attendance", "examinations", "marks", "courses", "timetable", "faculty", "fees", "notices", "academic_calendar"]
    for exp in expected:
        assert exp in domains
