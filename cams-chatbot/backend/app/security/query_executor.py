import time
import logging
from typing import Dict, Any, List, Optional
from sqlalchemy import text
from sqlalchemy.orm import Session
from sqlalchemy.exc import DBAPIError, OperationalError
from app.security.query_policy import QueryPolicy

logger = logging.getLogger("cams_chatbot.query_executor")


class QueryExecutor:
    """Executes validated read-only SQL queries with session-level timeout and bounds."""

    def __init__(self, db: Session):
        self.db = db

    def execute(self, sanitized_sql: str, params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        start_time = time.perf_counter()
        params = params or {}

        try:
            # Enforce read-only transaction state and timeout on current session
            self.db.execute(text(f"SET LOCAL statement_timeout = {QueryPolicy.get_statement_timeout_ms()};"))
            self.db.execute(text("SET LOCAL default_transaction_read_only = on;"))

            statement = text(sanitized_sql)
            result = self.db.execute(statement, params)

            keys = list(result.keys()) if result.returns_rows else []
            raw_rows = [dict(zip(keys, row)) for row in result.fetchall()] if result.returns_rows else []

            elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)
            logger.info(f"Query executed successfully in {elapsed_ms}ms ({len(raw_rows)} rows)")

            return {
                "success": True,
                "row_count": len(raw_rows),
                "columns": keys,
                "raw_rows": raw_rows,
                "execution_time_ms": elapsed_ms,
                "error": None
            }

        except OperationalError as oe:
            self.db.rollback()
            elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)
            err_msg = str(oe.orig) if hasattr(oe, 'orig') else str(oe)
            logger.error(f"Operational error during query execution ({elapsed_ms}ms): {err_msg}")
            if "statement timeout" in err_msg.lower():
                return {
                    "success": False,
                    "row_count": 0,
                    "columns": [],
                    "raw_rows": [],
                    "execution_time_ms": elapsed_ms,
                    "error": "Query cancelled: execution time exceeded maximum permitted timeout (10,000ms)"
                }
            return {
                "success": False,
                "row_count": 0,
                "columns": [],
                "raw_rows": [],
                "execution_time_ms": elapsed_ms,
                "error": "Database operational error during execution"
            }

        except DBAPIError as de:
            self.db.rollback()
            elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)
            err_msg = str(de.orig) if hasattr(de, 'orig') else str(de)
            logger.error(f"DBAPI error during query execution: {err_msg}")
            return {
                "success": False,
                "row_count": 0,
                "columns": [],
                "raw_rows": [],
                "execution_time_ms": elapsed_ms,
                "error": "Database access error: permission denied or read-only transaction violated"
            }

        except Exception as e:
            self.db.rollback()
            elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)
            logger.error(f"Unexpected query execution error: {e}")
            return {
                "success": False,
                "row_count": 0,
                "columns": [],
                "raw_rows": [],
                "execution_time_ms": elapsed_ms,
                "error": "Internal execution error occurred"
            }
