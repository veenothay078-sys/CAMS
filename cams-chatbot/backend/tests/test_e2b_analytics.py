import pytest
from unittest.mock import MagicMock, patch
from app.database.connection import SessionLocal
from app.services.e2b_service import E2BService
from app.chatbot.chat_service import ChatService
from app.services.nim_service import NIMService

@pytest.fixture(scope="module")
def db_session():
    db = SessionLocal()
    yield db
    db.close()

@pytest.fixture
def sample_dataset():
    return [
        {"subject_name": "Constitutional Law", "percentage": 85.0, "total_classes": 40, "attended_classes": 34},
        {"subject_name": "Jurisprudence", "percentage": 92.5, "total_classes": 40, "attended_classes": 37},
        {"subject_name": "Criminal Law", "percentage": 78.0, "total_classes": 40, "attended_classes": 31},
        {"subject_name": "Family Law", "percentage": 90.0, "total_classes": 40, "attended_classes": 36},
    ]


# 1. Average calculation
def test_e2b_average_calculation(sample_dataset):
    e2b = E2BService(api_key=None)  # test local deterministic fallback
    res = e2b.execute_analysis("average", sample_dataset)
    assert res["success"] is True
    assert res["operation"] == "average"
    assert res["field"] == "percentage"
    # Average of 85.0, 92.5, 78.0, 90.0 is 86.375
    assert abs(res["result"] - 86.38) < 0.1


# 2. Count calculation
def test_e2b_count_calculation(sample_dataset):
    e2b = E2BService(api_key=None)
    res = e2b.execute_analysis("count", sample_dataset)
    assert res["success"] is True
    assert res["operation"] == "count"
    assert res["result"] == 4


# 3. Percentage calculation
def test_e2b_percentage_calculation():
    e2b = E2BService(api_key=None)
    dataset = [
        {"status": "PRESENT"},
        {"status": "PRESENT"},
        {"status": "PRESENT"},
        {"status": "ABSENT"}
    ]
    res = e2b.execute_analysis("percentage", dataset)
    assert res["success"] is True
    assert res["operation"] == "percentage"
    assert res["result"] == 75.0


# 4. Trend analysis
def test_e2b_trend_analysis():
    e2b = E2BService(api_key=None)
    trend_data = [
        {"date": "2026-01-01", "marks": 50},
        {"date": "2026-02-01", "marks": 65},
        {"date": "2026-03-01", "marks": 80},
    ]
    res = e2b.execute_analysis("trend", trend_data)
    assert res["success"] is True
    assert res["operation"] == "trend"
    assert res["direction"] == "increasing"
    assert res["change"] == 30.0


# 5. Bar chart generation
def test_e2b_bar_chart(sample_dataset):
    e2b = E2BService(api_key=None)
    res = e2b.generate_chart_data("bar", sample_dataset, title="Subject Attendance")
    chart = res.get("chart", res)
    assert chart["type"] == "bar"
    assert chart["title"] == "Subject Attendance"
    assert len(chart["data"]) == 4
    assert chart["data"][0]["label"] == "Constitutional Law"
    assert chart["data"][0]["value"] == 85.0


# 6. Line chart generation
def test_e2b_line_chart():
    e2b = E2BService(api_key=None)
    time_series = [
        {"month": "January", "attendance": 88},
        {"month": "February", "attendance": 91},
        {"month": "March", "attendance": 85},
    ]
    res = e2b.generate_chart_data("line", time_series, title="Monthly Attendance Trend")
    chart = res.get("chart", res)
    assert chart["type"] == "line"
    assert chart["title"] == "Monthly Attendance Trend"
    assert len(chart["data"]) == 3
    assert chart["data"][1]["value"] == 91.0


# 7. Empty dataset handling
def test_e2b_empty_dataset():
    e2b = E2BService(api_key=None)
    res = e2b.execute_analysis("average", [])
    assert res["success"] is False
    assert "insufficient" in res["error"].lower()

    res_chart = e2b.generate_chart_data("bar", [])
    chart = res_chart.get("chart", res_chart)
    assert len(chart["data"]) == 0
    assert "insufficient" in res_chart.get("error", "").lower() or "insufficient" in res_chart.get("message", "").lower()


# 8. Invalid dataset handling
def test_e2b_invalid_dataset():
    e2b = E2BService(api_key=None)
    invalid_data = [{"name": "Item 1"}, {"name": "Item 2"}]  # no numeric fields
    res = e2b.execute_analysis("average", invalid_data)
    assert res["success"] is False
    assert "numeric" in res["error"].lower()


# 9. E2B timeout handling
def test_e2b_timeout_handling(sample_dataset):
    e2b = E2BService(api_key="e2b_mock_key_timeout")
    with patch("app.services.e2b_service.Sandbox") as mock_sandbox:
        mock_instance = MagicMock()
        mock_instance.__enter__.return_value = mock_instance
        mock_instance.run_code.side_effect = TimeoutError("Sandbox execution timed out after 30s")
        mock_sandbox.return_value = mock_instance

        # Should fall back cleanly without raising an unhandled exception or leaking stack traces
        res = e2b.execute_analysis("average", sample_dataset)
        assert res["success"] is True  # safely fell back to local deterministic computation
        assert res["operation"] == "average"


# 10. E2B failure handling
def test_e2b_failure_handling(sample_dataset):
    e2b = E2BService(api_key="e2b_mock_key_fail")
    with patch("app.services.e2b_service.Sandbox") as mock_sandbox:
        mock_sandbox.side_effect = Exception("E2B cloud connection refused")

        res = e2b.execute_analysis("maximum", sample_dataset)
        assert res["success"] is True  # safely fell back
        assert res["operation"] == "maximum"
        assert res["result"] == 92.5


# 11. Unauthorized data protection
def test_e2b_unauthorized_data_protection(db_session):
    """Verifies student cannot query fee structures or unauthorized global analytics."""
    chat = ChatService(db_session)
    student_ctx = {"role": "STUDENT", "student_id": "stu_other", "roll_no": "OTHER_001"}
    
    # Attempting to generate a chart of institution-wide fee structures or salary
    res = chat.process_message(
        "sess_sec_test",
        "Show a chart of total college fee collections across departments",
        user_context=student_ctx
    )
    # RBAC or intent check blocks unauthorized database access
    assert res.get("data") is None or len(res.get("data", [])) == 0 or "denied" in res.get("message", "").lower() or "not authorized" in res.get("message", "").lower() or "insufficient" in res.get("message", "").lower()


# 12. Oversized dataset clamping
def test_e2b_oversized_dataset_clamping():
    e2b = E2BService(api_key=None)
    oversized = [{"value": i, "label": f"item_{i}"} for i in range(1200)]
    is_valid, err, sanitized = e2b._validate_and_sanitize_dataset(oversized)
    assert is_valid is True
    assert len(sanitized) == 500  # MAX_DATASET_ROWS limit enforced


# 13. Normal text query does NOT invoke E2B
def test_normal_text_query_does_not_invoke_e2b(db_session):
    mock_e2b = MagicMock()
    nim = NIMService(api_key="nvapi-mock-test")
    nim.parse_intent = MagicMock(return_value=({
        "intent": "student_information",
        "entities": {"student_name": "student1"},
        "requested_output": "text",
        "requires_clarification": False
    }, None))
    nim.synthesize_response = MagicMock(return_value="Student details retrieved.")

    chat = ChatService(db_session, nim_service=nim, e2b_service=mock_e2b)
    res = chat.process_message(
        "sess_norm_text",
        "What is the details for student1?",
        user_context={"role": "ADMIN"}
    )
    assert res["response_type"] in ("text", "summary")
    mock_e2b.execute_analysis.assert_not_called()
    mock_e2b.generate_chart_data.assert_not_called()


# 14. Chart query DOES invoke E2B
def test_chart_query_invokes_e2b(db_session):
    mock_e2b = MagicMock()
    mock_e2b.generate_chart_data.return_value = {
        "success": True,
        "chart": {
            "type": "bar",
            "title": "Internal Marks Visualization",
            "x_axis": "Marks",
            "y_axis": "Score / Metric",
            "data": [{"label": "Subject 1", "value": 90}]
        }
    }

    nim = NIMService(api_key="nvapi-mock-test")
    nim.parse_intent = MagicMock(return_value=({
        "intent": "marks",
        "entities": {"student_name": "student1"},
        "requested_output": "chart",
        "requires_clarification": False
    }, None))
    nim.synthesize_response = MagicMock(return_value="Here is your marks chart.")

    chat = ChatService(db_session, nim_service=nim, e2b_service=mock_e2b)
    res = chat.process_message(
        "sess_chart_query",
        "Show marks as a bar chart for student1",
        user_context={"role": "ADMIN"}
    )
    assert res["response_type"] == "chart"
    mock_e2b.generate_chart_data.assert_called_once()
    assert res.get("chart") is not None
    assert res["chart"]["type"] == "bar"


# 15. PostgreSQL -> E2B data flow end-to-end
def test_postgresql_to_e2b_data_flow(db_session):
    """
    Verifies that real PostgreSQL CAMS data flows cleanly into E2B:
    PostgreSQL -> SafeQueryLayer -> E2BService -> Result
    """
    e2b = E2BService(api_key=None)
    chat = ChatService(db_session, e2b_service=e2b)

    res = chat.process_message(
        "sess_real_data_flow",
        "Show marks as a bar chart for student1",
        user_context={"role": "ADMIN"}
    )
    assert res["response_type"] == "chart"
    assert res.get("chart") is not None
    assert "data" in res["chart"]
    # Data originated from PostgreSQL internal_marks records (2 rows for student1)
    assert len(res["chart"]["data"]) == 2
