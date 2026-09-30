import os
import json
from typing import Dict, Any, List, Optional, Tuple, Set

CATALOG_PATH = os.path.join(os.path.dirname(__file__), "schema_catalog.json")

# Business Domain Groupings & Descriptions for CAMS Tables
TABLE_DOMAINS = {
    "students": "Student academic profiles, roll numbers, semesters, CGPAs, batch years, admission details.",
    "users": "System user directory containing names, email addresses, roles, and status.",
    "courses": "Curriculum course catalog, course codes, titles, credits, and semester allocations.",
    "degrees": "Degree and academic programs (e.g., B.A. LL.B., LL.M., B.B.A. LL.B.).",
    "timetable": "Weekly class schedules, weekdays, start/end time slots, classrooms, and allocated instructors.",
    "staff_attendance": "Daily faculty and staff attendance logs, check-in/out times, and attendance status.",
    "attendance": "Classroom subject-wise period attendance records and approval states.",
    "staff_attendance_records": "Historical faculty attendance logs and check-in verifications.",
    "internal_marks": "Continuous internal assessment (CIA) marks, tests, assignments, presentations, and scores.",
    "marks": "Semester and term examination scores and grading records.",
    "faculty_profiles": "Faculty designations, departments, specializations, qualifications, and employment details.",
    "notices": "Official published campus circulars, administrative notices, alerts, and publisher details.",
    "notifications": "Personal and broadcast system notifications for students and faculty.",
    "sections": "Class sections, section capacities, and semester division maps.",
    "academic_years": "Academic calendar years, active semester sessions, and term durations.",
    "fee_records": "Student fee collection records, invoice statuses, dues, and transaction histories.",
    "fee_structure": "Institutional fee schedules, tuition breakdowns, and due dates.",
    "departments": "Academic departments and divisions (e.g. Constitutional Law, Criminal Law, Corporate Law).",
    "exams": "Examination events, CIA tests, semester exams, and date schedules.",
    "exam_hall_tickets": "Student examination hall tickets and admit cards.",
    "exam_seating_arrangements": "Assigned examination halls and seating allocations.",
    "leave_applications": "Faculty and student leave applications and approval workflows.",
    "staff_leaves": "Staff leave ledger, casual leaves, and OD permits.",
    "holidays": "Official institutional holidays and non-working calendar days."
}

# Domain Synonyms Dictionary for Natural-Language Entity Matching
SYNONYMS = {
    "student": ["students", "learner", "learners", "pupil", "pupils", "classmate", "classmates", "cadet", "candidate", "people studying here", "batch"],
    "course": ["courses", "subject", "subjects", "curriculum", "syllabus", "paper", "papers", "module", "modules", "classes", "credits"],
    "faculty": ["faculties", "teacher", "teachers", "professor", "professors", "lecturer", "lecturers", "instructor", "instructors", "staff", "mentor", "dean", "hod"],
    "attendance": ["present", "presence", "absent", "absentee", "absentees", "attend", "attended", "roll call", "check in", "working hours"],
    "timetable": ["schedule", "schedules", "timing", "timings", "slots", "period", "periods", "routine", "class routine", "room", "classroom", "hall"],
    "marks": ["mark", "score", "scores", "grade", "grades", "gpa", "cgpa", "result", "results", "internal", "internals", "cia", "assessment", "exam score", "performance"],
    "exam": ["exams", "examination", "examinations", "test", "tests", "hall ticket", "seating", "midterm", "end semester"],
    "notices": ["notice", "circular", "circulars", "announcement", "announcements", "bulletin", "broadcast", "memo"],
    "degree": ["degrees", "program", "programs", "department", "departments", "branch", "specialization", "stream"],
    "fees": ["fee", "dues", "tuition", "payment", "payments", "receipt", "fine", "installments", "balance"],
    "users": ["user", "account", "accounts", "profile", "profiles", "members", "logins", "credentials", "directory"]
}

class SchemaCatalog:
    _catalog_data: Optional[Dict[str, Any]] = None

    @classmethod
    def load(cls) -> Dict[str, Any]:
        if cls._catalog_data is None:
            if os.path.exists(CATALOG_PATH):
                with open(CATALOG_PATH, "r", encoding="utf-8") as f:
                    cls._catalog_data = json.load(f)
            else:
                cls._catalog_data = {"total_tables": 0, "tables": {}}
        return cls._catalog_data

    @classmethod
    def get_table(cls, table_name: str) -> Optional[Dict[str, Any]]:
        catalog = cls.load()
        return catalog.get("tables", {}).get(table_name)

    @classmethod
    def get_all_table_names(cls) -> List[str]:
        catalog = cls.load()
        return list(catalog.get("tables", {}).keys())

    @classmethod
    def retrieve_schema_for_query(cls, query: str, top_k: int = 6) -> Dict[str, Any]:
        """
        Dynamically ranks and extracts the most relevant table schemas, columns,
        and foreign key relationships for a given natural-language user query.
        """
        catalog = cls.load()
        tables = catalog.get("tables", {})
        q_lower = query.lower()

        scores: Dict[str, float] = {}

        for tname, tinfo in tables.items():
            score = 0.0
            t_words = tname.lower().split("_")

            # Match table name directly
            for w in t_words:
                if w in q_lower:
                    score += 5.0

            # Match descriptions
            desc = TABLE_DOMAINS.get(tname, "")
            for word in desc.lower().split():
                if len(word) > 3 and word in q_lower:
                    score += 2.0

            # Match synonyms
            for domain_key, syn_list in SYNONYMS.items():
                if domain_key in tname or any(s in tname for s in syn_list):
                    for syn in syn_list:
                        if syn in q_lower:
                            score += 4.0

            # Match column names
            for col in tinfo.get("columns", []):
                cname = col["name"].lower()
                if len(cname) > 3 and cname in q_lower:
                    score += 1.5

            # Prioritize tables with actual rows
            if tinfo.get("row_count", 0) > 0:
                score += 1.0

            if score > 0:
                scores[tname] = score

        # Always include core reference tables if relevant
        if not scores:
            scores["students"] = 1.0
            scores["courses"] = 1.0
            scores["timetable"] = 1.0
            scores["users"] = 1.0

        sorted_tables = sorted(scores.items(), key=lambda x: x[1], reverse=True)[:top_k]
        selected_table_names = [t[0] for t in sorted_tables]

        # Automatically include joined foreign-key related tables (1-hop expansion)
        expanded_names: Set[str] = set(selected_table_names)
        for tname in selected_table_names:
            tinfo = tables.get(tname, {})
            for fk in tinfo.get("foreign_keys", []):
                target_t = fk.get("foreign_table")
                if target_t in tables and len(expanded_names) < top_k + 3:
                    expanded_names.add(target_t)

        result_tables = {}
        for tname in expanded_names:
            tinfo = tables.get(tname, {})
            result_tables[tname] = {
                "name": tname,
                "description": TABLE_DOMAINS.get(tname, f"CAMS academic data table {tname}"),
                "row_count": tinfo.get("row_count", 0),
                "columns": [c["name"] + f" ({c['type']})" for c in tinfo.get("columns", [])],
                "foreign_keys": [
                    f"{fk['column']} -> {fk['foreign_table']}.{fk['foreign_column']}"
                    for fk in tinfo.get("foreign_keys", [])
                ]
            }

        return {
            "query": query,
            "relevant_tables": list(expanded_names),
            "schemas": result_tables
        }

    @classmethod
    def format_schema_prompt_context(cls, query: str) -> str:
        """
        Formats retrieved schema context into a clean, compact prompt string
        for NVIDIA NIM LLM structured planning.
        """
        retrieved = cls.retrieve_schema_for_query(query)
        schemas = retrieved["schemas"]

        lines = ["=== RELEVANT CAMS POSTGRESQL SCHEMA ==="]
        for tname, s in schemas.items():
            lines.append(f"\nTABLE: {tname} ({s['description']})")
            lines.append(f"COLUMNS: {', '.join(s['columns'])}")
            if s['foreign_keys']:
                lines.append(f"RELATIONSHIPS: {', '.join(s['foreign_keys'])}")

        lines.append("\nRULES: Query MUST use ONLY the tables and columns above. Never invent tables.")
        return "\n".join(lines)
