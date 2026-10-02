import logging
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from app.core.config import settings

logger = logging.getLogger("cams_chatbot.database")

# Format database URL safely for SQLAlchemy
db_url = settings.DATABASE_URL
if db_url.startswith("postgres://"):
    db_url = db_url.replace("postgres://", "postgresql://", 1)

# Create engine with production-ready connection pooling
# connect_args to enforce statement timeout at session level
connect_args = {
    "options": f"-c statement_timeout={settings.DB_STATEMENT_TIMEOUT_MS}"
}

engine = create_engine(
    db_url,
    pool_pre_ping=True,
    pool_size=10,
    max_overflow=20,
    connect_args=connect_args,
    echo=False
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def check_db_connectivity() -> dict:
    """Verifies live PostgreSQL connection and counts tables."""
    try:
        with engine.connect() as conn:
            result = conn.execute(
                text("SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';")
            )
            count = result.scalar()
            return {
                "connected": True,
                "tables_count": count,
                "error": None
            }
    except Exception as e:
        logger.error(f"Database connectivity check failed: {e}")
        return {
            "connected": False,
            "tables_count": 0,
            "error": str(e)
        }
