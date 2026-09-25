# CAMS AI Chatbot
### AI-Powered College Management Information System

A production-quality conversational natural-language interface built on top of the **College Academic Management System (CAMS)** PostgreSQL database.

---

## 1. Project Overview

CAMS Chatbot enables students, faculty, heads of departments, and college administrators to interactively query their academic records using natural language instead of manually navigating disparate enterprise ERP modules.

### Key Highlights
- **122 CAMS PostgreSQL Tables Analyzed & Integrated**: Evaluated directly against the genuine production backup (`full_db_backup_20260922_110718.sql`).
- **Safe Query Layer**: SQL injection prevention, SELECT-only verification, AST parsing, table allowlisting, and mandatory row limiting (`LIMIT 100`).
- **Controlled Query Abstraction**: Structured query intent translation prevents the LLM from executing raw arbitrary SQL directly.
- **Read-Only Database Security**: Enforces non-destructive queries at both the application level and the PostgreSQL role level (`cams_readonly`).
- **Persistent Chat History**: Reuses existing CAMS `chat_sessions` and `chat_messages` tables.
- **Pluggable AI & Sandbox Architecture**: Abstracted service interfaces for NVIDIA NIM (LLM) and E2B Sandbox (Code Interpreter & Visualizations).

---

## 2. Architecture & Request Pipeline

```
Users (Student / Faculty / HOD / Admin)
   │
   ▼
React Frontend (Vite + Inter UI)
   │
   ▼
FastAPI Backend (/api/v1)
   │
   ▼
Authentication & RBAC (Role Scoping)
   │
   ▼
AI Query Orchestrator
   │
   ├──► NVIDIA NIM (Natural Language Understanding -> StructuredQueryIntent)
   │
   ▼
IntentQueryBuilder (Pre-Compiled Parameter-Bound SQL Template)
   │
   ▼
Safe Query Layer (AST Parser • Table Allowlist • Limit Injection • 10s Timeout)
   │
   ▼
PostgreSQL CAMS Database (Read-Only • 122 Tables)
   │
   ▼
QueryResultFormatter (Sanitization & PII Stripping)
   │
   ├──► E2B Sandbox (Code Interpreter / Calculations / Charts - Phase 3)
   │
   ├──► NVIDIA NIM (Natural Language Synthesis - Phase 3)
   │
   ▼
Response Formatter (Markdown & Tabular Output)
   │
   ▼
React Frontend
```

---

## 3. Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Frontend** | React 18, Vite 5, Vanilla CSS | Professional college ERP conversational interface |
| **Backend** | FastAPI, Python 3.10+, SQLAlchemy 2 | High-performance asynchronous API & Query Orchestrator |
| **Database** | PostgreSQL 17 / 16 (122 tables) | Source of truth for all college and chat records |
| **Security** | Safe Query Layer, JWT, RBAC | SELECT-only enforcement, allowlisting, least-privilege |
| **LLM** | NVIDIA NIM (`meta/llama-3.1-70b-instruct`) | Query translation & empathetic answer synthesis |
| **Sandbox** | E2B Sandbox | Isolated code interpreter for computations & charts |

---

## 4. Priority Chatbot Data Domains

1. **Student Information**: `students`, `parent_student_map`, `degrees`.
2. **Attendance**: `attendance`, `attendance_corrections`, `staff_attendance`.
3. **Examinations**: `exams`, `exam_hall_tickets`, `exam_seating_arrangements`.
4. **Marks & Grades**: `marks`, `internal_marks`, `student_subject_grades`.
5. **Courses & Curriculum**: `courses`, `course_enrollments`, `sections`, `subject_allocations`.
6. **Timetable**: `timetable`, `timetable_approvals`, `timetable_templates`.
7. **Faculty & Staff**: `faculty_profiles`, `faculty_absences`, `leaves`.
8. **Fees & Finance**: `fee_records`, `fee_structure`, `payments`.
9. **Notices & Communication**: `notices`, `notice_acknowledgements`, `notifications`.
10. **Academic Calendar**: `academic_calendars`, `academic_calendar_events`, `academic_years`.

---

## 5. Local Setup & Configuration

### Prerequisites
- Python 3.10+
- Node.js 18+ and npm
- PostgreSQL 16 or 17

### Environment Variables
Configure `backend/.env` (see `backend/.env.example`):
```env
PROJECT_NAME="CAMS AI Chatbot"
APP_ENV="development"
DEBUG=true
API_V1_STR="/api/v1"

# Database Configuration (Read-only user)
DATABASE_URL="postgresql://cams_readonly:cams_readonly_pass@127.0.0.1:5433/cams_db"
DB_STATEMENT_TIMEOUT_MS=10000
DB_MAX_ROWS_LIMIT=100

# Security
SECRET_KEY="cams-chatbot-development-secret-key-change-in-production"
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# LLM: NVIDIA NIM
NVIDIA_NIM_API_KEY=""
NVIDIA_NIM_BASE_URL="https://integrate.api.nvidia.com/v1"
NVIDIA_NIM_MODEL="meta/llama-3.1-70b-instruct"

# Code Interpreter: E2B Sandbox
E2B_API_KEY=""

# CORS
CORS_ORIGINS="http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:8000"
```

---

## 6. Running the System

### 1. PostgreSQL Database
Ensure your PostgreSQL instance is running with the CAMS database restored.
```powershell
& "C:\Program Files\PostgreSQL\17\bin\postgres.exe" -D "C:\Users\veeno\AppData\Local\cams_pgdata" -p 5433
```

### 2. Start the FastAPI Backend
```bash
cd backend
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```
- API Documentation (Swagger): `http://localhost:8000/docs`
- Dedicated Database Health Check: `http://localhost:8000/api/v1/health/database`
- Controlled Data Endpoints: `http://localhost:8000/api/v1/data/domains`

### 3. Start the React Frontend
```bash
cd frontend
npm.cmd run dev
```
- Open `http://localhost:5173` in your browser.

---

## 7. Running Backend Tests
Execute the full test suite (37 tests) verifying live PostgreSQL connectivity, 122 tables detection, Safe Query Layer defenses, structured intent execution, and RBAC:
```bash
cd backend
python -m pytest tests -v
```

---

## 8. Current Phase & Future Roadmap

### Phase 1: Foundation & Safe Database Integration (COMPLETED)
- [x] Full-stack architecture scaffolding (`cams-chatbot/`)
- [x] Complete database inspection & documentation (`docs/database-analysis.md` for 122 tables)
- [x] PostgreSQL connection pooling & read-only role enforcement
- [x] College-themed React UI (sidebar, chat stream, markdown tables, domain quick-starters)

### Phase 2: PostgreSQL Data-Access Foundation & Safe Query Layer (COMPLETED)
- [x] Verified connection to actual PostgreSQL database (122 tables)
- [x] Dedicated database health check: `GET /api/v1/health/database`
- [x] Repository layer (`backend/app/repositories/`)
- [x] Safe Query Layer (`QueryValidator`, `QueryPolicy`, `QueryExecutor`, `QueryResultFormatter`, `SafeQueryService`)
- [x] Controlled query abstraction (`StructuredQueryIntent`, `IntentQueryBuilder`) preventing direct SQL from LLMs
- [x] Rejection verification for `INSERT`, `UPDATE`, `DELETE`, `DROP`, `ALTER`, `TRUNCATE`, `CREATE`, `GRANT`, `REVOKE`
- [x] Dedicated Read-Only Database User documentation (`cams_readonly`)
- [x] Controlled data access endpoints (`/api/v1/data/domains`, `/api/v1/data/query`, `/api/v1/data/students/me`, etc.)
- [x] Comprehensive test suite passing (37/37 tests)

### Phase 3: NVIDIA NIM Integration & Multi-Turn Conversational Reasoning (Next Phase)
- Integrate live NVIDIA NIM API client for automated few-shot intent and entity extraction.
- Dynamic domain prompt mapping to `StructuredQueryIntent`.
- Multi-turn conversation context memory.
- Dynamic student vs faculty authorization context injection.

### Phase 4: E2B Sandbox Code Interpreter & Visualizations
- Isolated Python sandbox execution for complex calculations (GPA, attendance percentiles).
- Visual chart rendering directly in the React frontend.
