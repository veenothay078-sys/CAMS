import re
from typing import Dict, Any, Optional, List, Tuple, Set
from app.chatbot.query_plan import QueryPlan
from app.chatbot.domains import CHATBOT_DOMAINS
from app.schema_catalog.catalog import SchemaCatalog

class QueryPlanner:
    """
    Constructs a structured QueryPlan from parsed intent, extracted entities,
    user/session context, and dynamic Schema Catalog retrieval.
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

        # 0. Prompt Injection & Destructive Operation Guard
        if message:
            m_low = message.lower()
            if re.search(r"\b(delete|drop table|truncate|alter table|insert into|update .* set|grant |revoke |database password|system override)\b", m_low):
                return QueryPlan(
                    intent="unknown",
                    domain="general",
                    tables=[],
                    output_type="clarification",
                    requires_clarification=True,
                    clarification_prompt="Destructive database operations and credential inquiries are strictly prohibited by the Safe Query Layer."
                )

        # 1. Dynamically retrieve relevant schema and foreign key relationships
        schema_info = SchemaCatalog.retrieve_schema_for_query(message or intent)
        relevant_tables = schema_info.get("relevant_tables", [])

        # 2. Determine output_type, operation_type, and chart_type
        out_type = requested_output or "summary"
        op_type = None
        c_type = None

        if message:
            m_low = message.lower()
            if re.search(r"\b(chart|charts|barchart|barcharts|piechart|piecharts|linechart|linecharts|graph|graphs|plot|plots|visualize|visualization|visual|diagram|histogram|trends?|pie|bar|line)\b", m_low) or "barchart" in m_low or "piechart" in m_low or "linechart" in m_low:
                out_type = "chart"
                op_type = "chart"
                if re.search(r"\b(trend|trends|over time|timeline|line|linechart|history|monthly)\b", m_low) or "linechart" in m_low:
                    c_type = "line"
                    op_type = "trend"
                elif re.search(r"\b(distribution|share|proportion|pie|piechart|breakdown|by status|gender)\b", m_low) or "piechart" in m_low:
                    c_type = "pie"
                    op_type = "grouping"
                else:
                    c_type = "bar"
                    op_type = "comparison"
            elif re.search(r"\b(average|avg|mean)\b", m_low):
                out_type = "calculation"
                op_type = "average"
            elif re.search(r"\b(count|how many|number of|total count|total students|total courses|total faculty)\b", m_low):
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
            elif re.search(r"\b(details|table|all records|breakdown|list|show me all|all courses|all students|all faculty)\b", m_low):
                out_type = "table"
            elif re.search(r"\b(what is my|show my|who is|tell me my)\b", m_low):
                out_type = "text"

        # 3. Handle unknown or unsupported intent
        if intent not in self.SUPPORTED_INTENTS or intent == "unknown":
            # Check if dynamic schema catalog retrieved strong table match
            if relevant_tables:
                top_table = relevant_tables[0]
                if top_table in ("courses", "degrees"):
                    intent = "courses"
                elif top_table in ("faculty_profiles", "staff"):
                    intent = "faculty"
                elif top_table in ("staff_attendance", "attendance"):
                    intent = "attendance"
                elif top_table in ("timetable", "sections"):
                    intent = "timetable"
                elif top_table in ("students", "users"):
                    intent = "student_information"
                elif top_table in ("internal_marks", "marks"):
                    intent = "marks"
                elif top_table in ("notices", "notifications"):
                    intent = "notices"

        if intent not in self.SUPPORTED_INTENTS or intent == "unknown":
            return QueryPlan(
                intent="unknown",
                domain="general",
                tables=[],
                output_type="clarification",
                requires_clarification=True,
                clarification_prompt=(
                    "I couldn't identify what you're asking for. You can ask about "
                    "student profiles, attendance, exam schedules, marks, courses, "
                    "timetable, faculty, fees, notices, or the academic calendar."
                )
            )

        # Helper to resolve student identity from entities -> session -> user_context
        student_id, roll_no, student_name = self._resolve_student_identity(
            entities, session_context, user_context
        )

        msg_lower = (message or "").lower()
        is_plural_or_general = any(w in msg_lower for w in (
            "students", "all students", "all", "overall", "low attendance", "defaulter", "shortage",
            "below 75", "under 75", "distribution", "breakdown", "comparison", "compare",
            "department", "class", "semester", "users", "everyone", "of students", "attendance barchart"
        ))
        if is_plural_or_general and not entities.get("student_name") and not entities.get("roll_no"):
            if user_context.get("role") != "STUDENT":
                student_name = None
                roll_no = None

        # 4. Plan by intent
        if intent == "student_information":
            is_users_query = any(w in msg_lower for w in ("user", "users", "all users", "show users", "show me users", "list users", "who are the users", "get users", "system users"))
            is_list_query = is_users_query or any(w in msg_lower for w in (
                "all students", "all users", "list students", "students by department", "number of students",
                "show students", "show me students", "students", "student list", "show all students", "who are the students",
                "get students", "enrollment", "student records", "directory", "profiles", "show me all"
            ))

            if not is_list_query and not roll_no and not student_name and not student_id:
                return QueryPlan(
                    intent=intent,
                    domain="student",
                    tables=["students", "users"],
                    output_type="clarification",
                    requires_clarification=True,
                    clarification_prompt="Please provide the student's name, roll number, or ID."
                )

            filters = {}
            if is_users_query and not roll_no and not student_name and not student_id:
                filters["target_table"] = "users"
                return QueryPlan(
                    intent=intent,
                    domain="student",
                    tables=["users"],
                    filters=filters,
                    fields=["user_id", "full_name", "email", "role", "phone", "is_active"],
                    output_type="table",
                    operation_type=op_type,
                    chart_type=c_type,
                    target_entity="System Users"
                )

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
                output_type=out_type if out_type in ("calculation", "chart") else ("table" if (is_list_query or not (roll_no or student_name or student_id)) else "summary"),
                operation_type=op_type,
                chart_type=c_type,
                target_entity=roll_no or student_name or student_id or "Students"
            )

        elif intent == "attendance":
            # For general student, staff attendance or class-wide queries, roll_no is not required
            msg_lower = (message or "").lower()
            is_at_risk = any(w in msg_lower for w in ("below", "under", "low", "less than", "75%", "< 75", "risk", "defaulter", "shortage", "attention"))
            is_students = any(w in msg_lower for w in ("student", "students", "pupil", "pupils", "all students", "student attendance", "students attendance"))
            is_general = is_at_risk or is_students or any(w in msg_lower for w in ("staff", "faculty", "class", "overall", "semester", "trend", "chart", "rate", "breakdown", "distribution", "department", "dept", "subject", "all"))
            is_student_asking_self = (user_context.get("role") == "STUDENT" and (roll_no or student_name or student_id))
            
            # Generic ambiguous inquiry check (only if not general or student self)
            if not is_general and not is_student_asking_self and not roll_no and not student_name and not student_id:
                return QueryPlan(
                    intent=intent,
                    domain="attendance",
                    tables=["attendance"],
                    output_type="clarification",
                    requires_clarification=True,
                    clarification_prompt="Whose attendance would you like to see — please provide a specific student name, student ID or roll number, class, subject, or department:"
                )

            filters = {}
            if is_at_risk:
                filters["target_type"] = "students_at_risk"
            elif is_students:
                filters["target_type"] = "students"

            if roll_no:
                filters["roll_no"] = roll_no
            if student_name:
                filters["student_name"] = student_name
            if entities.get("date"):
                filters["date"] = entities["date"]
            if entities.get("semester"):
                filters["semester"] = entities["semester"]

            if out_type == "chart" or op_type == "chart" or "graph" in msg_lower or "chart" in msg_lower:
                final_out_type = "chart"
                op_type = "chart"
                if not c_type:
                    c_type = "bar"
            elif is_at_risk or is_students:
                final_out_type = "table"
            elif is_student_asking_self and out_type == "calculation":
                final_out_type = "summary"
            else:
                final_out_type = out_type

            return QueryPlan(
                intent=intent,
                domain="attendance",
                tables=["staff_attendance", "users"],
                filters=filters,
                fields=["date", "status", "faculty_name", "source"],
                output_type=final_out_type,
                operation_type=op_type if final_out_type in ("calculation", "chart") else None,
                chart_type=c_type,
                target_entity=roll_no or student_name or ("Students Below 75% Attendance" if is_at_risk else "Attendance Register")
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
                fields=["exam_id", "exam_date", "start_time", "end_time", "exam_type", "center", "course_name"],
                output_type="table" if out_type == "summary" else out_type,
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "marks":
            is_general = any(w in (message or "").lower() for w in ("average", "subject", "all", "semester", "chart", "highest", "lowest"))
            if not is_general and not roll_no and not student_name and not student_id and not entities.get("semester"):
                return QueryPlan(
                    intent=intent,
                    domain="marks",
                    tables=["internal_marks"],
                    output_type="clarification",
                    requires_clarification=True,
                    clarification_prompt="Please specify the student's name, roll number, or subject to view marks."
                )

            filters = {}
            if roll_no:
                filters["roll_no"] = roll_no
            if student_name:
                filters["student_name"] = student_name
            if entities.get("semester"):
                filters["semester"] = entities["semester"]

            return QueryPlan(
                intent=intent,
                domain="marks",
                tables=["internal_marks", "students", "users", "courses"],
                filters=filters,
                fields=["student_name", "roll_no", "course_name", "total_mark", "semester"],
                output_type="table" if out_type == "summary" else out_type,
                operation_type=op_type,
                chart_type=c_type,
                target_entity=roll_no or student_name or "Internal Assessment"
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
                fields=["code", "name", "credits", "semester", "degree_name"],
                output_type="table" if out_type == "summary" else out_type,
                operation_type=op_type,
                chart_type=c_type
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
                tables=["timetable", "courses", "sections", "users"],
                filters=filters,
                fields=["weekday", "start_time", "end_time", "room", "course_name", "section_name", "faculty_name"],
                output_type="table" if out_type == "summary" else out_type,
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "faculty":
            filters = {}
            if entities.get("name"):
                filters["name"] = entities["name"]

            return QueryPlan(
                intent=intent,
                domain="faculty",
                tables=["faculty_profiles", "users"],
                filters=filters,
                fields=["full_name", "designation", "specialization", "email"],
                output_type="table" if out_type == "summary" else out_type,
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "fees":
            filters = {}
            if roll_no:
                filters["roll_no"] = roll_no
            if student_name:
                filters["student_name"] = student_name

            return QueryPlan(
                intent=intent,
                domain="fees",
                tables=["fee_records", "fee_structure", "students", "users"],
                filters=filters,
                fields=["student_name", "roll_no", "fee_type", "amount", "due_date", "status"],
                output_type=out_type,
                operation_type=op_type,
                chart_type=c_type,
                target_entity=roll_no or student_name or "Fee Records"
            )

        elif intent == "notices":
            return QueryPlan(
                intent=intent,
                domain="notices",
                tables=["notices"],
                filters={},
                fields=["title", "category", "priority", "publish_date", "body"],
                output_type="table" if out_type == "summary" else out_type,
                operation_type=op_type,
                chart_type=c_type
            )

        elif intent == "academic_calendar":
            return QueryPlan(
                intent=intent,
                domain="academic_calendar",
                tables=["academic_calendar_events"],
                filters={},
                fields=["title", "category", "start_date", "end_date", "is_holiday", "event_type"],
                output_type=out_type,
                operation_type=op_type,
                chart_type=c_type
            )

        return QueryPlan(
            intent="unknown",
            domain="general",
            tables=[],
            output_type="clarification",
            requires_clarification=True,
            clarification_prompt="I couldn't identify what you're asking for. Please ask about CAMS academic data."
        )

    def _resolve_student_identity(
        self,
        entities: Dict[str, Any],
        session_context: Dict[str, Any],
        user_context: Dict[str, Any]
    ) -> Tuple[Optional[str], Optional[str], Optional[str]]:
        student_id = entities.get("student_id")
        roll_no = entities.get("roll_no")
        student_name = entities.get("student_name")

        # Check session context for pronoun resolution if not in current query
        if not student_id and not roll_no and not student_name:
            if session_context.get("last_roll_no"):
                roll_no = session_context["last_roll_no"]
            if session_context.get("last_student_name"):
                student_name = session_context["last_student_name"]
            if session_context.get("last_student_id"):
                student_id = session_context["last_student_id"]

        # Default student role identity if explicitly scoped
        if user_context.get("role") == "STUDENT":
            if not student_id and user_context.get("student_id"):
                student_id = user_context.get("student_id")
            if not roll_no and user_context.get("roll_no"):
                roll_no = user_context.get("roll_no")
            if not student_name and user_context.get("student_name"):
                student_name = user_context.get("student_name")

        return student_id, roll_no, student_name
