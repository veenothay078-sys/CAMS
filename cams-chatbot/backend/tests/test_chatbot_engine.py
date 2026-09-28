import pytest
from app.database.connection import SessionLocal
from app.chatbot.chat_service import ChatService
from app.chatbot.query_plan import QueryPlan
from app.chatbot.query_planner import QueryPlanner
from app.chatbot.authorization_service import AuthorizationService
from app.chatbot.plan_query_builder import PlanQueryBuilder
from app.services.safe_query_service import SafeQueryService
from app.security.query_validator import QueryValidator

@pytest.fixture(scope="module")
def db_session():
    db = SessionLocal()
    yield db
    db.close()

@pytest.fixture(scope="module")
def chat_service(db_session):
    return ChatService(db_session)


# 1. Attendance question
def test_attendance_question(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_attendance",
        message="What is the attendance of student1?",
        user_context={"role": "ADMIN"}
    )
    assert res["response_type"] in ("table", "text")
    assert "attendance" in res["message"].lower() or "record" in res["message"].lower()


# 2. Examination schedule question
def test_examination_schedule_question(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_exam",
        message="Show the examination schedule for semester 1",
        user_context={"role": "STUDENT"}
    )
    assert res["response_type"] in ("table", "text")
    assert "examination" in res["message"].lower() or "schedule" in res["message"].lower()


# 3. Marks question
def test_marks_question(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_marks",
        message="What are the internal marks for student1?",
        user_context={"role": "ADMIN"}
    )
    assert res["response_type"] == "table"
    assert res["data"] is not None
    assert len(res["data"]) > 0
    assert "internal mark" in res["message"].lower()


# 4. Timetable question
def test_timetable_question(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_timetable",
        message="Show the timetable for Thursday",
        user_context={"role": "STUDENT"}
    )
    assert res["response_type"] == "table"
    assert res["data"] is not None
    assert len(res["data"]) > 0
    assert "Thursday" in res["message"]


# 5. Student information question
def test_student_information_question(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_student_info",
        message="Show profile for student1",
        user_context={"role": "ADMIN"}
    )
    assert res["response_type"] == "text"
    assert "student1" in res["message"]
    assert "LAW-001" in res["message"]


# 6. Unknown intent
def test_unknown_intent(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_unknown",
        message="What is the weather outside today in New York?",
        user_context={"role": "STUDENT"}
    )
    assert res["response_type"] == "clarification"
    assert "couldn't identify" in res["message"].lower() or "ask about" in res["message"].lower()


# 7. Missing student information (ambiguous query without identity)
def test_missing_student_information(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_ambiguous",
        message="Show my attendance",
        user_context={"role": "STUDENT"}  # No roll_no or student_id provided
    )
    assert res["response_type"] == "clarification"
    assert "student id or roll number" in res["message"].lower()


# 8. No database result (empty-result response, no hallucination)
def test_no_database_result(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_empty",
        message="Show profile for student NonExistent999",
        user_context={"role": "ADMIN"}
    )
    assert res["response_type"] == "text"
    assert "couldn't find a student" in res["message"].lower() or "no matching" in res["message"].lower()
    assert res["data"] == []


# 9. Unauthorized request (student requesting another student's private data)
def test_unauthorized_request(chat_service):
    res = chat_service.process_message(
        session_id="test_sess_unauthorized",
        message="Show internal marks for student5",
        user_context={
            "role": "STUDENT",
            "student_id": "std_law_001",
            "roll_no": "LAW-001",
            "full_name": "student1"
        }
    )
    assert res["response_type"] == "error"
    assert "Access Denied" in res["message"]


# 10. Conversation follow-up (pronoun resolution across turns)
def test_conversation_follow_up(chat_service):
    sess_id = "test_sess_followup"
    # Turn 1: Mention student1
    res1 = chat_service.process_message(
        session_id=sess_id,
        message="What is student1's profile?",
        user_context={"role": "ADMIN"}
    )
    assert "LAW-001" in res1["message"]

    # Turn 2: Follow up with pronoun "his"
    res2 = chat_service.process_message(
        session_id=sess_id,
        message="What about his marks?",
        user_context={"role": "ADMIN"}
    )
    assert res2["response_type"] == "table"
    assert res2["data"] is not None
    assert len(res2["data"]) > 0
    assert "LAW-001" in str(res2["data"])


# 11. Safe Query Layer integration (validation, execution, sanitization)
def test_safe_query_layer_integration(db_session):
    safe_service = SafeQueryService(db_session)
    planner = QueryPlanner()
    plan = planner.plan_query(
        intent="courses",
        entities={"semester": 1},
        user_context={"role": "STUDENT"}
    )
    result = safe_service.execute_plan(plan, user_role="STUDENT")
    assert result["success"] is True
    assert result["row_count"] > 0
    assert "courses" in result["tables_accessed"]
    assert result["error"] is None


# 12. Raw SQL injection attempt (must be blocked / neutralized)
def test_raw_sql_injection_attempt(chat_service):
    malicious_input = "Show attendance for student'; DROP TABLE students; --"
    res = chat_service.process_message(
        session_id="test_sess_sqli",
        message=malicious_input,
        user_context={"role": "ADMIN"}
    )
    # The injection attempt should either result in clarification, empty result, or error - NEVER raw execution
    assert res["response_type"] in ("clarification", "text", "error")
    # Verify students table was NOT dropped
    db = SessionLocal()
    from sqlalchemy import text
    cnt = db.execute(text("SELECT count(*) FROM students")).scalar()
    assert cnt > 0
    db.close()


# 13. Invalid query plan handling
def test_invalid_query_plan(db_session):
    safe_service = SafeQueryService(db_session)
    invalid_plan = QueryPlan(
        intent="non_existent_intent",
        domain="unknown",
        tables=["non_existent_table"],
        filters={}
    )
    result = safe_service.execute_plan(invalid_plan, user_role="STUDENT")
    assert result["success"] is False or result.get("error") is not None


# 14. Unsupported table request (restricted internal table blocked by policy)
def test_unsupported_table_request(db_session):
    # Attempt to query strictly forbidden table "audit_logs"
    forbidden_plan = QueryPlan(
        intent="audit",
        domain="security",
        tables=["audit_logs"],
        filters={}
    )
    # 1. AuthorizationService check
    is_auth, err = AuthorizationService.authorize(forbidden_plan, {"role": "STUDENT"})
    assert is_auth is False
    assert "not authorized" in err.lower()

    # 2. QueryValidator check
    is_valid, _, _, val_err = QueryValidator.validate("SELECT * FROM audit_logs", user_role="STUDENT")
    assert is_valid is False
    assert "forbidden" in val_err.lower() or "not authorized" in val_err.lower()


# 15. FastAPI HTTP POST /api/v1/chat endpoint integration
def test_post_chat_api_endpoint():
    from fastapi.testclient import TestClient
    from app.main import app

    client = TestClient(app)
    response = client.post(
        "/api/v1/chat",
        json={"message": "Show courses for semester 1"},
        headers={"X-User-Role": "STUDENT"}
    )
    assert response.status_code == 200
    data = response.json()
    assert "session_id" in data
    assert data["response_type"] == "table"
    assert data["data"] is not None
    assert len(data["data"]) > 0


# 16. FastAPI HTTP POST /api/v1/chat student data isolation
def test_post_chat_api_student_data_isolation():
    from fastapi.testclient import TestClient
    from app.main import app

    client = TestClient(app)
    # Student1 attempting to query student5's private records
    response = client.post(
        "/api/v1/chat",
        json={"message": "Show marks for student5"},
        headers={
            "X-User-Role": "STUDENT",
            "X-Roll-No": "LAW-001",
            "X-Student-Id": "std_law_001",
            "X-Full-Name": "student1"
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert data["response_type"] == "error"
    assert "Access Denied" in data["message"]
