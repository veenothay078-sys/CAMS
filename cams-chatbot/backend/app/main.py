import time
from datetime import datetime, timezone
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from app.core.config import settings
from app.core.logging import setup_logging, logger
from app.api.v1.api import api_router
from app.database.connection import check_db_connectivity
from app.schemas.health import HealthResponse

# Initialize structured logging
setup_logging()

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="Natural language conversational intelligence over the CAMS PostgreSQL database.",
    version="1.0.0-phase1",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def request_logging_middleware(request: Request, call_next):
    """Logs latency and status code for each incoming API request."""
    start_time = time.perf_counter()
    response = await call_next(request)
    process_time = round((time.perf_counter() - start_time) * 1000, 2)
    logger.info(f"{request.method} {request.url.path} returned {response.status_code} ({process_time}ms)")
    return response


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Centralized exception handler to prevent internal trace leakage."""
    logger.error(f"Unhandled exception on {request.method} {request.url.path}: {exc}", exc_info=True)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": "Internal server error occurred. Please contact CAMS administrator."}
    )


# Root Health-check endpoint: GET /health
@app.get("/health", response_model=HealthResponse, tags=["Health"])
def root_health():
    """Root health check endpoint."""
    db_status = check_db_connectivity()
    return HealthResponse(
        status="healthy" if db_status["connected"] else "degraded",
        environment=settings.APP_ENV,
        timestamp=datetime.now(timezone.utc),
        version="1.0.0-phase1",
        database_connected=db_status["connected"],
        database_tables_count=db_status["tables_count"],
        database_error=db_status["error"]
    )


# Mount versioned API routes: /api/v1
app.include_router(api_router, prefix=settings.API_V1_STR)


@app.on_event("startup")
def on_startup():
    logger.info(f"Starting {settings.PROJECT_NAME} in '{settings.APP_ENV}' mode...")
    db_info = check_db_connectivity()
    if db_info["connected"]:
        logger.info(f"PostgreSQL connection verified! Detected {db_info['tables_count']} tables in CAMS database.")
    else:
        logger.warning(f"PostgreSQL connection could not be established: {db_info['error']}")


@app.on_event("shutdown")
def on_shutdown():
    logger.info(f"Shutting down {settings.PROJECT_NAME}...")
