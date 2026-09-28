# CAMS AI Chatbot
### AI-Powered College Management Information System

A production-ready conversational natural-language intelligence interface built on top of the **College Academic Management System (CAMS)** PostgreSQL database (122 relational tables).

---

## 1. Overview

The CAMS AI Chatbot provides students, faculty, department heads, and college administrators with an intuitive natural-language assistant to query institutional academic records in real time—eliminating the need to navigate dozens of complex ERP modules.

---

## 2. Key Features

- **Natural-Language CAMS Queries**: Conversational query understanding across 10 academic domains (Profiles, Attendance, Exams, Marks, Timetables, Courses, Faculty, Fees, Notices, Calendar).
- **Authentication & RBAC**: JWT (HS256) authentication with strict role-based data boundaries (Student, Faculty, Admin).
- **Safe Query Layer**: AST SQL parsing, read-only policy enforcement, table allowlisting, SQL injection defense, and mandatory row clamping (`LIMIT 500`).
- **PostgreSQL Integration**: Direct read-only connection to all 122 tables in the CAMS relational database.
- **NVIDIA NIM LLM**: Structured intent/entity extraction and zero-hallucination explanation synthesis via `meta/llama-3.1-70b-instruct`.
- **Multi-Turn Context & Pronoun Memory**: Contextual pronoun resolution ("What is Arun's roll number?" $\to$ "What about his marks?") and clean entity switching.
- **E2B Sandbox Analytics Engine**: Isolated Python execution environment for arithmetic computations (average, count, min/max, percentage) without database access.
- **Interactive SVG Visualizations**: Client-side SVG Bar, Line, and Pie charts with interactive hover tooltips.
- **Structured Results & Tables**: Clean tabular formatting with horizontal scrolling and mobile responsiveness.
- **Persistent Chat History**: Session creation, multi-turn history, session deletion, and conversation clearing.
- **Layered Security Hardening**: Defense against prompt injection, SQL injection, tautology attacks, and sensitive column exfiltration.

---

## 3. End-to-End Architecture

```
                               ┌─────────────────────────────┐
                               │   React 18 Frontend (Vite)  │
                               │  (Chat, Charts, Tables, RBAC)│
                               └──────────────┬──────────────┘
                                              │ HTTPS / JSON + JWT
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

## 4. Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Frontend** | React 18, Vite 5, Lucide React, Vanilla CSS | Institutional college ERP chat interface, SVG charts, and responsive mobile drawer |
| **Backend** | FastAPI, Python 3.10+, SQLAlchemy 2, Pydantic 2 | High-performance asynchronous API & Query Orchestrator |
| **Database** | PostgreSQL 17 / 16 (122 tables) | Source of truth for student, course, exam, and institutional records |
| **Security** | Safe Query Layer, JWT (HS256), RBAC | SELECT-only AST enforcement, injection blocking, role table isolation |
| **LLM Engine**| NVIDIA NIM (`meta/llama-3.1-70b-instruct`) | Structured intent extraction & conversational explanation synthesis |
| **Analytics** | E2B Sandbox | Controlled Python sandbox for math aggregations and data visualizations |

---

## 5. Environment Variables

Templates are provided in `.env.example`:

### Backend (`cams-chatbot/backend/.env`)
```env
PROJECT_NAME="CAMS AI Chatbot"
APP_ENV="production"
DEBUG=false
API_V1_STR="/api/v1"

# Database Configuration (Read-only user connection)
DATABASE_URL="postgresql://cams_readonly:your_password@<db-host>:5432/cams_db"
DB_STATEMENT_TIMEOUT_MS=3000
DB_MAX_ROWS_LIMIT=500

# Security & Authentication
SECRET_KEY="<strong-random-secret-key>"
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# NVIDIA NIM Configuration
NVIDIA_API_KEY="nvapi-your-key-here"
NVIDIA_NIM_BASE_URL="https://integrate.api.nvidia.com/v1"
NVIDIA_MODEL="meta/llama-3.1-70b-instruct"
NVIDIA_NIM_TIMEOUT_SEC=15.0

# E2B Sandbox Configuration
E2B_API_KEY="e2b_your_api_key_here"

# CORS Configuration
CORS_ORIGINS="https://cams.college.edu"
```

### Frontend (`cams-chatbot/frontend/.env`)
```env
VITE_API_BASE_URL="/api/v1"
```

---

## 6. Running Locally

### 1. PostgreSQL Database
Ensure your PostgreSQL instance is running with the CAMS database:
```powershell
& "C:\Program Files\PostgreSQL\17\bin\postgres.exe" -D "C:\Users\veeno\AppData\Local\cams_pgdata" -p 5433
```

### 2. Start the FastAPI Backend
```powershell
cd cams-chatbot\backend
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```
- Swagger Documentation: `http://localhost:8000/docs`
- Health Check: `http://localhost:8000/health`

### 3. Start the React Frontend
```powershell
cd cams-chatbot\frontend
npm.cmd run dev
```
- Open `http://localhost:5173` in your browser.

---

## 7. Testing & Quality Assurance

### Run Automated Backend Test Suite (129 Tests)
```powershell
cd cams-chatbot\backend
python -m pytest tests/ -v
```
**Results: 129 / 129 tests passed (100% pass rate)**.

### Production Frontend Build
```powershell
cd cams-chatbot\frontend
npm.cmd run build
```

---

## 8. Production Deployment

See [`docs/deployment.md`](file:///c:/Users/veeno/OneDrive/Desktop/CAMS/cams-chatbot/docs/deployment.md) and [`docs/database-deployment.md`](file:///c:/Users/veeno/OneDrive/Desktop/CAMS/cams-chatbot/docs/database-deployment.md) for full server provisioning, Nginx reverse-proxy setup, and database role configuration.

---

## 9. Security Architecture

- **RBAC Enforcement**: Students cannot view other students' records; faculty cannot query fee payment records.
- **Read-Only Database Role**: Database user `cams_readonly` is restricted from executing `INSERT`, `UPDATE`, `DELETE`, `ALTER`, or `DROP` on academic tables.
- **Safe Query Layer**: AST validation ensures only `SELECT` statements are executed, blocks multi-statements, filters SQL comments, and neutralizes tautology injection constructs (`1' OR '1'='1`).
- **Prompt Injection Armor**: System prompts neutralize instruction overrides, roleplay exfiltration, and administrative privilege escalation attempts.
- **Secret Protection**: API keys, database credentials, and session tokens remain backend-only.

---

## 10. Known Limitations

1. **Historical Table Sparsity**: Specific tables in the test database backup (e.g. `attendance`) contain zero initial rows; the engine truthfully outputs verified empty notices rather than hallucinating mock records.
2. **Unstructured Regulations**: PDF student handbooks and ordinances are not yet indexed in a vector database.
