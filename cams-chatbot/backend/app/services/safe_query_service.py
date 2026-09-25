from typing import Dict, Any, Optional
from sqlalchemy.orm import Session
from app.security.query_validator import QueryValidator
from app.security.query_executor import QueryExecutor
from app.security.result_formatter import QueryResultFormatter
from app.core.logging import logger

class SafeQueryService:
    """
    Core Safe Query Layer service:
    Validates candidate SQL -> enforces role policy -> executes read-only query -> sanitizes results.
    """

    def __init__(self, db: Session):
        self.db = db
        self.executor = QueryExecutor(db)

    def execute_safe_query(
        self,
        sql: str,
        params: Optional[Dict[str, Any]] = None,
        user_role: str = "STUDENT"
    ) -> Dict[str, Any]:
        """
        Coordinates the complete safe query workflow.
        Returns:
            Dict containing success, row_count, columns, data, execution_time_ms, tables_accessed, error
        """
        # Step 1: Validation & Policy check
        is_valid, sanitized_sql, tables, error = QueryValidator.validate(sql, user_role=user_role)
        if not is_valid:
            logger.warning(f"Query validation failed for role [{user_role}]: {error}")
            return {
                "success": False,
                "row_count": 0,
                "columns": [],
                "data": [],
                "execution_time_ms": 0.0,
                "tables_accessed": tables,
                "error": error
            }

        # Step 2: Safe execution
        exec_result = self.executor.execute(sanitized_sql, params)
        if not exec_result["success"]:
            return {
                "success": False,
                "row_count": 0,
                "columns": [],
                "data": [],
                "execution_time_ms": exec_result["execution_time_ms"],
                "tables_accessed": tables,
                "error": exec_result["error"]
            }

        # Step 3: Result Sanitization & PII Masking
        sanitized_data = QueryResultFormatter.format_results(exec_result["raw_rows"], user_role=user_role)

        return {
            "success": True,
            "row_count": len(sanitized_data),
            "columns": exec_result["columns"],
            "data": sanitized_data,
            "execution_time_ms": exec_result["execution_time_ms"],
            "tables_accessed": tables,
            "error": None
        }
