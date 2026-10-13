import logging
from pathlib import Path
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


def auto_seed_database_if_empty() -> dict:
    """
    Checks if PostgreSQL public tables count is 0.
    If empty, executes cams_db_dump.sql to automatically create all 122 tables
    and populate baseline seed data (degrees, courses, users, chat tables, etc.).
    """
    try:
        status = check_db_connectivity()
        if not status["connected"]:
            return {
                "seeded": False,
                "tables_count": 0,
                "error": f"Database not connected: {status['error']}"
            }

        if status["tables_count"] > 0:
            logger.info(f"Database already contains {status['tables_count']} tables. Skipping auto-seeding.")
            return {
                "seeded": False,
                "tables_count": status["tables_count"],
                "message": f"Database already contains {status['tables_count']} tables."
            }

        logger.warning("Database contains 0 tables! Initializing schema and seed records from cams_db_dump.sql...")

        candidate_paths = [
            Path(__file__).resolve().parent / "cams_db_dump.sql",
            Path(__file__).resolve().parents[1] / "cams_db_dump.sql",
            Path(__file__).resolve().parents[2] / "cams_db_dump.sql",
            Path("app/database/cams_db_dump.sql"),
            Path("cams_db_dump.sql"),
            Path("cams-chatbot/backend/app/database/cams_db_dump.sql"),
            Path("cams-chatbot/backend/cams_db_dump.sql"),
        ]

        dump_file = None
        for path in candidate_paths:
            if path.exists():
                dump_file = path
                break

        if not dump_file:
            err = f"Could not locate cams_db_dump.sql in candidates: {[str(p) for p in candidate_paths]}"
            logger.error(err)
            return {"seeded": False, "tables_count": 0, "error": err}

        logger.info(f"Executing database dump from {dump_file} (size: {dump_file.stat().st_size} bytes)...")
        with open(dump_file, "r", encoding="utf-8") as f:
            sql_script = f.read()

        raw_conn = engine.raw_connection()
        try:
            with raw_conn.cursor() as cur:
                cur.execute("SET statement_timeout = 0;")
                cur.execute(sql_script)
            raw_conn.commit()
            logger.info("Database seed script executed and committed successfully.")
        except Exception as exec_err:
            raw_conn.rollback()
            logger.error(f"Execution of seed script failed: {exec_err}", exc_info=True)
            return {"seeded": False, "tables_count": 0, "error": str(exec_err)}
        finally:
            raw_conn.close()

        # Re-check count
        updated_status = check_db_connectivity()
        logger.info(f"Auto-seeding completed! Database now has {updated_status['tables_count']} tables.")
        return {
            "seeded": True,
            "tables_count": updated_status["tables_count"],
            "message": f"Successfully initialized {updated_status['tables_count']} tables and seed records."
        }

    except Exception as e:
        logger.error(f"Unexpected error during auto_seed_database_if_empty: {e}", exc_info=True)
        return {"seeded": False, "tables_count": 0, "error": str(e)}

