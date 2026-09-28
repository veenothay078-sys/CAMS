from typing import Dict, Any, Optional
from sqlalchemy.orm import Session
from app.chatbot.intent_parser import (
    IntentParserInterface,
    NvidiaNimIntentParser,
    IntentParseResult
)
from app.services.nim_service import NIMService
from app.services.e2b_service import E2BService
from app.chatbot.entity_extractor import EntityExtractor
from app.chatbot.query_planner import QueryPlanner
from app.chatbot.authorization_service import AuthorizationService
from app.chatbot.result_processor import ResultProcessor
from app.chatbot.response_formatter import ResponseFormatter
from app.services.safe_query_service import SafeQueryService
from app.core.logging import logger

class QueryOrchestrator:
    """
    Core pipeline orchestrator for the CAMS Query Engine:
    User Question
        ↓
    NVIDIA NIM Intent & Entity Extraction (NvidiaNimIntentParser)
        ↓
    Structured Intent Validation
        ↓
    Query Planning (Structured QueryPlan - calculation/chart detection)
        ↓
    Authorization Check (RBAC & Data scope)
        ↓
    Safe Query Layer (Validation & Read-only execution)
        ↓
    PostgreSQL CAMS Database
        ↓
    Result Processing
        ↓
    E2B Sandbox (Only when calculations/analysis/charts are required)
        ↓
    NVIDIA NIM Natural-Language Synthesis
        ↓
    Response Formatter
    """

    def __init__(
        self,
        db: Session,
        intent_parser: Optional[IntentParserInterface] = None,
        nim_service: Optional[NIMService] = None,
        e2b_service: Optional[E2BService] = None
    ):
        self.db = db
        self.nim_service = nim_service or NIMService()
        self.e2b_service = e2b_service or E2BService()
        self.intent_parser = intent_parser or NvidiaNimIntentParser(self.nim_service)
        self.entity_extractor = EntityExtractor()
        self.query_planner = QueryPlanner()
        self.safe_query_service = SafeQueryService(db)

    def process_query(
        self,
        session_id: str,
        message: str,
        user_context: Optional[Dict[str, Any]] = None,
        session_context: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        user_context = user_context or {"role": "STUDENT"}
        session_context = session_context or {}
        user_role = user_context.get("role", "STUDENT")

        # Step 1: Intent Extraction via NVIDIA NIM
        parse_result: IntentParseResult = self.intent_parser.parse_intent(message, session_context)
        logger.info(
            f"Session {session_id} - Parsed intent: {parse_result.intent} "
            f"(confidence: {parse_result.confidence:.2f})"
        )

        # Handle API errors (timeout, rate limit, missing key, auth failure)
        if parse_result.error:
            logger.warning(f"Session {session_id} - Intent parsing error: {parse_result.error}")
            return ResponseFormatter.format_response(
                session_id=session_id,
                message=parse_result.error,
                response_type="error",
                data=None
            )

        # Handle early clarification request from model
        if parse_result.requires_clarification and parse_result.clarification_prompt:
            return ResponseFormatter.format_response(
                session_id=session_id,
                message=parse_result.clarification_prompt,
                response_type="clarification",
                data=None
            )

        # Step 2: Entity Extraction & Merging (Model entities + Regex pronoun resolution)
        rule_entities = self.entity_extractor.extract_entities(message, session_context)
        merged_entities = {**rule_entities, **{k: v for k, v in parse_result.entities.items() if v is not None}}
        logger.info(f"Session {session_id} - Merged entities: {merged_entities}")

        # Step 3: Query Planning (Structured QueryPlan - never raw SQL)
        plan = self.query_planner.plan_query(
            intent=parse_result.intent,
            entities=merged_entities,
            user_context=user_context,
            session_context=session_context,
            message=message,
            requested_output=parse_result.requested_output
        )

        # Step 4: Authorization Check (RBAC & scope verification)
        is_authorized, auth_error = AuthorizationService.authorize(plan, user_context)
        if not is_authorized:
            logger.warning(f"Session {session_id} - Authorization failed: {auth_error}")
            return ResponseFormatter.format_response(
                session_id=session_id,
                message=auth_error or "Access Denied: You do not have permission to view this data.",
                response_type="error",
                data=None
            )

        # Step 5: Clarification Handling
        if plan.requires_clarification:
            return ResponseFormatter.format_response(
                session_id=session_id,
                message=plan.clarification_prompt or "Please provide more details.",
                response_type="clarification",
                data=None
            )

        # Step 6: Safe Query Layer Execution
        query_result = self.safe_query_service.execute_plan(plan, user_role=user_role)

        # Step 7: Result Processing
        msg_text, response_type, processed_data = ResultProcessor.process_result(plan, query_result)

        # Step 8: E2B Sandbox Analytics (Calculations & Charts)
        # CRITICAL: E2B is ONLY invoked for calculation or chart requests. Never for normal text/table queries.
        chart_data = None
        calc_data = None
        if query_result.get("success") and (plan.output_type in ("calculation", "chart") or plan.operation_type is not None):
            dataset = query_result.get("data", [])
            if not dataset:
                if plan.output_type == "chart" or plan.operation_type == "chart":
                    msg_text = "Insufficient data is available to generate this chart."
                    response_type = "text"
                else:
                    msg_text = "Insufficient data to perform this calculation."
                    response_type = "text"
            else:
                if plan.output_type == "chart" or plan.operation_type == "chart":
                    chart_res = self.e2b_service.generate_chart_data(
                        chart_type=plan.chart_type or "bar",
                        dataset=dataset,
                        title=f"{plan.domain.replace('_', ' ').title()} Visualization",
                        x_axis=plan.domain.title(),
                        y_axis="Score / Metric"
                    )
                    if chart_res.get("success"):
                        chart_data = chart_res.get("chart")
                        response_type = "chart"
                        msg_text = f"Here is the {plan.chart_type or 'bar'} chart for {plan.target_entity or plan.domain}:"
                    else:
                        msg_text = chart_res.get("error", "Insufficient data is available to generate this chart.")
                elif plan.output_type == "calculation":
                    calc_res = self.e2b_service.execute_analysis(
                        operation=plan.operation_type or "average",
                        dataset=dataset
                    )
                    if calc_res.get("success"):
                        calc_data = calc_res.get("metrics")
                        calc_val = calc_res.get("result")
                        response_type = "calculation"
                        op_name = (plan.operation_type or "calculation").title()
                        msg_text = f"{op_name} result for {plan.target_entity or plan.domain}: {calc_val}"
                    else:
                        msg_text = calc_res.get("error", "Insufficient data to perform this calculation.")

        # Step 9: NVIDIA NIM Natural Language Synthesis
        if (
            query_result.get("success")
            and query_result.get("data")
            and self.nim_service.is_configured
            and plan.output_type not in ("chart", "calculation")
        ):
            synthesized_explanation = self.nim_service.synthesize_response(
                question=message,
                intent=plan.intent,
                database_data=query_result.get("data", []),
                target_entity=plan.target_entity
            )
            if synthesized_explanation:
                msg_text = synthesized_explanation

        # Step 10: Final Response Formatting
        formatted = ResponseFormatter.format_response(
            session_id=session_id,
            message=msg_text,
            response_type=response_type,
            data=processed_data,
            chart=chart_data,
            calculation=calc_data
        )

        # Include internal metadata for session updates
        formatted["_plan"] = plan.model_dump()
        formatted["_entities"] = merged_entities
        formatted["_intent"] = plan.intent
        return formatted
