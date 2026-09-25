from fastapi import APIRouter
from app.api.v1.endpoints import health, auth, chat, query, data

api_router = APIRouter()

api_router.include_router(health.router, tags=["Health"])
api_router.include_router(auth.router, prefix="/auth", tags=["Authentication & RBAC"])
api_router.include_router(chat.router, prefix="/chat", tags=["Conversational Chatbot"])
api_router.include_router(query.router, prefix="/query", tags=["Safe Query Engine"])
api_router.include_router(data.router, prefix="/data", tags=["Controlled Data Access"])
