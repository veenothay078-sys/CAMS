# CAMS Database Analysis & Data-Access Architecture
## College Academic Management System (CAMS) - PostgreSQL Source of Truth

> **Database Engine**: PostgreSQL 17.5 (Dumped from production version 16.15)  
> **Source Backup**: `full_db_backup_20260922_110718.sql`  
> **Total Tables Verified**: **Exactly 122 tables**  
> **Access Mode**: **Strictly Read-Only** (`cams_readonly` role with `statement_timeout = 10000ms`)

---

## 1. Executive Summary & Global Schema Conventions

Every table in CAMS adheres to a rigorous relational enterprise structure:
1. **Primary Key Standard**: Every table has a primary key named `id` of type `character varying` (e.g. `cs_abc123`, `usr_admin`).
2. **Audit Timestamp Standard**: All tables track `created_at` and `updated_at` with time zone (`timestamp with time zone`).
3. **Soft-Delete Standard**: Records implement `is_deleted` (`boolean`, default false) and `deleted_at` (`timestamp with time zone`). The Safe Query Layer ensures all generated queries include `WHERE is_deleted = false`.
4. **Foreign Key Constraints**: 92 tables enforce strict referential foreign keys.
5. **PostgreSQL Enums**: Fixed domains are modeled as native PostgreSQL ENUMs:
   * `user_role`: `['SUPER_ADMIN', 'ADMIN', 'PRINCIPAL', 'HOD', 'FACULTY', 'STUDENT', 'PARENT']`
   * `message_role`: `['USER', 'MODEL', 'SYSTEM']`
   * `exam_type` & `mark_exam_type`: `['CIA', 'SEMESTER']`
   * `fee_status`: `['PAID', 'PENDING', 'OVERDUE', 'PARTIALLY_PAID']`
   * `weekday`: `['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY']`
   * `approval_status`: `['PENDING', 'APPROVED', 'REJECTED', 'CHANGES_REQUESTED']`

---

## 2. Dedicated Read-Only Database User Configuration

To ensure database isolation and prevent any accidental modification, a dedicated read-only role (`cams_readonly`) is configured for the chatbot service.

```sql
-- 1. Create dedicated read-only role
CREATE ROLE cams_readonly WITH LOGIN PASSWORD 'cams_readonly_pass';

-- 2. Grant connection and usage permissions
GRANT CONNECT ON DATABASE cams_db TO cams_readonly;
GRANT USAGE ON SCHEMA public TO cams_readonly;

-- 3. Grant SELECT on all existing and future tables
GRANT SELECT ON ALL TABLES IN SCHEMA public TO cams_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO cams_readonly;

-- 4. Grant write permissions strictly to native chat history tables
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE chat_sessions TO cams_readonly;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE chat_messages TO cams_readonly;

-- 5. Enforce statement timeout and transaction read-only defaults
ALTER ROLE cams_readonly SET statement_timeout = '10000';
ALTER ROLE cams_readonly SET default_transaction_read_only = 'on';
```

**Connection String (Environment Config)**:
```env
DATABASE_URL="postgresql://cams_readonly:cams_readonly_pass@127.0.0.1:5433/cams_db"
```

---

## 3. Important Tables Grouped by Domain

### A. Student Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `students` | Core student academic profile & admission info | `id` | `user_id`, `roll_no`, `full_name`, `semester`, `batch_year`, `cgpa`, `degree_id`, `section_id`, `academic_status` | `user_id -> users.id`, `degree_id -> degrees.id`, `section_id -> sections.id` | `users`, `degrees`, `sections`, `parent_student_map` |
| `parent_student_map` | Parent to student mapping for portal access | `id` | `parent_id`, `student_id` | `parent_id -> users.id`, `student_id -> students.id` | `users`, `students` |
| `student_interactions`| Faculty-student mentoring logs | `id` | `faculty_id`, `section_id`, `interaction_date` | `faculty_id -> users.id`, `section_id -> sections.id` | `users`, `sections` |

### B. Attendance Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `attendance` | Period-wise daily class attendance records | `id` | `section_id`, `subject_id`, `faculty_id`, `date`, `hour`, `absentee_ids`, `od_ids`, `is_locked`, `approval_status` | `section_id -> sections.id`, `subject_id -> courses.id`, `faculty_id -> users.id` | `sections`, `courses`, `users` |
| `attendance_corrections` | Student on-duty / absence correction requests | `id` | `student_id`, `attendance_id`, `reason`, `status`, `approved_by` | `student_id -> users.id`, `attendance_id -> attendance.id` | `users`, `attendance` |
| `staff_attendance` | Faculty daily check-in / check-out records | `id` | `faculty_id`, `date`, `check_in`, `check_out` | `faculty_id -> users.id` | `users` |

### C. Courses & Curriculum Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `degrees` | Academic degree programs (e.g. LL.B., B.A. LL.B.) | `id` | `code`, `name`, `program_level`, `duration_years`, `credit_pattern`, `passing_marks` | None | `courses`, `students`, `academic_years` |
| `courses` | Academic subject catalog | `id` | `degree_id`, `code`, `name`, `credits`, `semester` | `degree_id -> degrees.id` | `degrees`, `sections`, `timetable`, `internal_marks` |
| `sections` | Course sections and cohort divisions | `id` | `course_id`, `section_name`, `faculty_id`, `capacity` | `course_id -> courses.id`, `faculty_id -> users.id` | `courses`, `users`, `timetable`, `attendance` |
| `subject_allocations` | Faculty course teaching assignments | `id` | `academic_year_id`, `course_id`, `section_id`, `faculty_id`, `semester` | `academic_year_id -> academic_years.id`, `course_id -> courses.id`, `faculty_id -> users.id` | `academic_years`, `courses`, `sections`, `users` |

### D. Examinations Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `exams` | Scheduled CIA and semester examinations | `id` | `course_id`, `type`, `center`, `date`, `start_time`, `end_time` | `course_id -> courses.id` | `courses`, `exam_hall_tickets` |
| `exam_hall_tickets` | Student examination hall ticket allocations | `id` | `student_id`, `exam_id`, `seat_number`, `status` | `student_id -> students.id`, `exam_id -> exams.id` | `students`, `exams` |
| `exam_seating_arrangements` | Seating allocations per room | `id` | `exam_id`, `room_id`, `seat_number` | `exam_id -> exams.id`, `room_id -> rooms.id` | `exams`, `rooms` |

### E. Marks & Assessment Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `internal_marks` | Detailed continuous internal assessment marks | `id` | `student_id`, `section_id`, `subject_id`, `academic_year`, `semester`, `internal_exam_mark`, `assignment_mark`, `presentation_mark`, `attendance_mark`, `total_mark`, `status` | `section_id -> sections.id`, `subject_id -> courses.id` | `students`, `sections`, `courses` |
| `marks` | Consolidated examination mark records | `id` | `student_id`, `section_id`, `exam_type`, `mark`, `max_mark` | None (indexed) | `students`, `sections` |
| `student_cgpa_records` | Cumulative grade point average tracking | `id` | `student_id`, `cgpa`, `total_credits`, `standing` | `student_id -> students.id` | `students` |

### F. Faculty & Staff Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `faculty_profiles` | Comprehensive faculty employment and bio data | `id` | `user_id`, `faculty_id`, `designation`, `specialization`, `employee_code`, `employment_status`, `personal_email` | `user_id -> users.id` | `users`, `sections`, `timetable` |
| `faculty_absences` | Faculty leave absence records for substitution | `id` | `faculty_id`, `absence_date`, `session`, `reason` | `faculty_id -> users.id` | `users`, `substitution_allocations` |
| `leaves` | Faculty and staff leave applications | `id` | `faculty_id`, `leave_type`, `from_date`, `to_date`, `status` | `faculty_id -> users.id` | `users`, `leave_approvals` |

### G. Timetable Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `timetable` | Active scheduled class timetable | `id` | `section_id`, `subject_id`, `faculty_id`, `room`, `weekday`, `start_time`, `end_time`, `is_draft` | `section_id -> sections.id`, `subject_id -> courses.id`, `faculty_id -> users.id` | `sections`, `courses`, `users` |
| `timetable_approvals` | HOD and Principal timetable sign-offs | `id` | `timetable_id`, `approved_by`, `status`, `comments` | `timetable_id -> timetable.id`, `approved_by -> users.id` | `timetable`, `users` |

### H. Fees & Finance Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `fee_structure` | Program and semester fee blueprints | `id` | `degree_id`, `semester`, `amount`, `due_date`, `fee_type` | `degree_id -> degrees.id` | `degrees`, `fee_records` |
| `fee_records` | Student fee ledger and payment status | `id` | `student_id`, `fee_structure_id`, `status` | `student_id -> users.id`, `fee_structure_id -> fee_structure.id` | `users`, `fee_structure`, `payments` |
| `payments` | Fee transaction receipts | `id` | `fee_record_id`, `amount_paid`, `payment_mode`, `transaction_ref` | `fee_record_id -> fee_records.id` | `fee_records` |

### I. Notices & Communication Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `notices` | Published campus circulars and announcements | `id` | `created_by`, `title`, `body`, `audience_type`, `publish_date`, `expiry_date`, `priority`, `status` | `created_by -> users.id`, `degree_id -> degrees.id` | `users`, `degrees`, `notice_acknowledgements` |
| `notice_acknowledgements` | Tracking student/faculty read receipts | `id` | `notice_id`, `user_id`, `acknowledged_at` | `notice_id -> notices.id`, `user_id -> users.id` | `notices`, `users` |

### J. Academic Calendar Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `academic_years` | College terms and semester session boundaries | `id` | `name`, `start_date`, `end_date`, `degree_id`, `current_semester`, `is_active` | `degree_id -> degrees.id` | `degrees`, `academic_calendars` |
| `academic_calendar_events` | Holidays, events, and examination milestones | `id` | `title`, `category`, `start_date`, `end_date`, `is_holiday`, `event_type`, `visibility_scope` | None (scoped by degree/batch) | `degrees`, `batch_sections` |

### K. Users, Authentication & RBAC Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `users` | Authentication accounts and institutional roles | `id` | `email`, `phone`, `full_name`, `hashed_password`, `role`, `is_active`, `degree_id` | `degree_id -> degrees.id` | `students`, `faculty_profiles`, `chat_sessions` |
| `user_sessions` | Login session tracking | `id` | `user_id`, `ip_address`, `user_agent`, `created_at` | `user_id -> users.id` | `users` |

### L. Native Chatbot Storage Domain
| Table Name | Purpose | Primary Key | Important Columns | Foreign Keys | Related Tables |
|---|---|---|---|---|---|
| `chat_sessions` | Natural language conversational sessions | `id` | `user_id`, `title`, `is_active`, `created_at`, `updated_at` | `user_id -> users.id` | `users`, `chat_messages` |
| `chat_messages` | Individual conversation dialogue turns | `id` | `session_id`, `role`, `content`, `created_at` | `session_id -> chat_sessions.id` | `chat_sessions` |

---

## 4. Comprehensive Relationship Map

```mermaid
erDiagram
    users ||--o| students : "user_id"
    users ||--o| faculty_profiles : "user_id"
    users ||--o{ chat_sessions : "user_id"
    chat_sessions ||--o{ chat_messages : "session_id"
    degrees ||--o{ courses : "degree_id"
    degrees ||--o{ students : "degree_id"
    degrees ||--o{ academic_years : "degree_id"
    courses ||--o{ sections : "course_id"
    courses ||--o{ timetable : "subject_id"
    courses ||--o{ attendance : "subject_id"
    courses ||--o{ internal_marks : "subject_id"
    sections ||--o{ timetable : "section_id"
    sections ||--o{ attendance : "section_id"
    sections ||--o{ internal_marks : "section_id"
    users ||--o{ timetable : "faculty_id"
    users ||--o{ attendance : "faculty_id"
    students ||--o{ parent_student_map : "student_id"
    users ||--o{ parent_student_map : "parent_id"
    fee_structure ||--o{ fee_records : "fee_structure_id"
    users ||--o{ fee_records : "student_id"
    notices ||--o{ notice_acknowledgements : "notice_id"
    users ||--o{ notices : "created_by"
```

---

## 5. Safe Query Guardrails & Policy Matrix

| Policy Rule | Enforcement Mechanism | Failure Action |
|---|---|---|
| **SELECT-Only Enforcement** | `QueryValidator` token parsing | Query rejected before database submission |
| **Destructive Command Blocking** | Lexical analysis of `INSERT`, `UPDATE`, `DELETE`, `DROP`, `ALTER`, `TRUNCATE`, `CREATE`, `GRANT` | Immediate 400 Bad Request error returned |
| **Injection Defense** | Pattern check against `;`, `pg_sleep()`, `--`, `/* */` | Query aborted |
| **Row-Size Limiting** | Regex detection; automatically clamps or injects `LIMIT 100` | Max 100 rows ever returned into application memory |
| **Statement Timeout** | Session-level `SET LOCAL statement_timeout = 10000;` | Cancelled by PostgreSQL after 10.0 seconds |
| **Role-Based Table Access** | `QueryPolicy.is_table_allowed()` checked against authenticated JWT role | Immediate 403 Forbidden error |
| **Sensitive Column Masking** | `QueryResultFormatter` strips `hashed_password` and PII | Confidential fields never leave backend |