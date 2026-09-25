from abc import ABC, abstractmethod
from typing import Dict, Any, List, Optional
import httpx
from app.core.config import settings
from app.core.logging import logger

class LLMServiceInterface(ABC):
    """Abstract interface for LLM operations (intent detection, SQL generation, synthesis)."""

    @abstractmethod
    async def generate_sql(self, user_prompt: str, user_role: str, user_id: str, context: Optional[str] = None) -> Dict[str, Any]:
        """Translates user natural language into intent and read-only SQL query."""
        pass

    @abstractmethod
    async def synthesize_response(self, user_prompt: str, sql_executed: str, query_results: List[Dict[str, Any]]) -> str:
        """Synthesizes human-readable natural language response from query results."""
        pass


class MockLLMService(LLMServiceInterface):
    """
    Intelligent mock LLM service for Phase 1 development and offline testing.
    Uses pattern matching over the 10 priority CAMS domains to generate safe queries.
    """

    async def generate_sql(self, user_prompt: str, user_role: str, user_id: str, context: Optional[str] = None) -> Dict[str, Any]:
        prompt_lower = user_prompt.lower()

        # Domain A: Student Information
        if "student" in prompt_lower or "profile" in prompt_lower or "roll" in prompt_lower or "who am i" in prompt_lower:
            return {
                "intent": "student_lookup",
                "domain": "student",
                "sql": "SELECT s.roll_no, s.full_name, s.semester, s.cgpa, s.academic_status, d.name AS degree_name, u.email FROM students s JOIN users u ON s.user_id = u.id LEFT JOIN degrees d ON s.degree_id = d.id WHERE s.is_deleted = false",
                "explanation": "Looking up student information and academic degree."
            }

        # Domain B: Attendance
        elif "attendance" in prompt_lower or "present" in prompt_lower or "absent" in prompt_lower:
            return {
                "intent": "attendance_records",
                "domain": "attendance",
                "sql": "SELECT a.date, a.hour, c.name AS subject_name, sec.section_name, a.approval_status FROM attendance a JOIN courses c ON a.subject_id = c.id JOIN sections sec ON a.section_id = sec.id WHERE a.is_deleted = false ORDER BY a.date DESC",
                "explanation": "Retrieving recent class attendance entries."
            }

        # Domain C & D: Examinations & Marks
        elif "mark" in prompt_lower or "grade" in prompt_lower or "score" in prompt_lower or "exam" in prompt_lower:
            return {
                "intent": "marks_lookup",
                "domain": "marks",
                "sql": "SELECT im.semester, c.name AS subject_name, im.internal_exam_mark, im.assignment_mark, im.presentation_mark, im.attendance_mark, im.total_mark, im.status FROM internal_marks im JOIN courses c ON im.subject_id = c.id WHERE im.is_deleted = false",
                "explanation": "Retrieving internal examination marks and scores."
            }

        # Domain E: Courses
        elif "course" in prompt_lower or "subject" in prompt_lower or "curriculum" in prompt_lower or "syllabus" in prompt_lower:
            return {
                "intent": "course_catalog",
                "domain": "courses",
                "sql": "SELECT c.code, c.name, c.credits, c.semester, d.name AS degree_name FROM courses c JOIN degrees d ON c.degree_id = d.id WHERE c.is_deleted = false ORDER BY c.semester, c.code",
                "explanation": "Listing courses and academic curriculum."
            }

        # Domain F: Timetable
        elif "timetable" in prompt_lower or "schedule" in prompt_lower or "class" in prompt_lower or "room" in prompt_lower:
            return {
                "intent": "class_timetable",
                "domain": "timetable",
                "sql": "SELECT t.weekday, t.start_time, t.end_time, t.room, c.name AS subject_name, sec.section_name, u.full_name AS faculty_name FROM timetable t JOIN courses c ON t.subject_id = c.id JOIN sections sec ON t.section_id = sec.id JOIN users u ON t.faculty_id = u.id WHERE t.is_deleted = false ORDER BY t.weekday, t.start_time",
                "explanation": "Retrieving weekly schedule and classroom timetable."
            }

        # Domain G: Faculty
        elif "faculty" in prompt_lower or "teacher" in prompt_lower or "professor" in prompt_lower or "staff" in prompt_lower:
            return {
                "intent": "faculty_directory",
                "domain": "faculty",
                "sql": "SELECT fp.faculty_id, u.full_name, u.email, fp.designation, fp.specialization, fp.employment_status FROM faculty_profiles fp JOIN users u ON fp.user_id = u.id WHERE fp.is_deleted = false",
                "explanation": "Searching faculty directory."
            }

        # Domain H: Fees
        elif "fee" in prompt_lower or "payment" in prompt_lower or "due" in prompt_lower or "dues" in prompt_lower:
            return {
                "intent": "fee_records",
                "domain": "fees",
                "sql": "SELECT fs.fee_type, fs.semester, fs.amount, fs.due_date, fr.status AS payment_status FROM fee_records fr JOIN fee_structure fs ON fr.fee_structure_id = fs.id WHERE fr.is_deleted = false",
                "explanation": "Retrieving college fee structure and dues."
            }

        # Domain I: Notices
        elif "notice" in prompt_lower or "announcement" in prompt_lower or "circular" in prompt_lower:
            return {
                "intent": "notices_feed",
                "domain": "notices",
                "sql": "SELECT n.title, n.body, n.category, n.priority, n.publish_date, u.full_name AS published_by FROM notices n JOIN users u ON n.created_by = u.id WHERE n.is_deleted = false ORDER BY n.publish_date DESC",
                "explanation": "Retrieving official college notices."
            }

        # Domain J: Academic Calendar
        elif "calendar" in prompt_lower or "holiday" in prompt_lower or "event" in prompt_lower or "semester start" in prompt_lower:
            return {
                "intent": "academic_calendar",
                "domain": "academic_calendar",
                "sql": "SELECT ay.name AS academic_year, ay.start_date, ay.end_date, ay.current_semester, ay.is_active FROM academic_years ay WHERE ay.is_deleted = false",
                "explanation": "Retrieving academic year terms and calendar schedule."
            }

        # Default fallback: safe system status
        return {
            "intent": "general_inquiry",
            "domain": "general",
            "sql": "SELECT count(*) AS total_students FROM students WHERE is_deleted = false",
            "explanation": "General summary inquiry."
        }

    async def synthesize_response(self, user_prompt: str, sql_executed: str, query_results: List[Dict[str, Any]]) -> str:
        count = len(query_results)
        if count == 0:
            return "No matching records were found in the CAMS database for your request."

        # Provide a structured natural language summary
        return f"Retrieved {count} record(s) from the CAMS database matching your inquiry."


class NvidiaNimService(LLMServiceInterface):
    """
    NVIDIA NIM API Client interface ready for Phase 2 integration.
    """

    def __init__(self, api_key: str = settings.NVIDIA_NIM_API_KEY, base_url: str = settings.NVIDIA_NIM_BASE_URL, model: str = settings.NVIDIA_NIM_MODEL):
        self.api_key = api_key
        self.base_url = base_url.rstrip("/")
        self.model = model

    async def generate_sql(self, user_prompt: str, user_role: str, user_id: str, context: Optional[str] = None) -> Dict[str, Any]:
        if not self.api_key:
            logger.info("NVIDIA NIM API key not configured; falling back to MockLLMService")
            return await MockLLMService().generate_sql(user_prompt, user_role, user_id, context)

        # Implementation for Phase 2 NVIDIA NIM call
        async with httpx.AsyncClient() as client:
            headers = {"Authorization": f"Bearer {self.api_key}", "Content-Type": "application/json"}
            payload = {
                "model": self.model,
                "messages": [
                    {"role": "system", "content": "You are a CAMS SQL Assistant. Generate strictly SELECT queries over allowed tables."},
                    {"role": "user", "content": user_prompt}
                ],
                "temperature": 0.1
            }
            response = await client.post(f"{self.base_url}/chat/completions", headers=headers, json=payload, timeout=30.0)
            data = response.json()
            # Fallback mock for Phase 1
            return await MockLLMService().generate_sql(user_prompt, user_role, user_id, context)

    async def synthesize_response(self, user_prompt: str, sql_executed: str, query_results: List[Dict[str, Any]]) -> str:
        if not self.api_key:
            return await MockLLMService().synthesize_response(user_prompt, sql_executed, query_results)

        return await MockLLMService().synthesize_response(user_prompt, sql_executed, query_results)


def get_llm_service() -> LLMServiceInterface:
    """Dependency injector for LLM service."""
    if settings.NVIDIA_NIM_API_KEY:
        return NvidiaNimService()
    return MockLLMService()
