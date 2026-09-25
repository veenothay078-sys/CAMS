import base64
import json
import time
import hmac
import hashlib
from typing import Optional, Dict, Any
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.core.config import settings

security_bearer = HTTPBearer(auto_error=False)


def _b64encode(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).decode().rstrip("=")

def _b64decode(data: str) -> bytes:
    padding = 4 - (len(data) % 4)
    if padding != 4:
        data += "=" * padding
    return base64.urlsafe_b64decode(data)


def create_access_token(data: Dict[str, Any], expires_delta_sec: Optional[int] = None) -> str:
    """Creates a signed HS256 JWT without heavy external dependencies."""
    header = {"alg": "HS256", "typ": "JWT"}
    to_encode = data.copy()
    expire_time = time.time() + (expires_delta_sec if expires_delta_sec else settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60)
    to_encode.update({"exp": int(expire_time), "iat": int(time.time())})

    header_b64 = _b64encode(json.dumps(header).encode())
    payload_b64 = _b64encode(json.dumps(to_encode).encode())
    signing_input = f"{header_b64}.{payload_b64}".encode()

    signature = hmac.new(settings.SECRET_KEY.encode(), signing_input, hashlib.sha256).digest()
    signature_b64 = _b64encode(signature)

    return f"{header_b64}.{payload_b64}.{signature_b64}"


def decode_access_token(token: str) -> Dict[str, Any]:
    """Decodes and validates signed HS256 JWT."""
    try:
        parts = token.split(".")
        if len(parts) != 3:
            raise ValueError("Invalid JWT format")
        
        header_b64, payload_b64, signature_b64 = parts
        signing_input = f"{header_b64}.{payload_b64}".encode()
        expected_sig = hmac.new(settings.SECRET_KEY.encode(), signing_input, hashlib.sha256).digest()
        actual_sig = _b64decode(signature_b64)

        if not hmac.compare_digest(expected_sig, actual_sig):
            raise ValueError("Signature mismatch")

        payload = json.loads(_b64decode(payload_b64).decode())
        if payload.get("exp", 0) < time.time():
            raise ValueError("Token expired")

        return payload
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Could not validate credentials: {str(e)}",
            headers={"WWW-Authenticate": "Bearer"},
        )


def get_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security_bearer)
) -> Dict[str, Any]:
    """Extracts authenticated user context from Bearer token, or defaults to development user if disabled."""
    if not credentials:
        if settings.APP_ENV == "development":
            # Default development user context mapped to CAMS admin
            return {
                "id": "usr_admin",
                "email": "admin@gmail.com",
                "full_name": "System Administrator",
                "role": "ADMIN",
                "is_active": True
            }
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing Authorization header",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return decode_access_token(credentials.credentials)
