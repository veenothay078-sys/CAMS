# CAMS AI Chatbot
### AI-Powered College Management Information System

A production-quality conversational natural-language intelligence platform built on top of the **College Academic Management System (CAMS)** PostgreSQL database (122 relational tables).

---

## 1. Project Overview

The CAMS AI Chatbot enables students, faculty, department heads, and administrators to interactively query their academic records using natural language instead of manually clicking through complex ERP menus.

### Key Capabilities
- **122 CAMS PostgreSQL Tables Integrated**: Evaluated directly against the production CAMS relational database.
- **Safe Query Layer**: AST SQL parsing, read-only policy enforcement, table allowlisting, SQL injection defense, and mandatory row clamping (`LIMIT 500`).
- **NVIDIA NIM LLM**: Structured intent/entity extraction and conversational synthesis powered by `meta/llama-3.1-70b-instruct`.
- **E2B Sandbox Analytics Engine**: Isolated Python execution environment for computing metrics (averages, counts, percentages, min/max) and generating interactive SVG charts (Bar, Line, Pie).
- **Multi-Turn Context & RBAC**: Conversational pronoun resolution ("his marks", "her attendance") with strict role-based data isolation (Student, Faculty, Admin).
- **Responsive Web UI**: Built with React 18, Vite, and Vanilla CSS, supporting desktop, laptop, tablet, and mobile drawer views.

---

## 2. End-to-End Architecture

```
                               ┌─────────────────────────────┐
                               │   React 18 Frontend (Vite)  │
                               │  (Chat, Charts, Tables, RBAC)│
                               └──────────────┬──────────────┘
                                              │ HTTP / JSON
                                              ▼
                               ┌─────────────────────────────┐
                               │       FastAPI Backend       │
                               │    (/api/v1 + /health)      │
                               └──────────────┬──────────────┘
                                              │
                         ┌────────────────────┴────────────────────┐
                         ▼                                         ▼
           ┌───────────────────────────┐             ┌───────────────────────────┐
           │   Authentication & RBAC   │             │   Chat History & Memory   │
           │ (JWT, Role Authorization) │             │ (chat_sessions, messages) │
           └─────────────┬─────────────┘             └─────────────┬─────────────┘
                         │                                         │
                         └────────────────────┬────────────────────┘
                                              │
                                              ▼
                               ┌─────────────────────────────┐
                               │   NVIDIA NIM (LLM Engine)   │
                               │ (Intent, Entities, QueryPlan)│
                               └──────────────┬──────────────┘
                                              │ Structured QueryPlan
                                              ▼
                               ┌─────────────────────────────┐
                               │      Safe Query Layer       │
                               │ (AST Check, SELECT-Only,    │
                               │  Allowlist, Timeout, Limits)│
                               └──────────────┬──────────────┘
                                              │ Parameterized SQL
                                              ▼
                               ┌─────────────────────────────┐
                               │   PostgreSQL CAMS Database  │
                               │   (122 Tables • Read-Only)  │
                               └──────────────┬──────────────┘
                                              │ Sanitized Rows
                         ┌────────────────────┴────────────────────┐
                         ▼ (If calculation / chart)                ▼ (Text only)
           ┌───────────────────────────┐             ┌───────────────────────────┐
           │    E2B Sandbox Analytics  │             │   NVIDIA NIM Synthesis    │
           │ (Isolated Python Compute) │             │ (Natural Language Answer) │
           └─────────────┬─────────────┘             └─────────────┬─────────────┘
                         │                                         │
                         └────────────────────┬────────────────────┘
                                              │
                                              ▼
                               ┌─────────────────────────────┐
                               │   React Frontend Renderer   │
                               │ (Text, SVG Chart, Markdown) │
                               └─────────────────────────────┘
```

---

## 3. Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Frontend** | React 18, Vite 5, Lucide React, Vanilla CSS | Institutional college ERP chat UI, SVG charts, and responsive mobile drawer |
| **Backend** | FastAPI, Python 3.10+, SQLAlchemy 2, Pydantic 2 | High-performance asynchronous API & Query Orchestrator |
| **Database** | PostgreSQL 17 / 16 (122 tables) | Source of truth for student, course, exam, and institutional records |
| **Security** | Safe Query Layer, JWT (HS256), RBAC | SELECT-only AST enforcement, injection blocking, role table isolation |
| **LLM Engine**| NVIDIA NIM (`meta/llama-3.1-70b-instruct`) | Structured intent extraction & conversational explanation synthesis |
| **Analytics** | E2B Sandbox | Controlled Python sandbox for math aggregations and data visualizations |

---

## 4. Priority CAMS Academic Domains

1. **Student Profiles**: `students`, `degrees`, `departments`, `regulations`
2. **Attendance**: `attendance`, `attendance_corrections`, `staff_attendance`
3. **Examinations**: `exams`, `exam_hall_tickets`, `exam_seating_arrangements`
4. **Marks & Grades**: `marks`, `internal_marks`, `student_subject_grades`
5. **Courses & Curriculum**: `courses`, `course_enrollments`, `sections`, `subject_allocations`
6. **Class Timetables**: `timetable`, `timetable_approvals`, `timetable_templates`
7. **Faculty & Staff**: `faculty_profiles`, `faculty_absences`, `leaves`
8. **Fees & Payments**: `fee_records`, `fee_structure`, `payments`
9. **Campus Notices**: `notices`, `notice_acknowledgements`, `notifications`
10. **Academic Calendar**: `academic_calendars`, `academic_calendar_events`, `academic_years`

---

## 5. Environment Variables & Configuration

Copy `.env.example` to `backend/.env`:
```env
PROJECT_NAME="CAMS AI Chatbot"
APP_ENV="development" # Set to "production" in live environments
DEBUG=false
API_V1_STR="/api/v1"

# Database Configuration (Read-only user connection)
DATABASE_URL="postgresql://cams_readonly:cams_readonly_pass@127.0.0.1:5433/cams_db"
DB_STATEMENT_TIMEOUT_MS=3000
DB_MAX_ROWS_LIMIT=500

# Security & Authentication
SECRET_KEY="cams-chatbot-production-secret-key-replace-with-secure-random-token"
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# NVIDIA NIM Configuration
NVIDIA_API_KEY="nvapi-your-key-here"
NVIDIA_NIM_BASE_URL="https://integrate.api.nvidia.com/v1"
NVIDIA_MODEL="meta/llama-3.1-70b-instruct"
NVIDIA_NIM_TIMEOUT_SEC=15.0

# E2B Sandbox Configuration
E2B_API_KEY="e2b_your_api_key_here"

# CORS Configuration
CORS_ORIGINS="http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:8000"
```

---

## 6. How to Run Locally

### 1. Start PostgreSQL Cluster
Ensure PostgreSQL is running on port 5433 (or configured port) with the CAMS database:
```powershell
& "C:\Program Files\PostgreSQL\17\bin\postgres.exe" -D "C:\Users\veeno\AppData\Local\cams_pgdata" -p 5433
```

### 2. Start FastAPI Backend
```powershell
cd cams-chatbot\backend
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```
- Swagger Documentation: `http://localhost:8000/docs`
- Health Check: `http://localhost:8000/health`

### 3. Start React Frontend
```powershell
cd cams-chatbot\frontend
npm.cmd run dev
```
- Open `http://localhost:5173` in your browser.

---

## 7. Testing & Quality Assurance

### Run Complete Automated Backend Tests
```powershell
cd cams-chatbot\backend
python -m pytest tests/ -v
```
**Results: 129 / 129 tests passing (100% pass rate)**.
- `test_phase6_hardening.py` (45 tests): Injection defenses, RBAC scoping, zero-hallucination, and timeout protections.
- `test_e2b_analytics.py` (15 tests): Calculation and chart rendering.
- `test_nim_integration.py` (16 tests): LLM extraction and response synthesis.
- `test_safe_query.py` (18 tests): AST SQL validation and read-only policy.
- `test_chatbot_engine.py` (21 tests): Query planning, context memory, and entity resolution.
- `test_auth_rbac.py`, `test_chat_sessions.py`, `test_data_endpoints.py`, `test_health.py` (14 tests).

### Production Frontend Build
```powershell
cd cams-chatbot\frontend
npm.cmd run build
```

---

## 8. Development Milestone Summary

- **Phase 1: Foundation & Safe Database Integration**: Initialized full stack, mapped 122 tables, implemented connection pooling and read-only enforcement.
- **Phase 2: Safe Query Layer**: AST parser, SELECT-only validation, table allowlisting, and parameter-bound query templates.
- **Phase 3: Chatbot Engine & Query Planning**: Implemented structured `QueryPlan`, multi-turn pronoun context memory, and RBAC rules.
- **Phase 4: NVIDIA NIM Integration**: Integrated `meta/llama-3.1-70b-instruct` for intent extraction and empathetic response synthesis.
- **Phase 5: E2B Sandbox Analytics**: Added isolated computations and responsive SVG Bar/Line/Pie charts.
- **Phase 6: Hardening & Security Audit**: Neutralized prompt injection, SQL injection, tautology attacks; enforced student/faculty isolation; zero-hallucination guardrails.
- **Phase 7: Final Polish & Deployment Readiness**: Added responsive mobile drawer, role switcher, retry flows, production configurations, and complete documentation.
