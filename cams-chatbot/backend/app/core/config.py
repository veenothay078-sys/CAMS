import os
from typing import List
from pydantic import BaseModel
from dotenv import load_dotenv

# Load .env from project root or backend folder
env_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), ".env")
load_dotenv(dotenv_path=env_path)


class Settings(BaseModel):
    PROJECT_NAME: str = os.getenv("PROJECT_NAME", "CAMS AI Chatbot")
    APP_ENV: str = os.getenv("APP_ENV", "development")
    DEBUG: bool = os.getenv("DEBUG", "true").lower() in ("true", "1", "yes")
    API_V1_STR: str = os.getenv("API_V1_STR", "/api/v1")

    # Database
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL",
        "postgresql://cams_readonly:cams_readonly_pass@127.0.0.1:5433/cams_db"
    )
    DB_STATEMENT_TIMEOUT_MS: int = int(os.getenv("DB_STATEMENT_TIMEOUT_MS", "10000"))
    DB_MAX_ROWS_LIMIT: int = int(os.getenv("DB_MAX_ROWS_LIMIT", "100"))

    # Security
    SECRET_KEY: str = os.getenv("SECRET_KEY", "cams-chatbot-development-secret-key-change-in-production")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "1440"))

    # NVIDIA NIM Configuration
    NVIDIA_API_KEY: str = os.getenv("NVIDIA_API_KEY", os.getenv("NVIDIA_NIM_API_KEY", ""))
    NVIDIA_NIM_API_KEY: str = os.getenv("NVIDIA_API_KEY", os.getenv("NVIDIA_NIM_API_KEY", ""))
    NVIDIA_NIM_BASE_URL: str = os.getenv("NVIDIA_NIM_BASE_URL", "https://integrate.api.nvidia.com/v1")
    NVIDIA_MODEL: str = os.getenv("NVIDIA_MODEL", os.getenv("NVIDIA_NIM_MODEL", "meta/llama-3.1-70b-instruct"))
    NVIDIA_NIM_MODEL: str = os.getenv("NVIDIA_MODEL", os.getenv("NVIDIA_NIM_MODEL", "meta/llama-3.1-70b-instruct"))
    NVIDIA_NIM_TIMEOUT_SEC: float = float(os.getenv("NVIDIA_NIM_TIMEOUT_SEC", "15.0"))

    # E2B Sandbox
    E2B_API_KEY: str = os.getenv("E2B_API_KEY", "")

    # CORS
    CORS_ORIGINS: List[str] = [
        origin.strip()
        for origin in os.getenv(
            "CORS_ORIGINS",
            "http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:8000"
        ).split(",")
        if origin.strip()
    ]


settings = Settings()
