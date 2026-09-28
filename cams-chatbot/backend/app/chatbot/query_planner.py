import re
from typing import Dict, Any, Optional, List
from app.chatbot.query_plan import QueryPlan
from app.chatbot.domains import CHATBOT_DOMAINS

class QueryPlanner:
    """
    Constructs a structured QueryPlan from parsed intent, extracted entities,
    user/session context, and inquiry analysis needs.
    Detects when code execution (calculation/chart) is needed vs simple text/table.
    """

    SUPPORTED_INTENTS = {
        "student_information",
        "attendance",
        "examination_schedule",
        "marks",
        "courses",
        "timetable",
        "faculty",
        "fees",
        "notices",
        "academic_calendar"
    }

    def plan_query(
        self,
        intent: str,
        entities: Dict[str, Any],
        user_context: Optional[Dict[str, Any]] = None,
        session_context: Optional[Dict[str, Any]] = None,
        message: Optional[str] = None,
        requested_output: Optional[str] = None
    ) -> QueryPlan:
        user_context = user_context or {}
        session_context = session_context or {}

        # 1. Determine output_type, operation_type, and chart_type
        out_type = requested_output or "summary"
        op_type = None
        c_type = None

        if message:
            m_low = message.lower()
            if re.search(r"\b(chart|graph|plot|visualize|trends|trend)\b", m_low):
                out_type = "chart"
                op_type = "chart"
                if re.search(r"\b(trend|trends|over time|timeline|line)\b", m_low):
                    c_type = "line"
                    op_type = "trend"
                elif re.search(r"\b(distribution|share|proportion|pie)\b", m_low):
                    c_type = "pie"
                    op_type = "grouping"
                else:
                    c_type = "bar"
                    op_type = "comparison"
            elif re.search(r"\b(average|avg|mean)\b", m_low):
                out_type = "calculation"
                op_type = "average"
            elif re.search(r"\b(count|how many|number of|total count|total students|total courses)\b", m_low):
                out_type = "calculation"
                op_type = "count"
            elif re.search(r"\b(percentage|percent|pct)\b", m_low):
                out_type = "calculation"
                op_type = "percentage"
            elif re.search(r"\b(minimum|lowest|min)\b", m_low):
                out_type = "calculation"
                op_type = "minimum"
            elif re.search(r"\b(maximum|highest|max|top)\b", m_low):
                out_type = "calculation"
                op_type = "maximum"
            elif re.search(r"\b(compare|comparison)\b", m_low):
                out_type = "calculation"
                op_type = "comparison"
            elif re.search(r"\b(details|table|all records|breakdown)\b", m_low):
                out_type = "table"
            elif re.search(r"\b(what is my|show my|who is)\b", m_low):
                out_type = "text"

        # 2. Handle unknown or unsupported intent
        if intent not in self.SUPPORTED_INTENTS or intent == "unknown":
            return QueryPlan(
                intent="unknown",
                domain="general",
                tables=[],
                output_type="clarification",
                requires_clarification=True,
                clarification_prompt=(
                    "I couldn't identify what you're asking for. You can ask about "
                    "student information, attendance, exam schedules, marks, courses, "
                    "timetable, faculty, fees, notices, or the academic calendar."
                )
            )

        # Helper to resolve student identity from entities -> session -> user_context
        student_id, roll_no, student_name = self._resolve_student_identity(
            entities, session_context, user_context
        )

        # 3. Plan by intent
        if intent == "student_information":
            if not roll_no and not student_name and not student_id:
                return QueryPlan(
                    intent=intent,
                    domain="student",
                    tables=["students", "users"],
                    output_type="clarification",
                    requires_clarification=True,
                    clarification_prompt="Please provide the student's name, roll number, or ID."
                )
            filters = {}
            if roll_no:
                filters["roll_no"] = roll_no
            if student_name:
                filters["student_name"] = student_name
            if student_id:
                filters["student_id"] = student_id

            return QueryPlan(
                intent=intent,
                domain="student",
                tables=["students", "users", "degrees"],
                filters=filters,
                fields=["roll_no", "full_name", "semester", "cgpa", "batch_year", "email"],
                output_type=out_type if out_type in ("calculation", "chart") else "summary",
                operation_type=op_type,
                chart_type=c_type,
                target_entity=roll_no or student_name or student_id
            )

        elif intent == "attendance":
            # For class-wide attendance calculation/chart, roll_no is not required
            is_class_level = any(w in (message or "").lower() for w in ("class", "overall", "semester", "all students", "average attendance", "trend"))
            if not is_class_level and not roll_no and not student_name and not student_id:
                return QueryPlan(
                    intent=intent,
                    domain="attendance",
                    tables=["attendance"],
                    output_type="clarification",
                    requires_clarification=True,
                    clarification_prompt="Please provide your student ID or roll number to check attendance."
                )
            filters = {}
            if roll_no:
                filters["roll_no"] = roll_no
            if student_name:
                filters["student_name"] = student_name
            if student_id:
                filters["student_id"] = student_id
            if entities.get("date"):
                filters["date"] = entities["date"]

            return QueryPlan(
                intent=intent,
                domain="attendance",
                tables=["attendance", "students", "users"],
                filters=filters,
                fields=["attendance_percentage", "total_classes", "classes_attended", "absences"],
                output_type=out_type,
                operation_type=op_type,
                chart_type=c_type,
                target_entity=roll_no or student_name or student_id or "Class"
            )

        elif intent == "examination_schedule":
            filters = {}
            if entities.get("semester"):
                filters["semester"] = entities["semester"]
            if entities.get("exam_type"):
                filters["exam_type"] = entities["exam_type"]

            return QueryPlan(
                intent=intent,
                domain="examinations",
                tables=["exams", "courses"],
                filters=filters,
                fields=["exam_date", "start_time", "end_time", "course_name", "course_code", "exam_type", "center"],
                output_type=out_type if out_type in ("calculation", "chart") else "table",
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "marks":
            is_aggregate_marks = any(w in (message or "").lower() for w in ("class average", "overall marks", "average marks", "all students"))
            if not is_aggregate_marks and not roll_no and not student_name and not student_id:
                return QueryPlan(
                    intent=intent,
                    domain="marks",
                    tables=["internal_marks"],
                    output_type="clarification",
                    requires_clarification=True,
                    clarification_prompt="Please provide the student's name, roll number, or ID to retrieve marks."
                )
            filters = {}
            if roll_no:
                filters["roll_no"] = roll_no
            if student_name:
                filters["student_name"] = student_name
            if student_id:
                filters["student_id"] = student_id
            if entities.get("semester"):
                filters["semester"] = entities["semester"]

            return QueryPlan(
                intent=intent,
                domain="marks",
                tables=["internal_marks", "courses", "students", "users"],
                filters=filters,
                fields=["course_name", "internal_exam_mark", "assignment_mark", "presentation_mark", "total_mark"],
                output_type=out_type if out_type in ("calculation", "chart") else "table",
                operation_type=op_type,
                chart_type=c_type,
                target_entity=roll_no or student_name or student_id or "Class"
            )

        elif intent == "timetable":
            filters = {}
            if entities.get("weekday"):
                filters["weekday"] = entities["weekday"]
            if entities.get("semester"):
                filters["semester"] = entities["semester"]
            if entities.get("section"):
                filters["section"] = entities["section"]

            return QueryPlan(
                intent=intent,
                domain="timetable",
                tables=["timetable", "courses", "sections"],
                filters=filters,
                fields=["weekday", "start_time", "end_time", "room", "course_name", "course_code"],
                output_type=out_type if out_type in ("calculation", "chart") else "table",
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "courses":
            filters = {}
            if entities.get("semester"):
                filters["semester"] = entities["semester"]

            return QueryPlan(
                intent=intent,
                domain="courses",
                tables=["courses", "degrees"],
                filters=filters,
                fields=["code", "name", "semester", "credits"],
                output_type=out_type if out_type in ("calculation", "chart") else "table",
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "faculty":
            filters = {}
            if entities.get("student_name"):
                filters["name"] = entities["student_name"]

            return QueryPlan(
                intent=intent,
                domain="faculty",
                tables=["faculty_profiles", "users"],
                filters=filters,
                fields=["full_name", "designation", "specialization", "email"],
                output_type=out_type if out_type in ("calculation", "chart") else "table",
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "fees":
            if not roll_no and not student_name and not student_id:
                return QueryPlan(
                    intent=intent,
                    domain="fees",
                    tables=["fee_records"],
                    output_type="clarification",
                    requires_clarification=True,
                    clarification_prompt="Please provide your student ID or roll number to check fee records."
                )
            filters = {}
            if roll_no:
                filters["roll_no"] = roll_no
            if student_name:
                filters["student_name"] = student_name
            if student_id:
                filters["student_id"] = student_id

            return QueryPlan(
                intent=intent,
                domain="fees",
                tables=["fee_records", "fee_structure", "students", "users"],
                filters=filters,
                fields=["fee_type", "amount", "due_date", "status"],
                output_type=out_type if out_type in ("calculation", "chart") else "table",
                operation_type=op_type,
                chart_type=c_type,
                target_entity=roll_no or student_name or student_id
            )

        elif intent == "notices":
            filters = {}
            return QueryPlan(
                intent=intent,
                domain="notices",
                tables=["notices"],
                filters=filters,
                fields=["title", "category", "priority", "publish_date", "body"],
                output_type=out_type if out_type in ("calculation", "chart") else "table",
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "academic_calendar":
            filters = {}
            return QueryPlan(
                intent=intent,
                domain="academic_calendar",
                tables=["academic_calendar_events"],
                filters=filters,
                fields=["title", "category", "start_date", "end_date", "description", "is_holiday"],
                output_type=out_type if out_type in ("calculation", "chart") else "table",
                operation_type=op_type,
                chart_type=c_type
            )

        return QueryPlan(
            intent=intent,
            domain="general",
            tables=[],
            output_type="clarification",
            requires_clarification=True,
            clarification_prompt="Please provide more details for your query."
        )

    def _resolve_student_identity(
        self,
        entities: Dict[str, Any],
        session_context: Dict[str, Any],
        user_context: Dict[str, Any]
    ) -> tuple[Optional[str], Optional[str], Optional[str]]:
        student_id = entities.get("student_id")
        roll_no = entities.get("roll_no")
        student_name = entities.get("student_name")

        # Session context fallback
        if not roll_no and session_context.get("last_roll_no"):
            roll_no = session_context["last_roll_no"]
        if not student_name and session_context.get("last_student_name"):
            student_name = session_context["last_student_name"]
        if not student_id and session_context.get("last_student_id"):
            student_id = session_context["last_student_id"]

        # Authenticated user context fallback if caller is a student
        if user_context.get("role") == "STUDENT":
            if not student_id and user_context.get("student_id"):
                student_id = user_context["student_id"]
            if not roll_no and user_context.get("roll_no"):
                roll_no = user_context["roll_no"]
            if not student_name and user_context.get("full_name"):
                student_name = user_context["full_name"]

        return student_id, roll_no, student_name
