import re
from typing import Dict, Any, Optional

class EntityExtractor:
    """
    Extracts supported CAMS entities from user natural language and session context.
    Resolves conversational pronouns ('his', 'her', 'their', 'the student') to prior session context.
    """

    # Supported entities regex rules
    ROLL_NO_PATTERN = re.compile(r"\b([A-Z]{2,4}-[0-9]{3,4}|[0-9]{2}[A-Z]{2,4}[0-9]{2,4})\b", re.IGNORECASE)
    SEMESTER_PATTERN = re.compile(r"\b(?:semester|sem)\s*([1-8])\b|\b([1-8])(?:st|nd|rd|th)\s*sem(?:ester)?\b", re.IGNORECASE)
    YEAR_PATTERN = re.compile(r"\b(first|second|third|fourth|fifth)\s*year\b", re.IGNORECASE)
    WEEKDAY_PATTERN = re.compile(r"\b(monday|tuesday|wednesday|thursday|friday|saturday)\b", re.IGNORECASE)
    DATE_PATTERN = re.compile(r"\b(\d{4}-\d{2}-\d{2})\b")
    EXAM_TYPE_PATTERN = re.compile(r"\b(cia|semester|internal|external)\b", re.IGNORECASE)
    SECTION_PATTERN = re.compile(r"\bsection\s*([A-Za-z0-9]+)\b", re.IGNORECASE)

    # Common names/keywords pattern for student detection (prioritizing explicit student IDs/names)
    STUDENT_NAME_PATTERN = re.compile(
        r"\b(student\s*[0-9]+)\b|"
        r"\b(?:profile|details|marks|attendance|record|info)\s+for\s+(?:student\s+)?([A-Za-z0-9_-]+)\b|"
        r"\b([A-Za-z0-9_]+)'s\s+(?:attendance|mark|marks|grade|profile|result|fee|fees|info|details)\b|"
        r"\bstudent\s+([A-Za-z0-9_-]+)\b",
        re.IGNORECASE
    )

    PRONOUN_PATTERN = re.compile(r"\b(he|him|his|she|her|they|their|the student|this student)\b", re.IGNORECASE)

    YEAR_TO_SEMESTER = {
        "first": 1,
        "second": 3,
        "third": 5,
        "fourth": 7,
        "fifth": 9
    }

    STOPWORDS = {
        "my", "the", "a", "an", "this", "our", "all", "details", "details for",
        "info", "information", "records", "his", "her", "their", "student", "students",
        "attendance", "marks", "exam", "exams", "fees", "fee", "timetable",
        "profile", "schedule", "result", "results", "grade", "grades", "subject", "courses",
        "particular", "specific", "certain", "given", "individual", "single", "someone", "anyone"
    }

    def extract_entities(self, text: str, session_context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        entities: Dict[str, Any] = {}
        session_context = session_context or {}

        # 1. Roll Number
        roll_match = self.ROLL_NO_PATTERN.search(text)
        if roll_match:
            entities["roll_no"] = roll_match.group(1).upper()

        # 2. Semester
        sem_match = self.SEMESTER_PATTERN.search(text)
        if sem_match:
            sem_val = sem_match.group(1) or sem_match.group(2)
            entities["semester"] = int(sem_val)
        else:
            # Check year phrase (e.g. "third year")
            year_match = self.YEAR_PATTERN.search(text)
            if year_match:
                yr_name = year_match.group(1).lower()
                entities["semester"] = self.YEAR_TO_SEMESTER.get(yr_name, 1)

        # 3. Weekday
        weekday_match = self.WEEKDAY_PATTERN.search(text)
        if weekday_match:
            entities["weekday"] = weekday_match.group(1).upper()

        # 4. Date
        date_match = self.DATE_PATTERN.search(text)
        if date_match:
            entities["date"] = date_match.group(1)

        # 5. Exam Type
        exam_match = self.EXAM_TYPE_PATTERN.search(text)
        if exam_match:
            et = exam_match.group(1).upper()
            entities["exam_type"] = "CIA" if "CIA" in et or "INTERNAL" in et else "SEMESTER"

        # 6. Section
        sec_match = self.SECTION_PATTERN.search(text)
        if sec_match:
            entities["section"] = sec_match.group(1).upper()

        # 7. Student Name or ID (search all match candidates in text)
        for match in self.STUDENT_NAME_PATTERN.finditer(text):
            candidate = next((g for g in match.groups() if g), None)
            if candidate:
                cleaned_name = candidate.strip()
                if cleaned_name.lower().startswith("details for "):
                    cleaned_name = cleaned_name[12:].strip()
                tokens = cleaned_name.lower().split()
                if not any(t in self.STOPWORDS for t in tokens) and not self.PRONOUN_PATTERN.search(cleaned_name) and len(cleaned_name) > 1:
                    entities["student_name"] = cleaned_name
                    break

        # 8. Follow-up pronoun resolution using session context
        if not entities.get("student_name") and not entities.get("roll_no"):
            if self.PRONOUN_PATTERN.search(text):
                # Inherit student context from previous turn
                if session_context.get("last_student_name"):
                    entities["student_name"] = session_context["last_student_name"]
                if session_context.get("last_roll_no"):
                    entities["roll_no"] = session_context["last_roll_no"]
                if session_context.get("last_student_id"):
                    entities["student_id"] = session_context["last_student_id"]

        # Also inherit semester or course if not explicitly overridden
        if not entities.get("semester") and session_context.get("last_semester"):
            entities["semester"] = session_context["last_semester"]

        return entities
