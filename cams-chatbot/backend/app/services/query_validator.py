from typing import Dict, Any
from app.security.safe_query import SafeQueryValidator

class QueryValidatorService:
    """Service to validate and audit arbitrary candidate SQL queries."""

    @staticmethod
    def validate(sql: str) -> Dict[str, Any]:
        is_valid, sanitized_sql, tables, error = SafeQueryValidator.validate_query(sql)
        warnings = []
        if sanitized_sql and "LIMIT" not in sql.upper():
            warnings.append("Automatic LIMIT 100 clause was injected to bound memory consumption.")

        return {
            "is_valid": is_valid,
            "sanitized_sql": sanitized_sql,
            "tables_accessed": tables,
            "error": error,
            "warnings": warnings
        }
