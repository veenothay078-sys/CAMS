from enum import Enum
from typing import List, Set
from fastapi import HTTPException, status

class UserRole(str, Enum):
    SUPER_ADMIN = "SUPER_ADMIN"
    ADMIN = "ADMIN"
    PRINCIPAL = "PRINCIPAL"
    HOD = "HOD"
    FACULTY = "FACULTY"
    STUDENT = "STUDENT"
    PARENT = "PARENT"


# Role hierarchy and permissions
ROLE_HIERARCHY = {
    UserRole.SUPER_ADMIN: {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    UserRole.ADMIN: {UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    UserRole.PRINCIPAL: {UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    UserRole.HOD: {UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    UserRole.FACULTY: {UserRole.FACULTY, UserRole.STUDENT},
    UserRole.STUDENT: {UserRole.STUDENT},
    UserRole.PARENT: {UserRole.PARENT},
}


# Domain-level access permissions by role
DOMAIN_ROLE_PERMISSIONS = {
    "student": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    "attendance": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    "examination": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    "marks": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    "courses": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    "timetable": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    "faculty": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY},
    "fees": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.STUDENT, UserRole.PARENT},
    "notices": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    "academic_calendar": {UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.PRINCIPAL, UserRole.HOD, UserRole.FACULTY, UserRole.STUDENT, UserRole.PARENT},
    "finance_payroll": {UserRole.SUPER_ADMIN, UserRole.ADMIN},
    "system_audit": {UserRole.SUPER_ADMIN, UserRole.ADMIN}
}


def require_roles(allowed_roles: List[UserRole]):
    """FastAPI dependency to verify if user has at least one of the allowed roles."""
    def role_checker(current_user: dict):
        user_role = current_user.get("role")
        if not user_role or user_role not in [r.value for r in allowed_roles]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Access forbidden: requires one of {[r.value for r in allowed_roles]}, user has '{user_role}'"
            )
        return current_user
    return role_checker
