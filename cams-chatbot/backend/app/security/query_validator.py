import re
from typing import Tuple, List, Optional
from app.security.query_policy import (
    FORBIDDEN_KEYWORDS, FORBIDDEN_PATTERNS,
    STRICTLY_FORBIDDEN_TABLES, QueryPolicy, MAX_QUERY_ROW_LIMIT
)

class QueryValidator:
    """AST & Lexical validator ensuring all queries conform to strict read-only security."""

    @classmethod
    def validate(cls, sql: str, user_role: str = "STUDENT", max_limit: int = MAX_QUERY_ROW_LIMIT) -> Tuple[bool, Optional[str], List[str], Optional[str]]:
        """
        Validates a candidate SQL statement.
        Returns: (is_valid, sanitized_sql, tables_detected, error_message)
        """
        if not sql or not sql.strip():
            return False, None, [], "Query cannot be empty"

        cleaned_sql = sql.strip().rstrip(";")

        # 1. Multi-statement injection check
        if ";" in cleaned_sql:
            return False, None, [], "Multiple SQL statements are strictly prohibited"

        # 2. Dangerous function / injection pattern check
        for pattern in FORBIDDEN_PATTERNS:
            if re.search(pattern, cleaned_sql, re.IGNORECASE | re.DOTALL):
                return False, None, [], f"Query contains disallowed pattern or comment: {pattern}"

        # 3. Must begin with SELECT or WITH
        tokens = cleaned_sql.split()
        if not tokens:
            return False, None, [], "Empty query token sequence"

        first_token = tokens[0].upper()
        if first_token not in ("SELECT", "WITH"):
            return False, None, [], f"Only read-only SELECT queries are permitted (received '{first_token}')"

        # 4. Forbidden keyword check anywhere in the query
        upper_query = cleaned_sql.upper()
        words = set(re.findall(r"\b[A-Z_]+\b", upper_query))
        forbidden_found = words.intersection(FORBIDDEN_KEYWORDS)
        if forbidden_found:
            return False, None, [], f"Query contains forbidden operation keyword(s): {', '.join(sorted(forbidden_found))}"

        # 5. Extract tables accessed
        tables_detected = cls._extract_tables(cleaned_sql)
        if not tables_detected:
            return False, None, [], "Could not identify target table in query"

        # 6. Policy check on detected tables
        for tbl in tables_detected:
            tbl_clean = tbl.lower().replace('"', '')
            if tbl_clean in STRICTLY_FORBIDDEN_TABLES:
                return False, None, tables_detected, f"Access to restricted internal table '{tbl}' is forbidden"
            if not QueryPolicy.is_table_allowed(tbl_clean, user_role):
                return False, None, tables_detected, f"Role '{user_role}' is not authorized to query table '{tbl}'"

        # 7. Enforce LIMIT clause
        sanitized_sql = cls._enforce_limit(cleaned_sql, max_limit)

        return True, sanitized_sql, tables_detected, None

    @classmethod
    def _extract_tables(cls, sql: str) -> List[str]:
        pattern = r"\b(?:FROM|JOIN)\s+(?:public\.)?([\"a-zA-Z0-9_]+)"
        matches = re.findall(pattern, sql, re.IGNORECASE)
        tables = []
        for m in matches:
            clean_m = m.strip('"').lower()
            if clean_m not in ("select", "lateral", "where", "group", "order", "values"):
                tables.append(clean_m)
        return list(set(tables))

    @classmethod
    def _enforce_limit(cls, sql: str, max_limit: int) -> str:
        # 1. Parameterized LIMIT clause check (e.g. LIMIT :limit or LIMIT :param)
        if re.search(r"\bLIMIT\s+(?::[a-zA-Z0-9_]+|\?|\$\d+)\b", sql, re.IGNORECASE):
            return sql

        # 2. Literal integer LIMIT clause check
        limit_match = re.search(r"\bLIMIT\s+(\d+)\b", sql, re.IGNORECASE)
        if limit_match:
            existing_limit = int(limit_match.group(1))
            if existing_limit > max_limit:
                return re.sub(r"\bLIMIT\s+\d+\b", f"LIMIT {max_limit}", sql, flags=re.IGNORECASE)
            return sql
        else:
            return f"{sql} LIMIT {max_limit}"
