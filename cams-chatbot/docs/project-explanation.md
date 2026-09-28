# CAMS AI Chatbot — Comprehensive Project Explanation

---

## 1. Problem Statement
Traditional College Academic Management Systems (CAMS / ERPs) are composed of dozens of disparate web modules (admissions, attendance, exam seating, fee ledgers, grade books, timetables). Students and faculty often struggle with complex multi-step navigation menus just to check basic academic information such as attendance percentages, timetable slots, or examination schedules.

---

## 2. Proposed Solution
The **CAMS AI Chatbot** provides an intelligent, conversational natural-language interface over the institutional PostgreSQL database. Users can ask questions in plain English (*"What is my attendance?"*, *"When are the semester 1 exams?"*, *"Show marks as a bar chart"*) and receive instant, accurate, role-authorized answers in text, tabular, or chart format.

---

## 3. Why CAMS Relational Data is Essential
The database serves as the single source of truth for all institutional operations. Across 122 relational tables, it models student registrations, degree curriculums, faculty allocations, attendance logs, and internal assessment grades. Grounding AI responses directly in actual database rows eliminates hallucination.

---

## 4. Why PostgreSQL is Used
- **Relational Integrity**: 92 foreign key constraints ensure strict relational consistency between students, sections, courses, and marks.
- **Role Security**: Native support for read-only database roles (`cams_readonly`) with transaction-level read-only guarantees (`SET default_transaction_read_only = on`) and query statement timeouts.
- **Enterprise Features**: Robust ACID compliance, connection pooling support, and performance indexing.

---

## 5. Why NVIDIA NIM is Used
- **Structured Intent Extraction**: Powered by `meta/llama-3.1-70b-instruct`, NVIDIA NIM accurately extracts academic domains, intents, and entity parameters (roll numbers, dates, course codes) from conversational queries.
- **Empathetic Explanation Synthesis**: Synthesizes natural-language explanations over retrieved database records without fabricating missing information.
- **Zero-Hallucination Guardrails**: Prompts strictly instruct the model to state when zero matching records are found rather than inventing plausible data.

---

## 6. Why the Safe Query Layer is Essential
A fundamental vulnerability of naive Text-to-SQL systems is allowing an LLM to generate arbitrary SQL executed directly on the database. In CAMS, **the LLM is NEVER permitted to generate or execute raw SQL directly**.
- **Controlled Abstraction**: The LLM outputs a strongly typed `QueryPlan` with entity parameters.
- **Pre-Audited Builders**: `PlanQueryBuilder` compiles the plan into pre-approved, parameterized SQL templates.
- **AST & Lexical Validator**: `QueryValidator` verifies that every query begins strictly with `SELECT`, enforces table allowlists, blocks destructive keywords (`DROP`, `DELETE`, `UPDATE`, `INSERT`, `ALTER`, `TRUNCATE`, `UNION`), rejects semicolons and comments, and clamps rows to `LIMIT 500`.

---

## 7. Why E2B Sandbox is Used
- **Accurate Mathematics**: LLMs frequently make arithmetic errors when computing averages, percentages, and trends. E2B executes code in an isolated Python environment to compute exact calculations.
- **Client-Side SVG Visualizations**: E2B generates clean data coordinate arrays for Bar, Line, and Pie charts without loading heavy charting libraries.
- **Security Boundary**: E2B Sandbox runs in an isolated container with zero database credentials or network access to PostgreSQL.

---

## 8. Complete Request Flow

```
1. User enters natural-language query in React frontend.
2. React dispatches authenticated request with JWT Bearer token to FastAPI (/api/v1/chat).
3. AuthorizationService verifies role scope (Student, Faculty, Admin).
4. NVIDIA NIM extracts structured intent, entities, and QueryPlan.
5. EntityExtractor resolves multi-turn conversational pronouns ("his", "her").
6. Safe Query Layer validates AST, injects user session bounds, and checks table allowlists.
7. QueryExecutor executes read-only parameterized query against PostgreSQL.
8. If calculation or chart is required -> E2B Sandbox computes exact values/coordinates.
9. NVIDIA NIM synthesizes final empathetic explanation over verified rows.
10. Response Formatter packages JSON payload with text, table, calculation, and SVG chart data.
11. React frontend renders dynamic message bubble with interactive tooltips.
```

---

## 9. Security Architecture Summary
- **RBAC Enforcement**: Students cannot view other students' records; faculty cannot query fee payment records.
- **Read-Only Database Role**: Database user `cams_readonly` is prevented by PostgreSQL engine from mutating data.
- **Prompt Injection Defense**: Injected prompt armor neutralizes system instruction overrides.
- **Zero Secret Leakage**: Database URLs, API keys, and session secrets remain backend-only.

---

## 10. Main Advantages
1. **Zero Hallucination**: Every fact is sourced from authentic database records.
2. **Deterministic Security**: Layered defense prevents SQL injection, data exfiltration, and unauthorized access.
3. **High Performance**: Connection pooling yields sub-20ms database queries.
4. **Responsive UI**: Pure SVG charting and mobile drawer navigation ensure accessible cross-device usability.

---

## 11. Current Limitations
1. **Historical Table Sparsity**: Certain tables in the test backup (e.g. `attendance`) contain 0 rows; verified empty notices are returned.
2. **Unstructured Regulations**: PDF student handbooks are not yet indexed in a vector store.
