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

    def execute_plan(
        self,
        plan: Any,
        user_role: str = "STUDENT"
    ) -> Dict[str, Any]:
        """
        Translates a structured QueryPlan into parameterized SQL and executes it
        strictly through the Safe Query Layer.
        Never bypasses QueryValidator or role-based security policies.
        """
        if getattr(plan, "requires_clarification", False):
            return {
                "success": True,
                "row_count": 0,
                "columns": [],
                "data": [],
                "execution_time_ms": 0.0,
                "tables_accessed": getattr(plan, "tables", []),
                "is_clarification": True,
                "clarification_prompt": getattr(plan, "clarification_prompt", "Please provide more details."),
                "error": None
            }

        from app.chatbot.plan_query_builder import PlanQueryBuilder
        sql, params = PlanQueryBuilder.build_query(plan)

        if not sql:
            return {
                "success": False,
                "row_count": 0,
                "columns": [],
                "data": [],
                "execution_time_ms": 0.0,
                "tables_accessed": getattr(plan, "tables", []),
                "is_clarification": False,
                "error": "Failed to construct valid database query from query plan."
            }

        result = self.execute_safe_query(sql, params=params, user_role=user_role)
        result["is_clarification"] = False
        result["clarification_prompt"] = None
        return result
