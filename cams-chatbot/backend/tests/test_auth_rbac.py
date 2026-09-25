import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.security.auth import create_access_token, decode_access_token

client = TestClient(app)

def test_demo_token_generation_success():
    """Generates valid JWT for existing CAMS admin user."""
    response = client.post("/api/v1/auth/demo-token", json={"email": "admin@gmail.com"})
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["email"] == "admin@gmail.com"
    assert data["role"] == "ADMIN"

def test_demo_token_invalid_user_fails():
    """Requesting token for non-existent user must return 404."""
    response = client.post("/api/v1/auth/demo-token", json={"email": "nonexistent@gmail.com"})
    assert response.status_code == 404

def test_invalid_bearer_token_rejected():
    """Malformed or invalid JWT must return 401."""
    headers = {"Authorization": "Bearer invalid.jwt.token"}
    response = client.get("/api/v1/auth/me", headers=headers)
    assert response.status_code == 401

def test_valid_token_me_endpoint():
    """Valid JWT allows accessing /auth/me."""
    token = create_access_token({
        "id": "usr_student1",
        "email": "student1@gmail.com",
        "full_name": "Student One",
        "role": "STUDENT"
    })
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/api/v1/auth/me", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == "student1@gmail.com"
    assert data["role"] == "STUDENT"
