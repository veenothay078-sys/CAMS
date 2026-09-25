import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_root_health_endpoint():
    """Verifies root GET /health returns status, version, and verified live database connectivity."""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["database_connected"] is True
    assert data["database_tables_count"] == 122
    assert data["database_error"] is None

def test_api_v1_health_endpoint():
    """Verifies versioned GET /api/v1/health returns consistent status."""
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["database_connected"] is True
    assert data["database_tables_count"] == 122

def test_database_health_endpoint():
    """Verifies GET /api/v1/health/database returns dedicated database status without exposing credentials."""
    response = client.get("/api/v1/health/database")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["database_type"] == "PostgreSQL"
    assert data["connected"] is True
    assert data["tables_detected"] == 122
    assert data["read_only_mode"] is True
    assert data["statement_timeout_ms"] == 10000
    assert data["latency_ms"] >= 0.0
    assert data["error"] is None
    # Verify no credential leakage in response
    resp_text = response.text.lower()
    assert "password" not in resp_text
    assert "cams_readonly_pass" not in resp_text
    assert "secret" not in resp_text
