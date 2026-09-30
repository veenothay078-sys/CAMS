from typing import Dict, Any, Optional, List

class ResponseFormatter:
    """
    Builds the standardized structured API response for the CAMS chatbot.
    Format:
    {
        "session_id": "...",
        "message": "...",
        "response_type": "text" | "table" | "clarification" | "error",
        "data": [...] or None
    }
    """

    @classmethod
    def format_response(
        cls,
        session_id: str,
        message: str,
        response_type: str = "text",
        data: Optional[Any] = None,
        chart: Optional[Dict[str, Any]] = None,
        calculation: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        formatted_message = message.split('|')[0].strip() if '|' in message else message

        res = {
            "session_id": session_id,
            "message": formatted_message,
            "response_type": response_type,
            "data": data
        }
        if chart is not None:
            res["chart"] = chart
        if calculation is not None:
            res["calculation"] = calculation

        return res

    @classmethod
    def _build_markdown_table(cls, records: List[Dict[str, Any]], max_rows: int = 15) -> str:
        if not records or not isinstance(records[0], dict):
            return ""

        display = records[:max_rows]
        cols = list(display[0].keys())

        header = "| " + " | ".join(c.replace("_", " ").title() for c in cols) + " |"
        sep = "| " + " | ".join("---" for _ in cols) + " |"
        rows = []
        for r in display:
            row_str = "| " + " | ".join(str(r.get(c, "-")) if r.get(c) is not None else "-" for c in cols) + " |"
            rows.append(row_str)

        table_md = "\n".join([header, sep] + rows)
        if len(records) > max_rows:
            table_md += f"\n\n*Showing first {max_rows} of {len(records)} records.*"

        return table_md
