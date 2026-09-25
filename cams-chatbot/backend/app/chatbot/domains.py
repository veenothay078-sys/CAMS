from typing import Dict, List, Any

# Priority Chatbot Domains Definition with associated tables and sample query templates
CHATBOT_DOMAINS: Dict[str, Dict[str, Any]] = {
    "student": {
        "title": "Student Information",
        "description": "Student academic profiles, enrollment, semester, roll numbers, degrees.",
        "primary_tables": ["students", "users", "degrees", "parent_student_map"],
        "sample_queries": [
            "Show my student academic profile",
            "What is the roll number and semester for student 1?",
            "List enrolled degree programs"
        ]
    },
    "attendance": {
        "title": "Attendance Tracking",
        "description": "Daily period attendance, subject attendance, absences, and approvals.",
        "primary_tables": ["attendance", "attendance_corrections", "sections", "courses"],
        "sample_queries": [
            "What is my recent attendance record?",
            "Show attendance records for today's classes",
            "List attendance corrections pending approval"
        ]
    },
    "examinations": {
        "title": "Examinations & Schedules",
        "description": "Exam schedules, exam halls, CIA and semester test details.",
        "primary_tables": ["exams", "exam_hall_tickets", "exam_seating_arrangements"],
        "sample_queries": [
            "When are the upcoming CIA examinations?",
            "Show exam center and timing details",
            "What exams are scheduled for semester 1?"
        ]
    },
    "marks": {
        "title": "Marks & Internal Assessment",
        "description": "Internal test marks, assignments, presentations, viva, and total scores.",
        "primary_tables": ["internal_marks", "marks", "courses"],
        "sample_queries": [
            "Show my internal marks for this semester",
            "What are my assignment and presentation scores?",
            "List total marks scored per subject"
        ]
    },
    "courses": {
        "title": "Courses & Curriculum",
        "description": "Course catalog, credit distribution, semesters, and degrees.",
        "primary_tables": ["courses", "degrees", "sections", "subject_allocations"],
        "sample_queries": [
            "What courses are offered in semester 2?",
            "How many credits is Constitutional Law?",
            "List all sections and their capacities"
        ]
    },
    "timetable": {
        "title": "Timetable & Schedules",
        "description": "Class schedules, weekdays, time slots, classrooms, and allocated faculty.",
        "primary_tables": ["timetable", "sections", "courses", "users"],
        "sample_queries": [
            "What is my timetable for Monday?",
            "Which room is the 9 AM class held in?",
            "Show the weekly schedule for Section A"
        ]
    },
    "faculty": {
        "title": "Faculty Directory",
        "description": "Faculty profiles, designations, specializations, departments, and contacts.",
        "primary_tables": ["faculty_profiles", "users"],
        "sample_queries": [
            "Who is the professor for Criminal Law?",
            "List faculty members and their designations",
            "Show faculty contact information"
        ]
    },
    "fees": {
        "title": "Fee Records & Dues",
        "description": "Fee structures, payment dues, amounts, deadlines, and payment statuses.",
        "primary_tables": ["fee_records", "fee_structure"],
        "sample_queries": [
            "What are my pending fee dues?",
            "What is the tuition fee due date for semester 3?",
            "Show fee payment receipt status"
        ]
    },
    "notices": {
        "title": "Campus Notices & Circulars",
        "description": "Administrative announcements, academic notifications, and publisher details.",
        "primary_tables": ["notices", "notifications", "users"],
        "sample_queries": [
            "Show recent college notices",
            "Are there any urgent announcements this week?",
            "What notices have been published by the Principal?"
        ]
    },
    "academic_calendar": {
        "title": "Academic Calendar & Events",
        "description": "Semester dates, holidays, working days, college events, and exam periods.",
        "primary_tables": ["academic_years", "academic_calendar_events", "academic_calendars"],
        "sample_queries": [
            "When does the current semester end?",
            "What are the scheduled holidays for this month?",
            "Show the academic year calendar"
        ]
    }
}
