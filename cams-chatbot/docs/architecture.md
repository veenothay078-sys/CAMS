# CAMS AI Chatbot Architecture Document
## AI-Powered College Management Information System (Phase 2 Data-Access Foundation)

### 1. Architectural Overview & System Flow

The CAMS AI Chatbot enables natural language conversational intelligence over the PostgreSQL database without allowing raw SQL generation or exposing sensitive credentials.

The end-to-end request-response cycle is strictly structured as follows:

```mermaid
flowchart TD
    User([User: Student / Faculty / HOD / Admin]) -->|Natural Language Query| Frontend[React Frontend]
    Frontend -->|HTTPS API Request + JWT| Backend[FastAPI Backend /api/v1]
    Backend --> Auth[Authentication & RBAC Scoping]
    Auth --> Orchestrator[AI / Query Orchestrator]
    
    subgraph Controlled_Query_Pipeline [Controlled Query Intent Abstraction]
        Orchestrator --> LLM_Intent[NVIDIA NIM: Natural Language Intent Parsing]
        LLM_Intent --> IntentSchema[StructuredQueryIntent: JSON Domain & Entities]
        IntentSchema --> Builder[IntentQueryBuilder: Parameter-Bound Safe SQL Builder]
    end

    subgraph Safe_Query_Layer [Safe Query Layer (Security Core)]
        Builder --> Validator[QueryValidator: AST & Lexical Parsing]
        Validator --> Policy[QueryPolicy: Role Allowlist & Limit Enforcer]
        Policy --> Executor[QueryExecutor: Parameterized Execution + 10s Timeout]
    end

    Executor -->|Read-Only SQL| Postgres[(PostgreSQL CAMS DB - 122 Tables)]
    Postgres -->|Raw Result Rows| Sanitizer[QueryResultFormatter: PII & Password Stripper]
    Sanitizer --> Decision{Calculations / Chart Required?}
    Decision -->|Yes| E2B[E2B Sandbox: Code Execution & Charting - Phase 3]
    Decision -->|No| LLM_Response[NVIDIA NIM: Natural Language Synthesis - Phase 3]
    E2B --> LLM_Response
    LLM_Response --> Formatter[Response Formatter]
    Formatter -->|Structured JSON + Tabular Data| Frontend
    Frontend -->|Rendered Message & Tables| User
```

---

### 2. Controlled Query Abstraction: Why the LLM Does NOT Execute SQL Directly

A fundamental vulnerability of naive Text-to-SQL systems is allowing the LLM to generate arbitrary SQL strings sent directly to the database.

**In CAMS, the LLM will NEVER execute SQL directly:**
1. **Natural Language Understanding**: NVIDIA NIM interprets the user prompt into a strongly typed `StructuredQueryIntent`:
   ```json
   {
     "domain": "attendance",
     "intent": "recent_records",
     "entities": {
       "date": "2026-09-22"
     },
     "requested_output": "summary"
   }
   ```
2. **Intent-to-Query Mapping (`IntentQueryBuilder`)**:
   - Matches intent to pre-approved, audited query templates.
   - Automatically injects session identity parameters (`user_id = :current_user_id`).
   - Prevents student users from inquiring into other students' attendance or marks.
3. **Safe Query Layer Verification**:
   - Ensures query is strictly `SELECT`.
   - Disallows destructive keywords (`DROP`, `DELETE`, `UPDATE`, `INSERT`, `ALTER`, `TRUNCATE`, `GRANT`).
   - Enforces table allowlist and mandatory row limiting (`LIMIT 100`).
   - Executes with a session statement timeout (`statement_timeout = 10000ms`).

---

### 3. Safe Query Layer Components

#### A. `QueryPolicy`
Defines operational boundaries:
- `MAX_QUERY_ROW_LIMIT = 100` (Protects server memory).
- `STATEMENT_TIMEOUT_MS = 10000` (Prevents runaway CPU loops).
- `ALLOWED_CHATBOT_TABLES` vs `STRICTLY_FORBIDDEN_TABLES` (Blocks internal tables such as `audit_logs`, `system_settings`, `salary`).
- `ROLE_TABLE_PERMISSIONS`: Dynamic table authorization per `UserRole`.

#### B. `QueryValidator`
- Token and regex AST parser.
- Rejects multi-statements separated by semicolons (`;\s*\w+`).
- Rejects time-based blind injection (`pg_sleep`).
- Rejects SQL comments used for query truncation (`--`, `/* */`).
- Injects or clamps `LIMIT 100`.

#### C. `QueryExecutor`
- Executes queries against SQLAlchemy connection pool.
- Enforces transaction read-only mode (`SET LOCAL default_transaction_read_only = on`).
- Employs parameterized binding (`:param_name`).
- Masks raw database exceptions to avoid leaking table structures or credentials.

#### D. `QueryResultFormatter`
- Strips confidential fields (e.g. `hashed_password`, PII) before returning to services.
- Serializes Date, Time, Decimal, and UUID objects to standard JSON primitives.

---

### 4. Role-Based Access Control (RBAC) Scoping Model

| Role | Scope of Access | Enforced Constraints |
|---|---|---|
| **STUDENT** | Own profile, own attendance, own marks, enrolled courses, section timetable, own fee records | Parameter `user_id` bound to current student. Table access restricted. Sensitive PII stripped. |
| **FACULTY** | Assigned courses, allocated sections, own teaching schedule, student lists within assigned sections | Parameter `faculty_id` bound to current user. Cannot view institutional payroll or other faculty leaves without permission. |
| **HOD** | Department courses, department faculty workload, semester performance | Scoped to department degree programs. |
| **PRINCIPAL / ADMIN** | College-wide academic records, cross-department analytics, notice broadcasts | Full access to allowed academic tables. System settings remain protected. |

---

### 5. Dedicated Read-Only PostgreSQL User

The CAMS Chatbot backend connects using a least-privilege PostgreSQL user:

```sql
CREATE ROLE cams_readonly WITH LOGIN PASSWORD 'cams_readonly_pass';
GRANT CONNECT ON DATABASE cams_db TO cams_readonly;
GRANT USAGE ON SCHEMA public TO cams_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO cams_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO cams_readonly;

-- Allow session logging in native CAMS tables
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE chat_sessions TO cams_readonly;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE chat_messages TO cams_readonly;

ALTER ROLE cams_readonly SET default_transaction_read_only = 'on';
ALTER ROLE cams_readonly SET statement_timeout = '10000';
```
No database credentials or API keys are ever bundled into or accessible by the React frontend.
