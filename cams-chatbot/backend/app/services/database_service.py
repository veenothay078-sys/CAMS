import time
from typing import Dict, Any, List, Optional
from sqlalchemy import text
from sqlalchemy.orm import Session
from app.core.logging import logger
from app.security.safe_query import SafeQueryValidator

class DatabaseService:
    """Service to safely execute read-only queries against CAMS PostgreSQL."""

    def __init__(self, db: Session):
        self.db = db

    def execute_safe_query(self, sql: str, params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """
        Validates SQL against the Safe Query Layer, then executes it in read-only mode.
        """
        # Step 1: Validate through Safe Query Layer
        is_valid, sanitized_sql, tables, error = SafeQueryValidator.validate_query(sql)
        if not is_valid:
            logger.warning(f"Safe query validation failed: {error} for query: {sql}")
            return {
                "success": False,
                "row_count": 0,
                "columns": [],
                "data": [],
                "execution_time_ms": 0.0,
                "error": error
            }

        start_time = time.perf_counter()
        try:
            # Step 2: Execute strictly in read-only mode
            statement = text(sanitized_sql)
            result = self.db.execute(statement, params or {})
            
            # Fetch column keys and rows
            keys = list(result.keys()) if result.returns_rows else []
            rows = [dict(zip(keys, row)) for row in result.fetchall()] if result.returns_rows else []
            
            # JSON serialize values like dates, times, decimals, enums
            serialized_rows = self._serialize_rows(rows)

            elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)
            logger.info(f"Executed safe query on {tables} in {elapsed_ms}ms ({len(serialized_rows)} rows)")

            return {
                "success": True,
                "row_count": len(serialized_rows),
                "columns": keys,
                "data": serialized_rows,
                "execution_time_ms": elapsed_ms,
                "error": None
            }

        except Exception as e:
            elapsed_ms = round((time.perf_counter() - start_time) * 1000, 2)
            logger.error(f"Error executing safe query: {e}")
            return {
                "success": False,
                "row_count": 0,
                "columns": [],
                "data": [],
                "execution_time_ms": elapsed_ms,
                "error": f"Database execution error: {str(e)}"
            }

    @staticmethod
    def _serialize_rows(rows: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Converts date, decimal, time objects to standard JSON serializable primitives."""
        output = []
        for row in rows:
            clean_row = {}
            for k, v in row.items():
                if hasattr(v, "isoformat"):
                    clean_row[k] = v.isoformat()
                elif hasattr(v, "__str__") and type(v).__name__ in ("Decimal", "UUID"):
                    clean_row[k] = str(v)
                else:
                    clean_row[k] = v
            output.append(clean_row)
        return output
