from typing import List, Dict, Any

class ResponseFormatter:
    """Formats raw database records into clear, polite conversational responses with tables."""

    @staticmethod
    def format_chat_response(domain: str, intent: str, records: List[Dict[str, Any]], explanation: str = "") -> str:
        if not records:
            return f"I searched the CAMS database for {domain.replace('_', ' ')} records, but no entries were found matching your criteria."

        count = len(records)
        lines = []

        if explanation:
            lines.append(f"{explanation}\n")
        lines.append(f"**Found {count} result{'s' if count != 1 else ''}:**\n")

        # Format as Markdown table for up to 10 rows
        display_records = records[:10]
        columns = list(display_records[0].keys())

        # Header row
        header = "| " + " | ".join(c.replace("_", " ").title() for c in columns) + " |"
        separator = "| " + " | ".join("---" for _ in columns) + " |"
        lines.append(header)
        lines.append(separator)

        for rec in display_records:
            row_vals = [str(rec.get(c, "-")) if rec.get(c) is not None else "-" for c in columns]
            lines.append("| " + " | ".join(row_vals) + " |")

        if count > 10:
            lines.append(f"\n*Showing top 10 of {count} records.*")

        return "\n".join(lines)
