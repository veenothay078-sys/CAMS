from typing import Dict, Any, Optional, List, Tuple
from app.chatbot.query_plan import QueryPlan

class ResultProcessor:
    """
    Processes validated query results into structured data and natural summaries.
    Enforces truthfulness: never hallucinates missing data, cleanly identifies empty sets.
    """

    @classmethod
    def process_result(
        cls,
        plan: QueryPlan,
        query_result: Dict[str, Any]
    ) -> Tuple[str, str, Optional[Any]]:
        """
        Returns:
            (message, response_type, data)
            response_type is one of: 'text', 'table', 'clarification', 'error'
        """
        # 1. Clarification request
        if query_result.get("is_clarification") or plan.requires_clarification:
            prompt = query_result.get("clarification_prompt") or plan.clarification_prompt or "Please provide additional details."
            return prompt, "clarification", None

        # 2. Execution / security error
        if not query_result.get("success"):
            error_msg = query_result.get("error") or "An error occurred while processing your request."
            return error_msg, "error", None

        data = query_result.get("data", [])
        target = plan.target_entity or "the requested criteria"

        # 3. Empty result handling (NO HALLUCINATION)
        if not data:
            empty_messages = {
                "student_information": "I couldn't find a student matching the provided details.",
                "attendance": f"No attendance records were found for {target}.",
                "examination_schedule": "No examination schedules were found matching your criteria.",
                "marks": f"No marks or assessment records were found for {target}.",
                "courses": "No course curriculum records found for the requested semester or program.",
                "timetable": "No timetable schedule entries found for the requested day or section.",
                "faculty": "No faculty profiles found matching your search.",
                "fees": f"No fee records found for {target}.",
                "notices": "There are currently no active campus notices.",
                "academic_calendar": "No calendar events found."
            }
            msg = empty_messages.get(plan.intent, "No matching records found in the CAMS database.")
            return msg, "text", []

        # 4. Result Formatting by Intent
        intent = plan.intent

        if intent == "student_information":
            student = data[0]
            name = student.get("full_name") or student.get("roll_no") or "Student"
            roll = student.get("roll_no", "N/A")
            sem = student.get("semester", "N/A")
            cgpa = student.get("cgpa")
            cgpa_str = f"{cgpa:.2f}" if cgpa is not None else "N/A"
            degree = student.get("degree_name") or "Law Program"
            email = student.get("email", "")

            msg = (
                f"Student Profile: {name} (Roll No: {roll})\n"
                f"Degree: {degree} | Current Semester: {sem} | CGPA: {cgpa_str}"
            )
            if email:
                msg += f" | Email: {email}"
            return msg, "text", data

        elif intent == "attendance":
            # If records exist, calculate aggregate
            msg = f"Found {len(data)} attendance record(s) for {target}."
            return msg, "table", data

        elif intent == "marks":
            msg = f"Found {len(data)} internal mark record(s) for {target}."
            return msg, "table", data

        elif intent == "timetable":
            weekday_filter = plan.filters.get("weekday")
            day_str = f" for {weekday_filter.title()}" if weekday_filter else ""
            msg = f"Found {len(data)} scheduled class period(s){day_str}:"
            return msg, "table", data

        elif intent == "courses":
            sem_filter = plan.filters.get("semester")
            sem_str = f" for Semester {sem_filter}" if sem_filter else ""
            msg = f"Found {len(data)} course(s){sem_str}:"
            return msg, "table", data

        elif intent == "faculty":
            msg = f"Found {len(data)} faculty member(s):"
            return msg, "table", data

        elif intent == "fees":
            msg = f"Found {len(data)} fee record(s) for {target}:"
            return msg, "table", data

        elif intent == "notices":
            msg = f"Found {len(data)} active notice(s):"
            return msg, "table", data

        elif intent == "examination_schedule":
            msg = f"Found {len(data)} scheduled examination(s):"
            return msg, "table", data

        elif intent == "academic_calendar":
            msg = f"Found {len(data)} academic calendar event(s):"
            return msg, "table", data

        return f"Found {len(data)} record(s).", "table", data
