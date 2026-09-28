from typing import Tuple, Optional, Dict, Any
from app.chatbot.query_plan import QueryPlan
from app.security.query_policy import QueryPolicy
from app.security.rbac import UserRole
from app.core.logging import logger

class AuthorizationService:
    """
    RBAC and Data-Scope Authorization Engine.
    Ensures that queries adhere to caller's role permissions and data isolation boundaries.
    Prevents students from accessing other students' records or unauthorized financial/administrative data.
    """

    @classmethod
    def authorize(
        cls,
        plan: QueryPlan,
        user_context: Optional[Dict[str, Any]] = None
    ) -> Tuple[bool, Optional[str]]:
        user_context = user_context or {}
        user_role = (user_context.get("role") or "STUDENT").upper()

        # 1. Immediate Role Domain Restrictions
        if user_role == UserRole.FACULTY.value:
            if plan.intent == "fees" or "fee_records" in plan.tables:
                return False, "Access Denied: Faculty members are not authorized to view fee records."

        # 2. Table-level authorization check against QueryPolicy
        for tbl in plan.tables:
            if not QueryPolicy.is_table_allowed(tbl, user_role):
                logger.warning(f"Role '{user_role}' denied access to table '{tbl}'")
                return False, f"Access Denied: Role '{user_role}' is not authorized to query '{tbl}'."

        # If plan already requires clarification (and caller has domain access), allow clarification
        if plan.requires_clarification:
            return True, None

        # 2. Student Role Data Isolation (Row/Record Level)
        if user_role == UserRole.STUDENT.value:
            user_student_id = user_context.get("student_id")
            user_roll_no = user_context.get("roll_no")
            user_full_name = user_context.get("full_name")

            # Check if plan accesses student-private domains
            private_intents = {"attendance", "marks", "fees", "student_information"}
            if plan.intent in private_intents:
                target_roll = plan.filters.get("roll_no")
                target_name = plan.filters.get("student_name")
                target_student_id = plan.filters.get("student_id")

                # If target is specified and doesn't match caller
                if target_roll and user_roll_no and target_roll.upper() != user_roll_no.upper():
                    return False, "Access Denied: Students are not authorized to view other students' records."

                if target_student_id and user_student_id and target_student_id != user_student_id:
                    return False, "Access Denied: Students are not authorized to view other students' records."

                if target_name and user_full_name and target_name.lower() != user_full_name.lower():
                    return False, "Access Denied: Students are not authorized to view other students' records."

        # 3. Faculty Role Restrictions
        if user_role == UserRole.FACULTY.value:
            if plan.intent == "fees" or "fee_records" in plan.tables:
                return False, "Access Denied: Faculty members are not authorized to view fee records."

        return True, None
