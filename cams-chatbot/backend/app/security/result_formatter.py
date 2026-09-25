from typing import List, Dict, Any
from app.security.query_policy import SENSITIVE_COLUMNS

class QueryResultFormatter:
    """Formats and sanitizes query result rows before sending to services or API callers."""

    @classmethod
    def format_results(cls, rows: List[Dict[str, Any]], user_role: str = "STUDENT") -> List[Dict[str, Any]]:
        """
        Strips confidential columns (e.g., passwords, sensitive identifiers)
        and converts date/decimal/UUID objects to JSON primitives.
        """
        sanitized = []
        is_admin = user_role in ("SUPER_ADMIN", "ADMIN")

        for row in rows:
            clean_row = {}
            for col_name, val in row.items():
                col_lower = col_name.lower()
                # Never return password hashes regardless of role
                if "password" in col_lower:
                    continue
                # For non-admin, filter sensitive PII
                if not is_admin and col_lower in SENSITIVE_COLUMNS:
                    continue

                # Type normalization
                if hasattr(val, "isoformat"):
                    clean_row[col_name] = val.isoformat()
                elif hasattr(val, "__str__") and type(val).__name__ in ("Decimal", "UUID"):
                    clean_row[col_name] = str(val)
                else:
                    clean_row[col_name] = val

            sanitized.append(clean_row)
        return sanitized
