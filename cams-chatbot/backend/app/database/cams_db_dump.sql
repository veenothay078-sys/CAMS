--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: activity_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.activity_category AS ENUM (
    'SPORTS',
    'CLUB',
    'CULTURAL',
    'OTHER'
);


--
-- Name: allocation_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.allocation_method AS ENUM (
    'MANUAL',
    'AUTOMATIC'
);


--
-- Name: approval_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.approval_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CHANGES_REQUESTED'
);


--
-- Name: calendar_day_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.calendar_day_status AS ENUM (
    'WORKING',
    'HOLIDAY',
    'WEEKEND_HOLIDAY',
    'SPECIAL_WORKING_DAY',
    'STUDY_HOLIDAY',
    'EXAMINATION',
    'INSTITUTION_EVENT',
    'FESTIVAL_HOLIDAY',
    'GOVERNMENT_HOLIDAY',
    'SEMESTER_BREAK',
    'OTHER'
);


--
-- Name: calendar_event_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.calendar_event_type AS ENUM (
    'WORKING_DAY',
    'WEEKEND_HOLIDAY',
    'GOVERNMENT_HOLIDAY',
    'INSTITUTIONAL_HOLIDAY',
    'EXAMINATION',
    'CYCLE_TEST',
    'VIVA',
    'INTERNAL_EXAMINATION',
    'STUDY_HOLIDAY',
    'ACADEMIC_EVENT',
    'SPECIAL_WORKING_DAY',
    'SPECIAL_HOLIDAY',
    'UNIVERSITY_EXAMINATION',
    'OTHER'
);


--
-- Name: calendar_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.calendar_status AS ENUM (
    'DRAFT',
    'PENDING_APPROVAL',
    'APPROVED',
    'PUBLISHED',
    'ARCHIVED'
);


--
-- Name: deduction_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.deduction_type AS ENUM (
    'LOP',
    'CL'
);


--
-- Name: exam_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.exam_type AS ENUM (
    'CIA',
    'SEMESTER'
);


--
-- Name: fee_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.fee_status AS ENUM (
    'PAID',
    'PENDING',
    'OVERDUE',
    'PARTIALLY_PAID'
);


--
-- Name: leave_approval_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.leave_approval_status AS ENUM (
    'SUBMITTED',
    'UNDER_REVIEW',
    'FACULTY_APPROVED',
    'ADVISOR_APPROVED',
    'HOD_APPROVED',
    'PRINCIPAL_APPROVED',
    'REJECTED',
    'RESUBMISSION_REQUIRED',
    'PENDING',
    'APPROVED',
    'REJECTED_BY_HOD',
    'REJECTED_BY_PRINCIPAL',
    'REJECTED_BY_FACULTY',
    'REJECTED_BY_ADVISOR',
    'PENDING_HOD',
    'PENDING_PRINCIPAL',
    'APPROVED_BY_HOD',
    'FINAL_APPROVED',
    'HOD_REJECTED',
    'PRINCIPAL_REJECTED'
);


--
-- Name: mark_exam_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mark_exam_type AS ENUM (
    'CIA',
    'SEMESTER'
);


--
-- Name: message_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.message_role AS ENUM (
    'USER',
    'MODEL',
    'SYSTEM'
);


--
-- Name: payroll_run_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.payroll_run_status AS ENUM (
    'DRAFT',
    'SUBMITTED',
    'APPROVED',
    'REJECTED',
    'LOCKED'
);


--
-- Name: revision_approval_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.revision_approval_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


--
-- Name: substitution_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.substitution_status AS ENUM (
    'PENDING',
    'ALLOCATED',
    'ACKNOWLEDGED',
    'COMPLETED',
    'PARTIALLY_COMPLETED',
    'NOT_CONDUCTED'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'SUPER_ADMIN',
    'ADMIN',
    'PRINCIPAL',
    'HOD',
    'FACULTY',
    'STUDENT',
    'PARENT'
);


--
-- Name: weekday; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.weekday AS ENUM (
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academic_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_activities (
    faculty_id character varying(36) NOT NULL,
    faculty_name character varying(255),
    activity_type character varying(128) NOT NULL,
    topic text NOT NULL,
    duration character varying(64),
    date character varying(64) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: academic_calendar_date_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_calendar_date_events (
    id character varying(64) NOT NULL,
    academic_calendar_id character varying(64) NOT NULL,
    event_date date NOT NULL,
    day_of_week character varying(16) NOT NULL,
    status public.calendar_day_status NOT NULL,
    event_type public.calendar_event_type NOT NULL,
    event_name character varying(255) NOT NULL,
    description text,
    is_working_day boolean NOT NULL,
    is_instructional_day boolean NOT NULL,
    is_exam_day boolean NOT NULL,
    is_study_holiday boolean NOT NULL,
    is_weekend boolean NOT NULL,
    is_government_holiday boolean NOT NULL,
    is_attendance_eligible boolean NOT NULL,
    working_day_sequence integer,
    start_time character varying(16),
    end_time character varying(16),
    degree_id character varying(64),
    batch_id character varying(64),
    semester_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: academic_calendar_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_calendar_events (
    id character varying(64) NOT NULL,
    title character varying(255) NOT NULL,
    category character varying(128) NOT NULL,
    start_date character varying(16) NOT NULL,
    end_date character varying(16) NOT NULL,
    start_time character varying(16),
    description text,
    academic_year character varying(32),
    degree character varying(255),
    degree_id character varying(36),
    batch character varying(64),
    batch_id character varying(64),
    location character varying(255),
    is_holiday boolean NOT NULL,
    event_type character varying(64) NOT NULL,
    visibility_scope character varying(64) NOT NULL,
    created_by character varying(255),
    created_role character varying(64),
    status character varying(32) NOT NULL,
    approval_status character varying(32) NOT NULL,
    principal_action_by character varying(36),
    principal_action_date timestamp without time zone,
    principal_remarks text,
    audience json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: academic_calendar_setup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_calendar_setup (
    academic_year character varying(32) NOT NULL,
    institution_name character varying(255),
    start_date character varying(16),
    end_date character varying(16),
    odd_sem_start character varying(16),
    odd_sem_end character varying(16),
    even_sem_start character varying(16),
    even_sem_end character varying(16),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: academic_calendars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_calendars (
    id character varying(64) NOT NULL,
    institution_id character varying(64),
    academic_year_id character varying(64),
    degree_id character varying(128),
    department_id character varying(64),
    batch_id character varying(64),
    semester_id integer,
    calendar_name character varying(255) NOT NULL,
    valid_from date NOT NULL,
    valid_to date NOT NULL,
    version integer NOT NULL,
    previous_version_id character varying(64),
    change_reason text,
    circular_reference character varying(255),
    status public.calendar_status NOT NULL,
    created_by character varying(64),
    published_at timestamp without time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: academic_years; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_years (
    name character varying(128) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    degree_id character varying(128) NOT NULL,
    batch character varying(128) NOT NULL,
    current_semester integer NOT NULL,
    semester_end_date date,
    is_semester_open boolean NOT NULL,
    is_exam_period boolean NOT NULL,
    is_active boolean NOT NULL,
    status character varying(64) DEFAULT 'ACTIVE'::character varying,
    completed_at date,
    archived_at date,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_logs (
    user_id character varying(128),
    action character varying(255) NOT NULL,
    action_metadata character varying(4000),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: activity_point_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_point_applications (
    student_id character varying(36) NOT NULL,
    student_name character varying(255),
    roll_no character varying(64),
    title character varying(255) NOT NULL,
    category character varying(64) NOT NULL,
    description text,
    date character varying(64),
    supporting_document character varying(255),
    claimed_points double precision NOT NULL,
    approved_points double precision NOT NULL,
    status character varying(64) NOT NULL,
    reviewed_by character varying(255),
    reviewed_at character varying(64),
    faculty_remarks text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: allowance_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.allowance_types (
    name character varying(128) NOT NULL,
    code character varying(64) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_by character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: alumni_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alumni_members (
    name character varying(255) NOT NULL,
    experience character varying(64),
    specialization character varying(255),
    email character varying(255),
    phone character varying(32),
    batch_year character varying(16),
    current_position character varying(255),
    organization character varying(255),
    linkedin_url text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: assignment_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignment_submissions (
    assignment_id character varying(64) NOT NULL,
    student_id character varying(36) NOT NULL,
    student_name character varying(255),
    submitted_date character varying(64),
    status character varying(64) NOT NULL,
    submitted_file json,
    submitted_text text,
    marks_obtained double precision,
    grade character varying(16),
    feedback text,
    remarks text,
    history json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignments (
    section_id character varying(128) NOT NULL,
    faculty_id character varying(128) NOT NULL,
    title character varying(255) NOT NULL,
    deadline date NOT NULL,
    submission_count integer NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendance (
    section_id character varying(128) NOT NULL,
    subject_id character varying(128) NOT NULL,
    faculty_id character varying(128) NOT NULL,
    date date NOT NULL,
    hour character varying(32) NOT NULL,
    absentee_ids json,
    od_ids json,
    is_locked boolean NOT NULL,
    approval_status character varying(32) NOT NULL,
    auto_filled_from character varying(32),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: attendance_corrections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendance_corrections (
    attendance_id character varying(128),
    faculty_id character varying(128),
    student_reg_no character varying(64) NOT NULL,
    student_name character varying(256) NOT NULL,
    subject character varying(256) NOT NULL,
    date date NOT NULL,
    previous_status character varying(64) NOT NULL,
    updated_status character varying(64) NOT NULL,
    reason character varying(1024) NOT NULL,
    status character varying(64) NOT NULL,
    remarks character varying(1024),
    student_changes json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id character varying(64) NOT NULL,
    user_id character varying(128),
    user_email character varying(255),
    user_name character varying(255),
    user_role character varying(64),
    action character varying(255) NOT NULL,
    entity character varying(255) NOT NULL,
    entity_id character varying(255),
    tab_name character varying(255),
    details text,
    old_value text,
    new_value text,
    ip_address character varying(64),
    user_agent character varying(255),
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: backup_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.backup_configurations (
    auto_backup_enabled boolean NOT NULL,
    schedule_time character varying(5) NOT NULL,
    retention_count integer NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: backup_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.backup_history (
    filename character varying(255) NOT NULL,
    filepath character varying(1000) NOT NULL,
    size_bytes bigint NOT NULL,
    status character varying(50) NOT NULL,
    trigger_type character varying(50) NOT NULL,
    created_by character varying(128),
    error_message character varying(4000),
    is_incremental boolean NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: batch_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_sections (
    degree_id character varying(128) NOT NULL,
    batch character varying(128) NOT NULL,
    section_name character varying(32) NOT NULL,
    is_unified boolean DEFAULT false NOT NULL,
    capacity integer,
    legacy_section_id character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buildings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.buildings (
    id character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(64) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_messages (
    session_id character varying(128) NOT NULL,
    role public.message_role NOT NULL,
    content text NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: chat_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_sessions (
    user_id character varying(128) NOT NULL,
    title character varying(255),
    is_active boolean NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: class_advisors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_advisors (
    academic_year_id character varying(128) NOT NULL,
    faculty_id character varying(128) NOT NULL,
    degree_id character varying(128) NOT NULL,
    batch character varying(128) NOT NULL,
    section_name character varying(32) NOT NULL,
    batch_section_id character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: class_diaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_diaries (
    date character varying(64) NOT NULL,
    subject character varying(255) NOT NULL,
    course character varying(255) NOT NULL,
    semester character varying(32) NOT NULL,
    section character varying(64) NOT NULL,
    hour character varying(32) NOT NULL,
    year character varying(32),
    unit character varying(255) NOT NULL,
    topic text NOT NULL,
    subtopic text,
    teaching_method character varying(255) NOT NULL,
    co_po_mapping character varying(255),
    delivery_status character varying(255) NOT NULL,
    remarks text,
    attachments json,
    faculty_id character varying(36) NOT NULL,
    faculty_name character varying(255),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: classroom_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classroom_activities (
    faculty_id character varying(128) NOT NULL,
    section_id character varying(128) NOT NULL,
    activity_type character varying(64) NOT NULL,
    topic character varying(255) NOT NULL,
    duration_minutes integer NOT NULL,
    remarks text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: club_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.club_memberships (
    club_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    role character varying(64) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: clubs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clubs (
    name character varying(255) NOT NULL,
    category character varying(128),
    members_count integer NOT NULL,
    icon character varying(64),
    color character varying(128),
    border_color character varying(128),
    description text,
    president character varying(255),
    contact character varying(255),
    phone character varying(32),
    next_meeting character varying(128),
    recent_activities json,
    upcoming_events json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: community_service_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_service_logs (
    student_id character varying(36) NOT NULL,
    student_name character varying(255) NOT NULL,
    register_number character varying(64),
    degree_code character varying(64),
    activity_name character varying(255) NOT NULL,
    organization character varying(255) NOT NULL,
    category character varying(128) NOT NULL,
    hours_logged double precision NOT NULL,
    date character varying(32) NOT NULL,
    description text,
    certificate_url text,
    status character varying(32) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: course_enrollment_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_enrollment_requests (
    student_id character varying(36) NOT NULL,
    student_name character varying(255) NOT NULL,
    course_id character varying(64) NOT NULL,
    course_title character varying(255) NOT NULL,
    status character varying(32) NOT NULL,
    faculty_id character varying(36),
    faculty_name character varying(255),
    action_date character varying(64),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: course_enrollments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_enrollments (
    user_id character varying(36) NOT NULL,
    course_id character varying(64) NOT NULL,
    course_title character varying(255) NOT NULL,
    category character varying(128) NOT NULL,
    instructor character varying(255),
    duration character varying(64),
    credits integer NOT NULL,
    enrolled_at character varying(64),
    progress integer NOT NULL,
    certificate_earned boolean NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    degree_id character varying(128),
    code character varying(32) NOT NULL,
    name character varying(255) NOT NULL,
    credits integer NOT NULL,
    semester integer NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: custom_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_assignments (
    title character varying(255) NOT NULL,
    type character varying(64),
    course_id character varying(36),
    batch_section_id character varying(36),
    subject character varying(255),
    unit character varying(128),
    topic character varying(255),
    description text,
    instructions text,
    total_marks integer NOT NULL,
    issue_date character varying(64),
    deadline character varying(64),
    status character varying(64) NOT NULL,
    faculty_id character varying(36),
    faculty_name character varying(255),
    semester character varying(32),
    section character varying(64),
    attachments json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: deductions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deductions (
    salary_id character varying(128) NOT NULL,
    type public.deduction_type NOT NULL,
    days integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: degrees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.degrees (
    code character varying(32) NOT NULL,
    name character varying(255) NOT NULL,
    applicable_batch character varying(128) NOT NULL,
    program_level character varying(32) NOT NULL,
    duration_years integer NOT NULL,
    credit_pattern character varying(255),
    exam_formula character varying(255),
    passing_marks integer NOT NULL,
    grade_boundaries character varying(2000),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: employee_allowance_overrides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_allowance_overrides (
    employee_salary_assignment_id character varying(128) NOT NULL,
    allowance_type_id character varying(128) NOT NULL,
    override_amount numeric(12,2) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: employee_salary_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_salary_assignments (
    faculty_id character varying(128) NOT NULL,
    salary_structure_id character varying(128) NOT NULL,
    basic_salary_override numeric(12,2),
    special_allowance_override numeric(12,2),
    medical_allowance_override numeric(12,2),
    effective_from date NOT NULL,
    effective_to date,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: exam_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_settings (
    exam_id character varying(128) NOT NULL,
    halls character varying(255) NOT NULL,
    rules character varying(4000) NOT NULL,
    is_published boolean NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: exam_setup_splits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_setup_splits (
    exam_setup_id character varying(128) NOT NULL,
    name character varying(255) NOT NULL,
    mark integer NOT NULL,
    pass_mark integer,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: exam_setups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_setups (
    batch_id character varying(128) NOT NULL,
    semester integer NOT NULL,
    exam_name character varying(255) NOT NULL,
    pass_mark integer,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: exams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exams (
    course_id character varying(128) NOT NULL,
    type public.exam_type NOT NULL,
    center character varying(128) NOT NULL,
    date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: extracurricular_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.extracurricular_activities (
    name character varying(255) NOT NULL,
    category public.activity_category NOT NULL,
    description character varying(1000),
    degree_id character varying(128),
    faculty_id character varying(128),
    is_active boolean NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: extracurricular_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.extracurricular_logs (
    slot_id character varying(128),
    activity_id character varying(128) NOT NULL,
    faculty_id character varying(128) NOT NULL,
    log_date date NOT NULL,
    topics_covered character varying(2000),
    attendance_count integer,
    notes character varying(2000),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: extracurricular_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.extracurricular_slots (
    activity_id character varying(128) NOT NULL,
    degree_id character varying(128),
    batch character varying(128) NOT NULL,
    semester integer NOT NULL,
    weekday public.weekday NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    room character varying(64),
    faculty_id character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: faculty_absences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faculty_absences (
    faculty_id character varying(128) NOT NULL,
    date date NOT NULL,
    reason character varying(512),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: faculty_profile_update_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faculty_profile_update_requests (
    user_id character varying(128) NOT NULL,
    status character varying(64) NOT NULL,
    section_name character varying(128),
    old_value json,
    new_value json,
    reviewer_role character varying(64),
    faculty_id character varying(64),
    employee_code character varying(64),
    official_email character varying(255),
    official_phone character varying(32),
    gender character varying(16),
    date_of_birth date,
    blood_group character varying(16),
    nationality character varying(64),
    designation character varying(64),
    comments character varying(512),
    processed_at timestamp with time zone,
    processed_by character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: faculty_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faculty_profiles (
    user_id character varying(128) NOT NULL,
    faculty_id character varying(64),
    designation character varying(128) NOT NULL,
    specialization character varying(255),
    employee_code character varying(64),
    gender character varying(16),
    date_of_birth date,
    blood_group character varying(16),
    marital_status character varying(32),
    nationality character varying(64),
    community character varying(64),
    alternate_phone character varying(32),
    personal_email character varying(255),
    current_address character varying(512),
    permanent_address character varying(512),
    city character varying(128),
    state character varying(128),
    pincode character varying(16),
    profile_photo_url character varying(512),
    faculty_type character varying(64),
    employment_category character varying(64),
    date_of_joining date,
    employment_status character varying(64),
    approval_status character varying(64) DEFAULT 'PENDING_HOD'::character varying NOT NULL,
    reporting_hod_id character varying(36),
    reporting_principal_id character varying(36),
    confirmation_date date,
    educational_qualifications json,
    experience_details json,
    academic_responsibilities json,
    certifications_achievements json,
    promotion_history json,
    increment_history json,
    documents_repository json,
    notification_preferences json,
    section_verification_status json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: faculty_research; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faculty_research (
    faculty_id character varying(128) NOT NULL,
    title character varying(255) NOT NULL,
    publication character varying(255),
    grant_amount numeric(12,2),
    publisher character varying(255),
    publication_date date,
    isbn_issn character varying(64),
    research_type character varying(64),
    proof_file_url character varying(512),
    status character varying(64) NOT NULL,
    comments character varying(512),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: faculty_workload; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faculty_workload (
    faculty_id character varying(128) NOT NULL,
    semester integer NOT NULL,
    teaching_hours integer NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: fee_blueprints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fee_blueprints (
    name character varying(255) NOT NULL,
    program_level character varying(32) NOT NULL,
    degree_code character varying(64),
    batch_year character varying(16),
    quota character varying(64),
    community character varying(64),
    fee_components json NOT NULL,
    fees json,
    applicable_scholars json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: fee_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fee_records (
    student_id character varying(128) NOT NULL,
    fee_structure_id character varying(128) NOT NULL,
    status public.fee_status NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: fee_structure; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fee_structure (
    degree_id character varying(128) NOT NULL,
    semester integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    due_date date NOT NULL,
    fee_type character varying(255) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: floors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.floors (
    id character varying(64) NOT NULL,
    "buildingId" character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    level integer NOT NULL,
    code character varying(64),
    status character varying(64),
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: global_research_timelines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.global_research_timelines (
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    target_role character varying(64) DEFAULT '''FACULTY'''::character varying NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: grade_template_allowances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grade_template_allowances (
    salary_structure_id character varying(128) NOT NULL,
    allowance_type_id character varying(128) NOT NULL,
    amount numeric(12,2) DEFAULT 0.0 NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: grievances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grievances (
    grievance_id character varying(32) NOT NULL,
    raised_by character varying(128) NOT NULL,
    category character varying(128) NOT NULL,
    subject character varying(256) NOT NULL,
    description character varying(4000) NOT NULL,
    priority character varying(32) NOT NULL,
    status character varying(32) NOT NULL,
    attachment_url character varying(1024),
    assigned_to character varying(128),
    recipient character varying(32) NOT NULL,
    response_text character varying(4000),
    response_by character varying(32),
    response_date timestamp with time zone,
    principal_remarks character varying(4000),
    resolution_notes character varying(4000),
    resolution_date timestamp with time zone,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: innovation_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.innovation_posts (
    student_id character varying(36) NOT NULL,
    author_name character varying(255) NOT NULL,
    degree_code character varying(64),
    title character varying(255) NOT NULL,
    category character varying(128) NOT NULL,
    summary text NOT NULL,
    description text,
    tags json NOT NULL,
    upvotes integer NOT NULL,
    status character varying(32) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: internal_marks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.internal_marks (
    student_id character varying(128) NOT NULL,
    section_id character varying(128),
    subject_id character varying(128) NOT NULL,
    academic_year character varying(32) NOT NULL,
    semester character varying(32),
    exam_id character varying(64),
    internal_exam_mark numeric(5,2) NOT NULL,
    assignment_mark numeric(5,2) NOT NULL,
    presentation_mark numeric(5,2) NOT NULL,
    viva_voice_mark numeric(5,2) NOT NULL,
    attendance_mark numeric(5,2) NOT NULL,
    total_mark numeric(5,2) NOT NULL,
    status character varying(512) NOT NULL,
    hod_message character varying(1024),
    faculty_reply character varying(1024),
    is_message_visible_to_student boolean NOT NULL,
    previous_marks character varying(2048),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: internship_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.internship_applications (
    student_email character varying(255) NOT NULL,
    student_name character varying(255),
    drive_name character varying(255) NOT NULL,
    drive_id character varying(36),
    status character varying(64) NOT NULL,
    extra_data json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: internship_drives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.internship_drives (
    name character varying(255) NOT NULL,
    role character varying(255),
    package character varying(128),
    date character varying(64),
    status character varying(64) NOT NULL,
    location character varying(255),
    duration character varying(64),
    description text,
    numeric_id integer,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: internship_mentors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.internship_mentors (
    name character varying(255) NOT NULL,
    experience character varying(64),
    specialization character varying(255),
    email character varying(255),
    phone character varying(32),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: leave_approvals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leave_approvals (
    id character varying(64) NOT NULL,
    leave_id character varying(64) NOT NULL,
    approved_by character varying(128) NOT NULL,
    status public.leave_approval_status NOT NULL,
    remarks character varying(1024),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: leave_balances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leave_balances (
    user_id character varying(64) NOT NULL,
    casual_leave double precision NOT NULL,
    sick_leave double precision NOT NULL,
    earned_leave double precision NOT NULL,
    on_duty_leave double precision NOT NULL,
    metadata_ json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: leave_deduction_limits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leave_deduction_limits (
    leave_type character varying(64) NOT NULL,
    limit_days integer DEFAULT 0 NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    deduction_config_id character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: leaves; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leaves (
    id character varying(64) NOT NULL,
    user_id character varying(128) NOT NULL,
    type character varying(64) NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    num_days double precision NOT NULL,
    reason character varying(1024) NOT NULL,
    emergency_contact character varying(32) NOT NULL,
    attachment_url character varying(512),
    status character varying(64) NOT NULL,
    hod_status character varying(32),
    hod_action_by character varying(36),
    hod_action_date timestamp without time zone,
    hod_remarks character varying(1024),
    principal_action_by character varying(36),
    principal_action_date timestamp without time zone,
    principal_remarks character varying(1024),
    session_type character varying(32),
    priority character varying(16),
    latitude double precision,
    longitude double precision,
    location_address character varying(256),
    capture_time timestamp without time zone,
    verification_status character varying(32),
    distance_from_campus double precision,
    device_id character varying(64),
    location_accuracy double precision,
    geo_fence_status character varying(32),
    device_network_info character varying(128),
    metadata_ json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: lecture_recordings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lecture_recordings (
    title character varying(255) NOT NULL,
    faculty_name character varying(255),
    subject character varying(255),
    section character varying(64),
    date character varying(32),
    duration character varying(32),
    recording_url text,
    thumbnail_url text,
    status character varying(32) NOT NULL,
    views integer NOT NULL,
    extra_data json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: legal_event_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_event_questions (
    event_id character varying(64),
    student_name character varying(255),
    student_email character varying(255),
    question text NOT NULL,
    category character varying(128),
    status character varying(32) NOT NULL,
    answer text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: legal_event_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_event_registrations (
    event_id character varying(64) NOT NULL,
    student_email character varying(255) NOT NULL,
    student_name character varying(255),
    student_id character varying(64),
    status character varying(32) NOT NULL,
    attended boolean NOT NULL,
    registration_time character varying(32),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: legal_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_events (
    id character varying(64) NOT NULL,
    title character varying(255) NOT NULL,
    category character varying(128) NOT NULL,
    speaker json NOT NULL,
    date character varying(64) NOT NULL,
    "time" character varying(64) NOT NULL,
    duration character varying(64) NOT NULL,
    status character varying(64) NOT NULL,
    mode character varying(64) NOT NULL,
    platform character varying(128),
    "meetingLink" text,
    "totalSeats" integer NOT NULL,
    "availableSeats" integer NOT NULL,
    "registrationDeadline" character varying(64),
    description text NOT NULL,
    agenda json NOT NULL,
    "activityPoints" integer NOT NULL,
    "materialsAvailable" boolean NOT NULL,
    "certificateAvailable" boolean NOT NULL,
    "eventType" character varying(64),
    "organizingInstitute" character varying(255),
    posted_by character varying(64),
    degree_id character varying(64),
    batch_year character varying(64),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: lesson_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lesson_plans (
    subject character varying(255) NOT NULL,
    units json NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: marks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.marks (
    student_id character varying(128) NOT NULL,
    section_id character varying(128) NOT NULL,
    exam_type public.mark_exam_type NOT NULL,
    mark numeric(5,2) NOT NULL,
    max_mark numeric(5,2) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: mentorship_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentorship_records (
    student_id character varying(128) NOT NULL,
    mentor_id character varying(128) NOT NULL,
    meeting_log character varying(4000),
    academic_review character varying(4000),
    improvement_plan character varying(4000),
    remarks character varying(4000),
    follow_up character varying(4000),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    sender_id character varying(128) NOT NULL,
    receiver_id character varying(128) NOT NULL,
    body character varying(4000) NOT NULL,
    is_read boolean NOT NULL,
    read_at timestamp with time zone,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: notice_acknowledgements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notice_acknowledgements (
    notice_id character varying(128) NOT NULL,
    user_id character varying(128) NOT NULL,
    is_read boolean NOT NULL,
    read_at timestamp with time zone,
    is_acknowledged boolean NOT NULL,
    acknowledged_at timestamp with time zone,
    status character varying(32) NOT NULL,
    is_archived boolean NOT NULL,
    archived_at timestamp with time zone,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: notices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notices (
    created_by character varying(128) NOT NULL,
    title character varying(255) NOT NULL,
    body character varying(4000) NOT NULL,
    audience_type character varying(64) NOT NULL,
    publish_date date NOT NULL,
    category character varying(64),
    expiry_date date,
    priority character varying(32),
    status character varying(32),
    publisher_role character varying(32),
    target_semester integer,
    target_section character varying(64),
    audience_types character varying(512),
    degree_id character varying(128),
    batch_id character varying(64),
    attachment_url character varying(512),
    event_date date,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    user_id character varying(128) NOT NULL,
    type character varying(64) NOT NULL,
    message character varying(1024) NOT NULL,
    is_read boolean NOT NULL,
    sent_via character varying(32) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: online_meetings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.online_meetings (
    title character varying(255) NOT NULL,
    host character varying(255),
    platform character varying(128),
    meeting_link text,
    meeting_id character varying(128),
    passcode character varying(64),
    scheduled_date character varying(32),
    start_time character varying(32),
    duration character varying(32),
    status character varying(32) NOT NULL,
    audience character varying(128),
    degree character varying(255),
    description text,
    extra_data json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: parent_student_map; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parent_student_map (
    parent_id character varying(128) NOT NULL,
    student_id character varying(128) NOT NULL,
    relationship character varying(64),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    fee_record_id character varying(128) NOT NULL,
    amount numeric(12,2) NOT NULL,
    mode character varying(32) NOT NULL,
    txn_id character varying(128) NOT NULL,
    receipt_url character varying(512),
    paid_at timestamp with time zone NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: payroll_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payroll_runs (
    month integer NOT NULL,
    year integer NOT NULL,
    status public.payroll_run_status NOT NULL,
    generated_by character varying(128),
    approved_by character varying(128),
    total_employees integer NOT NULL,
    total_gross numeric(14,2) NOT NULL,
    total_deductions numeric(14,2) NOT NULL,
    total_net numeric(14,2) NOT NULL,
    submitted_at timestamp with time zone,
    approved_at timestamp with time zone,
    locked_at timestamp with time zone,
    rejection_reason text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: publication_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_plans (
    faculty_id character varying(128) NOT NULL,
    title character varying(255) NOT NULL,
    journal_conference character varying(255) NOT NULL,
    target_date date NOT NULL,
    status character varying(32) NOT NULL,
    research_area character varying(255),
    publication_type character varying(128),
    expected_publication_date date,
    academic_year character varying(64),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: publication_proofs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_proofs (
    plan_id character varying(128) NOT NULL,
    publication_date date NOT NULL,
    journal_name character varying(255) NOT NULL,
    issn_isbn character varying(64) NOT NULL,
    doi_number character varying(64),
    publication_link character varying(512),
    proof_file_url character varying(512) NOT NULL,
    status character varying(64) NOT NULL,
    remarks character varying(1024),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: research_compliance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.research_compliance (
    faculty_id character varying(128) NOT NULL,
    requirement_name character varying(255) NOT NULL,
    deadline date NOT NULL,
    status character varying(32) NOT NULL,
    submitted_at timestamp without time zone,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: research_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.research_plans (
    faculty_id character varying(128) NOT NULL,
    title character varying(255) NOT NULL,
    area character varying(128) NOT NULL,
    target_journal_conference character varying(255) NOT NULL,
    type character varying(128) NOT NULL,
    start_date date NOT NULL,
    expected_completion_date date NOT NULL,
    objectives character varying(1024) NOT NULL,
    abstract_summary character varying(2048) NOT NULL,
    status character varying(64) NOT NULL,
    plan_approval_status character varying(64) DEFAULT 'PENDING_APPROVAL'::character varying NOT NULL,
    plan_rejection_remarks character varying(2048),
    paper_rejection_remarks character varying(2048),
    late_permission_status character varying(64) DEFAULT 'NOT_REQUIRED'::character varying NOT NULL,
    is_late_submission boolean DEFAULT false NOT NULL,
    submitted_at timestamp with time zone,
    department_name character varying(128),
    cycle_start_date date NOT NULL,
    cycle_due_date date NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: research_progress_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.research_progress_updates (
    plan_id character varying(128) NOT NULL,
    progress_date date NOT NULL,
    current_stage character varying(128) NOT NULL,
    percentage_completed integer NOT NULL,
    work_completed character varying(1024) NOT NULL,
    remarks character varying(1024),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: research_verifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.research_verifications (
    proof_id character varying(128) NOT NULL,
    verified_by character varying(128) NOT NULL,
    status character varying(64) NOT NULL,
    remarks character varying(1024),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id character varying(64) NOT NULL,
    "floorId" character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(128) NOT NULL,
    "degreeId" character varying(64),
    "degreeCode" character varying(64),
    batch character varying(64),
    year character varying(64),
    section character varying(64),
    capacity integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: salary; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary (
    faculty_id character varying(128) NOT NULL,
    basic numeric(12,2) NOT NULL,
    allowances numeric(12,2) NOT NULL,
    gross numeric(12,2) NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    employee_id character varying(64),
    designation character varying(128),
    working_days integer DEFAULT 30 NOT NULL,
    leave_days integer DEFAULT 0 NOT NULL,
    special_allowance numeric(12,2) DEFAULT 0.0 NOT NULL,
    medical_allowance numeric(12,2) DEFAULT 0.0 NOT NULL,
    net_salary numeric(12,2) DEFAULT 0.0 NOT NULL,
    leave_deduction numeric(12,2),
    pf_deduction numeric(12,2) DEFAULT 0.0 NOT NULL,
    joining_date date,
    total_working_days integer DEFAULT 30 NOT NULL,
    payroll_run_id character varying(128),
    payment_status character varying(32) DEFAULT 'PENDING'::character varying NOT NULL,
    payment_date date,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: salary_allowances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_allowances (
    salary_id character varying(128) NOT NULL,
    allowance_type_id character varying(128) NOT NULL,
    allowance_name character varying(128) NOT NULL,
    allowance_code character varying(64) NOT NULL,
    amount numeric(12,2) DEFAULT 0.0 NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: salary_deduction_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_deduction_configs (
    role character varying(64) NOT NULL,
    calculation_type character varying(32) NOT NULL,
    value numeric(12,2) DEFAULT 0.0 NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: salary_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_revisions (
    faculty_id character varying(128) NOT NULL,
    previous_designation character varying(128),
    new_designation character varying(128) NOT NULL,
    previous_basic numeric(12,2) NOT NULL,
    previous_special numeric(12,2) NOT NULL,
    previous_medical numeric(12,2) NOT NULL,
    new_basic numeric(12,2) NOT NULL,
    new_special numeric(12,2) NOT NULL,
    new_medical numeric(12,2) NOT NULL,
    effective_date date NOT NULL,
    reason text,
    approved_by character varying(128),
    approval_status public.revision_approval_status NOT NULL,
    admin_remarks character varying(1024),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: salary_slip_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_slip_requests (
    faculty_id character varying(128) NOT NULL,
    request_type character varying(64) NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    remarks character varying(1024),
    status character varying(32) NOT NULL,
    admin_remarks character varying(1024),
    salary_slip_id character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: salary_slips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_slips (
    salary_id character varying(128) NOT NULL,
    pdf_url character varying(512) NOT NULL,
    generated_at timestamp with time zone NOT NULL,
    delivered_at timestamp with time zone,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: salary_structures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_structures (
    designation character varying(128) NOT NULL,
    basic_salary numeric(12,2) NOT NULL,
    special_allowance numeric(12,2) NOT NULL,
    medical_allowance numeric(12,2) NOT NULL,
    gross_salary numeric(12,2) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description character varying(512),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: scholarship_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scholarship_types (
    name character varying(255) NOT NULL,
    description text,
    reduction_type character varying(32) NOT NULL,
    reduction_value double precision NOT NULL,
    scope character varying(32) NOT NULL,
    batch_year character varying(16),
    degree_code character varying(64),
    program_level character varying(32) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: section_cohort_mappings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.section_cohort_mappings (
    id character varying(64) NOT NULL,
    section_id character varying(128) NOT NULL,
    batch_section_id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sections (
    course_id character varying(128) NOT NULL,
    section_name character varying(32) NOT NULL,
    faculty_id character varying(128),
    capacity integer,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: session_summaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_summaries (
    faculty_id character varying(128) NOT NULL,
    section_id character varying(128) NOT NULL,
    subject_code character varying(32) NOT NULL,
    topic_covered character varying(255) NOT NULL,
    subtopic_covered character varying(255),
    teaching_method character varying(128) NOT NULL,
    resources_used json,
    remarks text,
    date date NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: staff_attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staff_attendance (
    faculty_id character varying(128) NOT NULL,
    date date NOT NULL,
    status character varying(64) NOT NULL,
    check_in character varying(32),
    check_out character varying(32),
    working_hours numeric(5,2),
    source character varying(64) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: staff_attendance_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staff_attendance_records (
    faculty_id character varying(36) NOT NULL,
    faculty_name character varying(255) NOT NULL,
    degree_code character varying(64),
    date character varying(32) NOT NULL,
    check_in_time character varying(32),
    check_out_time character varying(32),
    status character varying(32) NOT NULL,
    remarks text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: student_concessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_concessions (
    student_id character varying(36) NOT NULL,
    scholarship_amount double precision NOT NULL,
    scholarship_name character varying(255),
    deduction_amount double precision NOT NULL,
    deduction_reason character varying(255),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: student_council_initiatives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_council_initiatives (
    title character varying(255) NOT NULL,
    lead_by character varying(255) NOT NULL,
    status character varying(64) NOT NULL,
    target_date character varying(32),
    description text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: student_council_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_council_members (
    "position" character varying(128) NOT NULL,
    student_name character varying(255) NOT NULL,
    degree_code character varying(64),
    year_group character varying(64),
    photo_url text,
    email character varying(255),
    manifesto text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: student_interactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_interactions (
    faculty_id character varying(128) NOT NULL,
    section_id character varying(128) NOT NULL,
    type character varying(32) NOT NULL,
    question_text text NOT NULL,
    options json,
    responses_count integer NOT NULL,
    is_active boolean NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: student_material_bookmarks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_material_bookmarks (
    user_id character varying(36) NOT NULL,
    material_id character varying(36) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: student_material_downloads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_material_downloads (
    user_id character varying(36) NOT NULL,
    material_id character varying(36) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: student_material_favorites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_material_favorites (
    user_id character varying(36) NOT NULL,
    material_id character varying(36) NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: student_papers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_papers (
    student_user_id character varying(36) NOT NULL,
    mentor_id character varying(36),
    title character varying(500) NOT NULL,
    abstract text,
    category character varying(128),
    status character varying(64) NOT NULL,
    remarks text,
    guide character varying(255),
    team json,
    submission_date character varying(32),
    awards json,
    file_size character varying(32),
    featured boolean NOT NULL,
    file_url text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: students; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.students (
    user_id character varying(128) NOT NULL,
    roll_no character varying(64) NOT NULL,
    semester integer NOT NULL,
    batch_year integer NOT NULL,
    academic_status character varying(64) DEFAULT 'ACTIVE'::character varying,
    completion_year integer,
    status_changed_at date,
    mentor_id character varying(128),
    skills json,
    degree_id character varying(128),
    quota character varying(64),
    cgpa numeric(3,2),
    certifications json,
    internships json,
    sports_records json,
    moot_courts json,
    profile_photo_url character varying(1000),
    section_id character varying(128),
    batch_section_id character varying(128),
    full_name character varying(128),
    date_of_birth date,
    gender character varying(16),
    blood_group character varying(8),
    nationality character varying(64),
    mobile_number character varying(20),
    current_address character varying(256),
    permanent_address character varying(256),
    aadhaar_number character varying(20),
    pan_number character varying(20),
    passport_number character varying(20),
    community_category character varying(64),
    religion character varying(64),
    emergency_contact_name character varying(128),
    emergency_contact_relationship character varying(64),
    emergency_contact_number character varying(20),
    father_name character varying(128),
    father_occupation character varying(128),
    father_mobile character varying(20),
    father_email character varying(128),
    mother_name character varying(128),
    mother_occupation character varying(128),
    mother_mobile character varying(20),
    mother_email character varying(128),
    parent_annual_income character varying(64),
    mark_10th character varying(64),
    mark_12th character varying(64),
    group_12th character varying(128),
    languages_known json,
    hobbies_interests json,
    special_skills json,
    medical_info character varying(256),
    verification_status character varying(64) DEFAULT 'DRAFT'::character varying,
    staff_remarks character varying(500),
    hod_remarks character varying(500),
    document_aadhaar_url character varying(1000),
    document_community_url character varying(1000),
    document_tc_url character varying(1000),
    document_other_url character varying(1000),
    document_income_url character varying(1000),
    edit_request_status character varying(64),
    edit_request_reason character varying(1000),
    scholarship_type_id character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: study_materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.study_materials (
    section_id character varying(128) NOT NULL,
    faculty_id character varying(128) NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(64) NOT NULL,
    file_url character varying(512) NOT NULL,
    is_verified boolean NOT NULL,
    status character varying(64) NOT NULL,
    comments character varying(1024),
    rejection_remarks character varying(2048),
    rejected_by character varying(255),
    rejected_date character varying(64),
    approved_by character varying(255),
    approved_date character varying(64),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: subject_allocations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subject_allocations (
    academic_year_id character varying(128) NOT NULL,
    course_id character varying(128) NOT NULL,
    section_id character varying(128) NOT NULL,
    faculty_id character varying(128) NOT NULL,
    degree_id character varying(128) NOT NULL,
    semester integer,
    allocated_by character varying(128),
    is_active boolean NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: substitution_allocations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.substitution_allocations (
    absence_id character varying(128) NOT NULL,
    timetable_id character varying(128) NOT NULL,
    date date NOT NULL,
    substitute_faculty_id character varying(128),
    status public.substitution_status NOT NULL,
    allocation_method public.allocation_method,
    completed_at timestamp with time zone,
    remarks character varying(1024),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: system_setting_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_setting_history (
    setting_id character varying(128) NOT NULL,
    user_id character varying(128),
    field_name character varying(128) NOT NULL,
    old_value character varying(4000),
    new_value character varying(4000),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_settings (
    college_name character varying(255) NOT NULL,
    logo_url character varying(1000),
    address character varying(1000),
    affiliation_number character varying(128),
    aicte_ugc_code character varying(128),
    accreditation_body character varying(4000),
    bank_name character varying(255),
    bank_account_no character varying(128),
    bank_ifsc character varying(64),
    bank_branch character varying(255),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: teaching_log_audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teaching_log_audits (
    user_name character varying(255) NOT NULL,
    role character varying(64) NOT NULL,
    action character varying(255) NOT NULL,
    "timestamp" character varying(64) NOT NULL,
    ip_address character varying(64),
    remarks text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: teaching_log_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teaching_log_notifications (
    faculty_id character varying(36) NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    date character varying(64) NOT NULL,
    is_read boolean NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: timetable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timetable (
    section_id character varying(128) NOT NULL,
    subject_id character varying(128) NOT NULL,
    faculty_id character varying(128),
    room character varying(64),
    weekday public.weekday NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    is_draft boolean DEFAULT true NOT NULL,
    is_combined_class boolean DEFAULT false NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: timetable_action_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timetable_action_history (
    section_id character varying(128) NOT NULL,
    semester integer NOT NULL,
    batch character varying(255) NOT NULL,
    action character varying(50) NOT NULL,
    action_by character varying(128) NOT NULL,
    comments text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: timetable_approvals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timetable_approvals (
    timetable_id character varying(128) NOT NULL,
    status public.approval_status NOT NULL,
    approved_by character varying(128),
    comments character varying(1000),
    rejection_remarks character varying(2048),
    approved_date character varying(64),
    rejected_by character varying(128),
    rejected_date character varying(64),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: timetable_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timetable_templates (
    degree_id character varying(128),
    semester integer NOT NULL,
    batch character varying(255) NOT NULL,
    periods_json character varying(10000) NOT NULL,
    breaks_json character varying(10000) NOT NULL,
    is_saturday_working boolean,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: user_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_preferences (
    user_id character varying(128) NOT NULL,
    key character varying(128) NOT NULL,
    value json,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_sessions (
    user_id character varying(128) NOT NULL,
    refresh_token_hash character varying(255) NOT NULL,
    user_agent character varying(512),
    ip_address character varying(64),
    is_revoked boolean DEFAULT false NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    last_active_at timestamp with time zone DEFAULT now() NOT NULL,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    email character varying(255) NOT NULL,
    phone character varying(32),
    full_name character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    role public.user_role NOT NULL,
    additional_roles character varying(255),
    is_active boolean NOT NULL,
    degree_id character varying(128),
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: working_day_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.working_day_config (
    month integer NOT NULL,
    year integer NOT NULL,
    total_working_days integer NOT NULL,
    overrides_json text,
    id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Data for Name: academic_activities; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: academic_calendar_date_events; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: academic_calendar_events; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: academic_calendar_setup; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: academic_calendars; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: academic_years; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.academic_years VALUES ('2026-2027', '2026-07-01', '2027-06-30', 'deg_b_a_l_l_b_2026_2031', '2026-2031', 1, NULL, true, false, true, 'ACTIVE', NULL, NULL, 'ay_2026_2027_b_a_l_l_b_2026_2031', '2026-09-16 14:51:19.36897+05:30', '2026-09-20 22:06:23.270502+05:30', false, NULL);
INSERT INTO public.academic_years VALUES ('2026-2027', '2026-07-01', '2027-06-30', 'deg_b_a_l_l_b_2025_2030', '2025-2030', 3, NULL, true, false, true, 'ACTIVE', NULL, NULL, 'ay_2026_2027_b_a_l_l_b_2025_2030', '2026-09-16 14:51:51.931186+05:30', '2026-09-20 22:06:23.276446+05:30', false, NULL);
INSERT INTO public.academic_years VALUES ('2026-2027', '2026-07-01', '2027-06-30', 'deg_l_l_b_2026_2029', '2026-2029', 1, NULL, true, false, true, 'ACTIVE', NULL, NULL, 'ay_2026_2027_l_l_b_2026_2029', '2026-09-16 14:51:26.115699+05:30', '2026-09-20 22:06:23.328232+05:30', false, NULL);
INSERT INTO public.academic_years VALUES ('2026-2027', '2026-07-01', '2027-06-30', 'deg_l_l_b_2025_2028', '2025-2028', 3, NULL, true, false, true, 'ACTIVE', NULL, NULL, 'ay_2026_2027_l_l_b_2025_2028', '2026-09-16 14:52:32.342794+05:30', '2026-09-20 22:06:23.329925+05:30', false, NULL);


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: activity_point_applications; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: allowance_types; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: alumni_members; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: assignment_submissions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: attendance_corrections; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.audit_logs VALUES ('audit_0e2b8a96bdfd', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-15 17:43:46.708039+05:30', '2026-09-15 17:43:46.713754+05:30', '2026-09-15 17:43:46.713761+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a0f8640e3a57', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-15 17:46:55.934922+05:30', '2026-09-15 17:46:55.935383+05:30', '2026-09-15 17:46:55.935387+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f0827e1e4946', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-16 10:48:02.465837+05:30', '2026-09-16 10:48:02.468194+05:30', '2026-09-16 10:48:02.468198+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b96639b206eb', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-16 14:45:56.750143+05:30', '2026-09-16 14:45:56.751852+05:30', '2026-09-16 14:45:56.75186+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c807bc10a66e', 'usr_sobi', 'sobi@gmail.com', 'Sobiya', 'HOD', 'LOGIN', 'Auth', 'usr_sobi', 'Authentication Portal', 'User Sobiya (sobi@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-16 17:04:05.525658+05:30', '2026-09-16 17:04:05.527184+05:30', '2026-09-16 17:04:05.527191+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2d8808748d2c', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:14:01.390762+05:30', '2026-09-17 15:14:01.394901+05:30', '2026-09-17 15:14:01.394908+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a6ab40dd4fb3', 'usr_arya', 'arya@gmail.com', 'Arya', 'FACULTY', 'LOGIN', 'Auth', 'usr_arya', 'Authentication Portal', 'User Arya (arya@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:14:08.401052+05:30', '2026-09-17 15:14:08.401592+05:30', '2026-09-17 15:14:08.401595+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d665b09fd886', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:14:08.767796+05:30', '2026-09-17 15:14:08.903847+05:30', '2026-09-17 15:14:08.903854+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_900bd08aea76', 'usr_madhan', 'madhan@gmail.com', 'Madhan', 'HOD', 'LOGIN', 'Auth', 'usr_madhan', 'Authentication Portal', 'User Madhan (madhan@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:14:31.42351+05:30', '2026-09-17 15:14:31.424127+05:30', '2026-09-17 15:14:31.424131+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cc4e5de5430a', 'usr_arya', 'arya@gmail.com', 'Arya', 'FACULTY', 'LOGIN', 'Auth', 'usr_arya', 'Authentication Portal', 'User Arya (arya@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:15:33.457005+05:30', '2026-09-17 15:15:33.457535+05:30', '2026-09-17 15:15:33.457538+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cc336c32000b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:15:33.713641+05:30', '2026-09-17 15:15:33.729725+05:30', '2026-09-17 15:15:33.729729+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cb1633c3e72d', 'usr_sobi', 'sobi@gmail.com', 'Sobiya', 'HOD', 'LOGIN', 'Auth', 'usr_sobi', 'Authentication Portal', 'User Sobiya (sobi@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:15:46.115443+05:30', '2026-09-17 15:15:46.116664+05:30', '2026-09-17 15:15:46.11667+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0f720442f3a0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/assignments/my', 'User Arya (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 15:15:51.449093+05:30', '2026-09-17 15:15:51.46268+05:30', '2026-09-17 15:15:51.462689+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9df92b7a17c5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:15:53.447949+05:30', '2026-09-17 15:15:53.449803+05:30', '2026-09-17 15:15:53.449806+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a40b71623e62', 'usr_ajay', 'ajay@gmail.com', 'Ajay', 'FACULTY', 'LOGIN', 'Auth', 'usr_ajay', 'Authentication Portal', 'User Ajay (ajay@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:15:53.462073+05:30', '2026-09-17 15:15:53.462455+05:30', '2026-09-17 15:15:53.462458+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4aed14baff0b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:15:53.616321+05:30', '2026-09-17 15:15:53.630728+05:30', '2026-09-17 15:15:53.630732+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c3de6bc089cc', 'usr_palani', 'palani@gmail.com', 'Palani', 'FACULTY', 'LOGIN', 'Auth', 'usr_palani', 'Authentication Portal', 'User Palani (palani@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:16:18.517715+05:30', '2026-09-17 15:16:18.518391+05:30', '2026-09-17 15:16:18.518394+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_75b23fc07f74', 'usr_student1', 'student1@gmail.com', 'student1', 'STUDENT', 'LOGIN', 'Auth', 'usr_student1', 'Authentication Portal', 'User student1 (student1@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:16:18.532124+05:30', '2026-09-17 15:16:18.53318+05:30', '2026-09-17 15:16:18.533188+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9fe6f0fb4afe', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:16:18.877183+05:30', '2026-09-17 15:16:18.890722+05:30', '2026-09-17 15:16:18.890726+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_28d83e4ec529', 'usr_student2', 'student2@gmail.com', 'student2', 'STUDENT', 'LOGIN', 'Auth', 'usr_student2', 'Authentication Portal', 'User student2 (student2@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:16:47.893776+05:30', '2026-09-17 15:16:47.894191+05:30', '2026-09-17 15:16:47.894194+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4a646697d9c9', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:17:05.208227+05:30', '2026-09-17 15:17:05.219042+05:30', '2026-09-17 15:17:05.219046+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f60247974584', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile', 'User Palani (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:17:14.386195+05:30', '2026-09-17 15:17:14.388248+05:30', '2026-09-17 15:17:14.388252+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_87a9c991c450', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/profile', 'User Arya (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:17:28.158786+05:30', '2026-09-17 15:17:28.16164+05:30', '2026-09-17 15:17:28.161648+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b934523b862f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/timetable', 'User Arya (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:17:29.752947+05:30', '2026-09-17 15:17:29.755482+05:30', '2026-09-17 15:17:29.755488+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e9c3e9e8cd0f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/calendar', 'User Arya (FACULTY) opened tab: /faculty/calendar', NULL, NULL, NULL, NULL, '2026-09-17 15:17:31.59774+05:30', '2026-09-17 15:17:31.609981+05:30', '2026-09-17 15:17:31.609987+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7eb4124b0b48', 'usr_student5', 'student5@gmail.com', 'student5', 'STUDENT', 'LOGIN', 'Auth', 'usr_student5', 'Authentication Portal', 'User student5 (student5@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:17:41.241359+05:30', '2026-09-17 15:17:41.24235+05:30', '2026-09-17 15:17:41.242358+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_67790f2e5dc9', 'usr_student8', 'student8@gmail.com', 'student8', 'STUDENT', 'LOGIN', 'Auth', 'usr_student8', 'Authentication Portal', 'User student8 (student8@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:18:00.992867+05:30', '2026-09-17 15:18:00.993515+05:30', '2026-09-17 15:18:00.99352+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_dec94ff35aab', 'usr_student3', 'student3@gmail.com', 'Student3', 'STUDENT', 'LOGIN', 'Auth', 'usr_student3', 'Authentication Portal', 'User Student3 (student3@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:18:04.344055+05:30', '2026-09-17 15:18:04.344433+05:30', '2026-09-17 15:18:04.344435+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_88800fbf3813', 'usr_dinesh', 'dinesh@gmail.com', 'Dinesh', 'PRINCIPAL', 'LOGIN', 'Auth', 'usr_dinesh', 'Authentication Portal', 'User Dinesh (dinesh@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:18:15.624757+05:30', '2026-09-17 15:18:15.625841+05:30', '2026-09-17 15:18:15.625848+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_067c9f9cc3af', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:19:40.381126+05:30', '2026-09-17 15:19:40.388885+05:30', '2026-09-17 15:19:40.388889+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_aaec9d51b25b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/timetable', 'User Arya (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:19:43.3919+05:30', '2026-09-17 15:19:43.402391+05:30', '2026-09-17 15:19:43.402399+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f3a8f535e0b0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:19:45.909446+05:30', '2026-09-17 15:19:45.924879+05:30', '2026-09-17 15:19:45.924884+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_29f3a94024ea', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/studymaterials/upload', 'User Arya (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 15:19:48.858935+05:30', '2026-09-17 15:19:48.872724+05:30', '2026-09-17 15:19:48.872728+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_356ee4b8f725', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/studymaterials/myuploads', 'User Arya (FACULTY) opened tab: /faculty/studymaterials/myuploads', NULL, NULL, NULL, NULL, '2026-09-17 15:20:00.168425+05:30', '2026-09-17 15:20:00.181391+05:30', '2026-09-17 15:20:00.181396+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f63fc6fecf24', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:20:35.39153+05:30', '2026-09-17 15:20:35.398519+05:30', '2026-09-17 15:20:35.398526+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f7e0302148cd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:21:03.159987+05:30', '2026-09-17 15:21:03.168345+05:30', '2026-09-17 15:21:03.168351+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4a44d5ef4ae8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/dashboard', 'User kavya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:21:50.877476+05:30', '2026-09-17 15:21:50.886277+05:30', '2026-09-17 15:21:50.886283+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b328f5e83f8a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/profile', 'User Arya (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:20:37.776876+05:30', '2026-09-17 15:20:37.78178+05:30', '2026-09-17 15:20:37.781785+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d707901f8783', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:20:45.320569+05:30', '2026-09-17 15:20:45.32797+05:30', '2026-09-17 15:20:45.327979+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8173b956a41e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:21:51.550612+05:30', '2026-09-17 15:21:51.555569+05:30', '2026-09-17 15:21:51.555574+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e59743ddfb34', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:23:58.856168+05:30', '2026-09-17 15:23:58.864405+05:30', '2026-09-17 15:23:58.864411+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f30814c639b6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/mentor-students', 'User kavya (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:24:09.312618+05:30', '2026-09-17 15:24:09.322066+05:30', '2026-09-17 15:24:09.322074+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_62f81b7acbc4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:24:14.599121+05:30', '2026-09-17 15:24:14.601869+05:30', '2026-09-17 15:24:14.601878+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cdccd657b3e6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:20:52.778564+05:30', '2026-09-17 15:20:52.782421+05:30', '2026-09-17 15:20:52.782426+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_33dd4fb67e17', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:21:49.67477+05:30', '2026-09-17 15:21:49.68046+05:30', '2026-09-17 15:21:49.680466+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cdfea44f6474', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:21:52.317751+05:30', '2026-09-17 15:21:52.334+05:30', '2026-09-17 15:21:52.334004+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_37097491e056', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/profile', 'User kavya (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:23:39.911987+05:30', '2026-09-17 15:23:39.925027+05:30', '2026-09-17 15:23:39.925031+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8ede6d809dfa', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/assignments/my', 'User Ajay (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 15:21:04.910649+05:30', '2026-09-17 15:21:04.914403+05:30', '2026-09-17 15:21:04.914406+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_47217b1b56d0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:21:53.858778+05:30', '2026-09-17 15:21:53.861428+05:30', '2026-09-17 15:21:53.861435+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_88da60ed40cd', 'usr_kavya', 'kavya@gmail.com', 'kavya', 'FACULTY', 'LOGIN', 'Auth', 'usr_kavya', 'Authentication Portal', 'User kavya (kavya@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:21:42.921584+05:30', '2026-09-17 15:21:42.922053+05:30', '2026-09-17 15:21:42.922056+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_491a5600a96e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/upload', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 15:24:03.314401+05:30', '2026-09-17 15:24:03.322326+05:30', '2026-09-17 15:24:03.322332+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1e1e9952f4dd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:21:46.835566+05:30', '2026-09-17 15:21:46.849376+05:30', '2026-09-17 15:21:46.849382+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d0d70be8ea69', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:24:04.145211+05:30', '2026-09-17 15:24:04.149857+05:30', '2026-09-17 15:24:04.149863+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_abc29b809815', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/upload', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 15:24:09.764079+05:30', '2026-09-17 15:24:09.770586+05:30', '2026-09-17 15:24:09.77059+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_389c72f1622b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:21:50.541556+05:30', '2026-09-17 15:21:50.548184+05:30', '2026-09-17 15:21:50.548193+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_029d056239ca', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:23:25.094402+05:30', '2026-09-17 15:23:25.10169+05:30', '2026-09-17 15:23:25.101698+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9fcdda99552d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/profile', 'User Arya (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:22:34.721575+05:30', '2026-09-17 15:22:34.748659+05:30', '2026-09-17 15:22:34.748664+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9a2c6e03915c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:23:53.161553+05:30', '2026-09-17 15:23:53.167577+05:30', '2026-09-17 15:23:53.167582+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e72fb12e8654', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:23:57.249429+05:30', '2026-09-17 15:23:57.256884+05:30', '2026-09-17 15:23:57.256892+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_decbbfe5b4bc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/profile', 'User kavya (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:24:09.319845+05:30', '2026-09-17 15:24:09.323797+05:30', '2026-09-17 15:24:09.323803+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e07c23a3884d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:24:12.347424+05:30', '2026-09-17 15:24:12.363804+05:30', '2026-09-17 15:24:12.36381+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3566a551ed4f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:24:15.031084+05:30', '2026-09-17 15:24:15.042135+05:30', '2026-09-17 15:24:15.042139+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_42c2fd796528', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:24:24.172391+05:30', '2026-09-17 15:24:24.181205+05:30', '2026-09-17 15:24:24.181214+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f6b519a32ded', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:24:30.37109+05:30', '2026-09-17 15:24:30.383698+05:30', '2026-09-17 15:24:30.383704+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5f07a5fe0476', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:24:33.404861+05:30', '2026-09-17 15:24:33.408016+05:30', '2026-09-17 15:24:33.408024+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c50a3cc2d379', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:24:53.948317+05:30', '2026-09-17 15:24:53.956814+05:30', '2026-09-17 15:24:53.956823+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d183cd371bc1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/calendar', 'User Ajay (FACULTY) opened tab: /faculty/calendar', NULL, NULL, NULL, NULL, '2026-09-17 15:24:55.025738+05:30', '2026-09-17 15:24:55.027688+05:30', '2026-09-17 15:24:55.027691+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b5b0df2569eb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:24:56.826305+05:30', '2026-09-17 15:24:56.833464+05:30', '2026-09-17 15:24:56.833473+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_787678ef5bc1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:25:48.826422+05:30', '2026-09-17 15:25:48.841021+05:30', '2026-09-17 15:25:48.841027+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c9289ea4b142', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:25:49.897423+05:30', '2026-09-17 15:25:49.927656+05:30', '2026-09-17 15:25:49.92766+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a797a2f25776', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:25:51.140379+05:30', '2026-09-17 15:25:51.166574+05:30', '2026-09-17 15:25:51.166578+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2048d6f93b95', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile', 'User Palani (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:25:52.508446+05:30', '2026-09-17 15:25:52.52255+05:30', '2026-09-17 15:25:52.522554+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c7a388bd7e09', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:25:57.771492+05:30', '2026-09-17 15:25:57.781506+05:30', '2026-09-17 15:25:57.781516+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_92c5cc346b8f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:25:58.844948+05:30', '2026-09-17 15:25:58.849127+05:30', '2026-09-17 15:25:58.849133+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8f028250df4f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/lecturerecordings/my-recordings', 'User Ajay (FACULTY) opened tab: /faculty/lecturerecordings/my-recordings', NULL, NULL, NULL, NULL, '2026-09-17 15:26:04.549905+05:30', '2026-09-17 15:26:04.560509+05:30', '2026-09-17 15:26:04.560515+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7185561b4d4a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/circulars', 'User Ajay (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 15:26:09.424542+05:30', '2026-09-17 15:26:09.431465+05:30', '2026-09-17 15:26:09.431473+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4a2783a02160', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:26:26.367519+05:30', '2026-09-17 15:26:26.373508+05:30', '2026-09-17 15:26:26.373514+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e52f2500ccac', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:26:27.245864+05:30', '2026-09-17 15:26:27.249098+05:30', '2026-09-17 15:26:27.249108+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_39ac5cb288f6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:26:29.700848+05:30', '2026-09-17 15:26:29.703529+05:30', '2026-09-17 15:26:29.703533+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a917abf67e87', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile', 'User Palani (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:26:33.696444+05:30', '2026-09-17 15:26:33.706815+05:30', '2026-09-17 15:26:33.70682+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d513ff84e89f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:26:43.516555+05:30', '2026-09-17 15:26:43.532282+05:30', '2026-09-17 15:26:43.532292+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e1372c331724', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:27:00.531967+05:30', '2026-09-17 15:27:00.539026+05:30', '2026-09-17 15:27:00.53903+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0614e4a6a9ee', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:27:15.508712+05:30', '2026-09-17 15:27:15.512903+05:30', '2026-09-17 15:27:15.512926+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7943a9a3ab68', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:27:16.67442+05:30', '2026-09-17 15:27:16.681253+05:30', '2026-09-17 15:27:16.681259+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f9a8314192d1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 15:28:07.437233+05:30', '2026-09-17 15:28:07.444738+05:30', '2026-09-17 15:28:07.444746+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c1089371d687', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:28:08.900287+05:30', '2026-09-17 15:28:08.914645+05:30', '2026-09-17 15:28:08.91465+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c1c267dd76f5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/calendar', 'User Ajay (FACULTY) opened tab: /faculty/calendar', NULL, NULL, NULL, NULL, '2026-09-17 15:28:10.267218+05:30', '2026-09-17 15:28:10.270036+05:30', '2026-09-17 15:28:10.270042+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_284e99176155', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/attendance/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/attendance/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:28:18.591069+05:30', '2026-09-17 15:28:18.602374+05:30', '2026-09-17 15:28:18.602378+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fa4c37d16cfd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 15:28:21.545409+05:30', '2026-09-17 15:28:21.553561+05:30', '2026-09-17 15:28:21.553564+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_96b016606754', 'usr_student4', 'student4@gmail.com', 'student4', 'STUDENT', 'LOGIN', 'Auth', 'usr_student4', 'Authentication Portal', 'User student4 (student4@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:28:21.610243+05:30', '2026-09-17 15:28:21.610643+05:30', '2026-09-17 15:28:21.610646+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d48be3a9954b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/activity-logs', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/activity-logs', NULL, NULL, NULL, NULL, '2026-09-17 15:28:24.682611+05:30', '2026-09-17 15:28:24.685755+05:30', '2026-09-17 15:28:24.685764+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c66bd2a24bec', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 15:30:17.140749+05:30', '2026-09-17 15:30:17.143537+05:30', '2026-09-17 15:30:17.143546+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6b0b995222de', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 15:30:33.973626+05:30', '2026-09-17 15:30:33.988801+05:30', '2026-09-17 15:30:33.988807+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_bcb66929a953', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/history', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 15:28:25.446411+05:30', '2026-09-17 15:28:25.449713+05:30', '2026-09-17 15:28:25.449721+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c2466ff5596d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:28:28.570436+05:30', '2026-09-17 15:28:28.574631+05:30', '2026-09-17 15:28:28.574634+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4473786ab908', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/myuploads', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/myuploads', NULL, NULL, NULL, NULL, '2026-09-17 15:28:33.087387+05:30', '2026-09-17 15:28:33.090421+05:30', '2026-09-17 15:28:33.090429+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d737c53a59e0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:29:22.405488+05:30', '2026-09-17 15:29:22.410584+05:30', '2026-09-17 15:29:22.410588+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2e0f948e6e6b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studentreports', 'User Ajay (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 15:30:15.352887+05:30', '2026-09-17 15:30:15.356519+05:30', '2026-09-17 15:30:15.356527+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f3e306517e89', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/salaryslip', 'User Ajay (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-17 15:30:25.638989+05:30', '2026-09-17 15:30:25.660269+05:30', '2026-09-17 15:30:25.660275+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b93d5b5898ad', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/tracker', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/tracker', NULL, NULL, NULL, NULL, '2026-09-17 15:28:26.68094+05:30', '2026-09-17 15:28:26.683695+05:30', '2026-09-17 15:28:26.683704+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0faaf597476d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/lecturerecordings/my-recordings', 'User Ajay (FACULTY) opened tab: /faculty/lecturerecordings/my-recordings', NULL, NULL, NULL, NULL, '2026-09-17 15:28:49.948219+05:30', '2026-09-17 15:28:49.955044+05:30', '2026-09-17 15:28:49.955053+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b9cb2bc0a0a3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/reports', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/reports', NULL, NULL, NULL, NULL, '2026-09-17 15:28:27.334528+05:30', '2026-09-17 15:28:27.336956+05:30', '2026-09-17 15:28:27.336964+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2cc26d1c700b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/class-management', 'User Ajay (FACULTY) opened tab: /faculty/class-management', NULL, NULL, NULL, NULL, '2026-09-17 15:29:53.479056+05:30', '2026-09-17 15:29:53.485697+05:30', '2026-09-17 15:29:53.485701+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_90a97cf9f8c2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/notifications', 'User Ajay (FACULTY) opened tab: /faculty/notifications', NULL, NULL, NULL, NULL, '2026-09-17 15:30:37.374288+05:30', '2026-09-17 15:30:37.379373+05:30', '2026-09-17 15:30:37.379382+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_59e9a9df80bc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/reports', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/reports', NULL, NULL, NULL, NULL, '2026-09-17 15:28:34.56041+05:30', '2026-09-17 15:28:34.563111+05:30', '2026-09-17 15:28:34.563124+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e35ae1682804', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:28:37.278146+05:30', '2026-09-17 15:28:37.288329+05:30', '2026-09-17 15:28:37.288335+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_39f481a3d378', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/assignments/my', 'User Ajay (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 15:28:41.625834+05:30', '2026-09-17 15:28:41.63537+05:30', '2026-09-17 15:28:41.635375+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f512008152a3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/myuploads', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/myuploads', NULL, NULL, NULL, NULL, '2026-09-17 15:29:02.830962+05:30', '2026-09-17 15:29:02.852605+05:30', '2026-09-17 15:29:02.852611+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_496d2652c008', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/reports', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/reports', NULL, NULL, NULL, NULL, '2026-09-17 15:29:04.238706+05:30', '2026-09-17 15:29:04.253105+05:30', '2026-09-17 15:29:04.253114+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3c9a0ed5e430', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/research', 'User Ajay (FACULTY) opened tab: /faculty/research', NULL, NULL, NULL, NULL, '2026-09-17 15:30:28.605554+05:30', '2026-09-17 15:30:28.62525+05:30', '2026-09-17 15:30:28.625255+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_45286f65a976', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/assignments/create', 'User Ajay (FACULTY) opened tab: /faculty/assignments/create', NULL, NULL, NULL, NULL, '2026-09-17 15:29:08.355533+05:30', '2026-09-17 15:29:08.374388+05:30', '2026-09-17 15:29:08.374394+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9125219cd145', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:30:43.166228+05:30', '2026-09-17 15:30:43.184895+05:30', '2026-09-17 15:30:43.184901+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3097e474acc5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:29:41.923999+05:30', '2026-09-17 15:29:41.936202+05:30', '2026-09-17 15:29:41.936206+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2ea5d209eeb9', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile-approvals', 'User Ajay (FACULTY) opened tab: /faculty/profile-approvals', NULL, NULL, NULL, NULL, '2026-09-17 15:30:03.921657+05:30', '2026-09-17 15:30:03.931435+05:30', '2026-09-17 15:30:03.931439+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5c088e38d367', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/circulars', 'User Ajay (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 15:30:39.190366+05:30', '2026-09-17 15:30:39.193504+05:30', '2026-09-17 15:30:39.193513+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9a4a913305c3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:30:06.501198+05:30', '2026-09-17 15:30:06.504285+05:30', '2026-09-17 15:30:06.504293+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_af190ccd8645', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/internships', 'User Ajay (FACULTY) opened tab: /faculty/internships', NULL, NULL, NULL, NULL, '2026-09-17 15:30:31.069774+05:30', '2026-09-17 15:30:31.090683+05:30', '2026-09-17 15:30:31.090688+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_eb4ecb9683d2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/attendance/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/attendance/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:30:49.468824+05:30', '2026-09-17 15:30:49.480393+05:30', '2026-09-17 15:30:49.480397+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0d9545c152c7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:30:59.778855+05:30', '2026-09-17 15:30:59.789223+05:30', '2026-09-17 15:30:59.789229+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_eca901fbf0a3', 'usr_sobi', 'sobi@gmail.com', 'Sobiya', 'HOD', 'LOGIN', 'Auth', 'usr_sobi', 'Authentication Portal', 'User Sobiya (sobi@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:31:22.562492+05:30', '2026-09-17 15:31:22.562907+05:30', '2026-09-17 15:31:22.56291+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_421bb4bc0549', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:31:41.372613+05:30', '2026-09-17 15:31:41.373104+05:30', '2026-09-17 15:31:41.373107+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7ae35dc5177c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/assignments/my', 'User Ajay (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 15:32:31.616107+05:30', '2026-09-17 15:32:31.619907+05:30', '2026-09-17 15:32:31.619928+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_31c4ede5ea87', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:32:32.446187+05:30', '2026-09-17 15:32:32.449387+05:30', '2026-09-17 15:32:32.449393+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a5cf05f7bdf1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile', 'User Palani (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:32:38.183131+05:30', '2026-09-17 15:32:38.197095+05:30', '2026-09-17 15:32:38.1971+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ffc775b00b57', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile', 'User Palani (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:32:41.285697+05:30', '2026-09-17 15:32:41.291961+05:30', '2026-09-17 15:32:41.291966+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f60f44ed4a8b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/activity-points', 'User Ajay (FACULTY) opened tab: /faculty/activity-points', NULL, NULL, NULL, NULL, '2026-09-17 15:32:51.179319+05:30', '2026-09-17 15:32:51.185163+05:30', '2026-09-17 15:32:51.18517+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b18ce76af86d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 15:32:52.021191+05:30', '2026-09-17 15:32:52.023845+05:30', '2026-09-17 15:32:52.023853+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e1e22f566dbd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studentreports', 'User Ajay (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 15:32:52.978229+05:30', '2026-09-17 15:32:52.981052+05:30', '2026-09-17 15:32:52.981061+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fc0d62a8bc4a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:32:53.846874+05:30', '2026-09-17 15:32:53.849601+05:30', '2026-09-17 15:32:53.84961+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_964aba77dde4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:32:55.489535+05:30', '2026-09-17 15:32:55.492149+05:30', '2026-09-17 15:32:55.492158+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1e4a48a241b6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile-approvals', 'User Palani (FACULTY) opened tab: /faculty/profile-approvals', NULL, NULL, NULL, NULL, '2026-09-17 15:32:59.487031+05:30', '2026-09-17 15:32:59.490536+05:30', '2026-09-17 15:32:59.490545+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6aeec5fd3f9d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/advisor-leaves', 'User Palani (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:33:14.933553+05:30', '2026-09-17 15:33:14.943487+05:30', '2026-09-17 15:33:14.943496+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5f9bf4b4fa0e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studentreports', 'User Ajay (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 15:33:21.171379+05:30', '2026-09-17 15:33:21.190356+05:30', '2026-09-17 15:33:21.190362+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1ecee011c5b8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:33:22.489607+05:30', '2026-09-17 15:33:22.498854+05:30', '2026-09-17 15:33:22.498863+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9d4f7a5d1787', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studentreports', 'User Palani (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 15:34:01.256779+05:30', '2026-09-17 15:34:01.268833+05:30', '2026-09-17 15:34:01.268839+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d16df85b3a66', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:34:26.402869+05:30', '2026-09-17 15:34:26.414242+05:30', '2026-09-17 15:34:26.414246+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ae69fdfd5855', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/upload', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 15:34:55.908548+05:30', '2026-09-17 15:34:55.912133+05:30', '2026-09-17 15:34:55.912137+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_743014bb4fb0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:34:57.22442+05:30', '2026-09-17 15:34:57.243325+05:30', '2026-09-17 15:34:57.243331+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8cc0a9627ed3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/upload', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 15:34:59.441775+05:30', '2026-09-17 15:34:59.462521+05:30', '2026-09-17 15:34:59.462526+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_886970546541', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:35:00.350272+05:30', '2026-09-17 15:35:00.367432+05:30', '2026-09-17 15:35:00.367438+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fb9a8f288e61', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/research', 'User Palani (FACULTY) opened tab: /faculty/research', NULL, NULL, NULL, NULL, '2026-09-17 15:35:12.353136+05:30', '2026-09-17 15:35:12.36065+05:30', '2026-09-17 15:35:12.360656+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ba831f830b59', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/internships', 'User Palani (FACULTY) opened tab: /faculty/internships', NULL, NULL, NULL, NULL, '2026-09-17 15:35:15.205772+05:30', '2026-09-17 15:35:15.216462+05:30', '2026-09-17 15:35:15.216467+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_67d55ff1094e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/leaves', 'User Palani (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:35:17.898023+05:30', '2026-09-17 15:35:17.901755+05:30', '2026-09-17 15:35:17.901761+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0539ad865aaf', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/meetings', 'User Palani (FACULTY) opened tab: /faculty/meetings', NULL, NULL, NULL, NULL, '2026-09-17 15:35:19.480272+05:30', '2026-09-17 15:35:19.483215+05:30', '2026-09-17 15:35:19.48322+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_21f3a575938f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studentreports', 'User Palani (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 15:35:21.127344+05:30', '2026-09-17 15:35:21.135776+05:30', '2026-09-17 15:35:21.135784+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5975954333ec', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/advisor-leaves', 'User Palani (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:35:29.359434+05:30', '2026-09-17 15:35:29.368655+05:30', '2026-09-17 15:35:29.368664+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_df45b14c5d3a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile-approvals', 'User Palani (FACULTY) opened tab: /faculty/profile-approvals', NULL, NULL, NULL, NULL, '2026-09-17 15:36:06.697637+05:30', '2026-09-17 15:36:06.701147+05:30', '2026-09-17 15:36:06.701152+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cae6ca9ac286', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studentreports', 'User Palani (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 15:36:09.236864+05:30', '2026-09-17 15:36:09.245073+05:30', '2026-09-17 15:36:09.245081+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3d92df5fcef8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studentreports', 'User Palani (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 15:36:12.942411+05:30', '2026-09-17 15:36:12.955363+05:30', '2026-09-17 15:36:12.955368+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_edcc701fe9a5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/class-management', 'User Palani (FACULTY) opened tab: /faculty/class-management', NULL, NULL, NULL, NULL, '2026-09-17 15:37:00.67925+05:30', '2026-09-17 15:37:00.692628+05:30', '2026-09-17 15:37:00.692632+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e16621b04c60', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile-approvals', 'User Palani (FACULTY) opened tab: /faculty/profile-approvals', NULL, NULL, NULL, NULL, '2026-09-17 15:37:34.941948+05:30', '2026-09-17 15:37:34.959598+05:30', '2026-09-17 15:37:34.959606+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_55745a3391dc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/advisor-leaves', 'User Palani (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:37:46.58942+05:30', '2026-09-17 15:37:46.599492+05:30', '2026-09-17 15:37:46.599501+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_06f9b1f52de4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/advisor-leaves', 'User Palani (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:38:29.465398+05:30', '2026-09-17 15:38:29.483811+05:30', '2026-09-17 15:38:29.483817+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_33dea5214b93', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/advisor-leaves', 'User Arya (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:43:31.616796+05:30', '2026-09-17 15:43:31.627201+05:30', '2026-09-17 15:43:31.627211+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a412afefefe0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/dashboard', 'User kavya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:37:57.428628+05:30', '2026-09-17 15:37:57.445408+05:30', '2026-09-17 15:37:57.445414+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e92dc4ed5e92', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studymaterials/upload', 'User Palani (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 15:38:35.26309+05:30', '2026-09-17 15:38:35.291544+05:30', '2026-09-17 15:38:35.29155+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a21a983a7755', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/advisor-leaves', 'User kavya (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:47:14.741902+05:30', '2026-09-17 15:47:14.745437+05:30', '2026-09-17 15:47:14.745446+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f060b52c3bf2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/lecturerecordings/my-recordings', 'User Palani (FACULTY) opened tab: /faculty/lecturerecordings/my-recordings', NULL, NULL, NULL, NULL, '2026-09-17 15:38:05.40862+05:30', '2026-09-17 15:38:05.418337+05:30', '2026-09-17 15:38:05.418346+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_68f093a6b17a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/leaves', 'User Ajay (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:42:13.806633+05:30', '2026-09-17 15:42:13.818193+05:30', '2026-09-17 15:42:13.818198+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d406173b6bb1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/leaves', 'User kavya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:44:37.949489+05:30', '2026-09-17 15:44:37.960186+05:30', '2026-09-17 15:44:37.960191+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d537e47a896a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:47:21.310726+05:30', '2026-09-17 15:47:21.320765+05:30', '2026-09-17 15:47:21.320771+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5d63581198ab', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:38:31.439442+05:30', '2026-09-17 15:38:31.459584+05:30', '2026-09-17 15:38:31.459591+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2f9dc8be14fb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:40:12.371362+05:30', '2026-09-17 15:40:12.379843+05:30', '2026-09-17 15:40:12.379849+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_097d63a342f0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/attendance/defaulters', 'User Palani (FACULTY) opened tab: /faculty/attendance/defaulters', NULL, NULL, NULL, NULL, '2026-09-17 15:40:54.227407+05:30', '2026-09-17 15:40:54.230039+05:30', '2026-09-17 15:40:54.230047+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_af0b25c8a3f7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:40:17.020492+05:30', '2026-09-17 15:40:17.023261+05:30', '2026-09-17 15:40:17.02327+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_040499afe5f1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/leaves', 'User Ajay (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:40:25.102774+05:30', '2026-09-17 15:40:25.126626+05:30', '2026-09-17 15:40:25.126631+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2072ab53445b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/attendance/mark', 'User Palani (FACULTY) opened tab: /faculty/attendance/mark', NULL, NULL, NULL, NULL, '2026-09-17 15:40:43.98502+05:30', '2026-09-17 15:40:43.987775+05:30', '2026-09-17 15:40:43.987783+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ef3d2ce84b9b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/leaves', 'User Palani (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:41:02.745075+05:30', '2026-09-17 15:41:02.747746+05:30', '2026-09-17 15:41:02.747751+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_97803c1e5cce', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/leaves', 'User kavya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:41:07.561216+05:30', '2026-09-17 15:41:07.563681+05:30', '2026-09-17 15:41:07.563691+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c12906f7da9d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 15:42:09.596437+05:30', '2026-09-17 15:42:09.606423+05:30', '2026-09-17 15:42:09.606428+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ccee433effde', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/leaves', 'User Arya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:41:07.89819+05:30', '2026-09-17 15:41:07.900805+05:30', '2026-09-17 15:41:07.900809+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_07c839c0ffdc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:43:32.441744+05:30', '2026-09-17 15:43:32.450647+05:30', '2026-09-17 15:43:32.450657+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_dcb84e61f1cd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/leaves', 'User Palani (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:43:46.837036+05:30', '2026-09-17 15:43:46.936494+05:30', '2026-09-17 15:43:46.936499+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d399798c0d4c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/advisor-leaves', 'User Arya (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:44:50.943177+05:30', '2026-09-17 15:44:50.95433+05:30', '2026-09-17 15:44:50.954336+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3cd84df3ecb5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/leaves', 'User Palani (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:45:22.879538+05:30', '2026-09-17 15:45:22.899794+05:30', '2026-09-17 15:45:22.899799+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a29b250ddfc2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:47:26.474996+05:30', '2026-09-17 15:47:26.489952+05:30', '2026-09-17 15:47:26.489957+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2d8dc64de7c2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/advisor-leaves', 'User Palani (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:45:32.112346+05:30', '2026-09-17 15:45:32.122366+05:30', '2026-09-17 15:45:32.122375+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2df24fec3ca5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/circulars', 'User Ajay (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 15:47:10.459431+05:30', '2026-09-17 15:47:10.476515+05:30', '2026-09-17 15:47:10.47652+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3283d7995183', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 15:47:12.476841+05:30', '2026-09-17 15:47:12.500132+05:30', '2026-09-17 15:47:12.500138+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3b1a6da1a7c0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/circulars', 'User Ajay (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 15:47:13.335901+05:30', '2026-09-17 15:47:13.33874+05:30', '2026-09-17 15:47:13.338748+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7efd9018cf30', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/attendance/dashboard', 'User Palani (FACULTY) opened tab: /faculty/attendance/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:48:06.619109+05:30', '2026-09-17 15:48:06.62718+05:30', '2026-09-17 15:48:06.627186+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_65210926738f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/attendance/view', 'User Palani (FACULTY) opened tab: /faculty/attendance/view', NULL, NULL, NULL, NULL, '2026-09-17 15:48:10.043233+05:30', '2026-09-17 15:48:10.051268+05:30', '2026-09-17 15:48:10.051277+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1f9564f96c7e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/attendance/defaulters', 'User Palani (FACULTY) opened tab: /faculty/attendance/defaulters', NULL, NULL, NULL, NULL, '2026-09-17 15:48:11.788251+05:30', '2026-09-17 15:48:11.791083+05:30', '2026-09-17 15:48:11.791091+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ac422db234f0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/leaves', 'User Palani (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:48:20.706639+05:30', '2026-09-17 15:48:20.709842+05:30', '2026-09-17 15:48:20.709853+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_59396b56e3d6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/leaves', 'User Palani (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:48:32.120956+05:30', '2026-09-17 15:48:32.129966+05:30', '2026-09-17 15:48:32.12997+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_667f0bb8c3ac', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:49:17.469158+05:30', '2026-09-17 15:49:17.476534+05:30', '2026-09-17 15:49:17.47654+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7bc30968cd21', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/class-management', 'User Ajay (FACULTY) opened tab: /faculty/class-management', NULL, NULL, NULL, NULL, '2026-09-17 15:49:18.573356+05:30', '2026-09-17 15:49:18.59264+05:30', '2026-09-17 15:49:18.592644+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_015c116ab0e5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:49:20.060978+05:30', '2026-09-17 15:49:20.082461+05:30', '2026-09-17 15:49:20.082466+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5d2d0d435142', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:49:23.325954+05:30', '2026-09-17 15:49:23.331038+05:30', '2026-09-17 15:49:23.331044+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_001e7f407aee', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:49:36.577379+05:30', '2026-09-17 15:49:36.593417+05:30', '2026-09-17 15:49:36.593425+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4f02b9da20bd', 'usr_dinesh', 'dinesh@gmail.com', 'Dinesh', 'PRINCIPAL', 'LOGIN', 'Auth', 'usr_dinesh', 'Authentication Portal', 'User Dinesh (dinesh@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:50:42.869218+05:30', '2026-09-17 15:50:42.870584+05:30', '2026-09-17 15:50:42.870592+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4f43a088ef7e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:51:56.505891+05:30', '2026-09-17 15:51:56.513164+05:30', '2026-09-17 15:51:56.513168+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_02b8d3b560de', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/profile-approvals', 'User kavya (FACULTY) opened tab: /faculty/profile-approvals', NULL, NULL, NULL, NULL, '2026-09-17 15:52:23.241825+05:30', '2026-09-17 15:52:23.250752+05:30', '2026-09-17 15:52:23.250759+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_61231c08e20a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/assignments/my', 'User Ajay (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 15:52:26.773154+05:30', '2026-09-17 15:52:26.7909+05:30', '2026-09-17 15:52:26.790905+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_eb1e3eeab151', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 15:52:29.350216+05:30', '2026-09-17 15:52:29.354417+05:30', '2026-09-17 15:52:29.354427+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fb4100714ffd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile-approvals', 'User Ajay (FACULTY) opened tab: /faculty/profile-approvals', NULL, NULL, NULL, NULL, '2026-09-17 15:52:32.805807+05:30', '2026-09-17 15:52:32.961771+05:30', '2026-09-17 15:52:32.961777+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_97f13279dbae', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/studentreports', 'User kavya (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 15:52:36.63065+05:30', '2026-09-17 15:52:36.633723+05:30', '2026-09-17 15:52:36.633727+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_445dbdbc4506', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/advisor-leaves', 'User kavya (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:52:36.628816+05:30', '2026-09-17 15:52:36.633247+05:30', '2026-09-17 15:52:36.633253+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_178376b51152', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:52:39.562441+05:30', '2026-09-17 15:52:39.584396+05:30', '2026-09-17 15:52:39.584402+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8b4aa4580587', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 15:52:40.616323+05:30', '2026-09-17 15:52:40.619956+05:30', '2026-09-17 15:52:40.619965+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7b636007f933', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/lecturerecordings/my-recordings', 'User Ajay (FACULTY) opened tab: /faculty/lecturerecordings/my-recordings', NULL, NULL, NULL, NULL, '2026-09-17 15:52:41.482589+05:30', '2026-09-17 15:52:41.48565+05:30', '2026-09-17 15:52:41.48566+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b5e728b99b6d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:53:20.883344+05:30', '2026-09-17 15:53:20.893849+05:30', '2026-09-17 15:53:20.893854+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_38298b2ec52b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 15:53:25.9504+05:30', '2026-09-17 15:53:25.952947+05:30', '2026-09-17 15:53:25.952956+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_64a7ce9143d0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:53:49.39354+05:30', '2026-09-17 15:53:49.406106+05:30', '2026-09-17 15:53:49.406113+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_dada58c93ecd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/calendar', 'User Ajay (FACULTY) opened tab: /faculty/calendar', NULL, NULL, NULL, NULL, '2026-09-17 15:53:50.664849+05:30', '2026-09-17 15:53:50.677646+05:30', '2026-09-17 15:53:50.677657+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_518d1fd72327', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:53:54.44781+05:30', '2026-09-17 15:53:54.457383+05:30', '2026-09-17 15:53:54.457391+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e92016669b4d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/leaves', 'User Ajay (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:54:16.965274+05:30', '2026-09-17 15:54:16.99889+05:30', '2026-09-17 15:54:16.998894+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cd379ec5f3ba', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/leaves', 'User Ajay (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:55:05.165109+05:30', '2026-09-17 15:55:05.174113+05:30', '2026-09-17 15:55:05.174117+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b2ce8aa9961a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:55:49.389135+05:30', '2026-09-17 15:55:49.396681+05:30', '2026-09-17 15:55:49.396686+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5da9417055a9', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:55:57.34789+05:30', '2026-09-17 15:55:57.367484+05:30', '2026-09-17 15:55:57.36749+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b15157ccd017', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/studymaterials/upload', 'User Arya (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 15:56:03.995933+05:30', '2026-09-17 15:56:04.005071+05:30', '2026-09-17 15:56:04.005075+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_87ea4611d274', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/studymaterials/dashboard', 'User Arya (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:56:06.218128+05:30', '2026-09-17 15:56:06.225722+05:30', '2026-09-17 15:56:06.225729+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7cb6260471dd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/leaves', 'User kavya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:56:58.520399+05:30', '2026-09-17 15:56:58.523521+05:30', '2026-09-17 15:56:58.523529+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a9fafa6bba4c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/dashboard', 'User kavya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:57:40.05269+05:30', '2026-09-17 15:57:40.05447+05:30', '2026-09-17 15:57:40.054475+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8633c71c352a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:59:25.502593+05:30', '2026-09-17 15:59:25.519187+05:30', '2026-09-17 15:59:25.519193+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_210ee03ddb1e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:01:14.212384+05:30', '2026-09-17 16:01:14.219018+05:30', '2026-09-17 16:01:14.219024+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e50131b8c78a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:01:17.417823+05:30', '2026-09-17 16:01:17.433626+05:30', '2026-09-17 16:01:17.433632+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_191eb9f743bf', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:04:26.891667+05:30', '2026-09-17 16:04:26.901425+05:30', '2026-09-17 16:04:26.901432+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8b5b0f3748bb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:06:01.452893+05:30', '2026-09-17 16:06:01.467079+05:30', '2026-09-17 16:06:01.467082+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fe9934dcb6c3', 'usr_kavya', 'kavya@gmail.com', 'kavya', 'FACULTY', 'LOGIN', 'Auth', 'usr_kavya', 'Authentication Portal', 'User kavya (kavya@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 15:56:41.578887+05:30', '2026-09-17 15:56:41.58038+05:30', '2026-09-17 15:56:41.580388+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_24d2d563d4d8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:00:41.120137+05:30', '2026-09-17 16:00:41.127356+05:30', '2026-09-17 16:00:41.127362+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3d491cfc4a60', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studentreports', 'User Palani (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 16:05:08.703279+05:30', '2026-09-17 16:05:08.705976+05:30', '2026-09-17 16:05:08.705984+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d08d3043839b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/dashboard', 'User kavya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:56:53.663167+05:30', '2026-09-17 15:56:53.688269+05:30', '2026-09-17 15:56:53.688273+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_be17540a6f3d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/leaves', 'User kavya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:57:40.063004+05:30', '2026-09-17 15:57:40.071055+05:30', '2026-09-17 15:57:40.071058+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1d1cda549332', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/leaves', 'User kavya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 15:59:16.185564+05:30', '2026-09-17 15:59:16.20909+05:30', '2026-09-17 15:59:16.209095+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_66fee95ce7e6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/upload', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 16:01:12.428457+05:30', '2026-09-17 16:01:12.451486+05:30', '2026-09-17 16:01:12.451492+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_945f28033e1f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile', 'User Palani (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 16:03:27.432607+05:30', '2026-09-17 16:03:27.453806+05:30', '2026-09-17 16:03:27.453811+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_11dcc0b9056a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/profile', 'User Palani (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 16:03:39.749594+05:30', '2026-09-17 16:03:39.763322+05:30', '2026-09-17 16:03:39.763329+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4cde84142c02', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/study-materials', 'User Palani (FACULTY) opened tab: /faculty/study-materials', NULL, NULL, NULL, NULL, '2026-09-17 16:06:13.840854+05:30', '2026-09-17 16:06:13.862174+05:30', '2026-09-17 16:06:13.862179+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7530292aeb1a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/salaryslip', 'User kavya (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-17 15:59:14.598241+05:30', '2026-09-17 15:59:14.607142+05:30', '2026-09-17 15:59:14.607151+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_911ece916e5e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:01:22.813029+05:30', '2026-09-17 16:01:22.818727+05:30', '2026-09-17 16:01:22.818735+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_44f5592ee7a1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 15:59:15.624464+05:30', '2026-09-17 15:59:15.634688+05:30', '2026-09-17 15:59:15.634692+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2ef426f859e2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:59:19.067823+05:30', '2026-09-17 15:59:19.069107+05:30', '2026-09-17 15:59:19.069111+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a02a2a49ea72', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/studymaterials/upload', 'User Arya (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 16:01:04.64053+05:30', '2026-09-17 16:01:04.647727+05:30', '2026-09-17 16:01:04.647731+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_195f5f5ae832', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studymaterials/upload', 'User Palani (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 15:59:23.765375+05:30', '2026-09-17 15:59:23.767859+05:30', '2026-09-17 15:59:23.767867+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f642236ba55e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 15:59:26.094798+05:30', '2026-09-17 15:59:26.105356+05:30', '2026-09-17 15:59:26.105362+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f2c7eb8964fe', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:01:16.095498+05:30', '2026-09-17 16:01:16.107627+05:30', '2026-09-17 16:01:16.107633+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4178c535eb3d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:03:38.524762+05:30', '2026-09-17 16:03:38.541236+05:30', '2026-09-17 16:03:38.541242+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0166ca4ee0b8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/studymaterials/upload', 'User Arya (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 16:00:36.25359+05:30', '2026-09-17 16:00:36.258431+05:30', '2026-09-17 16:00:36.258435+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_afbed17170ca', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:03:59.315463+05:30', '2026-09-17 16:03:59.318395+05:30', '2026-09-17 16:03:59.318405+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c31598e5f288', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studymaterials/myuploads', 'User Palani (FACULTY) opened tab: /faculty/studymaterials/myuploads', NULL, NULL, NULL, NULL, '2026-09-17 16:04:22.79347+05:30', '2026-09-17 16:04:22.796463+05:30', '2026-09-17 16:04:22.796473+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2589f5bb8c13', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/upload', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 16:01:15.32351+05:30', '2026-09-17 16:01:15.332981+05:30', '2026-09-17 16:01:15.332986+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c3f64829d304', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/classdiary/create', 'User Arya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:02:06.745054+05:30', '2026-09-17 16:02:06.749+05:30', '2026-09-17 16:02:06.749003+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_621c86bf895d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:05:26.086002+05:30', '2026-09-17 16:05:26.097466+05:30', '2026-09-17 16:05:26.097472+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_bd7f0e4e8a49', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/attendance/dashboard', 'User Palani (FACULTY) opened tab: /faculty/attendance/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:05:54.327179+05:30', '2026-09-17 16:05:54.339831+05:30', '2026-09-17 16:05:54.339835+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d8e9a90ff4e7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/upload', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/upload', NULL, NULL, NULL, NULL, '2026-09-17 16:01:17.161687+05:30', '2026-09-17 16:01:17.164666+05:30', '2026-09-17 16:01:17.164671+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_816dae68c749', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studymaterials/myuploads', 'User Palani (FACULTY) opened tab: /faculty/studymaterials/myuploads', NULL, NULL, NULL, NULL, '2026-09-17 16:04:16.98697+05:30', '2026-09-17 16:04:17.001548+05:30', '2026-09-17 16:04:17.001552+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9b71b4f14abb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/leave-apply', 'User Palani (FACULTY) opened tab: /faculty/leave-apply', NULL, NULL, NULL, NULL, '2026-09-17 16:06:01.435696+05:30', '2026-09-17 16:06:01.451549+05:30', '2026-09-17 16:06:01.451554+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_964fa25dd4dd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/classdiary/today', 'User Arya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:02:00.348093+05:30', '2026-09-17 16:02:00.355131+05:30', '2026-09-17 16:02:00.355134+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8fd4dd044387', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:02:08.58645+05:30', '2026-09-17 16:02:08.590078+05:30', '2026-09-17 16:02:08.590082+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c342440bccf9', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/create', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:02:11.738665+05:30', '2026-09-17 16:02:11.746864+05:30', '2026-09-17 16:02:11.746872+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fae0ac25b216', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:03:12.17553+05:30', '2026-09-17 16:03:12.189117+05:30', '2026-09-17 16:03:12.189121+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e1743c5e8dd7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/dashboard', 'User Palani (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:06:13.862787+05:30', '2026-09-17 16:06:13.874544+05:30', '2026-09-17 16:06:13.874547+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_abb2101829c2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/studymaterials/audit', 'User Palani (FACULTY) opened tab: /faculty/studymaterials/audit', NULL, NULL, NULL, NULL, '2026-09-17 16:04:20.184753+05:30', '2026-09-17 16:04:20.188179+05:30', '2026-09-17 16:04:20.188189+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e422b7d4ce8c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/calendar', 'User Palani (FACULTY) opened tab: /faculty/calendar', NULL, NULL, NULL, NULL, '2026-09-17 16:04:43.475243+05:30', '2026-09-17 16:04:43.487723+05:30', '2026-09-17 16:04:43.487732+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2e0c83c16fc0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/lesson-plan', 'User Palani (FACULTY) opened tab: /faculty/classdiary/lesson-plan', NULL, NULL, NULL, NULL, '2026-09-17 16:06:07.596014+05:30', '2026-09-17 16:06:07.60959+05:30', '2026-09-17 16:06:07.609593+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_395b24d00044', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:06:31.44956+05:30', '2026-09-17 16:06:31.464127+05:30', '2026-09-17 16:06:31.464132+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cc587f0927d0', 'usr_madhan', 'madhan@gmail.com', 'Madhan', 'HOD', 'LOGIN', 'Auth', 'usr_madhan', 'Authentication Portal', 'User Madhan (madhan@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 16:06:41.010851+05:30', '2026-09-17 16:06:41.011976+05:30', '2026-09-17 16:06:41.011983+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0e0ad0481916', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/classdiary/today', 'User Arya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:06:43.720943+05:30', '2026-09-17 16:06:43.727199+05:30', '2026-09-17 16:06:43.727205+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_95da0fb74cf5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/timetable', 'User Arya (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:06:46.81666+05:30', '2026-09-17 16:06:46.820478+05:30', '2026-09-17 16:06:46.820486+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e38aa68cbcfb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/timetable', 'User Ajay (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:06:47.273576+05:30', '2026-09-17 16:06:47.276499+05:30', '2026-09-17 16:06:47.276508+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f26b397930e8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/advisor-leaves', 'User kavya (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 16:07:20.80339+05:30', '2026-09-17 16:07:20.812612+05:30', '2026-09-17 16:07:20.812621+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b34c059ca2ee', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/leaves', 'User kavya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 16:07:27.701074+05:30', '2026-09-17 16:07:27.719238+05:30', '2026-09-17 16:07:27.719243+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_da6628e11dbd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:07:31.359837+05:30', '2026-09-17 16:07:31.368424+05:30', '2026-09-17 16:07:31.368427+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8e5f2f0f31c6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/studentreports', 'User kavya (FACULTY) opened tab: /faculty/studentreports', NULL, NULL, NULL, NULL, '2026-09-17 16:07:31.425603+05:30', '2026-09-17 16:07:31.427646+05:30', '2026-09-17 16:07:31.42765+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_69c3eec3f23b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/create', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:07:33.752329+05:30', '2026-09-17 16:07:33.760945+05:30', '2026-09-17 16:07:33.760954+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7d095c059db7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/classdiary/create', 'User Arya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:07:35.175813+05:30', '2026-09-17 16:07:35.178832+05:30', '2026-09-17 16:07:35.178841+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_30dec333a976', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:07:36.180908+05:30', '2026-09-17 16:07:36.183443+05:30', '2026-09-17 16:07:36.183451+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e9b68025dd68', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/profile-approvals', 'User kavya (FACULTY) opened tab: /faculty/profile-approvals', NULL, NULL, NULL, NULL, '2026-09-17 16:07:45.95746+05:30', '2026-09-17 16:07:45.960801+05:30', '2026-09-17 16:07:45.96081+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_dd4eae32f2a4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:07:52.988845+05:30', '2026-09-17 16:07:52.991601+05:30', '2026-09-17 16:07:52.99161+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1d111da28e48', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/leaves', 'User kavya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 16:08:06.975508+05:30', '2026-09-17 16:08:06.978519+05:30', '2026-09-17 16:08:06.978528+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7949eb8d3c5e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/internships', 'User kavya (FACULTY) opened tab: /faculty/internships', NULL, NULL, NULL, NULL, '2026-09-17 16:08:08.719038+05:30', '2026-09-17 16:08:08.730269+05:30', '2026-09-17 16:08:08.730275+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d48fc745588b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/classdiary/today', 'User Arya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:08:12.959931+05:30', '2026-09-17 16:08:12.962695+05:30', '2026-09-17 16:08:12.962703+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6a8c24112503', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/classdiary/today', 'User Arya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:08:15.696483+05:30', '2026-09-17 16:08:15.700205+05:30', '2026-09-17 16:08:15.700213+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c139c3397da3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/leaves', 'User kavya (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 16:08:18.397032+05:30', '2026-09-17 16:08:18.41971+05:30', '2026-09-17 16:08:18.419715+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8cf1df7db713', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/classdiary/history', 'User Arya (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:08:24.831719+05:30', '2026-09-17 16:08:24.834528+05:30', '2026-09-17 16:08:24.834536+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_44a866dc3ea8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/history', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:08:35.712811+05:30', '2026-09-17 16:08:35.715853+05:30', '2026-09-17 16:08:35.715858+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_53c7906c704d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/history', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:09:07.003978+05:30', '2026-09-17 16:09:07.024885+05:30', '2026-09-17 16:09:07.02489+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d27b9214c93f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:09:40.132238+05:30', '2026-09-17 16:09:40.13504+05:30', '2026-09-17 16:09:40.135048+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ef51b7914812', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/create', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:09:42.791298+05:30', '2026-09-17 16:09:42.794218+05:30', '2026-09-17 16:09:42.794226+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_05b4e8de4448', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:12:41.649482+05:30', '2026-09-17 16:12:41.653906+05:30', '2026-09-17 16:12:41.653923+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_938456439698', 'usr_madhan', 'madhan@gmail.com', 'Madhan', 'HOD', 'LOGIN', 'Auth', 'usr_madhan', 'Authentication Portal', 'User Madhan (madhan@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 16:12:44.32435+05:30', '2026-09-17 16:12:44.325604+05:30', '2026-09-17 16:12:44.325611+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_94266cdf014b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/tracker', 'User Palani (FACULTY) opened tab: /faculty/classdiary/tracker', NULL, NULL, NULL, NULL, '2026-09-17 16:12:58.689289+05:30', '2026-09-17 16:12:58.692162+05:30', '2026-09-17 16:12:58.69217+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6a8ba3d31f6e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:13:10.146524+05:30', '2026-09-17 16:13:10.149251+05:30', '2026-09-17 16:13:10.149259+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8f4d79f23a1d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/create', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:13:12.113707+05:30', '2026-09-17 16:13:12.129727+05:30', '2026-09-17 16:13:12.129738+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1c7ea54db38d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/activity-logs', 'User kavya (FACULTY) opened tab: /faculty/classdiary/activity-logs', NULL, NULL, NULL, NULL, '2026-09-17 16:13:12.343638+05:30', '2026-09-17 16:13:12.347994+05:30', '2026-09-17 16:13:12.348+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7b289fd4c1cc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/history', 'User kavya (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:13:12.345015+05:30', '2026-09-17 16:13:12.348683+05:30', '2026-09-17 16:13:12.348689+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e166535c1b77', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 16:13:37.519545+05:30', '2026-09-17 16:13:37.526733+05:30', '2026-09-17 16:13:37.526737+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_957634bb1b42', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:13:12.440223+05:30', '2026-09-17 16:13:12.442486+05:30', '2026-09-17 16:13:12.442494+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e646d1ef3d21', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/tracker', 'User kavya (FACULTY) opened tab: /faculty/classdiary/tracker', NULL, NULL, NULL, NULL, '2026-09-17 16:13:12.43387+05:30', '2026-09-17 16:13:12.437985+05:30', '2026-09-17 16:13:12.437993+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d4334ff027cd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/reports', 'User kavya (FACULTY) opened tab: /faculty/classdiary/reports', NULL, NULL, NULL, NULL, '2026-09-17 16:13:12.435698+05:30', '2026-09-17 16:13:12.438876+05:30', '2026-09-17 16:13:12.438883+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e86173c95595', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:13:43.498047+05:30', '2026-09-17 16:13:43.500563+05:30', '2026-09-17 16:13:43.500573+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ced9f41e1e8c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:14:07.316652+05:30', '2026-09-17 16:14:07.319934+05:30', '2026-09-17 16:14:07.319945+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_809aa327f502', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/history', 'User Palani (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:16:26.165972+05:30', '2026-09-17 16:16:26.171673+05:30', '2026-09-17 16:16:26.171676+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_066265f33985', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/history', 'User Palani (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:16:49.747949+05:30', '2026-09-17 16:16:49.758756+05:30', '2026-09-17 16:16:49.758762+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b56481bec1c4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:13:12.856011+05:30', '2026-09-17 16:13:12.858624+05:30', '2026-09-17 16:13:12.858632+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_aa3e0c41e2ca', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/create', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:13:14.49333+05:30', '2026-09-17 16:13:14.50173+05:30', '2026-09-17 16:13:14.501736+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_646ab0d47650', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/create', 'User kavya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:13:47.624254+05:30', '2026-09-17 16:13:47.638142+05:30', '2026-09-17 16:13:47.638148+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c884e2053986', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:13:22.201324+05:30', '2026-09-17 16:13:22.204133+05:30', '2026-09-17 16:13:22.204142+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f4376937bb47', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/create', 'User kavya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:13:38.332323+05:30', '2026-09-17 16:13:38.340707+05:30', '2026-09-17 16:13:38.340715+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1e7f26255f46', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/create', 'User kavya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:14:06.158778+05:30', '2026-09-17 16:14:06.161442+05:30', '2026-09-17 16:14:06.161451+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_38b3a69fafab', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:13:47.977839+05:30', '2026-09-17 16:13:48.002596+05:30', '2026-09-17 16:13:48.0026+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b2d3b47d3c2b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:14:37.504748+05:30', '2026-09-17 16:14:37.516485+05:30', '2026-09-17 16:14:37.516489+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a6804bb2e7d9', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:15:19.326131+05:30', '2026-09-17 16:15:19.328988+05:30', '2026-09-17 16:15:19.328997+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b723b2997d64', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:15:25.86708+05:30', '2026-09-17 16:15:25.870097+05:30', '2026-09-17 16:15:25.870105+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3562225b3768', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/create', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:15:57.837324+05:30', '2026-09-17 16:15:57.845792+05:30', '2026-09-17 16:15:57.845799+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ff8014472c7e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:17:10.326302+05:30', '2026-09-17 16:17:10.347872+05:30', '2026-09-17 16:17:10.347876+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_16d7dfd1b6f3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/assignments/my', 'User Ajay (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 16:13:48.76004+05:30', '2026-09-17 16:13:48.786311+05:30', '2026-09-17 16:13:48.786319+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d03815cb0a85', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:14:01.834119+05:30', '2026-09-17 16:14:01.837511+05:30', '2026-09-17 16:14:01.83752+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6f4095eec7c1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/studymaterials/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:13:49.590402+05:30', '2026-09-17 16:13:49.592977+05:30', '2026-09-17 16:13:49.592986+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_909eb30e4c77', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:14:12.23359+05:30', '2026-09-17 16:14:12.257755+05:30', '2026-09-17 16:14:12.25776+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6f37d83e754a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/create', 'User kavya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:14:53.994701+05:30', '2026-09-17 16:14:54.002966+05:30', '2026-09-17 16:14:54.002975+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7af10f9e06cd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:15:22.166073+05:30', '2026-09-17 16:15:22.172008+05:30', '2026-09-17 16:15:22.172012+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_16a78fdaa9ca', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/attendance/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/attendance/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:14:36.666744+05:30', '2026-09-17 16:14:36.684698+05:30', '2026-09-17 16:14:36.684704+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6a50eca218a8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:14:50.997694+05:30', '2026-09-17 16:14:51.000647+05:30', '2026-09-17 16:14:51.000655+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_463b695f1b9d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:14:54.561469+05:30', '2026-09-17 16:14:54.565605+05:30', '2026-09-17 16:14:54.565612+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_67e362af4081', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:15:05.569203+05:30', '2026-09-17 16:15:05.571682+05:30', '2026-09-17 16:15:05.57169+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f16b23c782a1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:15:12.455188+05:30', '2026-09-17 16:15:12.459348+05:30', '2026-09-17 16:15:12.459354+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a5db61692431', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:15:20.686341+05:30', '2026-09-17 16:15:20.693151+05:30', '2026-09-17 16:15:20.693157+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_79867a5faddb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:15:25.2223+05:30', '2026-09-17 16:15:25.224762+05:30', '2026-09-17 16:15:25.22477+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ae37d50a71f0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:15:26.854429+05:30', '2026-09-17 16:15:26.870981+05:30', '2026-09-17 16:15:26.870987+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_db22f1708081', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/mark-management', 'User Arya (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:15:37.785427+05:30', '2026-09-17 16:15:37.794221+05:30', '2026-09-17 16:15:37.79423+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_97c4abca4769', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:15:58.841153+05:30', '2026-09-17 16:15:58.846694+05:30', '2026-09-17 16:15:58.846703+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4c3e7b8001eb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:16:13.811747+05:30', '2026-09-17 16:16:13.814852+05:30', '2026-09-17 16:16:13.814858+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e027a5600cc7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:16:59.517295+05:30', '2026-09-17 16:16:59.520821+05:30', '2026-09-17 16:16:59.52083+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b5c19d84d16f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:17:12.342278+05:30', '2026-09-17 16:17:12.354135+05:30', '2026-09-17 16:17:12.354142+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b1fda4fad398', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:15:16.100759+05:30', '2026-09-17 16:15:16.10774+05:30', '2026-09-17 16:15:16.107749+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_dacf5c0be2a2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/create', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:15:24.421061+05:30', '2026-09-17 16:15:24.42954+05:30', '2026-09-17 16:15:24.429549+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_337018c11ea5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:15:36.203008+05:30', '2026-09-17 16:15:36.206395+05:30', '2026-09-17 16:15:36.206407+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_645ad8ca8d40', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:15:55.064361+05:30', '2026-09-17 16:15:55.071224+05:30', '2026-09-17 16:15:55.071228+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cde5cbe9c666', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:16:01.005039+05:30', '2026-09-17 16:16:01.014197+05:30', '2026-09-17 16:16:01.014204+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d5cf0e623510', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/classdiary/today', 'User Ajay (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:16:04.105737+05:30', '2026-09-17 16:16:04.108332+05:30', '2026-09-17 16:16:04.108338+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_20b097896745', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:16:07.078442+05:30', '2026-09-17 16:16:07.081959+05:30', '2026-09-17 16:16:07.081965+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5a1e95954fee', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:16:31.603419+05:30', '2026-09-17 16:16:31.607126+05:30', '2026-09-17 16:16:31.607136+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_be5ac523595b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:16:33.777115+05:30', '2026-09-17 16:16:33.77919+05:30', '2026-09-17 16:16:33.779196+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d58248b84dee', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/mark-management', 'User Arya (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:16:44.404813+05:30', '2026-09-17 16:16:44.419984+05:30', '2026-09-17 16:16:44.419988+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3e5b10f0942a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/create', 'User kavya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:17:11.846407+05:30', '2026-09-17 16:17:11.861742+05:30', '2026-09-17 16:17:11.861752+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a4a0db7d711b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:17:23.079447+05:30', '2026-09-17 16:17:23.094349+05:30', '2026-09-17 16:17:23.094353+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a5b02c2e5c6c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:17:30.598738+05:30', '2026-09-17 16:17:30.608398+05:30', '2026-09-17 16:17:30.608408+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_aed359b3dc24', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:18:01.678882+05:30', '2026-09-17 16:18:01.686429+05:30', '2026-09-17 16:18:01.686434+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4838c0084d25', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/mark-management', 'User Arya (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:18:26.721353+05:30', '2026-09-17 16:18:26.727576+05:30', '2026-09-17 16:18:26.727582+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_28c31a76e85d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:20:00.559198+05:30', '2026-09-17 16:20:00.594048+05:30', '2026-09-17 16:20:00.594052+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ff73b8b55b36', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:20:04.106745+05:30', '2026-09-17 16:20:04.135491+05:30', '2026-09-17 16:20:04.135495+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3812b55cb3a4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:20:06.907051+05:30', '2026-09-17 16:20:06.915732+05:30', '2026-09-17 16:20:06.915738+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d9ea58d9fc53', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/history', 'User Palani (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:20:45.342742+05:30', '2026-09-17 16:20:45.355067+05:30', '2026-09-17 16:20:45.35507+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_eedc8760cbc4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:20:49.31588+05:30', '2026-09-17 16:20:49.325091+05:30', '2026-09-17 16:20:49.3251+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6f19d976e71a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:20:57.65026+05:30', '2026-09-17 16:20:57.658543+05:30', '2026-09-17 16:20:57.658546+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f09249b5c228', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:21:02.158756+05:30', '2026-09-17 16:21:02.169562+05:30', '2026-09-17 16:21:02.169567+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_da71d31166d3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:21:05.650165+05:30', '2026-09-17 16:21:05.654458+05:30', '2026-09-17 16:21:05.654466+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5eaf6fcbed4f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:21:16.380063+05:30', '2026-09-17 16:21:16.382816+05:30', '2026-09-17 16:21:16.382825+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_89bc094112c6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:22:05.08589+05:30', '2026-09-17 16:22:05.095555+05:30', '2026-09-17 16:22:05.09556+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_35b72a794f16', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/mark-management', 'User Arya (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:22:38.140177+05:30', '2026-09-17 16:22:38.161132+05:30', '2026-09-17 16:22:38.161138+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ac3d9b59cda0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/history', 'User Palani (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:22:53.086595+05:30', '2026-09-17 16:22:53.08957+05:30', '2026-09-17 16:22:53.089578+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b9245010a0b9', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:23:20.809816+05:30', '2026-09-17 16:23:20.814178+05:30', '2026-09-17 16:23:20.814187+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8bf58d871153', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:23:23.207411+05:30', '2026-09-17 16:23:23.222491+05:30', '2026-09-17 16:23:23.222498+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_292f4d5d791a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:23:28.524475+05:30', '2026-09-17 16:23:28.527477+05:30', '2026-09-17 16:23:28.527486+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7b0b804d931f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:23:29.953337+05:30', '2026-09-17 16:23:29.962525+05:30', '2026-09-17 16:23:29.962532+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6ffb6361c1aa', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:23:37.932683+05:30', '2026-09-17 16:23:37.935643+05:30', '2026-09-17 16:23:37.935653+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a7305f235829', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:23:39.698418+05:30', '2026-09-17 16:23:39.71682+05:30', '2026-09-17 16:23:39.716826+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7561e23a00fc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:24:27.216932+05:30', '2026-09-17 16:24:27.220032+05:30', '2026-09-17 16:24:27.220042+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_45bdc105d2fd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:25:12.424305+05:30', '2026-09-17 16:25:12.438497+05:30', '2026-09-17 16:25:12.438503+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e73cd972de31', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/activity-logs', 'User kavya (FACULTY) opened tab: /faculty/classdiary/activity-logs', NULL, NULL, NULL, NULL, '2026-09-17 16:25:39.291445+05:30', '2026-09-17 16:25:39.304106+05:30', '2026-09-17 16:25:39.304115+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_81de73f678a5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:28:55.911335+05:30', '2026-09-17 16:28:55.92054+05:30', '2026-09-17 16:28:55.920544+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ae4e5848e3bf', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:28:57.199848+05:30', '2026-09-17 16:28:57.213352+05:30', '2026-09-17 16:28:57.21336+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3a8c8b8f7244', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/certifications', 'User Palani (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:31:07.438066+05:30', '2026-09-17 16:31:07.448282+05:30', '2026-09-17 16:31:07.448287+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_72bc660bbccb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:24:29.659207+05:30', '2026-09-17 16:24:29.673329+05:30', '2026-09-17 16:24:29.673337+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8f8a117ba7c1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:24:32.761133+05:30', '2026-09-17 16:24:32.764114+05:30', '2026-09-17 16:24:32.764123+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_59288804e58a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:26:17.505136+05:30', '2026-09-17 16:26:17.50816+05:30', '2026-09-17 16:26:17.508169+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a603d774a1d3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:26:25.868836+05:30', '2026-09-17 16:26:25.871655+05:30', '2026-09-17 16:26:25.871663+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e1ed61b93a3b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/class-management', 'User kavya (FACULTY) opened tab: /faculty/class-management', NULL, NULL, NULL, NULL, '2026-09-17 16:32:48.575431+05:30', '2026-09-17 16:32:48.582178+05:30', '2026-09-17 16:32:48.582184+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ed0326bd1032', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/legal-events', 'User kavya (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:35:14.568433+05:30', '2026-09-17 16:35:14.571294+05:30', '2026-09-17 16:35:14.571302+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2aab3cc4bf64', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/create', 'User Palani (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:24:36.916084+05:30', '2026-09-17 16:24:36.932324+05:30', '2026-09-17 16:24:36.932331+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c4dea5f2b83c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:25:03.041725+05:30', '2026-09-17 16:25:03.045294+05:30', '2026-09-17 16:25:03.045304+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_42e9ff5c6809', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/class-management', 'User Ajay (FACULTY) opened tab: /faculty/class-management', NULL, NULL, NULL, NULL, '2026-09-17 16:28:33.05195+05:30', '2026-09-17 16:28:33.064504+05:30', '2026-09-17 16:28:33.064508+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6493a9f500b3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/advisor-leaves', 'User Ajay (FACULTY) opened tab: /faculty/advisor-leaves', NULL, NULL, NULL, NULL, '2026-09-17 16:28:44.905512+05:30', '2026-09-17 16:28:44.908699+05:30', '2026-09-17 16:28:44.908708+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7acddd4125f5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:28:57.063546+05:30', '2026-09-17 16:28:57.071503+05:30', '2026-09-17 16:28:57.071512+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3e488dd21c20', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/certifications', 'User Palani (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:31:09.616945+05:30', '2026-09-17 16:31:09.630402+05:30', '2026-09-17 16:31:09.630408+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_44ce8c99d511', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/history', 'User Palani (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:25:08.739976+05:30', '2026-09-17 16:25:08.760689+05:30', '2026-09-17 16:25:08.760694+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_214ec4fea7ab', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/create', 'User kavya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:25:12.801616+05:30', '2026-09-17 16:25:12.804887+05:30', '2026-09-17 16:25:12.804897+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4764ff394e93', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/certifications', 'User Arya (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:25:58.505101+05:30', '2026-09-17 16:25:58.512258+05:30', '2026-09-17 16:25:58.512266+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b7dce3e6a70c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/activity-logs', 'User kavya (FACULTY) opened tab: /faculty/classdiary/activity-logs', NULL, NULL, NULL, NULL, '2026-09-17 16:26:02.559523+05:30', '2026-09-17 16:26:02.562588+05:30', '2026-09-17 16:26:02.562599+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_159064177212', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:27:31.126518+05:30', '2026-09-17 16:27:31.129321+05:30', '2026-09-17 16:27:31.12933+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_549a3b1f3d5f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/leaves', 'User Ajay (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 16:28:16.551862+05:30', '2026-09-17 16:28:16.572364+05:30', '2026-09-17 16:28:16.57237+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f8e2a8764b9d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:28:55.735477+05:30', '2026-09-17 16:28:55.742571+05:30', '2026-09-17 16:28:55.742575+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_52b434617627', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:29:41.884106+05:30', '2026-09-17 16:29:41.89277+05:30', '2026-09-17 16:29:41.892775+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ec24cc508eb9', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/certifications', 'User Palani (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:30:18.646012+05:30', '2026-09-17 16:30:18.649573+05:30', '2026-09-17 16:30:18.649578+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e44f943c5d12', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/studymaterials/dashboard', 'User kavya (FACULTY) opened tab: /faculty/studymaterials/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:30:31.709022+05:30', '2026-09-17 16:30:31.71519+05:30', '2026-09-17 16:30:31.715198+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_90f887733a10', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/certifications', 'User Palani (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:31:15.018579+05:30', '2026-09-17 16:31:15.032342+05:30', '2026-09-17 16:31:15.032348+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f5c9c75b4b39', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/legal-events', 'User Palani (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:32:59.699127+05:30', '2026-09-17 16:32:59.708548+05:30', '2026-09-17 16:32:59.708558+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d3277243050e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/salaryslip', 'User kavya (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-17 16:34:57.947781+05:30', '2026-09-17 16:34:57.950728+05:30', '2026-09-17 16:34:57.950736+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_26938f8738c8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/internships', 'User kavya (FACULTY) opened tab: /faculty/internships', NULL, NULL, NULL, NULL, '2026-09-17 16:35:06.718039+05:30', '2026-09-17 16:35:06.720957+05:30', '2026-09-17 16:35:06.720968+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_27d9fa479b9e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:25:23.469661+05:30', '2026-09-17 16:25:23.481177+05:30', '2026-09-17 16:25:23.481183+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1e4cec4f372d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mark-management', 'User Ajay (FACULTY) opened tab: /faculty/mark-management', NULL, NULL, NULL, NULL, '2026-09-17 16:25:24.966424+05:30', '2026-09-17 16:25:24.97551+05:30', '2026-09-17 16:25:24.975515+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d74443fa6c03', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/history', 'User kavya (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:25:28.271669+05:30', '2026-09-17 16:25:28.28157+05:30', '2026-09-17 16:25:28.281574+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2eccb6a0a0b6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/activity-logs', 'User kavya (FACULTY) opened tab: /faculty/classdiary/activity-logs', NULL, NULL, NULL, NULL, '2026-09-17 16:26:23.389104+05:30', '2026-09-17 16:26:23.392039+05:30', '2026-09-17 16:26:23.392047+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d5c21195901a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/class-management', 'User Ajay (FACULTY) opened tab: /faculty/class-management', NULL, NULL, NULL, NULL, '2026-09-17 16:28:45.915036+05:30', '2026-09-17 16:28:45.933905+05:30', '2026-09-17 16:28:45.933929+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b5599b966bb6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/legal-events', 'User Arya (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:32:39.475269+05:30', '2026-09-17 16:32:39.481337+05:30', '2026-09-17 16:32:39.481343+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1c75085ce8ac', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/legal-events', 'User Arya (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:35:11.065544+05:30', '2026-09-17 16:35:11.097871+05:30', '2026-09-17 16:35:11.097875+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4d940d6e93b8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:25:40.039+05:30', '2026-09-17 16:25:40.041757+05:30', '2026-09-17 16:25:40.041766+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9adff0b67c5b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/legal-events', 'User Ajay (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:32:36.642869+05:30', '2026-09-17 16:32:36.646354+05:30', '2026-09-17 16:32:36.646358+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6040ef154a36', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/history', 'User kavya (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:25:41.961559+05:30', '2026-09-17 16:25:41.964269+05:30', '2026-09-17 16:25:41.964278+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fa502d8eb700', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/timetable', 'User kavya (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:27:25.004147+05:30', '2026-09-17 16:27:25.009133+05:30', '2026-09-17 16:27:25.009144+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f0704956985e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:30:22.865872+05:30', '2026-09-17 16:30:22.874095+05:30', '2026-09-17 16:30:22.874099+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_729657de4070', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:30:36.781602+05:30', '2026-09-17 16:30:36.789275+05:30', '2026-09-17 16:30:36.789279+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d5987519fe81', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:25:45.60946+05:30', '2026-09-17 16:25:45.612476+05:30', '2026-09-17 16:25:45.612485+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fa805f585cc0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/create', 'User kavya (FACULTY) opened tab: /faculty/classdiary/create', NULL, NULL, NULL, NULL, '2026-09-17 16:27:47.321557+05:30', '2026-09-17 16:27:47.324717+05:30', '2026-09-17 16:27:47.324725+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c124c545b085', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/certifications', 'User kavya (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:32:28.662271+05:30', '2026-09-17 16:32:28.67094+05:30', '2026-09-17 16:32:28.670946+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_267bf0c7ac63', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:25:49.668264+05:30', '2026-09-17 16:25:49.672762+05:30', '2026-09-17 16:25:49.672769+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_36fa1ea141de', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:28:53.858986+05:30', '2026-09-17 16:28:53.869078+05:30', '2026-09-17 16:28:53.869082+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_bda1215f5ce7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:29:17.312209+05:30', '2026-09-17 16:29:17.322012+05:30', '2026-09-17 16:29:17.322018+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3006a3c439b6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/timetable', 'User Palani (FACULTY) opened tab: /faculty/timetable', NULL, NULL, NULL, NULL, '2026-09-17 16:32:49.701664+05:30', '2026-09-17 16:32:49.714942+05:30', '2026-09-17 16:32:49.71495+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8f5ef9dfecfb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/history', 'User kavya (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:26:03.250772+05:30', '2026-09-17 16:26:03.253422+05:30', '2026-09-17 16:26:03.253432+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e86887f41fe3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:28:26.145933+05:30', '2026-09-17 16:28:26.149748+05:30', '2026-09-17 16:28:26.149757+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e1fa89bd9773', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/meetings', 'User Ajay (FACULTY) opened tab: /faculty/meetings', NULL, NULL, NULL, NULL, '2026-09-17 16:28:30.687278+05:30', '2026-09-17 16:28:30.690717+05:30', '2026-09-17 16:28:30.690723+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_88adef05760a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:28:51.776476+05:30', '2026-09-17 16:28:51.789386+05:30', '2026-09-17 16:28:51.789395+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_9bf3f4f64665', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/profile', 'User Arya (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 16:29:14.348129+05:30', '2026-09-17 16:29:14.362123+05:30', '2026-09-17 16:29:14.362128+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_af76c96e4d02', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/certifications', 'User Ajay (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:30:23.378818+05:30', '2026-09-17 16:30:23.393287+05:30', '2026-09-17 16:30:23.393291+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_51c58bffbc75', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/assignments/my', 'User kavya (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 16:30:44.860169+05:30', '2026-09-17 16:30:44.863026+05:30', '2026-09-17 16:30:44.863034+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2e273b3ac620', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/certifications', 'User Arya (FACULTY) opened tab: /faculty/certifications', NULL, NULL, NULL, NULL, '2026-09-17 16:32:10.709092+05:30', '2026-09-17 16:32:10.723981+05:30', '2026-09-17 16:32:10.723991+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0465797944ec', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/legal-events', 'User Arya (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:34:47.222241+05:30', '2026-09-17 16:34:47.225726+05:30', '2026-09-17 16:34:47.225731+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_21823bb42d5c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/research', 'User kavya (FACULTY) opened tab: /faculty/research', NULL, NULL, NULL, NULL, '2026-09-17 16:35:02.557018+05:30', '2026-09-17 16:35:02.570661+05:30', '2026-09-17 16:35:02.570667+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_376acbb421cd', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/classdiary/today', 'User kavya (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:30:51.820202+05:30', '2026-09-17 16:30:51.821816+05:30', '2026-09-17 16:30:51.821822+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_70a94216bb32', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/legal-events', 'User Palani (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:34:42.211768+05:30', '2026-09-17 16:34:42.234775+05:30', '2026-09-17 16:34:42.23478+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cf700e9c78f6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/legal-events', 'User Palani (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:35:17.84979+05:30', '2026-09-17 16:35:17.875811+05:30', '2026-09-17 16:35:17.875815+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d685ff1ace3f', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/legal-events', 'User Ajay (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:36:10.816558+05:30', '2026-09-17 16:36:10.83801+05:30', '2026-09-17 16:36:10.838014+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_78821e110f4b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/legal-events', 'User Palani (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:36:41.140564+05:30', '2026-09-17 16:36:41.163057+05:30', '2026-09-17 16:36:41.16306+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0814f81add3d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/legal-events', 'User Palani (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:36:44.979527+05:30', '2026-09-17 16:36:44.989404+05:30', '2026-09-17 16:36:44.989408+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8789b412ac58', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/legal-events', 'User Palani (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:36:53.829807+05:30', '2026-09-17 16:36:53.851992+05:30', '2026-09-17 16:36:53.851998+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4f6ec5fd8f1e', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/legal-events', 'User Arya (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:36:58.927323+05:30', '2026-09-17 16:36:58.947166+05:30', '2026-09-17 16:36:58.94717+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7319a601a0e8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/legal-events', 'User Ajay (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:37:15.682856+05:30', '2026-09-17 16:37:15.699134+05:30', '2026-09-17 16:37:15.699138+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_62d2c23cdea0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/legal-events', 'User Arya (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:37:18.916254+05:30', '2026-09-17 16:37:18.92177+05:30', '2026-09-17 16:37:18.921774+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_818e78cba21c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/circulars', 'User Palani (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 16:37:39.368544+05:30', '2026-09-17 16:37:39.372887+05:30', '2026-09-17 16:37:39.372897+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_90aa4ad614e1', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/legal-events', 'User Palani (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:37:53.706353+05:30', '2026-09-17 16:37:53.726435+05:30', '2026-09-17 16:37:53.72644+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_99ba1395ce0d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/assignments/my', 'User Arya (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 16:38:17.738353+05:30', '2026-09-17 16:38:17.747675+05:30', '2026-09-17 16:38:17.74768+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d6f68ff2e9ec', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/assignments/create', 'User Arya (FACULTY) opened tab: /faculty/assignments/create', NULL, NULL, NULL, NULL, '2026-09-17 16:38:25.62438+05:30', '2026-09-17 16:38:25.654321+05:30', '2026-09-17 16:38:25.654326+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_386db8edab7d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/assignments/my', 'User Ajay (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 16:38:27.459328+05:30', '2026-09-17 16:38:27.469598+05:30', '2026-09-17 16:38:27.469606+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_12e31f4d3b0c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/assignments/create', 'User Ajay (FACULTY) opened tab: /faculty/assignments/create', NULL, NULL, NULL, NULL, '2026-09-17 16:38:29.282186+05:30', '2026-09-17 16:38:29.289421+05:30', '2026-09-17 16:38:29.289425+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1579a7f981d8', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/circulars', 'User Palani (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 16:38:34.41669+05:30', '2026-09-17 16:38:34.424349+05:30', '2026-09-17 16:38:34.424358+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7c741b2680e2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/circulars', 'User Palani (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 16:38:36.908725+05:30', '2026-09-17 16:38:36.92094+05:30', '2026-09-17 16:38:36.920944+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ac81a26a45ec', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/circulars', 'User kavya (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 16:38:49.785186+05:30', '2026-09-17 16:38:49.7876+05:30', '2026-09-17 16:38:49.787608+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_aa08673c9d3d', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/grievances', 'User kavya (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:39:18.437325+05:30', '2026-09-17 16:39:18.454604+05:30', '2026-09-17 16:39:18.454611+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7fe1f38c5059', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/my', 'User Palani (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 16:39:19.250238+05:30', '2026-09-17 16:39:19.272046+05:30', '2026-09-17 16:39:19.272051+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1c7238cdf043', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/create', 'User Palani (FACULTY) opened tab: /faculty/assignments/create', NULL, NULL, NULL, NULL, '2026-09-17 16:39:30.061873+05:30', '2026-09-17 16:39:30.084589+05:30', '2026-09-17 16:39:30.084593+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_351c1d2e23b7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/legal-events', 'User kavya (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:39:31.366459+05:30', '2026-09-17 16:39:31.369036+05:30', '2026-09-17 16:39:31.369044+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7b831369f217', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/my', 'User Palani (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 16:39:54.963064+05:30', '2026-09-17 16:39:54.965718+05:30', '2026-09-17 16:39:54.965726+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ec48c715a132', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/create', 'User Palani (FACULTY) opened tab: /faculty/assignments/create', NULL, NULL, NULL, NULL, '2026-09-17 16:39:57.707401+05:30', '2026-09-17 16:39:57.710239+05:30', '2026-09-17 16:39:57.710249+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8075531092a3', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/create', 'User Palani (FACULTY) opened tab: /faculty/assignments/create', NULL, NULL, NULL, NULL, '2026-09-17 16:40:31.241944+05:30', '2026-09-17 16:40:31.265832+05:30', '2026-09-17 16:40:31.265837+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5aeb4dff2176', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/my', 'User Palani (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 16:40:33.734702+05:30', '2026-09-17 16:40:33.737487+05:30', '2026-09-17 16:40:33.737493+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_eb79ec75a7af', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/create', 'User Palani (FACULTY) opened tab: /faculty/assignments/create', NULL, NULL, NULL, NULL, '2026-09-17 16:40:37.550785+05:30', '2026-09-17 16:40:37.576119+05:30', '2026-09-17 16:40:37.576125+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_021b2853d6dc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/internships', 'User kavya (FACULTY) opened tab: /faculty/internships', NULL, NULL, NULL, NULL, '2026-09-17 16:40:59.709858+05:30', '2026-09-17 16:40:59.71264+05:30', '2026-09-17 16:40:59.712649+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_25221774fa65', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/notifications', 'User kavya (FACULTY) opened tab: /faculty/notifications', NULL, NULL, NULL, NULL, '2026-09-17 16:41:01.042877+05:30', '2026-09-17 16:41:01.045893+05:30', '2026-09-17 16:41:01.045902+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d75abca16ae6', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-17 16:41:19.351666+05:30', '2026-09-17 16:41:19.352161+05:30', '2026-09-17 16:41:19.352164+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_74cc29b699c4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/today', 'User Palani (FACULTY) opened tab: /faculty/classdiary/today', NULL, NULL, NULL, NULL, '2026-09-17 16:41:40.277152+05:30', '2026-09-17 16:41:40.295811+05:30', '2026-09-17 16:41:40.295817+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ce31b8e53f62', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/tracker', 'User Palani (FACULTY) opened tab: /faculty/classdiary/tracker', NULL, NULL, NULL, NULL, '2026-09-17 16:41:42.171016+05:30', '2026-09-17 16:41:42.173993+05:30', '2026-09-17 16:41:42.174002+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_99475df8012a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/grievances', 'User kavya (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:41:59.169497+05:30', '2026-09-17 16:41:59.171992+05:30', '2026-09-17 16:41:59.172+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_1d8374c4df99', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/classdiary/history', 'User Palani (FACULTY) opened tab: /faculty/classdiary/history', NULL, NULL, NULL, NULL, '2026-09-17 16:41:44.848762+05:30', '2026-09-17 16:41:44.851848+05:30', '2026-09-17 16:41:44.851857+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3be1de98b951', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/my', 'User Palani (FACULTY) opened tab: /faculty/assignments/my', NULL, NULL, NULL, NULL, '2026-09-17 16:41:48.671025+05:30', '2026-09-17 16:41:48.674076+05:30', '2026-09-17 16:41:48.674081+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0b34c90f8625', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 16:43:29.980629+05:30', '2026-09-17 16:43:29.983736+05:30', '2026-09-17 16:43:29.983744+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3c369fbf3e3b', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/mentor-students', 'User Ajay (FACULTY) opened tab: /faculty/mentor-students', NULL, NULL, NULL, NULL, '2026-09-17 16:43:37.743615+05:30', '2026-09-17 16:43:37.74687+05:30', '2026-09-17 16:43:37.746877+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7e2c8d423965', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:45:39.393603+05:30', '2026-09-17 16:45:39.397871+05:30', '2026-09-17 16:45:39.39788+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_418dd6334dc2', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_palani', '/faculty/assignments/create', 'User Palani (FACULTY) opened tab: /faculty/assignments/create', NULL, NULL, NULL, NULL, '2026-09-17 16:41:51.052203+05:30', '2026-09-17 16:41:51.075564+05:30', '2026-09-17 16:41:51.075573+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_100a740f4da5', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/attendance/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/attendance/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:43:35.529364+05:30', '2026-09-17 16:43:35.55298+05:30', '2026-09-17 16:43:35.552986+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_a9fc27a64886', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:43:07.003599+05:30', '2026-09-17 16:43:07.010558+05:30', '2026-09-17 16:43:07.010564+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f01c2b48a16c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:43:09.239353+05:30', '2026-09-17 16:43:09.248412+05:30', '2026-09-17 16:43:09.248416+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_3fc432974786', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:43:33.000484+05:30', '2026-09-17 16:43:33.006871+05:30', '2026-09-17 16:43:33.006876+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ef309674826a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:44:01.358453+05:30', '2026-09-17 16:44:01.367385+05:30', '2026-09-17 16:44:01.367388+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c712cf133713', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/dashboard', 'User kavya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:43:24.635087+05:30', '2026-09-17 16:43:24.637826+05:30', '2026-09-17 16:43:24.637834+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4446596deb37', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:46:05.883523+05:30', '2026-09-17 16:46:05.889901+05:30', '2026-09-17 16:46:05.889905+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_6eabb06e4933', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/research', 'User Ajay (FACULTY) opened tab: /faculty/research', NULL, NULL, NULL, NULL, '2026-09-17 16:50:44.979055+05:30', '2026-09-17 16:50:44.988836+05:30', '2026-09-17 16:50:44.988842+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c92ac7d29145', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_kavya', '/faculty/grievances', 'User kavya (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:43:27.01661+05:30', '2026-09-17 16:43:27.019473+05:30', '2026-09-17 16:43:27.019481+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2fc68e66be8a', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/profile', 'User Ajay (FACULTY) opened tab: /faculty/profile', NULL, NULL, NULL, NULL, '2026-09-17 16:43:31.810759+05:30', '2026-09-17 16:43:31.819595+05:30', '2026-09-17 16:43:31.819599+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_92a87f014240', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/class-management', 'User Ajay (FACULTY) opened tab: /faculty/class-management', NULL, NULL, NULL, NULL, '2026-09-17 16:43:39.730648+05:30', '2026-09-17 16:43:39.745392+05:30', '2026-09-17 16:43:39.745395+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_574f03ebe0fc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:43:59.556204+05:30', '2026-09-17 16:43:59.569657+05:30', '2026-09-17 16:43:59.569663+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_f383f324b68c', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:48:51.698009+05:30', '2026-09-17 16:48:51.712371+05:30', '2026-09-17 16:48:51.712376+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_dafed90840fb', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/dashboard', 'User Ajay (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-17 16:49:39.51747+05:30', '2026-09-17 16:49:39.52523+05:30', '2026-09-17 16:49:39.525236+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_ab1a9e1ceff0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/circulars', 'User Ajay (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 16:50:40.734977+05:30', '2026-09-17 16:50:40.753038+05:30', '2026-09-17 16:50:40.753043+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d719696a4ba4', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/notifications', 'User Ajay (FACULTY) opened tab: /faculty/notifications', NULL, NULL, NULL, NULL, '2026-09-17 16:50:41.637172+05:30', '2026-09-17 16:50:41.645318+05:30', '2026-09-17 16:50:41.645326+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4854aaf5eadc', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/internships', 'User Ajay (FACULTY) opened tab: /faculty/internships', NULL, NULL, NULL, NULL, '2026-09-17 16:50:43.433814+05:30', '2026-09-17 16:50:43.46098+05:30', '2026-09-17 16:50:43.460984+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2a07648840c0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/internships', 'User Ajay (FACULTY) opened tab: /faculty/internships', NULL, NULL, NULL, NULL, '2026-09-17 16:50:58.759517+05:30', '2026-09-17 16:50:58.779378+05:30', '2026-09-17 16:50:58.779383+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7778d2473cf6', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/salaryslip', 'User Ajay (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-17 16:57:56.440719+05:30', '2026-09-17 16:57:56.451576+05:30', '2026-09-17 16:57:56.451581+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_025d0e1cafa7', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/salaryslip', 'User Ajay (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-17 16:58:08.904419+05:30', '2026-09-17 16:58:08.915068+05:30', '2026-09-17 16:58:08.915073+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_5289f3e7c149', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/leaves', 'User Ajay (FACULTY) opened tab: /faculty/leaves', NULL, NULL, NULL, NULL, '2026-09-17 16:50:47.629897+05:30', '2026-09-17 16:50:47.654747+05:30', '2026-09-17 16:50:47.654751+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_cb996adcdb94', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/circulars', 'User Ajay (FACULTY) opened tab: /faculty/circulars', NULL, NULL, NULL, NULL, '2026-09-17 16:51:00.914953+05:30', '2026-09-17 16:51:00.921405+05:30', '2026-09-17 16:51:00.921413+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_b60236918565', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/grievances', 'User Ajay (FACULTY) opened tab: /faculty/grievances', NULL, NULL, NULL, NULL, '2026-09-17 16:51:01.754706+05:30', '2026-09-17 16:51:01.76903+05:30', '2026-09-17 16:51:01.769036+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0db72a4f8d71', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/legal-events', 'User Ajay (FACULTY) opened tab: /faculty/legal-events', NULL, NULL, NULL, NULL, '2026-09-17 16:51:02.897884+05:30', '2026-09-17 16:51:02.918717+05:30', '2026-09-17 16:51:02.918722+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_7fd117c0c798', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/salaryslip', 'User Ajay (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-17 16:56:55.18263+05:30', '2026-09-17 16:56:55.200873+05:30', '2026-09-17 16:56:55.200879+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4e4e34a0d747', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/salaryslip', 'User Arya (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-17 16:56:57.537339+05:30', '2026-09-17 16:56:57.637476+05:30', '2026-09-17 16:56:57.637484+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_108992386f60', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/salaryslip', 'User Ajay (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-17 16:57:22.257759+05:30', '2026-09-17 16:57:22.26519+05:30', '2026-09-17 16:57:22.265194+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e2a08a59dad0', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_ajay', '/faculty/salaryslip', 'User Ajay (FACULTY) opened tab: /faculty/salaryslip', NULL, NULL, NULL, NULL, '2026-09-18 10:10:01.689885+05:30', '2026-09-18 10:10:01.698953+05:30', '2026-09-18 10:10:01.698957+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_69ab8ef85b2e', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-18 17:28:15.983803+05:30', '2026-09-18 17:28:15.985192+05:30', '2026-09-18 17:28:15.985199+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_d0f587166b7f', 'usr_student1', 'student1@gmail.com', 'student1', 'STUDENT', 'LOGIN', 'Auth', 'usr_student1', 'Authentication Portal', 'User student1 (student1@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-18 17:28:32.685523+05:30', '2026-09-18 17:28:32.686534+05:30', '2026-09-18 17:28:32.68654+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0ac0293b61dc', 'usr_arya', 'arya@gmail.com', 'Arya', 'FACULTY', 'LOGIN', 'Auth', 'usr_arya', 'Authentication Portal', 'User Arya (arya@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-18 17:29:44.373317+05:30', '2026-09-18 17:29:44.374698+05:30', '2026-09-18 17:29:44.374705+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_0bcd46c15237', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/dashboard', 'User Arya (FACULTY) opened tab: /faculty/dashboard', NULL, NULL, NULL, NULL, '2026-09-18 17:29:44.606608+05:30', '2026-09-18 17:29:44.609379+05:30', '2026-09-18 17:29:44.609387+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_fb7f1cd93050', NULL, 'system@cams.edu', 'System User', 'STAFF', 'TAB_NAVIGATION', 'Navigation', 'usr_arya', '/faculty/class-management', 'User Arya (FACULTY) opened tab: /faculty/class-management', NULL, NULL, NULL, NULL, '2026-09-18 17:32:02.028145+05:30', '2026-09-18 17:32:02.032151+05:30', '2026-09-18 17:32:02.03216+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_e7efae4c8bae', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-18 17:32:12.142986+05:30', '2026-09-18 17:32:12.143557+05:30', '2026-09-18 17:32:12.14356+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_c942e452544c', 'usr_sobi', 'sobi@gmail.com', 'Sobiya', 'HOD', 'LOGIN', 'Auth', 'usr_sobi', 'Authentication Portal', 'User Sobiya (sobi@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-21 19:22:02.311868+05:30', '2026-09-21 19:22:02.314475+05:30', '2026-09-21 19:22:02.314479+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_371d957b3e8d', 'usr_sobi', 'sobi@gmail.com', 'Sobiya', 'HOD', 'LOGIN', 'Auth', 'usr_sobi', 'Authentication Portal', 'User Sobiya (sobi@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-21 19:25:34.43921+05:30', '2026-09-21 19:25:34.440616+05:30', '2026-09-21 19:25:34.440622+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_4e56be0ae070', 'usr_dinesh', 'dinesh@gmail.com', 'Dinesh', 'PRINCIPAL', 'LOGIN', 'Auth', 'usr_dinesh', 'Authentication Portal', 'User Dinesh (dinesh@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-21 19:27:08.090958+05:30', '2026-09-21 19:27:08.091426+05:30', '2026-09-21 19:27:08.091429+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_90040a82eb1c', 'usr_sobi', 'sobi@gmail.com', 'Sobiya', 'HOD', 'LOGIN', 'Auth', 'usr_sobi', 'Authentication Portal', 'User Sobiya (sobi@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-21 19:31:09.026104+05:30', '2026-09-21 19:31:09.027584+05:30', '2026-09-21 19:31:09.027592+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_adb05bd4eb01', 'usr_student1', 'student1@gmail.com', 'student1', 'STUDENT', 'LOGIN', 'Auth', 'usr_student1', 'Authentication Portal', 'User student1 (student1@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-21 19:33:56.324794+05:30', '2026-09-21 19:33:56.325265+05:30', '2026-09-21 19:33:56.325267+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_8df58b494f44', 'usr_admin', 'admin@gmail.com', 'System Administrator', 'ADMIN', 'LOGIN', 'Auth', 'usr_admin', 'Authentication Portal', 'User System Administrator (admin@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-22 10:22:18.210504+05:30', '2026-09-22 10:22:18.211108+05:30', '2026-09-22 10:22:18.211111+05:30', false, NULL);
INSERT INTO public.audit_logs VALUES ('audit_2ad18d7bece1', 'usr_madhan', 'madhan@gmail.com', 'Madhan', 'HOD', 'LOGIN', 'Auth', 'usr_madhan', 'Authentication Portal', 'User Madhan (madhan@gmail.com) logged in successfully.', NULL, NULL, NULL, NULL, '2026-09-22 10:23:49.792596+05:30', '2026-09-22 10:23:49.793337+05:30', '2026-09-22 10:23:49.79334+05:30', false, NULL);


--
-- Data for Name: backup_configurations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.backup_configurations VALUES (true, '21:00', 30, '50fff684-0458-48e1-a17f-0c0bc5e7eb8c', '2026-09-15 17:43:47.148507+05:30', '2026-09-15 17:43:47.148513+05:30', false, NULL);


--
-- Data for Name: backup_history; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: batch_sections; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.batch_sections VALUES ('deg_b_a_l_l_b_all', '2025-2030', 'B', false, 30, NULL, 'c7aa3daf-f193-42be-b397-1069411a024b', '2026-09-16 17:08:52.708699+05:30', '2026-09-16 17:08:52.708707+05:30', false, NULL);
INSERT INTO public.batch_sections VALUES ('deg_b_a_l_l_b_all', '2025-2030', 'A', false, 25, NULL, '381940f2-d10b-4e26-aaa7-3c48d054e57e', '2026-09-16 17:08:52.712762+05:30', '2026-09-16 17:08:52.712769+05:30', false, NULL);
INSERT INTO public.batch_sections VALUES ('deg_b_a_l_l_b_all', '2026-2031', 'A', false, 40, NULL, '9122c767-8dc3-476b-bb2b-404c879eb50d', '2026-09-16 17:05:32.903777+05:30', '2026-09-17 15:18:24.873055+05:30', false, NULL);
INSERT INTO public.batch_sections VALUES ('deg_l_l_b_all', '2026-2029', 'B', false, 10, NULL, '895142a8-e819-422e-8ff5-ab0cbfc30af1', '2026-09-17 15:19:09.83425+05:30', '2026-09-17 15:19:09.834258+05:30', false, NULL);
INSERT INTO public.batch_sections VALUES ('deg_l_l_b_all', '2026-2029', 'A', false, 1, NULL, '63ea93a1-ac32-4b5c-80a5-83e6c9f7b10a', '2026-09-17 15:19:09.838143+05:30', '2026-09-17 15:19:09.83815+05:30', false, NULL);
INSERT INTO public.batch_sections VALUES ('deg_l_l_b_all', '2025-2028', 'B', false, 10, NULL, '07f0b2f5-6a35-481f-a1f7-c62846c1a475', '2026-09-17 15:19:55.479254+05:30', '2026-09-17 15:19:55.479263+05:30', false, NULL);
INSERT INTO public.batch_sections VALUES ('deg_b_a_l_l_b_all', '2026-2031', 'B', false, 10, NULL, 'd26b1827-d82b-49a3-8c5e-0e4e825cf50b', '2026-09-16 17:05:32.898187+05:30', '2026-09-17 15:19:59.059617+05:30', false, NULL);
INSERT INTO public.batch_sections VALUES ('deg_l_l_b_all', '2025-2028', 'A', false, 6, NULL, '526b40cc-615d-44b0-9a32-cada66c5ed0f', '2026-09-17 15:19:55.483128+05:30', '2026-09-17 15:20:49.404525+05:30', false, NULL);


--
-- Data for Name: buildings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.buildings VALUES ('b-1789998948141', 'A_Block', 'A1', '2026-09-21 19:30:27.055569+05:30', '2026-09-21 19:30:27.055581+05:30', false, NULL);


--
-- Data for Name: chat_messages; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.chat_messages VALUES ('cs_ea34e33f4846', 'USER', 'Show student profile information', 'cm_a6d05205af0d', '2026-09-25 10:53:13.436377+05:30', '2026-09-25 10:53:13.436377+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_ea34e33f4846', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_d3b2fbb9c802', '2026-09-25 10:53:13.460905+05:30', '2026-09-25 10:53:13.460905+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_81dc13cbdab0', 'USER', 'Show student profile information', 'cm_c05def336687', '2026-09-25 10:58:56.137204+05:30', '2026-09-25 10:58:56.137204+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_81dc13cbdab0', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_6db9ec634c30', '2026-09-25 10:58:56.158056+05:30', '2026-09-25 10:58:56.158056+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_35fc7f87b312', 'USER', 'Show student profile information', 'cm_b29f201781e3', '2026-09-25 12:11:29.876587+05:30', '2026-09-25 12:11:29.876587+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_35fc7f87b312', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_46ccf6ba5d88', '2026-09-25 12:11:29.897214+05:30', '2026-09-25 12:11:29.897214+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_c81e337d3cd9', 'USER', 'Show student profile information', 'cm_fbef203458a3', '2026-09-25 12:12:15.710535+05:30', '2026-09-25 12:12:15.710535+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_c81e337d3cd9', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_9ba25fb1ee75', '2026-09-25 12:12:15.72863+05:30', '2026-09-25 12:12:15.72863+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_7199796942a0', 'USER', 'Show student profile information', 'cm_81902b747293', '2026-09-25 12:13:42.694384+05:30', '2026-09-25 12:13:42.694384+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_7199796942a0', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_b132580d59ca', '2026-09-25 12:13:42.723859+05:30', '2026-09-25 12:13:42.723859+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_a7a799a4fd16', 'USER', 'Show student profile information', 'cm_6b63e55d1228', '2026-09-28 08:54:08.722843+05:30', '2026-09-28 08:54:08.722843+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_a7a799a4fd16', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_c049b43f832e', '2026-09-28 08:54:08.757088+05:30', '2026-09-28 08:54:08.757088+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_9d3001b91195', 'USER', 'Show student profile information', 'cm_571dee926155', '2026-09-28 09:27:59.646006+05:30', '2026-09-28 09:27:59.646006+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_9d3001b91195', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_9968a70aeb56', '2026-09-28 09:27:59.671988+05:30', '2026-09-28 09:27:59.671988+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_675de8aac29c', 'USER', 'Show student profile information', 'cm_de4e6a715f8a', '2026-09-28 09:59:09.68972+05:30', '2026-09-28 09:59:09.68972+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_675de8aac29c', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_f3d705c4b784', '2026-09-28 09:59:09.712115+05:30', '2026-09-28 09:59:09.712115+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_0860570deba9', 'USER', 'Show student profile information', 'cm_6a37e68fbc55', '2026-09-28 12:13:08.481121+05:30', '2026-09-28 12:13:08.481121+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_0860570deba9', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_c4605f948e5b', '2026-09-28 12:13:08.49312+05:30', '2026-09-28 12:13:08.49312+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_aa4a87ffa684', 'USER', 'Show student profile information', 'cm_1c4cbcf23baf', '2026-09-28 12:14:36.144181+05:30', '2026-09-28 12:14:36.144181+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_aa4a87ffa684', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_6a4ec8491b9d', '2026-09-28 12:14:36.177342+05:30', '2026-09-28 12:14:36.177342+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_4b440ad21c46', 'USER', 'Show student profile information', 'cm_aa917450d91d', '2026-09-28 12:28:20.053784+05:30', '2026-09-28 12:28:20.053784+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_4b440ad21c46', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_456572d9280d', '2026-09-28 12:28:20.070378+05:30', '2026-09-28 12:28:20.070378+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_9a0447c08b57', 'USER', 'Show student profile information', 'cm_9f0d22ca5f81', '2026-09-28 12:32:12.875421+05:30', '2026-09-28 12:32:12.875421+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_9a0447c08b57', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_497731261533', '2026-09-28 12:32:12.89381+05:30', '2026-09-28 12:32:12.89381+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_d4009379af13', 'USER', 'Show student profile information', 'cm_c0cf01268c33', '2026-09-28 12:32:55.939838+05:30', '2026-09-28 12:32:55.939838+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_d4009379af13', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_75660ae374ea', '2026-09-28 12:32:55.960543+05:30', '2026-09-28 12:32:55.960543+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_8d9b4b8d8fdf', 'USER', 'Show student profile information', 'cm_a4d6184a97dc', '2026-09-28 12:53:48.550664+05:30', '2026-09-28 12:53:48.550664+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_8d9b4b8d8fdf', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_64a7d5f968f9', '2026-09-28 12:53:48.567998+05:30', '2026-09-28 12:53:48.567998+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_c6a04f21a7fe', 'USER', 'Show student profile information', 'cm_296d32a3c9ce', '2026-09-28 15:36:11.279361+05:30', '2026-09-28 15:36:11.279361+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_c6a04f21a7fe', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_504eb5166eae', '2026-09-28 15:36:11.292572+05:30', '2026-09-28 15:36:11.292572+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_fc4020028577', 'USER', 'Show student profile information', 'cm_012bda820488', '2026-09-28 16:04:38.972324+05:30', '2026-09-28 16:04:38.972324+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_fc4020028577', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_12d3a45de069', '2026-09-28 16:04:38.99097+05:30', '2026-09-28 16:04:38.99097+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_13130c3e6600', 'USER', 'Show student profile information', 'cm_193093b33457', '2026-09-28 20:17:46.090969+05:30', '2026-09-28 20:17:46.090969+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_13130c3e6600', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_e2c5e739855e', '2026-09-28 20:17:46.121971+05:30', '2026-09-28 20:17:46.121971+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_ebf709bbb234', 'USER', 'Show student profile information', 'cm_77d79aaf3b5e', '2026-09-28 20:26:12.894605+05:30', '2026-09-28 20:26:12.894605+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_ebf709bbb234', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_1b2b7456b97b', '2026-09-28 20:26:12.915409+05:30', '2026-09-28 20:26:12.915409+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_86c4c0a49cde', 'USER', 'Show student profile information', 'cm_2348f6c32fab', '2026-09-28 20:34:15.071366+05:30', '2026-09-28 20:34:15.071366+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_86c4c0a49cde', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_041710f6c4bf', '2026-09-28 20:34:15.09802+05:30', '2026-09-28 20:34:15.09802+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_594590d626c4', 'USER', 'Show student profile information', 'cm_bdcb27603eae', '2026-09-28 20:34:55.955028+05:30', '2026-09-28 20:34:55.955028+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_594590d626c4', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_c224a6a69261', '2026-09-28 20:34:55.971538+05:30', '2026-09-28 20:34:55.971538+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_60c1ed1d6ddb', 'USER', 'Show student profile information', 'cm_7703ab873540', '2026-09-28 20:59:24.257002+05:30', '2026-09-28 20:59:24.257002+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_60c1ed1d6ddb', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_15ec343846fa', '2026-09-28 20:59:24.29974+05:30', '2026-09-28 20:59:24.29974+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_90abe46e6c6d', 'USER', 'Show student profile information', 'cm_bae3785e80f6', '2026-09-28 21:00:39.46354+05:30', '2026-09-28 21:00:39.46354+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_90abe46e6c6d', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_5e59640dd033', '2026-09-28 21:00:39.504138+05:30', '2026-09-28 21:00:39.504138+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_90385c019873', 'USER', 'Show student profile information', 'cm_2e0fd6b81ea3', '2026-09-28 21:05:19.520487+05:30', '2026-09-28 21:05:19.520487+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_90385c019873', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_a5225f9e9168', '2026-09-28 21:05:19.560932+05:30', '2026-09-28 21:05:19.560932+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_384ed10f7f4b', 'USER', 'Show student profile information', 'cm_e04da22c4afe', '2026-09-28 21:06:07.400823+05:30', '2026-09-28 21:06:07.400823+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_384ed10f7f4b', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_67a7fdc676ce', '2026-09-28 21:06:07.445856+05:30', '2026-09-28 21:06:07.445856+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_a8793f5d38b7', 'USER', 'Show student profile information', 'cm_8ab14f5d50e3', '2026-09-28 21:21:21.043644+05:30', '2026-09-28 21:21:21.043644+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_a8793f5d38b7', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_66fb1f792655', '2026-09-28 21:21:21.068651+05:30', '2026-09-28 21:21:21.068651+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_b83b5b1f44a9', 'USER', 'Show student profile information', 'cm_ae1339e1526a', '2026-09-28 21:22:59.863519+05:30', '2026-09-28 21:22:59.863519+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_b83b5b1f44a9', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_dda8d13984ed', '2026-09-28 21:22:59.887973+05:30', '2026-09-28 21:22:59.887973+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_019b3582a590', 'USER', 'Show student profile information', 'cm_241f23033f89', '2026-09-28 21:27:10.407179+05:30', '2026-09-28 21:27:10.407179+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_019b3582a590', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_3d48e3cb7789', '2026-09-28 21:27:10.424714+05:30', '2026-09-28 21:27:10.424714+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_472f7f447ab1', 'USER', 'Show student profile information', 'cm_3b2c9fca889f', '2026-09-28 21:41:29.205102+05:30', '2026-09-28 21:41:29.205102+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_472f7f447ab1', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_bc6bbe11922a', '2026-09-28 21:41:29.241967+05:30', '2026-09-28 21:41:29.243976+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_d84bbc9a34bd', 'USER', 'Show student profile information', 'cm_5fb463bf44cf', '2026-09-29 15:07:23.240882+05:30', '2026-09-29 15:07:23.240882+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_d84bbc9a34bd', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_933f2b76ce9c', '2026-09-29 15:07:23.256937+05:30', '2026-09-29 15:07:23.256937+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_6b08fa9a30c0', 'USER', 'Show student profile information', 'cm_e4fd8bcf82ca', '2026-09-29 15:08:04.561845+05:30', '2026-09-29 15:08:04.561845+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_6b08fa9a30c0', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_684cc6882bbb', '2026-09-29 15:08:04.610677+05:30', '2026-09-29 15:08:04.610677+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_d0b3c58a8d24', 'USER', 'Show student profile information', 'cm_c7f0d42bf309', '2026-09-29 15:24:00.314072+05:30', '2026-09-29 15:24:00.314072+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_d0b3c58a8d24', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_39a92b4f1226', '2026-09-29 15:24:00.331179+05:30', '2026-09-29 15:24:00.331179+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_19805c01f368', 'USER', 'Show student profile information', 'cm_f920172d6a11', '2026-09-29 15:33:32.569444+05:30', '2026-09-29 15:33:32.569444+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_19805c01f368', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_9b16b515dddb', '2026-09-29 15:33:32.577558+05:30', '2026-09-29 15:33:32.577558+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_c61f78e742cd', 'USER', 'Show student profile information', 'cm_ffaab3c9c49a', '2026-09-29 15:34:19.498612+05:30', '2026-09-29 15:34:19.498612+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_c61f78e742cd', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_31448100fd4b', '2026-09-29 15:34:19.514883+05:30', '2026-09-29 15:34:19.514883+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_ce5e269dc21d', 'USER', 'Show student profile information', 'cm_ec35943e41bd', '2026-09-29 16:11:10.741054+05:30', '2026-09-29 16:11:10.741054+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_ce5e269dc21d', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_4cc0a2d9f579', '2026-09-29 16:11:10.776602+05:30', '2026-09-29 16:11:10.776602+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_3b3e870b8a40', 'USER', 'Show student profile information', 'cm_57e4b555d533', '2026-09-29 19:22:47.948193+05:30', '2026-09-29 19:22:47.948193+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_3b3e870b8a40', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_21b940dd68b0', '2026-09-29 19:22:47.962611+05:30', '2026-09-29 19:22:47.962611+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_65d50f233eb3', 'USER', 'Show student profile information', 'cm_3bfb479d43bf', '2026-09-29 19:34:17.567351+05:30', '2026-09-29 19:34:17.567351+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_65d50f233eb3', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_a2388f0c22bc', '2026-09-29 19:34:17.580616+05:30', '2026-09-29 19:34:17.580616+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_e6e9544c60d2', 'USER', 'Show student profile information', 'cm_af17b15b1326', '2026-09-29 19:41:25.678994+05:30', '2026-09-29 19:41:25.678994+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_e6e9544c60d2', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_a49bb1154716', '2026-09-29 19:41:25.69184+05:30', '2026-09-29 19:41:25.69184+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_65cc08d77293', 'USER', 'Show student profile information', 'cm_a840b2a2a598', '2026-09-29 19:48:55.616048+05:30', '2026-09-29 19:48:55.616048+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_65cc08d77293', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_52730f5c1587', '2026-09-29 19:48:55.637333+05:30', '2026-09-29 19:48:55.637333+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_87fd31ef4268', 'USER', 'Show student profile information', 'cm_cf8e483e6dbe', '2026-09-29 19:49:45.579072+05:30', '2026-09-29 19:49:45.579072+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_87fd31ef4268', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_1473d8c04af6', '2026-09-29 19:49:45.593209+05:30', '2026-09-29 19:49:45.593209+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_072a1343d64d', 'USER', 'Show student profile information', 'cm_cadc78a6bcb0', '2026-09-29 20:00:34.465298+05:30', '2026-09-29 20:00:34.465298+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_072a1343d64d', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_72c1326be782', '2026-09-29 20:00:34.484764+05:30', '2026-09-29 20:00:34.484764+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_347dfde07678', 'USER', 'Show student profile information', 'cm_7af58171f662', '2026-09-29 20:01:14.280841+05:30', '2026-09-29 20:01:14.280841+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_347dfde07678', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_c69c2a75bd9d', '2026-09-29 20:01:14.294903+05:30', '2026-09-29 20:01:14.294903+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_b382844d9d03', 'USER', 'Show student profile information', 'cm_5dd488e47a7d', '2026-09-29 20:11:00.497856+05:30', '2026-09-29 20:11:00.497856+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_b382844d9d03', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_c9ede90f000d', '2026-09-29 20:11:00.540435+05:30', '2026-09-29 20:11:00.540435+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_f8009f2f8539', 'USER', 'Show student profile information', 'cm_18ea8f7ef181', '2026-09-29 20:11:50.983223+05:30', '2026-09-29 20:11:50.983223+05:30', false, NULL);
INSERT INTO public.chat_messages VALUES ('cs_f8009f2f8539', 'MODEL', 'Looking up student information and academic degree.

**Found 8 results:**

| Roll No | Full Name | Semester | Cgpa | Academic Status | Degree Name | Email |
| --- | --- | --- | --- | --- | --- | --- |
| LAW-009 | - | 1 | - | ACTIVE | L.L.B - UG | student5@gmail.com |
| LAW-006 | - | 1 | - | ACTIVE | L.L.B - UG | student6@gmail.com |
| LAW-010 | - | 3 | - | ACTIVE | L.L.B - UG | student7@gmail.com |
| LAW-011 | - | 3 | - | ACTIVE | L.L.B - UG | student8@gmail.com |
| LAW-001 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student1@gmail.com |
| LAW-002 | - | 1 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student2@gmail.com |
| LAW-007 | - | 3 | - | ACTIVE | B.A.L.L.B - INTEGRATED | student3@gmail.com |
| LAW-008 | - | 3 | - | ACTIVE | B.A.L.L.B - 2025-2030 | student4@gmail.com |', 'cm_8706cfdf401b', '2026-09-29 20:11:51.003882+05:30', '2026-09-29 20:11:51.003882+05:30', false, NULL);


--
-- Data for Name: chat_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_ea34e33f4846', '2026-09-25 10:53:13.332187+05:30', '2026-09-25 10:53:13.332187+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_81dc13cbdab0', '2026-09-25 10:58:56.04095+05:30', '2026-09-25 10:58:56.04095+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_35fc7f87b312', '2026-09-25 12:11:29.775375+05:30', '2026-09-25 12:11:29.775375+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_c81e337d3cd9', '2026-09-25 12:12:15.608284+05:30', '2026-09-25 12:12:15.608284+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_7199796942a0', '2026-09-25 12:13:42.603898+05:30', '2026-09-25 12:13:42.603898+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_a7a799a4fd16', '2026-09-28 08:54:08.612258+05:30', '2026-09-28 08:54:08.612258+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_9d3001b91195', '2026-09-28 09:27:59.513295+05:30', '2026-09-28 09:27:59.513295+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_675de8aac29c', '2026-09-28 09:59:09.553202+05:30', '2026-09-28 09:59:09.553202+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_0860570deba9', '2026-09-28 12:13:08.348302+05:30', '2026-09-28 12:13:08.348302+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_aa4a87ffa684', '2026-09-28 12:14:35.92819+05:30', '2026-09-28 12:14:35.92819+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_4b440ad21c46', '2026-09-28 12:28:19.942336+05:30', '2026-09-28 12:28:19.942336+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_9a0447c08b57', '2026-09-28 12:32:12.726166+05:30', '2026-09-28 12:32:12.726166+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_d4009379af13', '2026-09-28 12:32:55.819004+05:30', '2026-09-28 12:32:55.819004+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_8d9b4b8d8fdf', '2026-09-28 12:53:48.43366+05:30', '2026-09-28 12:53:48.43366+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_c6a04f21a7fe', '2026-09-28 15:36:11.129634+05:30', '2026-09-28 15:36:11.129634+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_fc4020028577', '2026-09-28 16:04:38.83554+05:30', '2026-09-28 16:04:38.83554+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_student5', 'Show student academic profile an', true, 'cs_a874700c9224', '2026-09-28 20:07:47.980084+05:30', '2026-09-28 20:07:47.980084+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_13130c3e6600', '2026-09-28 20:17:45.952962+05:30', '2026-09-28 20:17:45.952962+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_ebf709bbb234', '2026-09-28 20:26:12.774181+05:30', '2026-09-28 20:26:12.774181+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_86c4c0a49cde', '2026-09-28 20:34:14.946826+05:30', '2026-09-28 20:34:14.946826+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_594590d626c4', '2026-09-28 20:34:55.831011+05:30', '2026-09-28 20:34:55.831011+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_60c1ed1d6ddb', '2026-09-28 20:59:24.126478+05:30', '2026-09-28 20:59:24.126478+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_c8f209243d73', '2026-09-28 20:59:26.87559+05:30', '2026-09-28 20:59:26.87559+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_90abe46e6c6d', '2026-09-28 21:00:39.325223+05:30', '2026-09-28 21:00:39.325223+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_3e8bfb99d274', '2026-09-28 21:00:41.976154+05:30', '2026-09-28 21:00:41.976154+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_90385c019873', '2026-09-28 21:05:19.356717+05:30', '2026-09-28 21:05:19.356717+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_b260b149a968', '2026-09-28 21:05:21.746591+05:30', '2026-09-28 21:05:21.746591+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_384ed10f7f4b', '2026-09-28 21:06:07.245658+05:30', '2026-09-28 21:06:07.245658+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_4aeb1ba50aaf', '2026-09-28 21:06:09.193148+05:30', '2026-09-28 21:06:09.193148+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_a8793f5d38b7', '2026-09-28 21:21:20.870285+05:30', '2026-09-28 21:21:20.870285+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_0b9fc9ff39e7', '2026-09-28 21:21:22.747812+05:30', '2026-09-28 21:21:22.747812+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_3fcd3a0dabdb', '2026-09-28 21:21:39.461489+05:30', '2026-09-28 21:21:39.461489+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_b83b5b1f44a9', '2026-09-28 21:22:59.685138+05:30', '2026-09-28 21:22:59.685138+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_e28b7fc7f108', '2026-09-28 21:23:01.495464+05:30', '2026-09-28 21:23:01.495464+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_019b3582a590', '2026-09-28 21:27:10.246579+05:30', '2026-09-28 21:27:10.246579+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_d4762da35641', '2026-09-28 21:27:11.808962+05:30', '2026-09-28 21:27:11.808962+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_0e405309d0e7', '2026-09-28 21:28:27.92061+05:30', '2026-09-28 21:28:27.92061+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_8cdf808c228b', '2026-09-28 21:28:28.687114+05:30', '2026-09-28 21:28:28.687114+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_472f7f447ab1', '2026-09-28 21:41:29.031826+05:30', '2026-09-28 21:41:29.031826+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_3b0110019ddb', '2026-09-28 21:41:30.786297+05:30', '2026-09-28 21:41:30.786297+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_7b1b583c2c2e', '2026-09-29 15:02:31.071711+05:30', '2026-09-29 15:02:31.071711+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_d84bbc9a34bd', '2026-09-29 15:07:23.061845+05:30', '2026-09-29 15:07:23.061845+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_85403489d8f1', '2026-09-29 15:07:25.578377+05:30', '2026-09-29 15:07:25.578377+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_6b08fa9a30c0', '2026-09-29 15:08:04.237534+05:30', '2026-09-29 15:08:04.237534+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_bd1b55874e49', '2026-09-29 15:08:06.268735+05:30', '2026-09-29 15:08:06.268735+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_a2ae20600c45', '2026-09-29 15:11:40.873068+05:30', '2026-09-29 15:11:40.873068+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_9a1636fb8052', '2026-09-29 15:12:15.017037+05:30', '2026-09-29 15:12:15.017037+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_46b600f5fdc1', '2026-09-29 15:12:55.779379+05:30', '2026-09-29 15:12:55.779379+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_c50353f3ba6f', '2026-09-29 15:13:21.658271+05:30', '2026-09-29 15:13:21.658271+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_d81c9b85305c', '2026-09-29 15:13:52.353258+05:30', '2026-09-29 15:13:52.353258+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_d0b3c58a8d24', '2026-09-29 15:24:00.029441+05:30', '2026-09-29 15:24:00.029441+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_a292808868b8', '2026-09-29 15:24:01.990207+05:30', '2026-09-29 15:24:01.990207+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_60c6ed29d486', '2026-09-29 15:26:30.459849+05:30', '2026-09-29 15:26:30.459849+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_d99f65aaafb5', '2026-09-29 15:26:37.472532+05:30', '2026-09-29 15:26:37.472532+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_f130444179fb', '2026-09-29 15:26:45.06171+05:30', '2026-09-29 15:26:45.06171+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_8b2de20a1869', '2026-09-29 15:26:52.859402+05:30', '2026-09-29 15:26:52.859402+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_f2b263f5d0dc', '2026-09-29 15:26:57.451904+05:30', '2026-09-29 15:26:57.453918+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_8d79ad0883cc', '2026-09-29 15:27:02.387821+05:30', '2026-09-29 15:27:02.387821+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_19805c01f368', '2026-09-29 15:33:32.360559+05:30', '2026-09-29 15:33:32.360559+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_f484bf1d1e89', '2026-09-29 15:33:34.868879+05:30', '2026-09-29 15:33:34.868879+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_c61f78e742cd', '2026-09-29 15:34:19.271303+05:30', '2026-09-29 15:34:19.271303+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_e1c747c25238', '2026-09-29 15:34:21.054607+05:30', '2026-09-29 15:34:21.054607+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_0c88ee111c36', '2026-09-29 16:00:06.742183+05:30', '2026-09-29 16:00:06.742183+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_4abe91f751c3', '2026-09-29 16:00:17.308222+05:30', '2026-09-29 16:00:17.312739+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_90d40d13dd78', '2026-09-29 16:00:29.650974+05:30', '2026-09-29 16:00:29.650974+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_5e794f0f1b05', '2026-09-29 16:00:36.206335+05:30', '2026-09-29 16:00:36.206335+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_3f90f410931a', '2026-09-29 16:00:45.466274+05:30', '2026-09-29 16:00:45.466274+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_1f5e494a3ba6', '2026-09-29 16:00:52.942355+05:30', '2026-09-29 16:00:52.942355+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_ce5e269dc21d', '2026-09-29 16:11:10.518171+05:30', '2026-09-29 16:11:10.518171+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_07c41d03cfb4', '2026-09-29 16:11:12.298224+05:30', '2026-09-29 16:11:12.298224+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_student5', 'New Conversation', true, 'cs_6f4bbfae22b9', '2026-09-29 16:25:01.455909+05:30', '2026-09-29 16:25:01.455909+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Verification Test Session', true, 'cs_954da2f0a130', '2026-09-29 19:22:33.130817+05:30', '2026-09-29 19:22:33.130817+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_3b3e870b8a40', '2026-09-29 19:22:47.737862+05:30', '2026-09-29 19:22:47.737862+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_583fde5c6c67', '2026-09-29 19:22:49.485595+05:30', '2026-09-29 19:22:49.485595+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_student5', 'New Conversation', true, 'cs_ec7ed14097bd', '2026-09-29 19:25:30.042415+05:30', '2026-09-29 19:25:30.042415+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Verification Test Session', true, 'cs_47c77f3197bf', '2026-09-29 19:34:00.261624+05:30', '2026-09-29 19:34:00.261624+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_ff96914023d8', '2026-09-29 19:35:24.045461+05:30', '2026-09-29 19:36:07.432083+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_4a0e3e8e63f7', '2026-09-29 19:34:19.17496+05:30', '2026-09-29 19:36:10.436434+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_65d50f233eb3', '2026-09-29 19:34:17.255637+05:30', '2026-09-29 19:36:12.30332+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Verification Test Session', true, 'cs_0df62b3a2e04', '2026-09-29 19:41:05.596474+05:30', '2026-09-29 19:41:05.596474+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_e6e9544c60d2', '2026-09-29 19:41:25.286751+05:30', '2026-09-29 19:41:25.286751+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_5c312106f4b6', '2026-09-29 19:41:27.521976+05:30', '2026-09-29 19:41:27.521976+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_e4919d8e820d', '2026-09-29 19:42:05.906716+05:30', '2026-09-29 19:42:05.906716+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_65cc08d77293', '2026-09-29 19:48:55.298115+05:30', '2026-09-29 19:48:55.298115+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_8413d74ea4e2', '2026-09-29 19:48:58.349121+05:30', '2026-09-29 19:48:58.349121+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_87fd31ef4268', '2026-09-29 19:49:45.174623+05:30', '2026-09-29 19:49:45.174623+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_0a6f090b7ebe', '2026-09-29 19:49:47.173894+05:30', '2026-09-29 19:49:47.173894+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Verification Test Session', true, 'cs_ff61637a666e', '2026-09-29 19:50:12.17345+05:30', '2026-09-29 19:50:12.17345+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_072a1343d64d', '2026-09-29 20:00:34.128912+05:30', '2026-09-29 20:00:34.128912+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_d88f1b346207', '2026-09-29 20:00:36.279746+05:30', '2026-09-29 20:00:36.279746+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_347dfde07678', '2026-09-29 20:01:14.000463+05:30', '2026-09-29 20:01:14.000463+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_5da639d1f430', '2026-09-29 20:01:16.027501+05:30', '2026-09-29 20:01:16.027501+05:30', false, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Verification Test Session', true, 'cs_c33aeaa4c5cf', '2026-09-29 20:14:17.613662+05:30', '2026-09-29 20:15:22.929127+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_084d9a9072fd', '2026-09-29 20:11:52.153615+05:30', '2026-09-29 20:15:26.069637+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_f8009f2f8539', '2026-09-29 20:11:50.616932+05:30', '2026-09-29 20:15:27.756219+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Follow-up', true, 'cs_f66314fe0e76', '2026-09-29 20:11:03.072353+05:30', '2026-09-29 20:15:37.644174+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Test Inquiry', true, 'cs_b382844d9d03', '2026-09-29 20:11:00.201519+05:30', '2026-09-29 20:15:38.992797+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Verification Test Session', true, 'cs_68e2fae79fc8', '2026-09-29 20:07:30.204745+05:30', '2026-09-29 20:15:41.156757+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'Verification Test Session', true, 'cs_814f907ef883', '2026-09-29 20:03:58.874455+05:30', '2026-09-29 20:15:42.921819+05:30', true, NULL);
INSERT INTO public.chat_sessions VALUES ('usr_admin', 'New Conversation', true, 'cs_ef46a37c79bf', '2026-09-29 20:16:43.367213+05:30', '2026-09-29 20:16:43.367213+05:30', false, NULL);


--
-- Data for Name: class_advisors; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.class_advisors VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'usr_arya', 'deg_b_a_l_l_b_all', '2026-2031', 'A', '9122c767-8dc3-476b-bb2b-404c879eb50d', '724bcb01-bae9-4339-953c-dcfd5c12ee19', '2026-09-16 17:20:35.15456+05:30', '2026-09-17 15:27:14.523466+05:30', false, NULL);
INSERT INTO public.class_advisors VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'usr_alexa', 'deg_b_a_l_l_b_all', '2026-2031', 'B', 'd26b1827-d82b-49a3-8c5e-0e4e825cf50b', '22fe4d90-2089-4f79-909d-6fc11395ce37', '2026-09-16 17:20:35.155231+05:30', '2026-09-17 15:29:57.849879+05:30', false, NULL);
INSERT INTO public.class_advisors VALUES ('ay_2026_2027_b_a_l_l_b_2025_2030', 'usr_ajay', 'deg_b_a_l_l_b_all', '2025-2030', 'B', 'c7aa3daf-f193-42be-b397-1069411a024b', 'fd30718d-9849-4dc3-bebb-94455a3b030d', '2026-09-16 17:20:35.16417+05:30', '2026-09-16 17:20:35.164174+05:30', false, NULL);
INSERT INTO public.class_advisors VALUES ('ay_2026_2027_l_l_b_2026_2029', 'usr_palani', 'deg_l_l_b_all', '2026-2029', 'A', '63ea93a1-ac32-4b5c-80a5-83e6c9f7b10a', '57bf1fc1-fa97-4444-b122-3b0c35466dcb', '2026-09-17 15:23:39.968858+05:30', '2026-09-17 15:23:39.968861+05:30', false, NULL);
INSERT INTO public.class_advisors VALUES ('ay_2026_2027_l_l_b_2026_2029', 'usr_kavya', 'deg_l_l_b_all', '2026-2029', 'B', '895142a8-e819-422e-8ff5-ab0cbfc30af1', 'b69c1119-a649-4771-bf43-ec584ec075a7', '2026-09-17 15:23:39.971802+05:30', '2026-09-17 15:23:39.971805+05:30', false, NULL);
INSERT INTO public.class_advisors VALUES ('ay_2026_2027_l_l_b_2025_2028', 'usr_madhan', 'deg_l_l_b_all', '2025-2028', 'A', '526b40cc-615d-44b0-9a32-cada66c5ed0f', '194ccb7a-8acf-4319-a080-9f186e067cff', '2026-09-17 15:23:39.987109+05:30', '2026-09-17 15:23:39.987113+05:30', false, NULL);
INSERT INTO public.class_advisors VALUES ('ay_2026_2027_l_l_b_2025_2028', 'usr_kavya', 'deg_l_l_b_all', '2025-2028', 'B', '07f0b2f5-6a35-481f-a1f7-c62846c1a475', '6b09a37d-4d8a-48f1-a5bd-15f45d9b8844', '2026-09-17 15:23:39.96972+05:30', '2026-09-17 15:26:11.36349+05:30', false, NULL);
INSERT INTO public.class_advisors VALUES ('ay_2026_2027_b_a_l_l_b_2025_2030', 'usr_sobi', 'deg_b_a_l_l_b_all', '2025-2030', 'A', '381940f2-d10b-4e26-aaa7-3c48d054e57e', 'f78cecd7-3317-4eef-8657-39d1b6b17ead', '2026-09-16 17:20:35.160812+05:30', '2026-09-17 15:28:36.438737+05:30', false, NULL);


--
-- Data for Name: class_diaries; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.class_diaries VALUES ('2026-09-17', 'Political Science – I', 'B.A.L.L.B - INTEGRATED', '1', 'A', 'Hour 1', 'First Year', 'Unit I', 'mode of law', 'mode of law', 'Lecture', '', 'Submitted', '', '[]', 'usr_arya', 'Arya', 'c7ec2d9a-2d13-48fb-89cd-3bc788a61edd', '2026-09-17 16:07:50.271054+05:30', '2026-09-17 16:08:35.513172+05:30', false, NULL);
INSERT INTO public.class_diaries VALUES ('2026-09-17', 'Sociology – I', 'B.A.L.L.B - INTEGRATED', '1', 'A', 'Hour 1', 'First Year', 'Unit I, Unit II', 'Meaning, Nature & Scope of Sociology, Sociology as a Science, Social Stratification', 'Meaning, Nature & Scope of Sociology, Sociology as a Science, Social Stratification', 'Lecture', '', 'Submitted', '', '[]', 'usr_ajay', 'Ajay', 'a098f13d-4869-478d-8191-e9406d5fe7b4', '2026-09-17 16:08:35.515109+05:30', '2026-09-17 16:16:26.015096+05:30', false, NULL);
INSERT INTO public.class_diaries VALUES ('2026-09-17', 'Company Law', 'L.L.B - UG', '1', 'A', 'Hour 1', 'First Year', 'Unit I', 'Memorandum & Articles of Association', 'Memorandum & Articles of Association', 'Lecture', '', 'Submitted', '', '[]', 'usr_palani', 'Palani', 'd96c1f87-3935-4c79-a42f-61df8c6a0ca4', '2026-09-17 16:16:26.017054+05:30', '2026-09-17 16:16:26.913422+05:30', false, NULL);
INSERT INTO public.class_diaries VALUES ('2026-09-17', 'Interpretation of Statutes', 'L.L.B - UG', '3', 'A', 'Hour 2', 'Second Year', 'Unit I', 'Internal & external aids', 'Internal & external aids', 'Lecture', '', 'Submitted', '', '[]', 'usr_palani', 'Palani', 'ba813113-1cd3-4def-8ad9-9002609156b4', '2026-09-17 16:16:49.613325+05:30', '2026-09-17 16:20:45.188907+05:30', false, NULL);
INSERT INTO public.class_diaries VALUES ('2026-09-18', 'Interpretation of Statutes', 'L.L.B - UG', '3', 'A', 'Hour 3', 'Second Year', 'Unit I', 'Legal maxims', 'Legal maxims', 'Lecture', '', 'Submitted', '', '[]', 'usr_palani', 'Palani', 'a436b0ee-6ff6-45ec-aafd-025e7a64dc4f', '2026-09-17 16:20:45.190839+05:30', '2026-09-17 16:25:08.582566+05:30', false, NULL);
INSERT INTO public.class_diaries VALUES ('2026-09-17', 'Environmental Law', 'L.L.B - UG', '3', 'A', 'Hour 2', 'Second Year', 'Unit I', 'Water Act & Air Act', 'Water Act & Air Act', 'Lecture', '', 'Submitted', '', '[]', 'usr_palani', 'Palani', '358c26c2-0f9e-449d-b96a-72e6fbd67cfc', '2026-09-17 16:25:08.584941+05:30', '2026-09-17 16:25:28.121503+05:30', false, NULL);
INSERT INTO public.class_diaries VALUES ('2026-09-17', 'Environmental Law', 'L.L.B - UG', '3', 'A', 'Hour 1', 'Second Year', 'Unit I', 'Water Act & Air Act', 'Water Act & Air Act', 'Lecture', NULL, 'Submitted', '', 'null', 'usr_kavya', 'kavya', 'fd237f77-b595-49b5-822d-581e140c38ab', '2026-09-17 16:25:28.123658+05:30', '2026-09-17 16:25:28.123677+05:30', false, NULL);


--
-- Data for Name: classroom_activities; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: club_memberships; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: clubs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: community_service_logs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: course_enrollment_requests; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: course_enrollments; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Legal Method', 'Legal Method', 4, 1, 'crs_legal_method_b_a_l_l_b_all', '2026-09-16 15:35:27.896328+05:30', '2026-09-16 15:35:27.896336+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Political Science – I', 'Political Science – I', 4, 1, 'crs_political_science___i_b_a_l_l_b_all', '2026-09-16 15:35:48.81736+05:30', '2026-09-16 15:35:48.81737+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Sociology – I', 'Sociology – I', 4, 1, 'crs_sociology___i_b_a_l_l_b_all', '2026-09-16 15:36:03.142643+05:30', '2026-09-16 15:36:03.142655+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Economics – I', 'Economics – I', 4, 1, 'crs_economics___i_b_a_l_l_b_all', '2026-09-16 15:36:25.13577+05:30', '2026-09-16 15:36:25.135781+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'English – I', 'English – I', 4, 1, 'crs_english___i_b_a_l_l_b_all', '2026-09-16 15:37:00.361682+05:30', '2026-09-16 15:37:00.361693+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Law of Contract – I', 'Law of Contract – I', 4, 3, 'crs_law_of_contract___i_b_a_l_l_b_all', '2026-09-16 15:40:44.247632+05:30', '2026-09-16 15:40:44.247641+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Family Law – I', 'Family Law – I', 4, 3, 'crs_family_law___i_b_a_l_l_b_all', '2026-09-16 15:41:00.403793+05:30', '2026-09-16 15:41:00.403803+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Constitutional Law – I', 'Constitutional Law – I', 4, 3, 'crs_constitutional_law___i_b_a_l_l_b_all', '2026-09-16 15:41:15.416176+05:30', '2026-09-16 15:41:15.416185+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Law of Torts', 'Law of Torts', 4, 3, 'crs_law_of_torts_b_a_l_l_b_all', '2026-09-16 15:41:49.568252+05:30', '2026-09-16 15:41:49.568262+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_b_a_l_l_b_all', 'Legal Language / Legal Writing', 'Legal Language / Legal Writing', 4, 3, 'crs_legal_language___legal_writing_b_a_l_l_b_all', '2026-09-16 15:42:05.561746+05:30', '2026-09-16 15:42:05.561756+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_l_l_b_all', 'Company Law', 'Company Law', 4, 1, 'crs_company_law_l_l_b_all', '2026-09-16 15:45:30.957854+05:30', '2026-09-16 15:45:30.957862+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_l_l_b_all', 'Civil Procedure Code', 'Civil Procedure Code', 4, 1, 'crs_civil_procedure_code_l_l_b_all', '2026-09-16 15:45:51.073802+05:30', '2026-09-16 15:45:51.073812+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_l_l_b_all', 'Criminal Procedure Code', 'Criminal Procedure Code', 4, 1, 'crs_criminal_procedure_code_l_l_b_all', '2026-09-16 15:46:06.141427+05:30', '2026-09-16 15:46:06.141436+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_l_l_b_all', 'Environmental Law', 'Environmental Law', 4, 3, 'crs_environmental_law_l_l_b_all', '2026-09-16 15:51:32.297026+05:30', '2026-09-16 15:51:32.297037+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_l_l_b_all', 'Interpretation of Statutes', 'Interpretation of Statutes', 4, 3, 'crs_interpretation_of_statutes_l_l_b_all', '2026-09-16 15:51:55.050693+05:30', '2026-09-16 15:51:55.050702+05:30', false, NULL);
INSERT INTO public.courses VALUES ('deg_l_l_b_all', 'Professional', 'Professional Ethics & Bar Bench Relations', 4, 3, 'crs_professional_l_l_b_all', '2026-09-16 15:53:24.990552+05:30', '2026-09-16 15:53:24.990562+05:30', false, NULL);


--
-- Data for Name: custom_assignments; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: deductions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: degrees; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.degrees VALUES ('B.A.L.L.B', 'B.A.L.L.B - INTEGRATED', 'All', 'INTEGRATED', 5, '{"type":"CBCS","gpa_scale":10,"total_credits":200,"semesters":[20,20,20,20,20,20,20,20,20,20]}', '{"cia_marks":40,"see_marks":60,"total_marks":100,"min_cia":0,"min_see":30,"passing_percent":40}', 40, '{"O":{"lower":90,"upper":100},"A+":{"lower":80,"upper":89},"A":{"lower":70,"upper":79},"B+":{"lower":60,"upper":69},"B":{"lower":50,"upper":59},"RA / F":{"lower":0,"upper":49}}', 'deg_b_a_l_l_b_all', '2026-09-16 14:50:26.69148+05:30', '2026-09-16 14:50:26.691488+05:30', false, NULL);
INSERT INTO public.degrees VALUES ('L.L.B', 'L.L.B - UG', 'All', 'UG', 3, '{"type":"CBCS","gpa_scale":10,"total_credits":120,"semesters":[20,20,20,20,20,20]}', '{"cia_marks":40,"see_marks":60,"total_marks":100,"min_cia":0,"min_see":30,"passing_percent":40}', 40, '{"O":{"lower":90,"upper":100},"A+":{"lower":80,"upper":89},"A":{"lower":70,"upper":79},"B+":{"lower":60,"upper":69},"B":{"lower":50,"upper":59},"RA / F":{"lower":0,"upper":49}}', 'deg_l_l_b_all', '2026-09-16 14:50:49.758668+05:30', '2026-09-16 14:50:49.758677+05:30', false, NULL);
INSERT INTO public.degrees VALUES ('B.A.L.L.B', 'B.A.L.L.B - 2026-2031', '2026-2031', 'INTEGRATED', 5, '{"type":"CBCS","gpa_scale":10,"total_credits":200,"semesters":[20,20,20,20,20,20,20,20,20,20]}', '{"cia_marks":40,"see_marks":60,"total_marks":100,"min_cia":0,"min_see":30,"passing_percent":40}', 40, '{"O":{"lower":90,"upper":100},"A+":{"lower":80,"upper":89},"A":{"lower":70,"upper":79},"B+":{"lower":60,"upper":69},"B":{"lower":50,"upper":59},"RA / F":{"lower":0,"upper":49}}', 'deg_b_a_l_l_b_2026_2031', '2026-09-16 14:51:19.345668+05:30', '2026-09-16 14:51:19.345681+05:30', false, NULL);
INSERT INTO public.degrees VALUES ('L.L.B', 'L.L.B - 2026-2029', '2026-2029', 'UG', 3, '{"type":"CBCS","gpa_scale":10,"total_credits":120,"semesters":[20,20,20,20,20,20]}', '{"cia_marks":40,"see_marks":60,"total_marks":100,"min_cia":0,"min_see":30,"passing_percent":40}', 40, '{"O":{"lower":90,"upper":100},"A+":{"lower":80,"upper":89},"A":{"lower":70,"upper":79},"B+":{"lower":60,"upper":69},"B":{"lower":50,"upper":59},"RA / F":{"lower":0,"upper":49}}', 'deg_l_l_b_2026_2029', '2026-09-16 14:51:26.095852+05:30', '2026-09-16 14:51:26.095861+05:30', false, NULL);
INSERT INTO public.degrees VALUES ('B.A.L.L.B', 'B.A.L.L.B - 2025-2030', '2025-2030', 'INTEGRATED', 5, '{"type":"CBCS","gpa_scale":10,"total_credits":200,"semesters":[20,20,20,20,20,20,20,20,20,20]}', '{"cia_marks":40,"see_marks":60,"total_marks":100,"min_cia":0,"min_see":30,"passing_percent":40}', 40, '{"O":{"lower":90,"upper":100},"A+":{"lower":80,"upper":89},"A":{"lower":70,"upper":79},"B+":{"lower":60,"upper":69},"B":{"lower":50,"upper":59},"RA / F":{"lower":0,"upper":49}}', 'deg_b_a_l_l_b_2025_2030', '2026-09-16 14:51:51.917997+05:30', '2026-09-16 14:51:51.918008+05:30', false, NULL);
INSERT INTO public.degrees VALUES ('L.L.B', 'L.L.B - 2025-2028', '2025-2028', 'UG', 3, '{"type":"CBCS","gpa_scale":10,"total_credits":120,"semesters":[20,20,20,20,20,20]}', '{"cia_marks":40,"see_marks":60,"total_marks":100,"min_cia":0,"min_see":30,"passing_percent":40}', 40, '{"O":{"lower":90,"upper":100},"A+":{"lower":80,"upper":89},"A":{"lower":70,"upper":79},"B+":{"lower":60,"upper":69},"B":{"lower":50,"upper":59},"RA / F":{"lower":0,"upper":49}}', 'deg_l_l_b_2025_2028', '2026-09-16 14:52:32.32986+05:30', '2026-09-16 14:52:32.329869+05:30', false, NULL);


--
-- Data for Name: employee_allowance_overrides; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: employee_salary_assignments; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.employee_salary_assignments VALUES ('usr_ajay', 'sal_struct_professor', NULL, NULL, NULL, '2026-09-17', NULL, 'sal_assign_usr_ajay', '2026-09-17 16:56:22.369421+05:30', '2026-09-17 16:56:22.369428+05:30', false, NULL);
INSERT INTO public.employee_salary_assignments VALUES ('usr_arya', 'sal_struct_professor', 50000.00, 10000.00, 0.00, '2026-09-17', NULL, 'sal_assign_usr_arya', '2026-09-17 16:56:32.99453+05:30', '2026-09-17 16:56:32.994538+05:30', false, NULL);


--
-- Data for Name: exam_settings; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: exam_setup_splits; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.exam_setup_splits VALUES ('8a45cc1f-76dc-4235-a007-dee01a32c894', 'Main Theory Paper', 60, NULL, 'd0fd5d01-c521-4222-adc4-4d64c999764c', '2026-09-17 16:16:59.892486+05:30', '2026-09-17 16:16:59.892494+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('8a45cc1f-76dc-4235-a007-dee01a32c894', 'Practical / Viva', 40, NULL, 'cce6d49c-da45-42c9-a885-f6c9ed977b75', '2026-09-17 16:16:59.892497+05:30', '2026-09-17 16:16:59.892498+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('73677bdb-f869-44c0-b1d4-aeeb994dacb8', 'Written Test', 20, NULL, '6d75b57e-0d9b-44c3-9d08-e20f4ea863b4', '2026-09-17 16:17:40.604149+05:30', '2026-09-17 16:17:40.604154+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('73677bdb-f869-44c0-b1d4-aeeb994dacb8', 'Assignment / Seminar', 5, NULL, 'de65d638-bfed-4c36-8e5f-9b5890936d15', '2026-09-17 16:17:40.604155+05:30', '2026-09-17 16:17:40.604156+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('73677bdb-f869-44c0-b1d4-aeeb994dacb8', 'Class Attendance', 5, NULL, 'f6bf5ea2-60e3-4945-a8dc-7c1da55bf79f', '2026-09-17 16:17:40.604158+05:30', '2026-09-17 16:17:40.604158+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('cdf33812-9425-436f-ad9f-abcdc76de9d3', 'Written Test', 20, NULL, 'fc506af1-5270-49d9-ab23-2f0894b51b73', '2026-09-17 16:18:14.516569+05:30', '2026-09-17 16:18:14.516578+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('cdf33812-9425-436f-ad9f-abcdc76de9d3', 'Assignment / Seminar', 5, NULL, '5327d5d9-8ff6-42c5-b29e-fcfe9719eea4', '2026-09-17 16:18:14.516582+05:30', '2026-09-17 16:18:14.516584+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('cdf33812-9425-436f-ad9f-abcdc76de9d3', 'Class Attendance', 5, NULL, '060e7522-02c9-4bb0-a1be-1f5b6f10eb80', '2026-09-17 16:18:14.516587+05:30', '2026-09-17 16:18:14.516589+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('5159a3b6-4448-406d-8852-d0f73b6901b0', 'Main Theory Paper', 60, NULL, '2bc9bccd-47f2-4654-9c90-33f732e49c36', '2026-09-17 16:18:24.088582+05:30', '2026-09-17 16:18:24.088591+05:30', false, NULL);
INSERT INTO public.exam_setup_splits VALUES ('5159a3b6-4448-406d-8852-d0f73b6901b0', 'Practical / Viva', 40, NULL, 'd21eaa90-bda4-4308-bbbd-df7198075e76', '2026-09-17 16:18:24.088595+05:30', '2026-09-17 16:18:24.088597+05:30', false, NULL);


--
-- Data for Name: exam_setups; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.exam_setups VALUES ('deg_b_a_l_l_b_2026_2031', 1, 'End-Semester Main Exam (70 Marks)', NULL, '8a45cc1f-76dc-4235-a007-dee01a32c894', '2026-09-17 16:16:54.167327+05:30', '2026-09-17 16:16:54.167334+05:30', false, NULL);
INSERT INTO public.exam_setups VALUES ('deg_b_a_l_l_b_2025_2030', 3, 'Internal Assessment 1 (30 Marks)', NULL, '73677bdb-f869-44c0-b1d4-aeeb994dacb8', '2026-09-17 16:17:40.599794+05:30', '2026-09-17 16:17:40.599801+05:30', false, NULL);
INSERT INTO public.exam_setups VALUES ('deg_l_l_b_2025_2028', 3, 'Internal Assessment 1 (30 Marks)', NULL, 'cdf33812-9425-436f-ad9f-abcdc76de9d3', '2026-09-17 16:18:14.513383+05:30', '2026-09-17 16:18:14.513395+05:30', false, NULL);
INSERT INTO public.exam_setups VALUES ('deg_l_l_b_2026_2029', 1, 'End-Semester Main Exam (70 Marks)', NULL, '5159a3b6-4448-406d-8852-d0f73b6901b0', '2026-09-17 16:18:19.708847+05:30', '2026-09-17 16:18:19.708853+05:30', false, NULL);


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: extracurricular_activities; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: extracurricular_logs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: extracurricular_slots; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: faculty_absences; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.faculty_absences VALUES ('usr_arya', '2026-09-18', 'Leave (Rest Leave): rest leave', '6fd6039a-4058-4b27-ac65-dd02a33534f6', '2026-09-17 15:54:33.158256+05:30', '2026-09-17 15:54:33.158261+05:30', false, NULL);
INSERT INTO public.faculty_absences VALUES ('usr_arya', '2026-09-19', 'Leave (Rest Leave): rest leave', '2b169d36-8007-46a7-8181-8fbf61ee2160', '2026-09-17 15:54:33.174902+05:30', '2026-09-17 15:54:33.174907+05:30', false, NULL);
INSERT INTO public.faculty_absences VALUES ('usr_kavya', '2026-09-18', 'Leave (Rest Leave): family function', 'f9f700dc-6599-42e4-ba9e-295dd0552e95', '2026-09-17 15:54:44.949658+05:30', '2026-09-17 15:54:44.949664+05:30', false, NULL);
INSERT INTO public.faculty_absences VALUES ('usr_kavya', '2026-09-19', 'Leave (Rest Leave): family function', 'f548d8c5-4ddd-4494-836d-425e9aa99f54', '2026-09-17 15:54:44.962241+05:30', '2026-09-17 15:54:44.962246+05:30', false, NULL);
INSERT INTO public.faculty_absences VALUES ('usr_palani', '2026-09-17', 'Leave (Rest Leave): HI', '1d5dbbbd-9840-4b60-9a51-88c01a556788', '2026-09-17 15:54:57.162175+05:30', '2026-09-17 15:54:57.162181+05:30', false, NULL);
INSERT INTO public.faculty_absences VALUES ('usr_palani', '2026-09-18', 'Leave (Rest Leave): HI', '3959163b-9d4e-491c-a36a-3a323d03e166', '2026-09-17 15:54:57.173695+05:30', '2026-09-17 15:54:57.173701+05:30', false, NULL);
INSERT INTO public.faculty_absences VALUES ('usr_palani', '2026-09-19', 'Leave (Rest Leave): HI', '0046c4f4-d3ba-4bf8-a704-54c2be9f64b3', '2026-09-17 15:54:57.183368+05:30', '2026-09-17 15:54:57.183373+05:30', false, NULL);
INSERT INTO public.faculty_absences VALUES ('usr_palani', '2026-09-21', 'Leave (Rest Leave): HI', '8369c195-e35c-430d-b879-7116071f153e', '2026-09-17 15:54:57.193644+05:30', '2026-09-17 15:54:57.193648+05:30', false, NULL);
INSERT INTO public.faculty_absences VALUES ('usr_palani', '2026-09-22', 'Leave (Rest Leave): HI', 'bd53a7a7-56a9-4ff9-ae4b-80c2c0195938', '2026-09-17 15:54:57.202645+05:30', '2026-09-17 15:54:57.20265+05:30', false, NULL);


--
-- Data for Name: faculty_profile_update_requests; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: faculty_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.faculty_profiles VALUES ('usr_dinesh', NULL, 'College Principal', '', 'EMP-001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-22', 'Active', 'APPROVED', NULL, NULL, NULL, '[]', '[]', '[]', '[]', '[]', '[]', '{}', '{}', NULL, 'fac_emp_001', '2026-09-16 14:48:37.58297+05:30', '2026-09-16 14:48:37.582977+05:30', false, NULL);
INSERT INTO public.faculty_profiles VALUES ('usr_sobi', NULL, 'Head of Department (HOD)', '', 'EMP-002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-18', 'Active', 'APPROVED', NULL, 'usr_dinesh', NULL, '[]', '[]', '[]', '[]', '[]', '[]', '{}', '{}', NULL, 'fac_emp_002', '2026-09-16 15:06:19.021691+05:30', '2026-09-16 15:06:19.021694+05:30', false, NULL);
INSERT INTO public.faculty_profiles VALUES ('usr_madhan', NULL, 'Head of Department (HOD)', '', 'EMP-003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-22', 'Active', 'APPROVED', NULL, 'usr_dinesh', NULL, '[]', '[]', '[]', '[]', '[]', '[]', '{}', '{}', NULL, 'fac_emp_003', '2026-09-16 15:07:05.546406+05:30', '2026-09-16 15:07:05.54641+05:30', false, NULL);
INSERT INTO public.faculty_profiles VALUES ('usr_palani', NULL, 'Assistant Professor', '', 'EMP-006', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-21', 'Active', 'PENDING_PRINCIPAL', 'usr_madhan', 'usr_dinesh', NULL, '[]', '[]', '[]', '[]', '[]', '[]', '{}', '{}', NULL, 'fac_emp_006', '2026-09-16 15:14:29.445631+05:30', '2026-09-16 15:14:29.445634+05:30', false, NULL);
INSERT INTO public.faculty_profiles VALUES ('usr_kavya', NULL, 'Assistant Professor', '', 'EMP-007', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-22', 'Active', 'PENDING_PRINCIPAL', 'usr_madhan', 'usr_dinesh', NULL, '[]', '[]', '[]', '[]', '[]', '[]', '{}', '{}', NULL, 'fac_emp_007', '2026-09-16 15:15:07.51746+05:30', '2026-09-16 15:15:07.51747+05:30', false, NULL);
INSERT INTO public.faculty_profiles VALUES ('usr_alexa', NULL, 'Assistant Professor', '', 'EMP-008', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-20', 'Active', 'PENDING_PRINCIPAL', 'usr_sobi', 'usr_dinesh', NULL, '[]', '[]', '[]', '[]', '[]', '[]', '{}', '{}', NULL, 'fac_emp_008', '2026-09-16 17:20:25.600095+05:30', '2026-09-16 17:20:25.600099+05:30', false, NULL);
INSERT INTO public.faculty_profiles VALUES ('usr_ajay', NULL, 'Professor', '', 'EMP-005', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-18', 'Active', 'PENDING_PRINCIPAL', 'usr_sobi', 'usr_dinesh', NULL, '[]', '[]', '[]', '[]', '[]', '[]', '{}', '{}', NULL, 'fac_emp_005', '2026-09-16 15:13:40.248359+05:30', '2026-09-17 16:56:22.377593+05:30', false, NULL);
INSERT INTO public.faculty_profiles VALUES ('usr_arya', NULL, 'Professor', '', 'EMP-004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-18', 'Active', 'PENDING_PRINCIPAL', 'usr_sobi', 'usr_dinesh', NULL, '[]', '[]', '[]', '[]', '[]', '[]', '{}', '{}', NULL, 'fac_emp_004', '2026-09-16 15:12:57.972714+05:30', '2026-09-17 16:56:33.002196+05:30', false, NULL);


--
-- Data for Name: faculty_research; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: faculty_workload; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: fee_blueprints; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.fee_blueprints VALUES ('B.A.L.L.B', 'INTEGRATED', 'B.A.L.L.B', 'All', NULL, NULL, '[]', '{"government": "150000", "management": "200000", "nri": "300000"}', '["sch_type_merit_scholarship", "sch_type_sports_quota"]', 'B.A.L.L.B', '2026-09-17 16:44:21.672556+05:30', '2026-09-17 16:44:21.672567+05:30', false, NULL);
INSERT INTO public.fee_blueprints VALUES ('L.L.B', 'UG', 'L.L.B', 'All', NULL, NULL, '[]', '{"government": "150000", "management": "200000", "nri": "300000"}', '[]', 'L.L.B', '2026-09-17 16:45:29.909944+05:30', '2026-09-17 16:45:29.909953+05:30', false, NULL);
INSERT INTO public.fee_blueprints VALUES ('B.A.L.L.B - 2025-2030', 'INTEGRATED', 'B.A.L.L.B', '2025-2030', NULL, NULL, '[]', '{"government": "70000", "management": "200000", "nri": "300000"}', '["sch_type_merit_scholarship", "sch_type_sports_quota"]', 'B.A.L.L.B_2025-2030', '2026-09-17 16:44:30.275984+05:30', '2026-09-17 16:45:30.063036+05:30', false, NULL);
INSERT INTO public.fee_blueprints VALUES ('L.L.B - 2025-2028', 'UG', 'L.L.B', '2025-2028', NULL, NULL, '[]', '{"government": "70000", "management": "200000", "nri": "300000"}', '["sch_type_sports_quota", "sch_type_merit_scholarship"]', 'L.L.B_2025-2028', '2026-09-17 16:45:18.391194+05:30', '2026-09-17 16:45:30.063045+05:30', false, NULL);


--
-- Data for Name: fee_records; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.fee_records VALUES ('std_law_001', 'cf661e8c-c40d-4f0c-b6e5-ff87fd7be8e5', 'PENDING', 'c75c67ed-b54a-4f9b-9d42-f7e8f13d7668', '2026-09-17 15:16:19.205197+05:30', '2026-09-17 15:16:19.205202+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_002', 'cf661e8c-c40d-4f0c-b6e5-ff87fd7be8e5', 'PENDING', '4ce6b0a4-e421-43a8-bfc5-6ad709fbffc1', '2026-09-17 15:16:48.226081+05:30', '2026-09-17 15:16:48.226087+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_009', '10b370ce-a53e-448f-9d90-47a9ad017c61', 'PENDING', '95d61550-f86c-41cd-bcc4-f1c341f0d9ba', '2026-09-17 15:17:42.187315+05:30', '2026-09-17 15:17:42.187321+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_011', '10b370ce-a53e-448f-9d90-47a9ad017c61', 'PENDING', 'ebb0a4f2-1611-4e3f-99ad-74b8efe14e89', '2026-09-17 15:18:01.47841+05:30', '2026-09-17 15:18:01.478413+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_011', '2fdf4f91-b6a4-4baf-b36e-feb07561f339', 'PENDING', '42990b76-f223-4f97-a876-800b3b82b4b8', '2026-09-17 15:18:01.478422+05:30', '2026-09-17 15:18:01.478422+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_009', '2fdf4f91-b6a4-4baf-b36e-feb07561f339', 'PENDING', 'e2575025-fc8a-4bd0-8232-7f3b1a646e36', '2026-09-17 15:23:20.531486+05:30', '2026-09-17 15:23:20.53149+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_008', 'f2436886-4bde-4958-a6b7-6401c252e721', 'PENDING', '9ca018c2-ca36-4127-bbe2-a8cc024d6977', '2026-09-17 15:28:21.873746+05:30', '2026-09-17 15:28:21.873749+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_008', '902fba79-4d4b-4cad-a9ca-31af625f3eec', 'PENDING', '531a57b7-9892-45be-b84b-c0531bf9b398', '2026-09-17 15:28:21.873756+05:30', '2026-09-17 15:28:21.873757+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_008', '60795627-8d82-4164-afd9-cb733cc04c18', 'PENDING', '6955f3bb-c0ae-4116-a5bb-75d32d508820', '2026-09-17 16:46:28.48851+05:30', '2026-09-17 16:46:28.488516+05:30', false, NULL);
INSERT INTO public.fee_records VALUES ('std_law_008', '1ac0ea08-975b-401b-a867-145f3ec9ef48', 'PENDING', '923eac12-cb90-4614-a77a-716d112e3fb3', '2026-09-17 16:46:28.488527+05:30', '2026-09-17 16:46:28.488529+05:30', false, NULL);


--
-- Data for Name: fee_structure; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.fee_structure VALUES ('deg_l_l_b_all', 2, 85000.00, '2026-09-17', 'Year 2 Tuition Fee', '2fdf4f91-b6a4-4baf-b36e-feb07561f339', '2026-09-17 15:18:01.471221+05:30', '2026-09-17 15:18:01.471225+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_b_a_l_l_b_2025_2030', 3, 85000.00, '2026-09-17', 'Year 3 Tuition Fee', '60795627-8d82-4164-afd9-cb733cc04c18', '2026-09-17 16:44:21.692009+05:30', '2026-09-17 16:44:21.692015+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_b_a_l_l_b_2025_2030', 4, 85000.00, '2026-09-17', 'Year 4 Tuition Fee', '1ac0ea08-975b-401b-a867-145f3ec9ef48', '2026-09-17 16:44:21.69203+05:30', '2026-09-17 16:44:21.692032+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_b_a_l_l_b_2025_2030', 5, 85000.00, '2026-09-17', 'Year 5 Tuition Fee', 'a537bfc2-f56c-4a63-a25b-bc7093e2ebce', '2026-09-17 16:44:21.692043+05:30', '2026-09-17 16:44:21.692045+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_l_l_b_2025_2028', 1, 85000.00, '2026-09-17', 'Year 1 Tuition Fee', '05896f6f-6d5a-4c6b-b00f-653caa1f62c0', '2026-09-17 16:45:18.425141+05:30', '2026-09-17 16:45:18.425146+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_l_l_b_2025_2028', 2, 85000.00, '2026-09-17', 'Year 2 Tuition Fee', '2e713107-bd65-43e3-adee-f79c0ead2e4f', '2026-09-17 16:45:18.425162+05:30', '2026-09-17 16:45:18.425163+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_l_l_b_2025_2028', 3, 85000.00, '2026-09-17', 'Year 3 Tuition Fee', 'e3d10dde-159f-4035-828e-57d160d10353', '2026-09-17 16:45:18.425174+05:30', '2026-09-17 16:45:18.425176+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_l_l_b_2025_2028', 4, 85000.00, '2026-09-17', 'Year 4 Tuition Fee', '9d9c0a78-78ec-4462-8092-a57cc819927f', '2026-09-17 16:45:18.425186+05:30', '2026-09-17 16:45:18.425187+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_l_l_b_2025_2028', 5, 85000.00, '2026-09-17', 'Year 5 Tuition Fee', '195dadab-5d11-4843-a9d2-bbf159c88cec', '2026-09-17 16:45:18.425197+05:30', '2026-09-17 16:45:18.425198+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_b_a_l_l_b_all', 1, 150000.00, '2026-09-17', 'Year 1 Tuition Fee', 'cf661e8c-c40d-4f0c-b6e5-ff87fd7be8e5', '2026-09-17 15:16:19.175218+05:30', '2026-09-17 16:46:09.068811+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_b_a_l_l_b_2025_2030', 2, 150000.00, '2026-09-17', 'Year 2 Tuition Fee', '902fba79-4d4b-4cad-a9ca-31af625f3eec', '2026-09-17 15:28:21.870546+05:30', '2026-09-17 16:46:28.4926+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_b_a_l_l_b_2025_2030', 1, 150000.00, '2026-09-17', 'Year 1 Tuition Fee', 'f2436886-4bde-4958-a6b7-6401c252e721', '2026-09-17 15:28:21.868844+05:30', '2026-09-17 16:46:28.49261+05:30', false, NULL);
INSERT INTO public.fee_structure VALUES ('deg_l_l_b_all', 1, 200000.00, '2026-09-17', 'Year 1 Tuition Fee', '10b370ce-a53e-448f-9d90-47a9ad017c61', '2026-09-17 15:17:42.159925+05:30', '2026-09-17 17:22:37.449064+05:30', false, NULL);


--
-- Data for Name: floors; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.floors VALUES ('floor-1789999069777-429', 'b-1789998948141', 'Ground floor', 0, 'A', 'Active', '', '2026-09-21 19:30:27.057688+05:30', '2026-09-21 19:30:27.057697+05:30', false, NULL);


--
-- Data for Name: global_research_timelines; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: grade_template_allowances; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: grievances; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.grievances VALUES ('GRV-20260917-16B0', 'usr_student5', 'Hostel', 'Water not comming', 'Water not comming', 'Medium', 'Pending', '', NULL, 'Principal', NULL, NULL, NULL, NULL, NULL, NULL, '43b4a2c8-4036-4e8c-9895-fde3537369af', '2026-09-17 16:42:53.705006+05:30', '2026-09-17 16:42:53.705011+05:30', false, NULL);
INSERT INTO public.grievances VALUES ('GRV-20260917-87C3', 'usr_student1', 'Hostel', 'Food is not nice', 'The food is over salty and not proper hygiene', 'Medium', 'Pending', '', NULL, 'Principal', NULL, NULL, NULL, NULL, NULL, NULL, '78b8fa11-f557-42d2-90ea-6527a9f4e208', '2026-09-17 16:43:03.810455+05:30', '2026-09-17 16:43:03.810462+05:30', false, NULL);
INSERT INTO public.grievances VALUES ('GRV-20260917-8EFD', 'usr_student8', 'IT Support', 'Grievance', 'Water Issuses', 'Medium', 'Pending', '', NULL, 'Principal', NULL, NULL, NULL, NULL, NULL, NULL, 'fa11a451-4c91-4cea-af76-39b15d03b6a5', '2026-09-17 16:43:36.274948+05:30', '2026-09-17 16:43:36.274954+05:30', false, NULL);
INSERT INTO public.grievances VALUES ('GRV-20260917-FFE9', 'usr_student1', 'Infrastructure', 'Switch box ix not working', 'Any switch box ix not working in the classroom we are suffering for using laptop', 'Medium', 'Pending', '', NULL, 'Principal', NULL, NULL, NULL, NULL, NULL, NULL, 'dc9ce066-fc43-4fff-b7be-61f746dad885', '2026-09-17 16:44:47.884314+05:30', '2026-09-17 16:44:47.88432+05:30', false, NULL);
INSERT INTO public.grievances VALUES ('GRV-20260917-2E26', 'usr_student4', 'Transport', 'due to damaged seats in bus', 'In bus no 21 seats are damaged so that we are unable to sit', 'Medium', 'Pending', '', NULL, 'Principal', NULL, NULL, NULL, NULL, NULL, NULL, 'abb3ab88-caa3-4a1d-bbd4-d341f374998f', '2026-09-17 16:46:24.394568+05:30', '2026-09-17 16:46:24.394576+05:30', false, NULL);


--
-- Data for Name: innovation_posts; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: internal_marks; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.internal_marks VALUES ('std_law_001', '850e6f82-4538-44b0-bf58-105a9478ed84', 'crs_political_science___i_b_a_l_l_b_all', '2026-2027', '1', '8a45cc1f-76dc-4235-a007-dee01a32c894', 56.00, 35.00, 0.00, 0.00, 0.00, 91.00, 'APPROVED:8A45CC1F', NULL, NULL, false, NULL, 'f75fe33e-c34d-4790-b229-cb5ae4875285', '2026-09-17 16:18:52.678167+05:30', '2026-09-17 16:21:31.319293+05:30', false, NULL);
INSERT INTO public.internal_marks VALUES ('std_law_001', '3d27c602-f52f-4386-98f0-d4f3f8774bd5', 'crs_sociology___i_b_a_l_l_b_all', '2026-2027', '1', '8a45cc1f-76dc-4235-a007-dee01a32c894', 55.00, 40.00, 0.00, 0.00, 0.00, 95.00, 'APPROVED:8A45CC1F', 'change the mark', NULL, true, '[{"returned_at": "17-09-2026 10:52 AM", "reason": "change the mark", "exam_id": "8a45cc1f-76dc-4235-a007-dee01a32c894", "internal_exam_mark": 50.0, "assignment_mark": 40.0, "presentation_mark": 0.0, "viva_voice_mark": 0.0, "attendance_mark": 0.0, "total_mark": 90.0}]', '6e01ba43-4c58-4641-8d33-5e4bce1a1165', '2026-09-17 16:18:35.778405+05:30', '2026-09-17 16:25:21.069447+05:30', false, NULL);


--
-- Data for Name: internship_applications; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: internship_drives; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: internship_mentors; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: leave_approvals; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.leave_approvals VALUES ('LA-3D07CE', 'LV-16ED14', 'usr_ajay', 'APPROVED', '', '2026-09-17 15:43:56.058476+05:30', '2026-09-17 15:43:56.058482+05:30', false, NULL);
INSERT INTO public.leave_approvals VALUES ('LA-517A89', 'LV-7319E4', 'usr_arya', 'APPROVED', '', '2026-09-17 15:45:35.427029+05:30', '2026-09-17 15:45:35.427036+05:30', false, NULL);
INSERT INTO public.leave_approvals VALUES ('LA-2ED17D', 'LV-53C73F', 'usr_palani', 'REJECTED', 'kk', '2026-09-17 15:46:00.883427+05:30', '2026-09-17 15:46:00.883431+05:30', false, NULL);
INSERT INTO public.leave_approvals VALUES ('LA-80BA5F', 'LV-81E884', 'usr_madhan', 'APPROVED', '', '2026-09-17 15:46:02.281979+05:30', '2026-09-17 15:46:02.281984+05:30', false, NULL);
INSERT INTO public.leave_approvals VALUES ('LA-D91530', 'LV-E0BAA7', 'usr_arya', 'REJECTED', 'conflicts with exam schedule', '2026-09-17 15:46:26.076201+05:30', '2026-09-17 15:46:26.076208+05:30', false, NULL);
INSERT INTO public.leave_approvals VALUES ('LA-817D19', 'LV-BA67AB', 'usr_ajay', 'REJECTED', 'test', '2026-09-17 15:48:14.402978+05:30', '2026-09-17 15:48:14.402986+05:30', false, NULL);
INSERT INTO public.leave_approvals VALUES ('LA-44A99A', 'LV-694F45', 'usr_sobi', 'APPROVED', '', '2026-09-17 15:54:33.149553+05:30', '2026-09-17 15:54:33.149559+05:30', false, NULL);
INSERT INTO public.leave_approvals VALUES ('LA-024FA9', 'LV-F4A82D', 'usr_madhan', 'APPROVED', '', '2026-09-17 15:54:44.932495+05:30', '2026-09-17 15:54:44.932502+05:30', false, NULL);
INSERT INTO public.leave_approvals VALUES ('LA-A7BE74', 'LV-A67179', 'usr_madhan', 'APPROVED', '', '2026-09-17 15:54:57.157694+05:30', '2026-09-17 15:54:57.157701+05:30', false, NULL);


--
-- Data for Name: leave_balances; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.leave_balances VALUES ('__DEFAULTS_STUDENT__', 0, 0, 0, 0, '{"custom_quotas": {"trip_leave": 10, "industrial_view": 3}}', '9b4ede2a-81a2-4b5d-8c6e-7afb0a5e7792', '2026-09-17 15:39:37.364551+05:30', '2026-09-17 15:42:37.601009+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('__DEFAULTS_FACULTY__', 0, 0, 0, 0, '{"custom_quotas": {"rest_leave": 5}}', 'c85eb5f6-d2fd-43c7-bfaa-db5c38afa58d', '2026-09-17 15:39:37.364551+05:30', '2026-09-17 15:42:37.601009+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('__DEFAULTS_HOD__', 0, 0, 0, 0, '{"custom_quotas": {"trip_leave": 5}}', '5fcf30d5-233c-463e-ab8b-53a2e7f1d757', '2026-09-17 15:39:37.364551+05:30', '2026-09-17 15:42:37.601009+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('__DEFAULTS_PRINCIPAL__', 0, 0, 0, 0, '{"custom_quotas": {}}', '4531d5db-bdbe-4e52-a9f7-5b9451716dde', '2026-09-17 15:39:37.364551+05:30', '2026-09-17 15:42:37.601009+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('__ADMIN_LEAVE_TYPES__', 0, 0, 0, 0, '{"leave_types": [{"id": "lt-1789639741724-mm4c", "name": "Trip Leave", "code": "TR", "applies_to": "ALL", "default_days": 5, "allow_past_dates": true, "description": ""}, {"id": "lt-1789639765953-2d7k", "name": "Industrial view", "code": "IV", "applies_to": "ALL", "default_days": 3, "allow_past_dates": false, "description": ""}, {"id": "lt-1789639799084-0g2f", "name": "Rest Leave", "code": "RL", "applies_to": "ALL", "default_days": 5, "allow_past_dates": false, "description": ""}], "quotas": {"STUDENT": {"trip_leave": 10, "industrial_view": 3}, "FACULTY": {"rest_leave": 5}, "HOD": {"trip_leave": 5}, "PRINCIPAL": {}}}', 'fcdc6987-b1fc-40e3-a070-ef13b5034326', '2026-09-17 15:39:37.364551+05:30', '2026-09-17 15:42:37.601009+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('usr_student4', 0, 0, 0, 0, NULL, '986a5bf8-3bd8-476c-970f-827c236dc2e1', '2026-09-17 15:43:56.029464+05:30', '2026-09-17 15:43:56.029469+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('usr_student1', 0, 0, 0, 0, NULL, 'efa4f5c1-b897-4e4e-bca2-66706b89c12f', '2026-09-17 15:45:35.417867+05:30', '2026-09-17 15:45:35.417874+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('usr_student8', 0, 0, 0, 0, NULL, '3a5e543a-549a-41fa-934b-ff0c32e6df52', '2026-09-17 15:46:02.271622+05:30', '2026-09-17 15:46:02.271628+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('usr_arya', 0, 0, 0, 0, NULL, '46cb93ec-e9e6-418e-b66d-8624a2210ad9', '2026-09-17 15:54:33.14422+05:30', '2026-09-17 15:54:33.144226+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('usr_kavya', 0, 0, 0, 0, NULL, '09a19fa4-a630-4999-ab75-bb45b3061f6b', '2026-09-17 15:54:44.925818+05:30', '2026-09-17 15:54:44.925826+05:30', false, NULL);
INSERT INTO public.leave_balances VALUES ('usr_palani', 0, 0, 0, 0, NULL, '29f5ec5d-d7ac-4df0-8bf2-532c4268d7ee', '2026-09-17 15:54:57.15373+05:30', '2026-09-17 15:54:57.153738+05:30', false, NULL);


--
-- Data for Name: leave_deduction_limits; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: leaves; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.leaves VALUES ('LV-0B2EEE', 'usr_student1', '[Leave] Trip Leave', '2026-09-19', '2026-09-19', 1, 'I am going to family trip', '9454375435', NULL, 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Full Day', NULL, NULL, NULL, NULL, NULL, 'UNVERIFIED', NULL, NULL, NULL, NULL, NULL, 'null', '2026-09-17 15:41:30.803018+05:30', '2026-09-17 15:41:30.803024+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-DBA486', 'usr_madhan', 'Trip Leave', '2026-09-21', '2026-09-25', 5, 'Going to ooty ', '3333333333', '/static/uploads/leaves/ebbad6f2-500d-40b4-8107-710fdc41e90c.pdf', 'PENDING_PRINCIPAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-17 15:43:14.577224+05:30', '2026-09-17 15:43:14.577231+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-16ED14', 'usr_student4', '[Leave] Trip Leave', '2026-09-21', '2026-09-22', 2, 'Trip', '9368876512', NULL, 'APPROVED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Full Day', NULL, NULL, NULL, NULL, NULL, 'UNVERIFIED', NULL, NULL, NULL, NULL, NULL, 'null', '2026-09-17 15:42:00.671846+05:30', '2026-09-17 15:43:56.055366+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-8115F3', 'usr_student5', '[Leave] Trip Leave', '2026-09-14', '2026-09-17', 4, 'Fever', '9742345678', NULL, 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Full Day', NULL, NULL, NULL, NULL, NULL, 'UNVERIFIED', NULL, NULL, NULL, NULL, NULL, 'null', '2026-09-17 15:42:09.050791+05:30', '2026-09-17 15:43:58.156026+05:30', true, NULL);
INSERT INTO public.leaves VALUES ('LV-7319E4', 'usr_student1', '[Leave] Trip Leave', '2026-09-01', '2026-09-05', 5, 'I am planning to go yercaurd trip', '9454375435', NULL, 'APPROVED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Full Day', NULL, NULL, NULL, NULL, NULL, 'UNVERIFIED', NULL, NULL, NULL, NULL, NULL, 'null', '2026-09-17 15:43:58.725936+05:30', '2026-09-17 15:45:35.423502+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-53C73F', 'usr_student5', '[Leave] Trip Leave', '2026-09-14', '2026-09-19', 6, 'Trip', '9742345678', NULL, 'REJECTED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Full Day', NULL, NULL, NULL, NULL, NULL, 'UNVERIFIED', NULL, NULL, NULL, NULL, NULL, 'null', '2026-09-17 15:44:03.283074+05:30', '2026-09-17 15:46:00.880129+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-81E884', 'usr_student8', '[Leave] Industrial view', '2026-09-18', '2026-09-19', 2, 'N/A', '9721765532', NULL, 'APPROVED', 'APPROVED', 'usr_madhan', '2026-09-17 10:16:02.275374', '', NULL, NULL, NULL, 'Full Day', NULL, NULL, NULL, NULL, NULL, 'UNVERIFIED', NULL, NULL, NULL, NULL, NULL, 'null', '2026-09-17 15:42:36.226662+05:30', '2026-09-17 15:46:02.279925+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-E0BAA7', 'usr_student1', '[Leave] Trip Leave', '2026-09-09', '2026-09-09', 1, 'I went to trip with my friends', '9454375435', NULL, 'REJECTED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Full Day', NULL, NULL, NULL, NULL, NULL, 'UNVERIFIED', NULL, NULL, NULL, NULL, NULL, 'null', '2026-09-17 15:42:58.85819+05:30', '2026-09-17 15:46:26.07381+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-BA67AB', 'usr_student4', '[Leave] Trip Leave', '2026-10-01', '2026-10-07', 6, 'trip', '9368876512', NULL, 'REJECTED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Full Day', NULL, NULL, NULL, NULL, NULL, 'UNVERIFIED', NULL, NULL, NULL, NULL, NULL, 'null', '2026-09-17 15:45:21.941064+05:30', '2026-09-17 15:48:14.400274+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-694F45', 'usr_arya', 'Rest Leave', '2026-09-18', '2026-09-19', 2, 'rest leave', '7635429754', NULL, 'APPROVED', 'APPROVED', 'usr_sobi', '2026-09-17 10:24:33.128154', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-17 15:42:20.206097+05:30', '2026-09-17 15:54:33.146679+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-B10027', 'usr_ajay', 'Rest Leave', '2026-09-18', '2026-09-19', 2, 'Casual Leave', '9876543210', NULL, 'REJECTED_BY_HOD', 'REJECTED', 'usr_sobi', '2026-09-17 10:24:42.910351', 'dont take leave', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-17 15:41:18.45935+05:30', '2026-09-17 15:54:42.911265+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-F4A82D', 'usr_kavya', 'Rest Leave', '2026-09-18', '2026-09-20', 2, 'family function', '9528963417', NULL, 'APPROVED', 'APPROVED', 'usr_madhan', '2026-09-17 10:24:44.911241', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-17 15:46:48.613582+05:30', '2026-09-17 15:54:44.927742+05:30', false, NULL);
INSERT INTO public.leaves VALUES ('LV-A67179', 'usr_palani', 'Rest Leave', '2026-09-17', '2026-09-22', 5, 'HI', '8465789651', NULL, 'APPROVED', 'APPROVED', 'usr_madhan', '2026-09-17 10:24:57.138719', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-17 15:43:35.661117+05:30', '2026-09-17 15:54:57.155048+05:30', false, NULL);


--
-- Data for Name: lecture_recordings; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: legal_event_questions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: legal_event_registrations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.legal_event_registrations VALUES ('LEH-2026-001', 'student1@gmail.com', 'student1', NULL, 'Confirmed', false, '2026-09-17T11:05:36.409202', 'fd200ffd-f3d0-48a6-8611-3f05645c0ecb', '2026-09-17 16:35:36.416979+05:30', '2026-09-17 16:35:36.416986+05:30', false, NULL);
INSERT INTO public.legal_event_registrations VALUES ('LEH-2026-002', 'student1@gmail.com', 'student1', NULL, 'Confirmed', false, '2026-09-17T11:05:39.183501', '653d5a40-1385-4c27-a3c7-3e1979564187', '2026-09-17 16:35:39.186508+05:30', '2026-09-17 16:35:39.186517+05:30', false, NULL);
INSERT INTO public.legal_event_registrations VALUES ('LEH-2026-003', 'student1@gmail.com', 'student1', NULL, 'Confirmed', false, '2026-09-17T11:05:41.174836', 'ea071463-a2d1-4061-a772-369c47d2d898', '2026-09-17 16:35:41.177754+05:30', '2026-09-17 16:35:41.177763+05:30', false, NULL);
INSERT INTO public.legal_event_registrations VALUES ('LEH-2026-001', 'student4@gmail.com', 'student4', NULL, 'Confirmed', false, '2026-09-17T11:05:44.186442', '0bb1953f-9cf2-4906-89b3-1350eefc3d51', '2026-09-17 16:35:44.189518+05:30', '2026-09-17 16:35:44.189528+05:30', false, NULL);
INSERT INTO public.legal_event_registrations VALUES ('LEH-2026-002', 'student4@gmail.com', 'student4', NULL, 'Confirmed', false, '2026-09-17T11:05:45.549157', '50fe507e-9c78-4e84-afc3-4ca17221ad9c', '2026-09-17 16:35:45.552116+05:30', '2026-09-17 16:35:45.552126+05:30', false, NULL);
INSERT INTO public.legal_event_registrations VALUES ('LEH-2026-004', 'student1@gmail.com', 'student1', NULL, 'Confirmed', false, '2026-09-17T11:05:46.381757', 'a4e2bcdb-71e2-4a30-9c7c-2f148aef51e2', '2026-09-17 16:35:46.384577+05:30', '2026-09-17 16:35:46.384586+05:30', false, NULL);
INSERT INTO public.legal_event_registrations VALUES ('LEH-2026-003', 'student4@gmail.com', 'student4', NULL, 'Confirmed', false, '2026-09-17T11:05:48.341879', '0242fce8-6e6a-45a7-b471-da7f4cd3f088', '2026-09-17 16:35:48.344833+05:30', '2026-09-17 16:35:48.344842+05:30', false, NULL);
INSERT INTO public.legal_event_registrations VALUES ('LEH-2026-004', 'student4@gmail.com', 'student4', NULL, 'Confirmed', false, '2026-09-17T11:05:50.566463', '646ef52e-fe4b-41c7-b280-04b5c7347283', '2026-09-17 16:35:50.569287+05:30', '2026-09-17 16:35:50.569297+05:30', false, NULL);


--
-- Data for Name: legal_events; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.legal_events VALUES ('LEH-2026-001', 'Constitutional Law in the Digital Age', 'Constitutional Law', '{"name": "Hon. D.Y. Chandrachud", "designation": "Former Chief Justice of India", "type": "Supreme Court Judge", "bio": "50th Chief Justice of India. Known for landmark judgments on Right to Privacy, Section 377, and Sabarimala.", "initials": "DC"}', '20 Jun 2026', '10:00 AM', '120 min', 'Registration Open', 'Online', 'Zoom Webinar', 'https://zoom.us/j/leh2026001', 500, 127, '18 Jun 2026', 'An extensive exploration of how constitutional principles are being challenged and reshaped by emerging digital technologies.', '["Fundamental Rights in the Digital Era", "Right to Privacy \u2014 Puttaswamy Judgment & Its Impact", "Data Protection & Constitutional Safeguards", "AI and the Rule of Law", "Interactive Q&A"]', 5, false, true, 'Intra-College', 'CAMS School of Law', NULL, 'all', 'All', '2026-09-17 15:30:32.489657+05:30', '2026-09-17 15:30:32.489662+05:30', false, NULL);
INSERT INTO public.legal_events VALUES ('LEH-2026-002', 'Cyber Crime Investigation & Digital Evidence', 'Cyber Law', '{"name": "Hon. Uday Umesh Lalit", "designation": "Former Chief Justice of India", "type": "Supreme Court Judge", "bio": "49th Chief Justice of India. Renowned for judicial reforms and expertise in criminal & cyber law matters.", "initials": "UL"}', '22 Jun 2026', '02:00 PM', '90 min', 'Registration Open', 'Online', 'Google Meet', 'https://meet.google.com/leh-2026-002', 300, 85, '20 Jun 2026', 'A comprehensive session on the legal framework for cyber crime investigation and admissibility of digital evidence.', '["Cyber Crime Landscape in India", "IT Act 2000 \u2014 Key Provisions & Amendments", "Digital Evidence: Collection & Admissibility", "Section 65B Certificate", "Q&A Session"]', 4, false, true, 'Intra-College', 'CAMS School of Law', NULL, 'all', 'All', '2026-09-17 15:30:32.489664+05:30', '2026-09-17 15:30:32.489665+05:30', false, NULL);
INSERT INTO public.legal_events VALUES ('LEH-2026-003', 'National Moot Court Competition 2026', 'Moot Court Workshop', '{"name": "Adv. Harish Salve", "designation": "Senior Advocate, Supreme Court of India", "type": "Senior Advocate", "bio": "Former Solicitor General of India. One of India''s leading international arbitration and constitutional lawyers.", "initials": "HS"}', '28 Jun 2026', '09:00 AM', 'Full Day', 'Upcoming', 'Hybrid', 'Moot Court Hall / Hybrid Stream', 'https://zoom.us/j/moot2026', 200, 42, '24 Jun 2026', 'Annual flagship moot court competition on International Commercial Arbitration & Constitutional Remedies.', '["Inaugural Ceremony & Keynote Address", "Preliminary Rounds", "Quarter & Semi-Finals", "Grand Finals Judged by High Court Bench", "Valedictory & Prize Distribution"]', 10, true, true, 'Inter-College', 'CAMS School of Law Moot Court Society', NULL, 'all', 'All', '2026-09-17 15:30:32.489666+05:30', '2026-09-17 15:30:32.489667+05:30', false, NULL);
INSERT INTO public.legal_events VALUES ('LEH-2026-004', 'AI, Ethics & Intellectual Property Law', 'Intellectual Property Rights', '{"name": "Prof. (Dr.) Shamnad Basheer", "designation": "Founder, SpicyIP & Legal Scholar", "type": "Legal Scholar", "bio": "Pioneering Indian legal scholar and IP law expert who founded SpicyIP and IDIA.", "initials": "SB"}', '05 Jul 2026', '11:00 AM', '90 min', 'Registration Open', 'Online', 'Zoom Webinar', 'https://zoom.us/j/leh2026004', 400, 190, '03 Jul 2026', 'Exploring copyright ownership in AI-generated works, patentability of machine learning algorithms, and global IP frameworks.', '["AI-Generated Content & Copyright Law", "Patent Law & Machine Learning Inventions", "Fair Use vs Data Scraping", "Global Regulatory Approaches (EU AI Act)", "Interactive Q&A"]', 5, true, true, 'Intra-College', 'CAMS IPR Cell', NULL, 'all', 'All', '2026-09-17 15:30:32.489668+05:30', '2026-09-17 15:30:32.489669+05:30', false, NULL);
INSERT INTO public.legal_events VALUES ('LEH-TEMP-1789643006', 'Masterclass', 'Moot Court Workshop', '{"name": "Ramesh Kumar", "designation": "Cheif justice", "type": "Supreme Court Judge", "bio": "", "initials": "RK"}', '2026-09-26', '10:00 AM', '120 min', 'Pending', 'Online', 'Zoom', 'https://cams.local/event-link', 150, 150, '2026-09-26', '', '[]', 5, false, true, 'Intra-College', 'CAMS Law College', 'usr_arya', 'deg_b_a_l_l_b_all', NULL, '2026-09-17 16:33:26.591096+05:30', '2026-09-17 16:33:26.591103+05:30', false, NULL);
INSERT INTO public.legal_events VALUES ('LEH-TEMP-1789643072', 'Research', 'Constitutional Law', '{"name": "VK", "designation": "chief", "type": "Supreme Court Judge", "bio": "", "initials": "V"}', '2026-09-17', '10:00 A.M', '120 min', 'Pending', 'Online', 'Zoom', 'https://cams.local/event-link', 150, 150, '2026-09-17', '', '[]', 5, false, true, 'Intra-College', 'CAMS Law College', 'usr_palani', 'deg_l_l_b_all', NULL, '2026-09-17 16:34:32.279313+05:30', '2026-09-17 16:34:32.279321+05:30', false, NULL);
INSERT INTO public.legal_events VALUES ('LEH-TEMP-1789643167', 'Test', 'Constitutional Law', '{"name": "Ajay", "designation": "Chennai", "type": "High Court Judge", "bio": "Biography", "initials": "A"}', '2026-09-25', '11.00 AM', '120 min', 'Pending', 'Online', 'Zoom', 'https://law-college.cubegtp.com/faculty/legal-events', 150, 150, '2026-09-24', 'Description', '["Topic 1", "Topic 2", "Topic 3"]', 5, false, true, 'Intra-College', 'CAMS Law College', 'usr_ajay', 'deg_b_a_l_l_b_all', NULL, '2026-09-17 16:36:07.870818+05:30', '2026-09-17 16:36:07.870823+05:30', false, NULL);


--
-- Data for Name: lesson_plans; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.lesson_plans VALUES ('Legal Method', '{"Introduction to Law": ["Nature & definition of law", "Sources of law (custom, precedent, legislation)", "Legal system in India"], "Political Theory": ["Concepts: State, Sovereignty, Liberty, Equality", "Theories of State", "Democracy & forms of government"]}', '6ba035f9-f021-4b23-ace6-7961701fa17c', '2026-09-16 15:39:37.898335+05:30', '2026-09-17 16:25:28.12519+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Interpretation of Statutes', '{"Rules of interpretation (literal, golden, mischief rule)": ["Internal & external aids", "Presumptions in statutory interpretation", "Legal maxims"], "Industrial Disputes Act": ["Trade Unions Act", "Minimum Wages Act", "Employee rights & working conditions"]}', '9ff5d1e2-cb1b-44f1-8d8c-6b57b8318e1d', '2026-09-16 15:57:58.342328+05:30', '2026-09-17 16:25:28.125192+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Political Science – I', '{"Introduction": ["Political law", "mode of law"], "Political science": ["Introduction", "Law of torts and width"]}', 'd87d7724-70ed-4b07-8133-37ce9098403b', '2026-09-17 15:41:28.614251+05:30', '2026-09-17 16:25:28.125192+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Law of Contract – I', '{"Offer & acceptance": ["Consideration", "Capacity to contract", "Free consent", "Void agreements"], "Hindu Law (marriage, adoption, inheritance)": ["Muslim Law basics"]}', 'd97e63df-df2a-47f0-87a6-67ac3b2ca8b1', '2026-09-16 15:44:03.454976+05:30', '2026-09-17 16:25:28.125194+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Environmental Law', '{"Environment Protection Act, 1986": ["Water Act & Air Act", "Pollution control boards", "Sustainable development"], "Industrial Disputes Act": ["Trade Unions Act", "Minimum Wages Act", "Employee rights & working conditions"]}', 'e6f66bba-1c9a-4246-8e1a-82412a9e4cfe', '2026-09-16 15:55:11.61482+05:30', '2026-09-17 16:25:28.125195+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Family Law – I', '{"Sources & Schools of Hindu Law": ["Meaning & Concept of Hindu Law", "Sources of Hindu Law", "Schools of Hindu Law"], "Marriage under Hindu Law": ["Hindu Marriage: Concept & Nature", "Conditions for a Valid Marriage (Section 5 Hindu Marriage Act, 1955)"]}', 'e738db2c-5d99-45dd-a76f-78bb2bb3df65', '2026-09-16 17:31:31.928778+05:30', '2026-09-17 16:25:28.125196+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Company Law', '{"Company formation": ["Memorandum & Articles of Association", "Directors & shareholders", "Corporate governance basics"], "Sale, mortgage, lease": ["Gift & exchange", "Transfer rules", "t2"], "Unit 3": ["Article 320", "Justice", "Article 212"]}', 'f7910173-811f-4ff9-a913-8ed3044f9aff', '2026-09-16 15:48:00.936999+05:30', '2026-09-17 16:25:28.125197+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Professional Ethics & Bar Bench Relations', '{"K Map": ["AND gate", "ORgate"]}', '06ae4cc8-e1e1-43f1-b346-677ac96eb663', '2026-09-17 15:35:10.683201+05:30', '2026-09-17 16:25:28.125184+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Sociology – I', '{"Introduction to Sociology": ["Meaning, Nature & Scope of Sociology", "Sociology as a Science", "Relationship with other Social Sciences (Law, Economics, Political Science)"], "Basic Concepts in Sociology": ["Society: Meaning & Types", "Community vs Association", "Social Stratification"]}', '28ad7730-7cd1-4d99-b225-40374b1f2f1d', '2026-09-16 17:16:06.081038+05:30', '2026-09-17 16:25:28.125188+05:30', false, NULL);
INSERT INTO public.lesson_plans VALUES ('Civil Procedure Code', '{"Company formation": ["Memorandum & Articles of Association", "Directors & shareholders", "Corporate governance basics"], "Civil Procedure Code": ["Jurisdiction of courts", "Filing of suits", "Pleadings"], "unit 3": ["t1", "t2"]}', '4b2dfda1-2fff-468a-9767-1eb7c47907f9', '2026-09-16 15:50:19.718087+05:30', '2026-09-17 16:25:28.125189+05:30', false, NULL);


--
-- Data for Name: marks; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: mentorship_records; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: notice_acknowledgements; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.notice_acknowledgements VALUES ('66c2dee7-149e-4eb0-913e-0119338cf300', 'usr_student5', false, NULL, false, NULL, 'DELIVERED', false, NULL, '7384e249-47ee-4eba-80cb-a25086787c19', '2026-09-17 16:36:28.055005+05:30', '2026-09-17 16:36:28.055011+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('66c2dee7-149e-4eb0-913e-0119338cf300', 'usr_student7', false, NULL, false, NULL, 'DELIVERED', false, NULL, '2ecbaf08-af35-4c30-ad81-36b97be3197e', '2026-09-17 16:36:28.055026+05:30', '2026-09-17 16:36:28.055027+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('66c2dee7-149e-4eb0-913e-0119338cf300', 'usr_student6', false, NULL, false, NULL, 'DELIVERED', false, NULL, 'b5ad4286-48f5-44e6-98da-6e7988e9bc2f', '2026-09-17 16:36:28.05504+05:30', '2026-09-17 16:36:28.055042+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('66c2dee7-149e-4eb0-913e-0119338cf300', 'usr_student8', false, NULL, false, NULL, 'DELIVERED', false, NULL, 'fd838a96-672c-46ca-b8e2-c4b9e8350b33', '2026-09-17 16:36:28.055052+05:30', '2026-09-17 16:36:28.055054+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('d0ba391b-575c-4304-85fa-42c84f1b2896', 'usr_palani', false, NULL, false, NULL, 'DELIVERED', false, NULL, '21f91b95-ddc1-4334-a0bd-4f26503487f4', '2026-09-17 16:37:11.501163+05:30', '2026-09-17 16:37:11.50117+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('d0ba391b-575c-4304-85fa-42c84f1b2896', 'usr_madhan', false, NULL, false, NULL, 'DELIVERED', false, NULL, 'e9c65b90-9f2a-4d84-8e35-a602dae05493', '2026-09-17 16:37:11.501191+05:30', '2026-09-17 16:37:11.501193+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('d0ba391b-575c-4304-85fa-42c84f1b2896', 'usr_student6', false, NULL, false, NULL, 'DELIVERED', false, NULL, 'e6cfb93f-b2d6-44d0-91e9-43b307f9e357', '2026-09-17 16:37:11.501208+05:30', '2026-09-17 16:37:11.50121+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('d0ba391b-575c-4304-85fa-42c84f1b2896', 'usr_kavya', false, NULL, false, NULL, 'DELIVERED', false, NULL, '66f1e3dd-6976-4d1e-a474-133ff95e6876', '2026-09-17 16:37:11.501225+05:30', '2026-09-17 16:37:11.501227+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('d0ba391b-575c-4304-85fa-42c84f1b2896', 'usr_student5', false, NULL, false, NULL, 'DELIVERED', false, NULL, '553077da-20ac-461d-8647-cf10e625a567', '2026-09-17 16:37:11.501241+05:30', '2026-09-17 16:37:11.501243+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('d0ba391b-575c-4304-85fa-42c84f1b2896', 'usr_student8', false, NULL, false, NULL, 'DELIVERED', false, NULL, 'cd00a5aa-9290-4b31-b7f0-d764a6b12dbe', '2026-09-17 16:37:11.501258+05:30', '2026-09-17 16:37:11.50126+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('d0ba391b-575c-4304-85fa-42c84f1b2896', 'usr_student7', false, NULL, false, NULL, 'DELIVERED', false, NULL, '5d3460de-711e-42d2-9d62-a2d323ce8e9d', '2026-09-17 16:37:11.501273+05:30', '2026-09-17 16:37:11.501276+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('64fb9d93-4e2a-41ca-99e8-15f40c0ac7c5', 'usr_student5', false, NULL, false, NULL, 'DELIVERED', false, NULL, '43dc5aef-aca9-4a38-ac88-f38c62c2a130', '2026-09-17 16:38:28.156096+05:30', '2026-09-17 16:38:28.156104+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('64fb9d93-4e2a-41ca-99e8-15f40c0ac7c5', 'usr_student7', false, NULL, false, NULL, 'DELIVERED', false, NULL, '81e1cd62-fadf-4b1c-bf28-9c75eb3fde33', '2026-09-17 16:38:28.156128+05:30', '2026-09-17 16:38:28.156131+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('64fb9d93-4e2a-41ca-99e8-15f40c0ac7c5', 'usr_student6', false, NULL, false, NULL, 'DELIVERED', false, NULL, 'c7712be6-9954-42fb-954c-b882830afd76', '2026-09-17 16:38:28.156151+05:30', '2026-09-17 16:38:28.156154+05:30', false, NULL);
INSERT INTO public.notice_acknowledgements VALUES ('64fb9d93-4e2a-41ca-99e8-15f40c0ac7c5', 'usr_student8', false, NULL, false, NULL, 'DELIVERED', false, NULL, '1454c1af-ee18-428b-af36-2cd4051cebfa', '2026-09-17 16:38:28.15617+05:30', '2026-09-17 16:38:28.156173+05:30', false, NULL);


--
-- Data for Name: notices; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.notices VALUES ('usr_madhan', 'Exam', 'next week', 'Notify Entire Degree', '2026-09-17', 'General Information', NULL, 'Medium', 'Active', 'HOD', NULL, NULL, NULL, NULL, NULL, '/static/uploads/announcements/bf219b31-f12a-45d2-ac3c-94dbad21864f.png', NULL, 'd0ba391b-575c-4304-85fa-42c84f1b2896', '2026-09-17 16:37:11.469894+05:30', '2026-09-17 16:37:11.469903+05:30', false, NULL);
INSERT INTO public.notices VALUES ('usr_madhan', 'Exam', 'Exam starts at next week', 'All Active Sections', '2026-09-17', 'General Information', NULL, 'Medium', 'Cancelled', 'HOD', NULL, NULL, NULL, NULL, NULL, '/static/uploads/announcements/100b60ba-442e-4d79-beb7-7441a9bb7140.png', NULL, '66c2dee7-149e-4eb0-913e-0119338cf300', '2026-09-17 16:36:28.027881+05:30', '2026-09-17 16:37:18.852983+05:30', true, NULL);
INSERT INTO public.notices VALUES ('usr_madhan', 'leave', 'leave', 'All BA LLB Students', '2026-09-17', 'General Information', NULL, 'Medium', 'Active', 'HOD', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '64fb9d93-4e2a-41ca-99e8-15f40c0ac7c5', '2026-09-17 16:38:28.131195+05:30', '2026-09-17 16:38:28.131202+05:30', false, NULL);


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.notifications VALUES ('usr_sobi', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '4865806b-98b1-4a2a-a436-c99cc12650a9', '2026-09-16 15:37:38.924397+05:30', '2026-09-16 15:37:38.924404+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '4ee062f0-22ba-4484-9d12-99c274e82249', '2026-09-16 15:37:38.924417+05:30', '2026-09-16 15:37:38.924418+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'e6b9713d-e153-49b7-9973-267794af2e5c', '2026-09-16 15:37:38.924427+05:30', '2026-09-16 15:37:38.924429+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_palani', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'c87d0c24-160b-4c73-8cf3-78d0c7a8e78e', '2026-09-16 15:37:38.924446+05:30', '2026-09-16 15:37:38.924448+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_alexa', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'b9f91112-7a4b-4e68-8713-4603ee3c17e2', '2026-09-16 17:28:20.207065+05:30', '2026-09-16 17:28:20.207073+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_alexa', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '0222231d-08f5-4b36-8eab-a04779af0290', '2026-09-17 09:49:29.355749+05:30', '2026-09-17 09:49:29.355755+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '5c99b1b2-504d-4866-9ce8-d69cf547c2dc', '2026-09-17 09:49:29.355762+05:30', '2026-09-17 09:49:29.355763+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '537ff8f1-f289-4b00-92b7-6cbea2e6cf41', '2026-09-17 09:49:29.355769+05:30', '2026-09-17 09:49:29.35577+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '457ed341-80b5-4a6b-8813-ffd410eca7b6', '2026-09-17 09:49:29.355776+05:30', '2026-09-17 09:49:29.355777+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_palani', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '6a52743f-1fd2-4f2d-ac9d-41ba257c697b', '2026-09-17 09:49:29.35579+05:30', '2026-09-17 09:49:29.355791+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'leave_request', 'Faculty Ajay has applied for Rest Leave leave from 2026-09-18 to 2026-09-19. Awaiting your review.', false, 'In-App', 'e4fcf7cd-b079-42aa-b991-40d471bca65f', '2026-09-17 15:41:18.519414+05:30', '2026-09-17 15:41:18.519418+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'leave_request', 'Student student1 has applied for leave ([Leave] Trip Leave) from 2026-09-19 to 2026-09-19.', false, 'In-App', '2f667fa9-1f1c-4c1a-b857-e4ea29a42331', '2026-09-17 15:41:30.809658+05:30', '2026-09-17 15:41:30.809663+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_parent_student1', 'leave_request', 'Your child student1 has applied for leave ([Leave] Trip Leave) from 2026-09-19 to 2026-09-19.', false, 'In-App', 'c5fcafc4-7bd4-4a99-a136-224d9459d88c', '2026-09-17 15:41:30.819227+05:30', '2026-09-17 15:41:30.819232+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_parent_student4', 'leave_request', 'Your child student4 has applied for leave ([Leave] Trip Leave) from 2026-09-21 to 2026-09-22.', false, 'In-App', '2e8a999c-5467-4f61-8d49-b033b13d9a27', '2026-09-17 15:42:00.687718+05:30', '2026-09-17 15:42:00.687723+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_palani', 'leave_request', 'Student student5 has applied for leave ([Leave] Trip Leave) from 2026-09-14 to 2026-09-17.', false, 'In-App', '491223fc-ca18-401b-a490-40b8e8278cfe', '2026-09-17 15:42:09.058748+05:30', '2026-09-17 15:42:09.058754+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_parent_student5', 'leave_request', 'Your child student5 has applied for leave ([Leave] Trip Leave) from 2026-09-14 to 2026-09-17.', false, 'In-App', 'd262c07f-19eb-4a55-bf2f-8ac688badef8', '2026-09-17 15:42:09.06773+05:30', '2026-09-17 15:42:09.067736+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'leave_request', 'Faculty Arya has applied for Rest Leave leave from 2026-09-18 to 2026-09-19. Awaiting your review.', false, 'In-App', '4ffba1f9-6334-4da3-a3b4-1d63c13417e0', '2026-09-17 15:42:20.233717+05:30', '2026-09-17 15:42:20.233723+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_parent_student8', 'leave_request', 'Your child student8 has applied for leave ([Leave] Industrial view) from 2026-09-18 to 2026-09-19.', false, 'In-App', 'e99dd175-9f38-4005-8d98-6b5e1ed3ea3a', '2026-09-17 15:42:36.237585+05:30', '2026-09-17 15:42:36.23759+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'leave_request', 'Student student1 has applied for leave ([Leave] Trip Leave) from 2026-09-09 to 2026-09-09.', false, 'In-App', 'b08a9416-2e99-46b4-a1da-65ae7f1f005f', '2026-09-17 15:42:58.865471+05:30', '2026-09-17 15:42:58.865476+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_parent_student1', 'leave_request', 'Your child student1 has applied for leave ([Leave] Trip Leave) from 2026-09-09 to 2026-09-09.', false, 'In-App', '37c10f2b-7d13-4781-9ee3-6bd729f5fa20', '2026-09-17 15:42:58.872671+05:30', '2026-09-17 15:42:58.872676+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'leave_request', 'HOD Madhan has applied for Trip Leave leave from 2026-09-21 to 2026-09-25. Awaiting your review.', false, 'In-App', '4eb9972e-143e-4072-b5c1-77651eaa31e9', '2026-09-17 15:43:14.592156+05:30', '2026-09-17 15:43:14.592163+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'leave_request', 'Faculty Palani has applied for Rest Leave leave from 2026-09-17 to 2026-09-22. Awaiting your review.', false, 'In-App', '7d47c454-e9e7-44e0-86c7-e739220cb477', '2026-09-17 15:43:35.683103+05:30', '2026-09-17 15:43:35.683112+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'leave_request', 'Student student1 has applied for leave ([Leave] Trip Leave) from 2026-09-01 to 2026-09-05.', false, 'In-App', '843b2f4b-0c38-4d27-83dc-c4602a8e8daf', '2026-09-17 15:43:58.734272+05:30', '2026-09-17 15:43:58.734278+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_parent_student1', 'leave_request', 'Your child student1 has applied for leave ([Leave] Trip Leave) from 2026-09-01 to 2026-09-05.', false, 'In-App', '74c43fa6-bd18-44ae-9b3e-aa4e8d383240', '2026-09-17 15:43:58.743892+05:30', '2026-09-17 15:43:58.743896+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_kavya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', true, 'In-App', 'fdda8afb-9b61-40e7-a8e8-41d3f25b6a89', '2026-09-17 09:49:29.355797+05:30', '2026-09-17 16:41:23.40926+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_kavya', 'leave_request', 'Student student8 has applied for leave ([Leave] Industrial view) from 2026-09-18 to 2026-09-19.', true, 'In-App', 'b2c6a164-e733-4342-a285-c1ad41ccd9ff', '2026-09-17 15:42:36.232278+05:30', '2026-09-17 16:41:29.677818+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_kavya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', true, 'In-App', 'c3efebce-6864-4e11-8128-edb09a122d1a', '2026-09-16 15:37:38.924455+05:30', '2026-09-17 16:41:34.284347+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_palani', 'leave_request', 'Student student5 has applied for leave ([Leave] Trip Leave) from 2026-09-14 to 2026-09-19.', false, 'In-App', '451f0d38-0dd3-43e7-a351-174c4d32b79e', '2026-09-17 15:44:03.297583+05:30', '2026-09-17 15:44:03.29759+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_parent_student5', 'leave_request', 'Your child student5 has applied for leave ([Leave] Trip Leave) from 2026-09-14 to 2026-09-19.', false, 'In-App', '9d6c6368-cae0-4940-88c2-704c71d2de09', '2026-09-17 15:44:03.314538+05:30', '2026-09-17 15:44:03.314545+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_parent_student4', 'leave_request', 'Your child student4 has applied for leave ([Leave] Trip Leave) from 2026-10-01 to 2026-10-07.', false, 'In-App', 'e66e8db1-4b6f-4252-b2f8-23dfee218f8c', '2026-09-17 15:45:21.964589+05:30', '2026-09-17 15:45:21.964595+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable for L.L.B - UG (Semester 3, Section A) submitted by HOD Madhan — pending approval.', false, 'In-App', '7159a256-fc22-4ba2-9106-c02f4cc33a9b', '2026-09-17 15:56:34.074402+05:30', '2026-09-17 15:56:34.074408+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable for L.L.B - UG (Semester 3, Section B) submitted by HOD Madhan — pending approval.', false, 'In-App', '23d6871d-50a5-4925-90e1-e5c530b9cdf0', '2026-09-17 16:00:22.898762+05:30', '2026-09-17 16:00:22.898768+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable for L.L.B - UG (Semester 1, Section A) submitted by HOD Madhan — pending approval.', false, 'In-App', '079d3afa-2107-4320-90ea-671db71ba2b7', '2026-09-17 16:00:30.946046+05:30', '2026-09-17 16:00:30.946053+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'leave_request', 'Student student4 has applied for leave ([Leave] Trip Leave) from 2026-10-01 to 2026-10-07.', false, 'In-App', '2a919ac7-1375-4ed1-a89d-7e55becc038f', '2026-09-17 15:45:21.951468+05:30', '2026-09-17 16:28:10.651845+05:30', true, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable for L.L.B - UG (Semester 1, Section A) submitted by HOD Madhan — pending approval.', false, 'In-App', '9fbe83e9-7984-434e-936b-9663544787e4', '2026-09-17 15:50:29.031159+05:30', '2026-09-17 15:50:29.031164+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'TIMETABLE_APPROVAL', 'Your timetable for L.L.B - UG (Semester 1, Section B) has been APPROVED by Principal Dinesh.', false, 'In-App', 'a0f829d5-fce2-4684-9aca-635dfb6312ce', '2026-09-17 16:02:43.891788+05:30', '2026-09-17 16:02:43.891794+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'leave_request', 'Faculty kavya has applied for Rest Leave leave from 2026-09-18 to 2026-09-20. Awaiting your review.', false, 'In-App', '743293df-34dd-4807-aab4-8d3c1b9eec12', '2026-09-17 15:46:48.635696+05:30', '2026-09-17 15:46:48.635704+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable for B.A.L.L.B - INTEGRATED (Semester 1, Section A) submitted by HOD Sobiya — pending approval.', false, 'In-App', 'd073fe65-ff4b-4bc3-88cb-ce80ea233fcb', '2026-09-17 15:53:09.099993+05:30', '2026-09-17 15:53:09.099998+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable change request due to faculty reallocation in L.L.B - UG submitted by HOD Madhan — pending approval.', false, 'In-App', '37d174f7-a8a2-4e81-8a90-734d23986026', '2026-09-17 15:54:32.214993+05:30', '2026-09-17 15:54:32.214999+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable for L.L.B - UG (Semester 1, Section B) submitted by HOD Madhan — pending approval.', false, 'In-App', '1590ea55-e0f8-481f-b6f9-d7ade1cc7796', '2026-09-17 15:59:16.583515+05:30', '2026-09-17 15:59:16.58352+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'TIMETABLE_APPROVAL', 'Your timetable for B.A.L.L.B - INTEGRATED (Semester 1, Section A) has been APPROVED by Principal Dinesh.', false, 'In-App', '75ffbbfe-3090-47de-8c41-e897e22115ac', '2026-09-17 16:02:28.842448+05:30', '2026-09-17 16:02:28.842453+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable for B.A.L.L.B - INTEGRATED (Semester 3, Section A) submitted by HOD Sobiya — pending approval.', false, 'In-App', '5c4164d3-e197-4c7a-9262-d17e542b8a22', '2026-09-17 16:08:58.550849+05:30', '2026-09-17 16:08:58.550855+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'TIMETABLE_APPROVAL', 'Your timetable for L.L.B - UG (Semester 3, Section B) has been APPROVED by Principal Dinesh.', false, 'In-App', '99022b18-2350-43ab-ac9f-bdff1979b05a', '2026-09-17 16:11:37.252964+05:30', '2026-09-17 16:11:37.25297+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'TIMETABLE_APPROVAL', 'Your timetable for B.A.L.L.B - INTEGRATED (Semester 3, Section A) has been APPROVED by Principal Dinesh.', false, 'In-App', '58d9fadd-2397-403a-8bcc-6e44b75c9a26', '2026-09-17 16:11:53.179908+05:30', '2026-09-17 16:11:53.179933+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'TIMETABLE_APPROVAL', 'Your timetable for L.L.B - UG (Semester 3, Section A) has been APPROVED by Principal Dinesh.', false, 'In-App', 'd35c6947-3c1f-4491-8ecd-aef25030e9bf', '2026-09-17 16:11:54.082363+05:30', '2026-09-17 16:11:54.082368+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'TIMETABLE_APPROVAL', 'Your timetable for L.L.B - UG (Semester 1, Section A) has been APPROVED by Principal Dinesh.', false, 'In-App', '2a388bf3-71e2-4fa9-b9f1-c17d8cb10b9d', '2026-09-17 16:12:00.310196+05:30', '2026-09-17 16:12:00.310202+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'marks_submission', 'Faculty Ajay has submitted End-Semester Main Exam (70 Marks) marks for Sociology – I (2026-2027).', false, 'In-App', 'cfd11c71-2126-429e-b180-d2665d514114', '2026-09-17 16:18:36.951751+05:30', '2026-09-17 16:18:36.951756+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'marks_submission', 'Faculty Arya has submitted End-Semester Main Exam (70 Marks) marks for Political Science – I (2026-2027).', false, 'In-App', '1db99da3-bb4d-406b-827b-43dfcc94380f', '2026-09-17 16:19:27.716979+05:30', '2026-09-17 16:19:27.716987+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_student1', 'marks_approval', 'Your End-Semester Main Exam (70 Marks) marks for Political Science – I (2026-2027) have been approved by the HOD.', false, 'In-App', '6981c011-3118-4d33-a176-dc9270f930c2', '2026-09-17 16:21:31.317762+05:30', '2026-09-17 16:21:31.317768+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'marks_approval', 'HOD has approved the End-Semester Main Exam (70 Marks) marks for Political Science – I (2026-2027).', false, 'In-App', '81ba717a-770f-47d6-b063-b66c32d775a6', '2026-09-17 16:21:31.32438+05:30', '2026-09-17 16:21:31.324384+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'marks_submission', 'Faculty Ajay has submitted End-Semester Main Exam (70 Marks) marks for Sociology – I (2026-2027).', false, 'In-App', '546d03ae-cc25-4af1-b0ce-426bdf94231c', '2026-09-17 16:23:39.327354+05:30', '2026-09-17 16:23:39.32736+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_student1', 'marks_approval', 'Your End-Semester Main Exam (70 Marks) marks for Sociology – I (2026-2027) have been approved by the HOD.', false, 'In-App', '9539b08c-8ae3-4ba7-99ec-e93d52e0cce8', '2026-09-17 16:25:21.057032+05:30', '2026-09-17 16:25:21.057041+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'f3774dd7-fe28-4b09-897f-024deb870793', '2026-09-16 15:37:38.924437+05:30', '2026-09-17 16:28:10.651845+05:30', true, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '19e7437f-fb63-44b9-9895-5cf442da68b8', '2026-09-17 09:49:29.355783+05:30', '2026-09-17 16:28:10.651845+05:30', true, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'leave_request', 'Student student4 has applied for leave ([Leave] Trip Leave) from 2026-09-21 to 2026-09-22.', false, 'In-App', 'a8783abf-5cb7-454a-8984-4957a0a14f14', '2026-09-17 15:42:00.679841+05:30', '2026-09-17 16:28:10.651845+05:30', true, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'leave_rejection', 'Your Rest Leave leave request (2026-09-18 to 2026-09-19) has been rejected by HOD Sobiya. Remarks: dont take leave', false, 'In-App', 'd9626ae8-197a-409a-b739-e64dc8346392', '2026-09-17 15:54:42.927525+05:30', '2026-09-17 16:28:10.651845+05:30', true, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'marks_rejection', 'HOD has returned End-Semester Main Exam (70 Marks) marks for Sociology – I (2026-2027) for 1 student(s). Please review comments, update the marks and resubmit.', false, 'In-App', '5c7df85b-4274-454a-8510-0f0a9ccef941', '2026-09-17 16:22:00.200972+05:30', '2026-09-17 16:28:10.651845+05:30', true, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'marks_approval', 'HOD has approved the End-Semester Main Exam (70 Marks) marks for Sociology – I (2026-2027).', false, 'In-App', '3fb6fc84-6cbd-459b-9ed2-ff515baecacf', '2026-09-17 16:25:21.075908+05:30', '2026-09-17 16:28:10.651845+05:30', true, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'new_event', 'New event ''Masterclass'' submitted by Faculty for review.', false, 'In-App', '38f6055b-de1f-435b-b2a0-0d7ea752a3d8', '2026-09-17 16:33:26.585903+05:30', '2026-09-17 16:33:26.585921+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'new_event', 'New event ''Research'' submitted by Faculty for review.', false, 'In-App', '3ec63d06-4ac2-42c9-82f6-cee686b6f20d', '2026-09-17 16:34:32.277246+05:30', '2026-09-17 16:34:32.277253+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'new_event', 'New event ''Test'' submitted by Faculty for review.', false, 'In-App', 'c5d3c0c8-297c-4e21-8f42-7a706f34ee8f', '2026-09-17 16:36:07.867762+05:30', '2026-09-17 16:36:07.867768+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_admin', 'grievance_raised', 'Student student5 has raised a new grievance under category ''Hostel''.', false, 'In-App', '428b1e4d-f952-476e-9bdd-cae8e76adc13', '2026-09-17 16:42:53.713363+05:30', '2026-09-17 16:42:53.713368+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'grievance_raised', 'Student student5 has raised a new grievance under category ''Hostel''.', false, 'In-App', 'f3578be0-343d-4f28-a185-ca41fbb31971', '2026-09-17 16:42:53.715801+05:30', '2026-09-17 16:42:53.715806+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_admin', 'grievance_raised', 'Student student1 has raised a new grievance under category ''Hostel''.', false, 'In-App', '51164aee-6c3e-476f-9322-9448ca07df18', '2026-09-17 16:43:03.817107+05:30', '2026-09-17 16:43:03.817114+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'grievance_raised', 'Student student1 has raised a new grievance under category ''Hostel''.', false, 'In-App', 'f97a79ef-11b1-4c0e-b336-d90934150f78', '2026-09-17 16:43:03.819933+05:30', '2026-09-17 16:43:03.819939+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_admin', 'grievance_raised', 'Student student8 has raised a new grievance under category ''IT Support''.', false, 'In-App', '45392fd5-69a5-4e2d-9d62-1054b0b424ce', '2026-09-17 16:43:36.281476+05:30', '2026-09-17 16:43:36.281481+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'grievance_raised', 'Student student8 has raised a new grievance under category ''IT Support''.', false, 'In-App', '287b7a0d-df58-4ad0-bb75-f3e8a1aae4a3', '2026-09-17 16:43:36.284179+05:30', '2026-09-17 16:43:36.284184+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_admin', 'grievance_raised', 'Student student1 has raised a new grievance under category ''Infrastructure''.', false, 'In-App', '93556fb9-dff6-4b96-a784-46b1380a304d', '2026-09-17 16:44:47.891091+05:30', '2026-09-17 16:44:47.891099+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'grievance_raised', 'Student student1 has raised a new grievance under category ''Infrastructure''.', false, 'In-App', '141ee517-655c-438e-8902-0d8d3c2709eb', '2026-09-17 16:44:47.893716+05:30', '2026-09-17 16:44:47.893723+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_admin', 'grievance_raised', 'Student student4 has raised a new grievance under category ''Transport''.', false, 'In-App', 'c493e6da-a68d-4f43-a89c-2ff98b17c0c8', '2026-09-17 16:46:24.405288+05:30', '2026-09-17 16:46:24.405297+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'grievance_raised', 'Student student4 has raised a new grievance under category ''Transport''.', false, 'In-App', '976f8059-325b-4b22-b82a-4ee23728fc7a', '2026-09-17 16:46:24.41018+05:30', '2026-09-17 16:46:24.410189+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'Request Approved', 'Your salary request (Salary Slip) for 9/2026 has been approved.', false, 'In-App', '2cc329ac-bfc6-4353-868e-644139398d98', '2026-09-17 16:57:18.636218+05:30', '2026-09-17 16:57:18.636226+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'Request Approved', 'Your salary request (Salary Slip) for 9/2026 has been approved.', false, 'In-App', '0f96fbec-ce07-4d9c-a497-5564753e27d0', '2026-09-17 17:24:34.397127+05:30', '2026-09-17 17:24:34.397135+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_alexa', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '3f77a8f9-c63e-47d3-b493-92a033766a92', '2026-09-18 17:28:33.051024+05:30', '2026-09-18 17:28:33.05103+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'e5c21500-4835-4803-af19-b41d33d5799f', '2026-09-18 17:28:33.051037+05:30', '2026-09-18 17:28:33.051038+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'd3f5b4dd-41b7-4c06-bf22-6fc69f93fd7c', '2026-09-18 17:28:33.051044+05:30', '2026-09-18 17:28:33.051045+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'bf8160e5-7fee-40a9-9a65-8be8918b945b', '2026-09-18 17:28:33.05105+05:30', '2026-09-18 17:28:33.051051+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '37624d17-7cea-4047-98a2-f17ce1d4a5aa', '2026-09-18 17:28:33.051056+05:30', '2026-09-18 17:28:33.051057+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_kavya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '80463632-c103-42b2-9bfc-e31c5fde657e', '2026-09-18 17:28:33.051062+05:30', '2026-09-18 17:28:33.051063+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_dinesh', 'TIMETABLE_APPROVAL', 'Timetable for B.A.L.L.B - INTEGRATED (Semester 1, Section A) submitted by HOD Sobiya — pending approval.', false, 'In-App', 'd2cd8182-5c73-4f2e-982b-cf13cbdfc485', '2026-09-21 19:32:46.262208+05:30', '2026-09-21 19:32:46.262213+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_alexa', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '64a7e5f7-2000-4d55-9591-82d9318fa532', '2026-09-21 19:33:58.802134+05:30', '2026-09-21 19:33:58.802139+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'd11c8314-eed3-4495-9dd1-586bb742f859', '2026-09-21 19:33:58.802147+05:30', '2026-09-21 19:33:58.802148+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '09076dd2-cad0-4af1-8537-2bdc7bc2c048', '2026-09-21 19:33:58.802154+05:30', '2026-09-21 19:33:58.802155+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '9671016b-161e-4270-84b5-eb489c1173b8', '2026-09-21 19:33:58.802161+05:30', '2026-09-21 19:33:58.802162+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'c7aa8b56-5c43-46fd-8bc8-1058c7c4aa7b', '2026-09-21 19:33:58.802167+05:30', '2026-09-21 19:33:58.802168+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_palani', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '8df08306-0b33-4887-a63e-616516714bf0', '2026-09-21 19:33:58.802174+05:30', '2026-09-21 19:33:58.802174+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_kavya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '5aedb60e-4683-4924-8228-a77f6b3afe51', '2026-09-21 19:33:58.80218+05:30', '2026-09-21 19:33:58.80218+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_alexa', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '04787153-adb3-468b-a8a0-da984823ee3a', '2026-09-22 10:23:55.517883+05:30', '2026-09-22 10:23:55.517888+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_sobi', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'e58f91c7-2945-442c-adcc-4e74b14b5576', '2026-09-22 10:23:55.517895+05:30', '2026-09-22 10:23:55.517896+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_madhan', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'f562e922-391c-4e2f-9d59-2ec5b2a6e6f6', '2026-09-22 10:23:55.517902+05:30', '2026-09-22 10:23:55.517903+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_arya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '664d92a5-c8dd-43f2-a519-9f497a3e3345', '2026-09-22 10:23:55.517909+05:30', '2026-09-22 10:23:55.51791+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_ajay', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '10d59eca-95a3-4934-a1ee-a5dbbc1c2dda', '2026-09-22 10:23:55.517915+05:30', '2026-09-22 10:23:55.517916+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_palani', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', '41665895-f391-4114-856f-a26eb9676bc9', '2026-09-22 10:23:55.517922+05:30', '2026-09-22 10:23:55.517922+05:30', false, NULL);
INSERT INTO public.notifications VALUES ('usr_kavya', 'DAILY_DIARY_REMINDER', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', false, 'In-App', 'e32337e7-4f97-44e0-928c-fd93ba7b1c39', '2026-09-22 10:23:55.517928+05:30', '2026-09-22 10:23:55.517928+05:30', false, NULL);


--
-- Data for Name: online_meetings; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: parent_student_map; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.parent_student_map VALUES ('usr_parent_student1', 'std_law_001', 'Parent', '27b5ecbb-cd98-48ae-8254-b3dfbe50cdcf', '2026-09-16 15:09:18.542735+05:30', '2026-09-16 15:09:18.542738+05:30', false, NULL);
INSERT INTO public.parent_student_map VALUES ('usr_parent_student2', 'std_law_002', 'Parent', 'b08688eb-a89c-4e63-aea2-1802a589d4ac', '2026-09-16 15:16:51.737947+05:30', '2026-09-16 15:16:51.73795+05:30', false, NULL);
INSERT INTO public.parent_student_map VALUES ('usr_parent_student3', 'std_law_007', 'Parent', '4935db23-4634-4483-8f83-1b5cc24798d5', '2026-09-16 15:18:05.462006+05:30', '2026-09-16 15:18:05.462009+05:30', false, NULL);
INSERT INTO public.parent_student_map VALUES ('usr_parent_student4', 'std_law_008', 'Parent', 'd7f43442-2b6f-4036-9f55-dc2531b43236', '2026-09-16 15:18:54.409913+05:30', '2026-09-16 15:18:54.409916+05:30', false, NULL);
INSERT INTO public.parent_student_map VALUES ('usr_parent_student5', 'std_law_009', 'Parent', '52e6b572-0650-4e1a-a440-2ff3b3d4399d', '2026-09-16 15:21:17.546487+05:30', '2026-09-16 15:21:17.54649+05:30', false, NULL);
INSERT INTO public.parent_student_map VALUES ('usr_parent_student6', 'std_law_006', 'Parent', '6018f77b-8c1c-4cd9-8f39-910522e78cba', '2026-09-16 15:22:17.873977+05:30', '2026-09-16 15:22:17.87398+05:30', false, NULL);
INSERT INTO public.parent_student_map VALUES ('usr_parent_student7', 'std_law_010', 'Parent', '6beb4b3d-b5ff-4476-96e6-d65ab9c71a70', '2026-09-16 15:23:22.678949+05:30', '2026-09-16 15:23:22.678953+05:30', false, NULL);
INSERT INTO public.parent_student_map VALUES ('usr_parent_student8', 'std_law_011', 'Parent', 'fdf484cc-ab0a-47cf-87ce-d0ef8dfa52df', '2026-09-16 15:24:05.16423+05:30', '2026-09-16 15:24:05.164233+05:30', false, NULL);


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: payroll_runs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.payroll_runs VALUES (9, 2026, 'DRAFT', 'usr_admin', NULL, 2, 110000.00, 0.00, 110000.00, NULL, NULL, NULL, NULL, '2e6d342a-7c12-412a-8afe-876d43e48cc9', '2026-09-17 16:56:48.932892+05:30', '2026-09-17 17:24:15.204048+05:30', false, NULL);


--
-- Data for Name: publication_plans; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: publication_proofs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: research_compliance; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: research_plans; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: research_progress_updates; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: research_verifications; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.rooms VALUES ('room-1789999106437', 'floor-1789999069777-429', '101', 'Classroom', 'deg_b_a_l_l_b_all', 'B.A.L.L.B', '', '1st Year', 'Single Class', 60, '2026-09-21 19:30:27.063401+05:30', '2026-09-21 19:30:27.063412+05:30', false, NULL);


--
-- Data for Name: salary; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.salary VALUES ('usr_alexa', 0.00, 0.00, 0.00, 9, 2026, 'USR_ALEX', 'Not Assigned', 14, 0, 0.00, 0.00, 0.00, 0.00, 0.00, '2026-10-20', 26, '2e6d342a-7c12-412a-8afe-876d43e48cc9', 'PENDING', NULL, 'acfcb179-cdce-4668-ba43-c7743f274944', '2026-09-17 16:56:49.058016+05:30', '2026-09-17 16:56:49.058022+05:30', false, NULL);
INSERT INTO public.salary VALUES ('usr_dinesh', 0.00, 0.00, 0.00, 9, 2026, 'USR_DINE', 'Not Assigned', 1, 0, 0.00, 0.00, 0.00, 0.00, 0.00, '2026-09-22', 26, '2e6d342a-7c12-412a-8afe-876d43e48cc9', 'PENDING', NULL, '404e444a-3758-4f0c-a0bd-f02d595935ba', '2026-09-17 16:56:49.137863+05:30', '2026-09-17 16:56:49.137868+05:30', false, NULL);
INSERT INTO public.salary VALUES ('usr_sobi', 0.00, 0.00, 0.00, 9, 2026, 'USR_SOBI', 'Not Assigned', 1, 0, 0.00, 0.00, 0.00, 0.00, 0.00, '2026-09-18', 26, '2e6d342a-7c12-412a-8afe-876d43e48cc9', 'PENDING', NULL, '1b359025-be1f-4f59-bda8-321009bb2472', '2026-09-17 16:56:49.172252+05:30', '2026-09-17 16:56:49.172256+05:30', false, NULL);
INSERT INTO public.salary VALUES ('usr_madhan', 0.00, 0.00, 0.00, 9, 2026, 'USR_MADH', 'Not Assigned', 1, 0, 0.00, 0.00, 0.00, 0.00, 0.00, '2026-09-22', 26, '2e6d342a-7c12-412a-8afe-876d43e48cc9', 'PENDING', NULL, 'efdfab2e-5a85-4001-9fbc-12a50224b249', '2026-09-17 16:56:49.195623+05:30', '2026-09-17 16:56:49.195626+05:30', false, NULL);
INSERT INTO public.salary VALUES ('usr_arya', 50000.00, 10000.00, 60000.00, 9, 2026, 'USR_ARYA', 'Professor', 1, 2, 10000.00, 0.00, 60000.00, 0.00, 0.00, '2026-09-18', 26, '2e6d342a-7c12-412a-8afe-876d43e48cc9', 'PENDING', NULL, '25033d29-f035-43d5-9ae3-881d911fdb96', '2026-09-17 16:56:49.21795+05:30', '2026-09-17 16:56:49.217953+05:30', false, NULL);
INSERT INTO public.salary VALUES ('usr_ajay', 50000.00, 0.00, 50000.00, 9, 2026, 'USR_AJAY', 'Professor', 1, 0, 0.00, 0.00, 50000.00, 0.00, 0.00, '2026-09-18', 26, '2e6d342a-7c12-412a-8afe-876d43e48cc9', 'PENDING', NULL, '58bdc3a4-9218-4bdd-8a9d-bbf2f34f625e', '2026-09-17 16:56:49.238511+05:30', '2026-09-17 16:56:49.238514+05:30', false, NULL);
INSERT INTO public.salary VALUES ('usr_palani', 0.00, 0.00, 0.00, 9, 2026, 'USR_PALA', 'Not Assigned', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '2026-09-21', 26, '2e6d342a-7c12-412a-8afe-876d43e48cc9', 'PENDING', NULL, '88cf586d-2a48-4648-9b24-994a90d4b208', '2026-09-17 16:56:49.257819+05:30', '2026-09-17 16:56:49.257821+05:30', false, NULL);
INSERT INTO public.salary VALUES ('usr_kavya', 0.00, 0.00, 0.00, 9, 2026, 'USR_KAVY', 'Not Assigned', 1, 3, 0.00, 0.00, 0.00, 0.00, 0.00, '2026-09-22', 26, '2e6d342a-7c12-412a-8afe-876d43e48cc9', 'PENDING', NULL, '7efa829e-524f-4dff-a788-8248b6cf88e1', '2026-09-17 16:56:49.27584+05:30', '2026-09-17 16:56:49.275842+05:30', false, NULL);


--
-- Data for Name: salary_allowances; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: salary_deduction_configs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: salary_revisions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.salary_revisions VALUES ('usr_ajay', 'None', 'Professor', 0.00, 0.00, 0.00, 50000.00, 0.00, 0.00, '2026-09-17', 'Salary structure assignment rollout', 'usr_admin', 'APPROVED', 'Structure assigned directly by HR/Admin', 'sal_rev_usr_ajay_20260917112622', '2026-09-17 16:56:22.385209+05:30', '2026-09-17 16:56:22.385216+05:30', false, NULL);
INSERT INTO public.salary_revisions VALUES ('usr_arya', 'None', 'Professor', 0.00, 0.00, 0.00, 50000.00, 10000.00, 0.00, '2026-09-17', 'Salary structure assignment rollout', 'usr_admin', 'APPROVED', 'Structure assigned directly by HR/Admin', 'sal_rev_usr_arya_20260917112632', '2026-09-17 16:56:33.004476+05:30', '2026-09-17 16:56:33.004484+05:30', false, NULL);


--
-- Data for Name: salary_slip_requests; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.salary_slip_requests VALUES ('usr_ajay', 'Salary Slip', 9, 2026, 'Slip', 'APPROVED', '', 'c0b257d8-28cb-4088-b67b-fd0baa2a8e9b', 'eebb0f4e-f96d-4cc7-89d5-f1bf49a23ddd', '2026-09-17 16:57:09.504186+05:30', '2026-09-17 16:57:18.646654+05:30', false, NULL);
INSERT INTO public.salary_slip_requests VALUES ('usr_arya', 'Salary Slip', 9, 2026, NULL, 'APPROVED', '', 'fba3523c-552b-4ee9-9a2d-8836e7a41f37', '36b72c7d-f470-419a-b3ea-b90afca2cc7f', '2026-09-17 16:57:19.8147+05:30', '2026-09-17 17:24:34.402618+05:30', false, NULL);


--
-- Data for Name: salary_slips; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.salary_slips VALUES ('acfcb179-cdce-4668-ba43-c7743f274944', '/uploads/payroll/salary_slip_usr_alexa_2026_9.pdf', '2026-09-17 16:56:49.098989+05:30', NULL, '518c1c65-f8b6-466c-9359-324f8dab6158', '2026-09-17 16:56:49.140373+05:30', '2026-09-17 16:56:49.140377+05:30', false, NULL);
INSERT INTO public.salary_slips VALUES ('404e444a-3758-4f0c-a0bd-f02d595935ba', '/uploads/payroll/salary_slip_usr_dinesh_2026_9.pdf', '2026-09-17 16:56:49.145303+05:30', NULL, 'eeb80072-26c6-404d-87e2-bd80fceb08b4', '2026-09-17 16:56:49.173547+05:30', '2026-09-17 16:56:49.17355+05:30', false, NULL);
INSERT INTO public.salary_slips VALUES ('1b359025-be1f-4f59-bda8-321009bb2472', '/uploads/payroll/salary_slip_usr_sobi_2026_9.pdf', '2026-09-17 16:56:49.176335+05:30', NULL, 'ccdbe5c2-f73b-44d4-8907-03b1aacec650', '2026-09-17 16:56:49.196764+05:30', '2026-09-17 16:56:49.196767+05:30', false, NULL);
INSERT INTO public.salary_slips VALUES ('efdfab2e-5a85-4001-9fbc-12a50224b249', '/uploads/payroll/salary_slip_usr_madhan_2026_9.pdf', '2026-09-17 16:56:49.199192+05:30', NULL, '49c73cda-b12d-4dee-a4d2-86339fe53ee9', '2026-09-17 16:56:49.219081+05:30', '2026-09-17 16:56:49.219083+05:30', false, NULL);
INSERT INTO public.salary_slips VALUES ('88cf586d-2a48-4648-9b24-994a90d4b208', '/uploads/payroll/salary_slip_usr_palani_2026_9.pdf', '2026-09-17 16:56:49.260606+05:30', NULL, 'bc4049b2-5e6c-4206-93fb-14076b76e983', '2026-09-17 16:56:49.276584+05:30', '2026-09-17 16:56:49.276586+05:30', false, NULL);
INSERT INTO public.salary_slips VALUES ('7efa829e-524f-4dff-a788-8248b6cf88e1', '/uploads/payroll/salary_slip_usr_kavya_2026_9.pdf', '2026-09-17 16:56:49.27843+05:30', NULL, 'aa8f17ae-349b-4303-a6a0-ff82644d83f0', '2026-09-17 16:56:49.27876+05:30', '2026-09-17 16:56:49.278761+05:30', false, NULL);
INSERT INTO public.salary_slips VALUES ('58bdc3a4-9218-4bdd-8a9d-bbf2f34f625e', '/uploads/payroll/salary_slip_usr_ajay_2026_9.pdf', '2026-09-17 16:56:49.242088+05:30', '2026-09-17 16:57:18.634234+05:30', 'c0b257d8-28cb-4088-b67b-fd0baa2a8e9b', '2026-09-17 16:56:49.258576+05:30', '2026-09-17 16:57:18.64081+05:30', false, NULL);
INSERT INTO public.salary_slips VALUES ('25033d29-f035-43d5-9ae3-881d911fdb96', '/uploads/payroll/salary_slip_usr_arya_2026_9.pdf', '2026-09-17 16:56:49.2214+05:30', '2026-09-17 17:24:34.395415+05:30', 'fba3523c-552b-4ee9-9a2d-8836e7a41f37', '2026-09-17 16:56:49.239748+05:30', '2026-09-17 17:24:34.399805+05:30', false, NULL);


--
-- Data for Name: salary_structures; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.salary_structures VALUES ('Professor', 50000.00, 0.00, 0.00, 50000.00, true, '', 'sal_struct_professor', '2026-09-17 16:56:12.203899+05:30', '2026-09-17 16:56:12.203906+05:30', false, NULL);


--
-- Data for Name: scholarship_types; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.scholarship_types VALUES ('Merit scholarship', NULL, 'percentage', 50, 'all_batches', NULL, NULL, 'all', 'sch_type_merit_scholarship', '2026-09-16 15:09:45.79304+05:30', '2026-09-16 15:09:45.793049+05:30', false, NULL);
INSERT INTO public.scholarship_types VALUES ('Sports quota', NULL, 'percentage', 10, 'all_batches', NULL, NULL, 'all', 'sch_type_sports_quota', '2026-09-16 15:10:06.073315+05:30', '2026-09-16 15:10:06.073324+05:30', false, NULL);


--
-- Data for Name: section_cohort_mappings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.section_cohort_mappings VALUES ('b54ae7c4-eaa4-4458-87f9-c0113b40100a', 'bbab245c-fc6f-443a-83d0-9722918c5160', '63ea93a1-ac32-4b5c-80a5-83e6c9f7b10a', '2026-09-17 15:49:59.995897+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('a57fee6f-7128-4b22-94f6-645caa8841c2', '99f37e4d-1b88-4a9c-bdde-b14e08ab9c29', '63ea93a1-ac32-4b5c-80a5-83e6c9f7b10a', '2026-09-17 15:50:05.07207+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('022ec6f2-e82e-4328-bd61-9c441b1922f6', '675c9af7-734d-4c86-bc0b-325dd7454f93', '63ea93a1-ac32-4b5c-80a5-83e6c9f7b10a', '2026-09-17 15:50:11.736579+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('82ad1439-a792-45fe-90b1-0937fa05cdd0', '77ab8e38-3b95-4945-aab9-f05aaa6df564', '9122c767-8dc3-476b-bb2b-404c879eb50d', '2026-09-17 15:50:59.089944+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('613ad608-6a4c-4d62-9fe1-7031d4b83415', 'bc62d232-0f14-4502-bb02-9c02c9999c77', '526b40cc-615d-44b0-9a32-cada66c5ed0f', '2026-09-17 15:50:59.487777+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('ccca00e9-a46e-4ed0-ab5b-83f9d6d96d83', 'a2d272e3-8fa8-4572-a228-8131c00adf18', '526b40cc-615d-44b0-9a32-cada66c5ed0f', '2026-09-17 15:51:03.296519+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('78a49b5d-f055-4739-8060-5cbc3e78715a', '01b45777-f5e9-42cc-ad29-e2da870f6f6a', '9122c767-8dc3-476b-bb2b-404c879eb50d', '2026-09-17 15:51:37.483619+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('76505a09-5e00-4d75-9dc6-952edda5bace', '467d4535-3637-43c4-8c30-23fcb05e20fc', '9122c767-8dc3-476b-bb2b-404c879eb50d', '2026-09-17 15:52:11.215662+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('e9588304-5b3a-4661-8a6d-83298f501bbf', 'c34ee2a5-5e86-4029-bbfa-664ed3ef35c3', '9122c767-8dc3-476b-bb2b-404c879eb50d', '2026-09-17 15:52:29.85309+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('66540429-062d-481d-9844-1546fd782b8d', '540c2321-3edb-4ecd-96d3-a98180c05fe5', '9122c767-8dc3-476b-bb2b-404c879eb50d', '2026-09-17 15:53:02.064602+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('dae9b9e2-f5e2-4a59-91f9-cd2a18c5780d', '9372d339-f6fe-424c-b51e-62b8ebcae451', '63ea93a1-ac32-4b5c-80a5-83e6c9f7b10a', '2026-09-17 15:55:58.596768+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('ebf4b7ee-5818-4912-9df8-2e9c917205be', '90afd3df-3b8b-46dc-91d4-7871dcbf9b24', '895142a8-e819-422e-8ff5-ab0cbfc30af1', '2026-09-17 15:56:56.950479+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('1c20981d-bf27-499e-8098-0074941a6e8a', '7a1ca373-30b0-4fac-83c0-c76d0076ca21', '07f0b2f5-6a35-481f-a1f7-c62846c1a475', '2026-09-17 15:59:40.120206+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('2e9f0a75-aed7-49cf-90f4-e69260aca92e', 'cfb8ce0c-1eac-4d18-968d-fe84271684f8', '07f0b2f5-6a35-481f-a1f7-c62846c1a475', '2026-09-17 16:00:01.538034+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('8b4fe6a9-aa08-409f-8e40-75021c8c511c', '76f163b3-00d5-428e-8296-330e06dc1c90', '381940f2-d10b-4e26-aaa7-3c48d054e57e', '2026-09-17 16:05:31.023216+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('53433815-5cc7-4971-aaae-80f8b16c2f81', 'da247040-a46e-423e-810f-7806cb39c212', '381940f2-d10b-4e26-aaa7-3c48d054e57e', '2026-09-17 16:05:44.741976+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('d6f3a82d-c94a-4545-ab0e-913968ad2e21', '2933dae4-9897-450e-be92-4bb5452acd27', '381940f2-d10b-4e26-aaa7-3c48d054e57e', '2026-09-17 16:06:03.413426+05:30');
INSERT INTO public.section_cohort_mappings VALUES ('5fe664b3-4c67-4ba0-91e9-6e729d1a8e92', '8e6d880f-12d6-42bb-9ee2-100b6eb6fcf1', '381940f2-d10b-4e26-aaa7-3c48d054e57e', '2026-09-17 16:06:15.528091+05:30');


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', NULL, 30, '8269988b-edc9-4c92-80a6-8b2ff0e87d54', '2026-09-16 17:05:32.918344+05:30', '2026-09-16 17:05:32.918353+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', NULL, 30, '9b61ee15-c1ec-4108-b30d-cf071eb9540f', '2026-09-16 17:05:32.922693+05:30', '2026-09-16 17:05:32.922701+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', NULL, 30, 'f4a85875-319a-43ff-8a0a-14348cee8927', '2026-09-16 17:05:32.92527+05:30', '2026-09-16 17:05:32.925278+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'B', NULL, 30, 'cac8e40a-175c-442a-b587-184c3d7e2902', '2026-09-16 17:05:32.927835+05:30', '2026-09-16 17:05:32.927842+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'B', NULL, 30, '0e27f050-9a7f-45a7-9652-5ccc2fd058e2', '2026-09-16 17:05:32.930212+05:30', '2026-09-16 17:05:32.930219+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_contract___i_b_a_l_l_b_all', 'B', NULL, 30, 'd52c9210-1211-4576-b6f9-a066bc79a639', '2026-09-16 17:05:32.932626+05:30', '2026-09-16 17:05:32.932633+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_family_law___i_b_a_l_l_b_all', 'B', NULL, 30, '78010905-66aa-4c55-9e92-89e6df3c2fbc', '2026-09-16 17:05:32.934826+05:30', '2026-09-16 17:05:32.934833+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_constitutional_law___i_b_a_l_l_b_all', 'B', NULL, 30, 'f251c4fb-f2cf-46c9-a7fa-5dee7d52301b', '2026-09-16 17:05:32.936799+05:30', '2026-09-16 17:05:32.936806+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_torts_b_a_l_l_b_all', 'B', NULL, 30, 'c6bffeab-266e-4dd0-ac86-441f510fd4ee', '2026-09-16 17:05:32.939161+05:30', '2026-09-16 17:05:32.939167+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_language___legal_writing_b_a_l_l_b_all', 'B', NULL, 30, 'bde8e754-2bcf-42bd-ab9d-f4f27e976a23', '2026-09-16 17:05:32.940919+05:30', '2026-09-16 17:05:32.940924+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', NULL, 20, '77ab8e38-3b95-4945-aab9-f05aaa6df564', '2026-09-16 17:05:32.942678+05:30', '2026-09-16 17:05:32.942683+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', NULL, 20, '01b45777-f5e9-42cc-ad29-e2da870f6f6a', '2026-09-16 17:05:32.944259+05:30', '2026-09-16 17:05:32.944265+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', NULL, 20, '467d4535-3637-43c4-8c30-23fcb05e20fc', '2026-09-16 17:05:32.946011+05:30', '2026-09-16 17:05:32.946016+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', NULL, 20, 'c34ee2a5-5e86-4029-bbfa-664ed3ef35c3', '2026-09-16 17:05:32.947751+05:30', '2026-09-16 17:05:32.947757+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', NULL, 20, '540c2321-3edb-4ecd-96d3-a98180c05fe5', '2026-09-16 17:05:32.949311+05:30', '2026-09-16 17:05:32.949317+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_contract___i_b_a_l_l_b_all', 'A', NULL, 20, '76f163b3-00d5-428e-8296-330e06dc1c90', '2026-09-16 17:05:32.950882+05:30', '2026-09-16 17:05:32.950887+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_family_law___i_b_a_l_l_b_all', 'A', NULL, 20, 'da247040-a46e-423e-810f-7806cb39c212', '2026-09-16 17:05:32.952447+05:30', '2026-09-16 17:05:32.952452+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_constitutional_law___i_b_a_l_l_b_all', 'A', NULL, 20, '2933dae4-9897-450e-be92-4bb5452acd27', '2026-09-16 17:05:32.954002+05:30', '2026-09-16 17:05:32.954007+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_torts_b_a_l_l_b_all', 'A', NULL, 20, '8e6d880f-12d6-42bb-9ee2-100b6eb6fcf1', '2026-09-16 17:05:32.955567+05:30', '2026-09-16 17:05:32.955573+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_language___legal_writing_b_a_l_l_b_all', 'A', NULL, 20, '29c355b9-8be5-4718-9732-bdbea0172a4e', '2026-09-16 17:05:32.957055+05:30', '2026-09-16 17:05:32.957061+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '953fc462-9b21-4113-9d5e-6e7870d82106', '2026-09-16 17:12:47.297416+05:30', '2026-09-16 17:12:47.297423+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '8a1edd33-42fe-4e38-9e86-a846cdfe8d5a', '2026-09-16 17:12:47.326438+05:30', '2026-09-16 17:12:47.326443+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '89504364-f8d5-49c2-b44e-667501be4c45', '2026-09-16 17:16:44.693413+05:30', '2026-09-16 17:16:44.693419+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, 'a1b2bda6-0e80-4540-a9a8-3280a47a649f', '2026-09-16 17:16:44.715764+05:30', '2026-09-16 17:16:44.715769+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, '53b35d03-0971-4581-801f-b10d55d83085', '2026-09-16 17:16:44.735205+05:30', '2026-09-16 17:16:44.73521+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '9e73a8be-158f-44fa-832e-f97ebd3b055f', '2026-09-16 17:18:43.340488+05:30', '2026-09-16 17:18:43.340519+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_arya', 60, '4539d7d6-6300-4c23-8693-65255ac0a7ab', '2026-09-16 17:18:43.355335+05:30', '2026-09-16 17:18:43.35534+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '1423421b-01c8-4543-92f5-6a3fb98f87a2', '2026-09-16 17:18:43.367012+05:30', '2026-09-16 17:18:43.367016+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, '36ae5b25-355a-4fa2-ae25-419d475c9a57', '2026-09-16 17:18:43.377761+05:30', '2026-09-16 17:18:43.377765+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, '5088136a-4458-4e7f-b1fb-e62b893d4933', '2026-09-16 17:18:43.388306+05:30', '2026-09-16 17:18:43.38831+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_family_law___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '7c9bd057-3aac-466e-88fc-45101c0a15aa', '2026-09-16 17:32:52.298201+05:30', '2026-09-16 17:32:52.298208+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_contract___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '620b7226-3d77-436b-8c67-8e5b331bd928', '2026-09-16 17:32:52.326895+05:30', '2026-09-16 17:32:52.326902+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_family_law___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '92b347b8-9115-49e0-8a82-709b60c421ba', '2026-09-16 17:33:11.236759+05:30', '2026-09-16 17:33:11.236767+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_family_law___i_b_a_l_l_b_all', 'B', 'usr_alexa', 60, 'f3ff06dc-7d85-478b-9b81-fb9a98b49022', '2026-09-16 17:33:11.265768+05:30', '2026-09-16 17:33:11.265774+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_contract___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, 'b6bb2eff-9c29-443f-a433-a0dc8a3ba1a6', '2026-09-16 17:33:11.289974+05:30', '2026-09-16 17:33:11.28998+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_contract___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '400ac41a-313e-4798-be0c-71e013edd658', '2026-09-16 17:33:11.309955+05:30', '2026-09-16 17:33:11.309962+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_company_law_l_l_b_all', 'B', NULL, 10, '5b130fcb-3ccb-41e6-b503-577bc9d7c9b7', '2026-09-17 15:19:09.850365+05:30', '2026-09-17 15:19:09.850372+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_civil_procedure_code_l_l_b_all', 'B', NULL, 10, 'a724aa3e-1e2b-4d59-bac6-e0756915f0b2', '2026-09-17 15:19:09.858475+05:30', '2026-09-17 15:19:09.85848+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_criminal_procedure_code_l_l_b_all', 'B', NULL, 10, '90afd3df-3b8b-46dc-91d4-7871dcbf9b24', '2026-09-17 15:19:09.86068+05:30', '2026-09-17 15:19:09.860685+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_environmental_law_l_l_b_all', 'B', NULL, 10, '7a1ca373-30b0-4fac-83c0-c76d0076ca21', '2026-09-17 15:19:09.862761+05:30', '2026-09-17 15:19:09.862765+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_interpretation_of_statutes_l_l_b_all', 'B', NULL, 10, 'f247411b-a086-4054-ae1a-0e4af38d1dd6', '2026-09-17 15:19:09.864168+05:30', '2026-09-17 15:19:09.864172+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_professional_l_l_b_all', 'B', NULL, 10, 'cfb8ce0c-1eac-4d18-968d-fe84271684f8', '2026-09-17 15:19:09.865561+05:30', '2026-09-17 15:19:09.865564+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_environmental_law_l_l_b_all', 'A', NULL, 1, 'bc62d232-0f14-4502-bb02-9c02c9999c77', '2026-09-17 15:19:09.871147+05:30', '2026-09-17 15:19:09.871151+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_interpretation_of_statutes_l_l_b_all', 'A', NULL, 1, 'a2d272e3-8fa8-4572-a228-8131c00adf18', '2026-09-17 15:19:09.873064+05:30', '2026-09-17 15:19:09.873067+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_professional_l_l_b_all', 'A', NULL, 1, '7f698e0b-a841-4e90-8051-d91fa938f685', '2026-09-17 15:19:09.874428+05:30', '2026-09-17 15:19:09.874431+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'b460d376-1a42-4ff5-a129-59efa76e791b', '2026-09-17 15:20:52.232333+05:30', '2026-09-17 15:20:52.232339+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '3343df3c-6eb7-4910-b690-afb5eb20f649', '2026-09-17 15:20:52.257605+05:30', '2026-09-17 15:20:52.25761+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_arya', 60, '8d919413-0b7b-4473-861c-5197194ebbca', '2026-09-17 15:20:52.279333+05:30', '2026-09-17 15:20:52.279338+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '6d0310f8-9189-4e40-9b17-836c51a66e04', '2026-09-17 15:20:52.296263+05:30', '2026-09-17 15:20:52.296267+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, '0c3a9757-21d4-470b-b409-9d3e6b67e67f', '2026-09-17 15:20:52.312922+05:30', '2026-09-17 15:20:52.312927+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, 'a6b6b7e7-a48f-4ed3-a7e3-6331d91ea57a', '2026-09-17 15:20:52.330449+05:30', '2026-09-17 15:20:52.330453+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'f4c33be1-0ab4-43a5-84d9-49692881b663', '2026-09-17 15:21:04.88309+05:30', '2026-09-17 15:21:04.883097+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '753cdf65-b390-419b-860f-1a6fcb38cdcf', '2026-09-17 15:21:04.931031+05:30', '2026-09-17 15:21:04.931035+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '4d833fe1-caed-4c79-a5a0-be86fe186aa3', '2026-09-17 15:21:04.954495+05:30', '2026-09-17 15:21:04.954498+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_arya', 60, 'ed42a79e-1559-4d5c-bb4b-cc742a0fcfb0', '2026-09-17 15:21:04.967241+05:30', '2026-09-17 15:21:04.967244+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '2d1e85fc-0438-42e5-bc15-a27fed1544c3', '2026-09-17 15:21:04.980125+05:30', '2026-09-17 15:21:04.980129+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, '15bb0641-19df-4abd-a590-3d240304b479', '2026-09-17 15:21:04.992325+05:30', '2026-09-17 15:21:04.992328+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, '882c2595-538f-4211-b120-9a612b50d3fb', '2026-09-17 15:21:05.004412+05:30', '2026-09-17 15:21:05.004416+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '27df86bb-f564-4a3b-9c21-bf2f05865a2b', '2026-09-17 15:21:30.820429+05:30', '2026-09-17 15:21:30.820435+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, 'f89230bc-b64e-41da-ab67-4ef7669c546c', '2026-09-17 15:21:30.836337+05:30', '2026-09-17 15:21:30.836341+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '1f2a72c1-eea9-42b3-97e3-090b6c743cc4', '2026-09-17 15:21:30.849871+05:30', '2026-09-17 15:21:30.849875+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_arya', 60, 'c9d13c61-8fc9-4bb2-bbea-d30913083dcf', '2026-09-17 15:21:30.860974+05:30', '2026-09-17 15:21:30.860978+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '61428bdf-4d3f-40aa-a5fb-48668292139c', '2026-09-17 15:21:30.870906+05:30', '2026-09-17 15:21:30.870908+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, '64708448-e5d2-410c-b707-32100ca03dff', '2026-09-17 15:21:30.880416+05:30', '2026-09-17 15:21:30.880419+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '2a51b2cd-5326-4125-b6eb-37b3f4f17659', '2026-09-17 15:21:30.890205+05:30', '2026-09-17 15:21:30.890208+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, 'c2f7c645-27d5-4e3c-a33a-2b7243dc2ad8', '2026-09-17 15:21:30.899312+05:30', '2026-09-17 15:21:30.899315+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '13a0100e-3b10-474e-8ee1-8aa13ce38052', '2026-09-17 15:21:53.026107+05:30', '2026-09-17 15:21:53.026113+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '4518c531-3e07-47ca-8bec-4dc3f50daa96', '2026-09-17 15:21:53.052203+05:30', '2026-09-17 15:21:53.052209+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'c35574aa-2ce2-4e8e-a5f0-9f538d26f127', '2026-09-17 15:21:53.108967+05:30', '2026-09-17 15:21:53.10897+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_arya', 60, '6ca8bb0e-a265-4e25-9680-a4d789abc3a6', '2026-09-17 15:21:53.121306+05:30', '2026-09-17 15:21:53.121309+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '11655ab7-a12e-4d39-aa30-58baf4178348', '2026-09-17 15:21:53.133414+05:30', '2026-09-17 15:21:53.133417+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, 'fb86080b-77c7-475d-a86d-13aae855f3aa', '2026-09-17 15:21:53.144901+05:30', '2026-09-17 15:21:53.144904+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_alexa', 60, '11faedad-0961-4e79-bd6c-14e144d15a68', '2026-09-17 15:21:53.156376+05:30', '2026-09-17 15:21:53.156379+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, 'a822fc84-2462-4a8f-9f7d-da46e80e9ab8', '2026-09-17 15:21:53.166889+05:30', '2026-09-17 15:21:53.166892+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '1ad250eb-f3d4-4375-9357-3ef90c2a358a', '2026-09-17 15:22:29.2287+05:30', '2026-09-17 15:22:29.228706+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'B', 'usr_alexa', 60, '2e5f7f1c-346f-4f39-b13d-9a3f4efd282d', '2026-09-17 15:22:29.252424+05:30', '2026-09-17 15:22:29.25243+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '596963c6-ed66-4e24-a2d3-3d8ee44c4f65', '2026-09-17 15:22:29.275407+05:30', '2026-09-17 15:22:29.275412+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, 'f2e8dc5e-1453-473b-95a8-42ddebb349c8', '2026-09-17 15:22:29.294904+05:30', '2026-09-17 15:22:29.294909+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'b83ea34d-a360-4880-9559-be6a8dc9de34', '2026-09-17 15:22:29.314132+05:30', '2026-09-17 15:22:29.314137+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_arya', 60, '8f6257b2-ef3b-4944-b3ee-ac87c57cd479', '2026-09-17 15:22:29.332652+05:30', '2026-09-17 15:22:29.332656+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_sobi', 60, 'ed87d512-9d65-4f54-aa4c-03730ce6fd28', '2026-09-17 15:22:29.35007+05:30', '2026-09-17 15:22:29.350075+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, '5ac0e283-2da0-45e9-9f35-05ed4e9c7718', '2026-09-17 15:22:29.364698+05:30', '2026-09-17 15:22:29.364703+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_alexa', 60, '13ab9384-fc0e-46a0-a5c5-45cecc8aebad', '2026-09-17 15:22:29.377469+05:30', '2026-09-17 15:22:29.377473+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, '0eb0f6c0-5820-46bf-bdad-881ef25a32ba', '2026-09-17 15:22:29.387991+05:30', '2026-09-17 15:22:29.387995+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_environmental_law_l_l_b_all', 'A', 'usr_kavya', 60, 'a18a5a3e-bc73-4746-b538-ca0aa522641b', '2026-09-17 15:22:58.390902+05:30', '2026-09-17 15:22:58.390921+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'e0e95c89-acf3-461e-9aac-5733f8a29985', '2026-09-17 15:35:13.047398+05:30', '2026-09-17 15:35:13.047405+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'B', 'usr_alexa', 60, '7e6a83a0-6138-42e4-a80f-05b9c6368074', '2026-09-17 15:35:13.070961+05:30', '2026-09-17 15:35:13.070967+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, 'bc877569-d15c-4cdf-954c-3427a44ec571', '2026-09-17 15:35:13.092197+05:30', '2026-09-17 15:35:13.092202+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, 'a9e0811d-cfb9-4818-9d3a-8c630c7727ef', '2026-09-17 15:35:13.111198+05:30', '2026-09-17 15:35:13.111203+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '77f0dd23-d554-4e4c-8abf-98ba898980dd', '2026-09-17 15:35:13.131268+05:30', '2026-09-17 15:35:13.131274+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_arya', 60, '7d51ddbd-7e1c-4592-ad6f-864ce9189dc1', '2026-09-17 15:35:13.150285+05:30', '2026-09-17 15:35:13.15029+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, 'af4edbca-704c-4eb7-b384-804d9ce8ccc7', '2026-09-17 15:35:13.168193+05:30', '2026-09-17 15:35:13.168198+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, '92427cb5-6d33-4e13-9bd0-b145b7bacada', '2026-09-17 15:35:13.182798+05:30', '2026-09-17 15:35:13.182802+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '3f0602d4-80ee-4697-896d-cc93c3c52fb6', '2026-09-17 15:35:13.19479+05:30', '2026-09-17 15:35:13.194794+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, 'b42e5157-b876-4641-bb25-cdbd393ac067', '2026-09-17 15:35:13.205251+05:30', '2026-09-17 15:35:13.205254+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_civil_procedure_code_l_l_b_all', 'A', 'usr_kavya', 60, '0aebb289-2657-400d-b602-dd687016c430', '2026-09-17 15:35:34.591772+05:30', '2026-09-17 15:35:34.59178+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_civil_procedure_code_l_l_b_all', 'A', 'usr_kavya', 60, 'ca153080-927d-4559-b9a9-fbc5388b731b', '2026-09-17 15:35:45.467973+05:30', '2026-09-17 15:35:45.467978+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_company_law_l_l_b_all', 'A', 'usr_palani', 60, '0ad4719a-900e-4875-bf97-5b7f307288c5', '2026-09-17 15:35:45.494272+05:30', '2026-09-17 15:35:45.494278+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_criminal_procedure_code_l_l_b_all', 'A', 'usr_palani', 60, '9372d339-f6fe-424c-b51e-62b8ebcae451', '2026-09-17 15:35:45.514296+05:30', '2026-09-17 15:35:45.514301+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '51cf6953-8291-4c68-aa45-11aa8202e59a', '2026-09-17 15:36:01.503465+05:30', '2026-09-17 15:36:01.503472+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'B', 'usr_alexa', 60, 'f2ca36d0-5f86-422d-8dcc-bd4b65c28f03', '2026-09-17 15:36:01.527154+05:30', '2026-09-17 15:36:01.527159+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '7fc69c2f-7b88-4714-971a-2ee3fee6d4bf', '2026-09-17 15:36:01.549117+05:30', '2026-09-17 15:36:01.549123+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '1ca63a78-1516-45e8-8512-15d5c2b1b845', '2026-09-17 15:36:01.568033+05:30', '2026-09-17 15:36:01.568038+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '9799589b-9cad-4f94-9686-387e4070db24', '2026-09-17 15:36:01.584637+05:30', '2026-09-17 15:36:01.584641+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_arya', 60, '64fb19de-207f-4a46-b025-5b55b048f0b0', '2026-09-17 15:36:01.600349+05:30', '2026-09-17 15:36:01.600353+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '7414073f-ba97-4713-85a9-b24d3167d09f', '2026-09-17 15:36:01.612936+05:30', '2026-09-17 15:36:01.612939+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, 'becd10de-2d5f-402b-9189-7e6dcac47e2d', '2026-09-17 15:36:01.623057+05:30', '2026-09-17 15:36:01.623061+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'ff467e0b-8382-41c6-a07c-4185229c164c', '2026-09-17 15:36:01.633773+05:30', '2026-09-17 15:36:01.633776+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, 'dd8f5dc8-b023-4bb0-9a65-35b97d08daca', '2026-09-17 15:36:01.643323+05:30', '2026-09-17 15:36:01.643326+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_civil_procedure_code_l_l_b_all', 'A', 'usr_kavya', 60, '67ae375b-88ab-4040-bf23-a65447179888', '2026-09-17 15:36:38.725062+05:30', '2026-09-17 15:36:38.72507+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_civil_procedure_code_l_l_b_all', 'B', 'usr_kavya', 60, '4b012915-2951-446e-9c5c-5ffb17632d82', '2026-09-17 15:36:38.746433+05:30', '2026-09-17 15:36:38.746439+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_company_law_l_l_b_all', 'A', 'usr_palani', 60, '956de5f8-fd87-4073-9a22-10b674edc921', '2026-09-17 15:36:38.76643+05:30', '2026-09-17 15:36:38.766436+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_company_law_l_l_b_all', 'B', 'usr_kavya', 60, '4d90e4f0-6eba-4d1e-a87a-85a0f81aa062', '2026-09-17 15:36:38.785223+05:30', '2026-09-17 15:36:38.785229+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_criminal_procedure_code_l_l_b_all', 'A', 'usr_palani', 60, '67f68a57-2487-43ee-92e8-f0ea68aad7cf', '2026-09-17 15:36:38.803203+05:30', '2026-09-17 15:36:38.803208+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_criminal_procedure_code_l_l_b_all', 'B', 'usr_madhan', 60, '240afb0a-786f-425a-8c95-ffd8e0574670', '2026-09-17 15:36:38.820851+05:30', '2026-09-17 15:36:38.820856+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_environmental_law_l_l_b_all', 'A', 'usr_kavya', 60, '82c42da8-1589-41ac-9a81-a06a21d9d029', '2026-09-17 15:36:51.733065+05:30', '2026-09-17 15:36:51.733071+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_interpretation_of_statutes_l_l_b_all', 'A', 'usr_palani', 60, 'e7cdb1c0-fc75-45f3-90ac-57649ff42a3e', '2026-09-17 15:36:51.754054+05:30', '2026-09-17 15:36:51.754059+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_professional_l_l_b_all', 'A', 'usr_palani', 60, 'cffc2627-60af-4776-a054-74f8a476ae7c', '2026-09-17 15:36:51.774408+05:30', '2026-09-17 15:36:51.774413+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_environmental_law_l_l_b_all', 'A', 'usr_kavya', 60, '1dc577b9-c821-4593-b216-156607c28f81', '2026-09-17 15:37:07.158962+05:30', '2026-09-17 15:37:07.158969+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_environmental_law_l_l_b_all', 'B', 'usr_palani', 60, 'd391142d-1c7d-4f3b-bc27-6a53ccc8e5a2', '2026-09-17 15:37:07.17762+05:30', '2026-09-17 15:37:07.177625+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_interpretation_of_statutes_l_l_b_all', 'A', 'usr_palani', 60, '9bc851f3-e5e4-4f21-9c65-db3ecde3d7b4', '2026-09-17 15:37:07.193745+05:30', '2026-09-17 15:37:07.193749+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_interpretation_of_statutes_l_l_b_all', 'B', 'usr_kavya', 60, '6fd27144-52b6-43b7-a75b-6c5689b45f9b', '2026-09-17 15:37:07.20832+05:30', '2026-09-17 15:37:07.208324+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_professional_l_l_b_all', 'A', 'usr_palani', 60, '3c9d02ca-0255-4cf4-a51f-6553bcca3fa0', '2026-09-17 15:37:07.219756+05:30', '2026-09-17 15:37:07.21976+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_professional_l_l_b_all', 'B', 'usr_madhan', 60, 'e624ba00-feda-4b6d-a808-8ee55700785b', '2026-09-17 15:37:07.230075+05:30', '2026-09-17 15:37:07.230078+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'e0728f81-8bfb-4d71-a66d-2e3aa05e9287', '2026-09-17 15:38:38.430397+05:30', '2026-09-17 15:38:38.430403+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'B', 'usr_alexa', 60, '47b24546-c38b-4b4a-9181-1a00e9b3b3df', '2026-09-17 15:38:38.453036+05:30', '2026-09-17 15:38:38.453042+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '52104c46-410a-4222-98c8-17f3cf1d4902', '2026-09-17 15:38:38.475909+05:30', '2026-09-17 15:38:38.475933+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '298fe73b-8c76-42c9-a1ad-bbd94429cc04', '2026-09-17 15:38:38.49631+05:30', '2026-09-17 15:38:38.496315+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'c5d1eb22-efef-4fa8-9d8e-4c052c9b6fb2', '2026-09-17 15:38:38.515929+05:30', '2026-09-17 15:38:38.515934+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '9927cc03-e967-4411-ae0c-0241f5119d06', '2026-09-17 15:38:38.534247+05:30', '2026-09-17 15:38:38.534252+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, 'e606ae6f-3957-4ce1-8da4-05f69675852d', '2026-09-17 15:38:38.552776+05:30', '2026-09-17 15:38:38.552781+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '7f46d994-f9ce-4011-b7ac-670a26453e7b', '2026-09-17 15:38:38.568321+05:30', '2026-09-17 15:38:38.568325+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '064aa62f-72dd-4211-a50b-537fab73e9f3', '2026-09-17 15:38:38.581015+05:30', '2026-09-17 15:38:38.581019+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, '0c1597e5-c46d-414f-ae79-49ab7bc0ab1d', '2026-09-17 15:38:38.591466+05:30', '2026-09-17 15:38:38.591469+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, 'f918ec74-3d56-4618-8827-b9ee9187e0bd', '2026-09-17 15:41:50.29534+05:30', '2026-09-17 15:41:50.295346+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'B', 'usr_alexa', 60, '879f3f4e-7ff3-4097-9e13-2533b9cad831', '2026-09-17 15:41:50.312473+05:30', '2026-09-17 15:41:50.312478+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '674b6192-6d57-4c27-b158-2e7fd0e2263d', '2026-09-17 15:41:50.327864+05:30', '2026-09-17 15:41:50.327868+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '89bc496a-dcec-4fc3-978c-7072398ee747', '2026-09-17 15:41:50.34058+05:30', '2026-09-17 15:41:50.340584+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '1e85c783-9a49-43b8-91cf-37568ad3901b', '2026-09-17 15:41:50.351879+05:30', '2026-09-17 15:41:50.351882+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '996b3cd7-ecc3-4d21-b463-538769b2eb1d', '2026-09-17 15:41:50.361873+05:30', '2026-09-17 15:41:50.361876+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '0298b948-6443-4a93-8ec5-9da9cbf047b3', '2026-09-17 15:41:50.371676+05:30', '2026-09-17 15:41:50.371679+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, 'cb4afb02-6b8b-45fd-b145-75eb0ce30b9e', '2026-09-17 15:41:50.381317+05:30', '2026-09-17 15:41:50.38132+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '17d2d6d9-8c5f-4844-aedf-6dae1c473cb4', '2026-09-17 15:41:50.391002+05:30', '2026-09-17 15:41:50.391005+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, '827248b5-9ef9-454c-8759-bcbaf3299d25', '2026-09-17 15:41:50.400375+05:30', '2026-09-17 15:41:50.400378+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '033f31e2-bfb7-46e7-a091-e67f348da3ee', '2026-09-17 15:42:11.909083+05:30', '2026-09-17 15:42:11.90909+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'B', 'usr_alexa', 60, '8b6544ea-7452-46da-87e9-7600ee17f7de', '2026-09-17 15:42:11.933328+05:30', '2026-09-17 15:42:11.933334+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '505c8ee9-1769-4911-a154-ed6ce03d3823', '2026-09-17 15:42:11.958032+05:30', '2026-09-17 15:42:11.958038+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '995e1b59-f5f9-4139-a3b9-d4214f3d6e0a', '2026-09-17 15:42:11.977616+05:30', '2026-09-17 15:42:11.977621+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_sobi', 60, 'b88fa291-6861-4f38-8fbd-db2b79b0cfdf', '2026-09-17 15:42:11.996826+05:30', '2026-09-17 15:42:11.996831+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_ajay', 60, 'e4c610b7-21a3-42b0-9a4a-b5eb42642d33', '2026-09-17 15:42:12.016299+05:30', '2026-09-17 15:42:12.016304+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '850e6f82-4538-44b0-bf58-105a9478ed84', '2026-09-17 15:42:12.035019+05:30', '2026-09-17 15:42:12.035025+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, '255a968a-398f-42ae-b7ad-80db6fa26a3f', '2026-09-17 15:42:12.051356+05:30', '2026-09-17 15:42:12.05136+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '3d27c602-f52f-4386-98f0-d4f3f8774bd5', '2026-09-17 15:42:12.065324+05:30', '2026-09-17 15:42:12.065328+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, '722f73b3-b855-492f-a0d4-c47b28adac02', '2026-09-17 15:42:12.076669+05:30', '2026-09-17 15:42:12.076672+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_civil_procedure_code_l_l_b_all', 'A', 'usr_kavya', 60, '57b8c7f6-3c99-4b7f-8dc1-337fd09b4616', '2026-09-17 15:52:42.952462+05:30', '2026-09-17 15:52:42.952467+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_civil_procedure_code_l_l_b_all', 'B', 'usr_kavya', 60, '697f49e8-23b4-4db3-819d-2714b50fb331', '2026-09-17 15:52:42.972878+05:30', '2026-09-17 15:52:42.972883+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_company_law_l_l_b_all', 'A', 'usr_palani', 60, '5e6efb00-6db7-4d72-991e-5f816a8a2aca', '2026-09-17 15:52:42.984905+05:30', '2026-09-17 15:52:42.984908+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_company_law_l_l_b_all', 'B', 'usr_kavya', 60, '0690b31c-1d74-4b3e-af85-d6cbea1bba4b', '2026-09-17 15:52:42.995204+05:30', '2026-09-17 15:52:42.995207+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_criminal_procedure_code_l_l_b_all', 'A', 'usr_madhan', 60, 'be565acd-1036-4ad7-96e4-f9197986c719', '2026-09-17 15:52:43.00565+05:30', '2026-09-17 15:52:43.005653+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_criminal_procedure_code_l_l_b_all', 'B', 'usr_madhan', 60, '8515637d-4513-4d56-b150-d1c7d8c19f55', '2026-09-17 15:52:43.016302+05:30', '2026-09-17 15:52:43.016305+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_criminal_procedure_code_l_l_b_all', 'A', 'usr_palani', 1, '675c9af7-734d-4c86-bc0b-325dd7454f93', '2026-09-17 15:19:09.869697+05:30', '2026-09-17 15:54:32.197997+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_civil_procedure_code_l_l_b_all', 'A', 'usr_kavya', 1, '99f37e4d-1b88-4a9c-bdde-b14e08ab9c29', '2026-09-17 15:19:09.868391+05:30', '2026-09-17 15:54:32.198003+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_company_law_l_l_b_all', 'A', 'usr_kavya', 1, 'bbab245c-fc6f-443a-83d0-9722918c5160', '2026-09-17 15:19:09.866738+05:30', '2026-09-17 15:54:32.198004+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_interpretation_of_statutes_l_l_b_all', 'A', 'usr_palani', 60, 'ff342615-85fe-4080-9187-91ad1595c9ea', '2026-09-17 15:56:17.921293+05:30', '2026-09-17 15:56:17.9213+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_contract___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, '27607080-1595-45ae-8fd5-24cf8ffd5dc4', '2026-09-17 16:06:58.775228+05:30', '2026-09-17 16:06:58.775236+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_law_of_contract___i_b_a_l_l_b_all', 'A', 'usr_arya', 60, 'ec70df9b-2860-4228-875d-eac0f577c824', '2026-09-17 16:07:10.089878+05:30', '2026-09-17 16:07:10.089885+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '5ee56b9c-2737-461d-a77a-d5436bcdc4b2', '2026-09-21 19:24:10.743301+05:30', '2026-09-21 19:24:10.743306+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_economics___i_b_a_l_l_b_all', 'B', 'usr_alexa', 60, 'dc9830a3-1360-462c-b9c4-fab114a31992', '2026-09-21 19:24:10.793218+05:30', '2026-09-21 19:24:10.793223+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'A', 'usr_sobi', 60, 'e49da79a-418f-40df-8401-c28cc917e568', '2026-09-21 19:24:10.807596+05:30', '2026-09-21 19:24:10.8076+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_english___i_b_a_l_l_b_all', 'B', 'usr_ajay', 60, '55d6c405-e6c1-4a75-b220-393903de60e7', '2026-09-21 19:24:10.819153+05:30', '2026-09-21 19:24:10.819156+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'A', 'usr_sobi', 60, '1d14fbcc-273c-4e63-a63d-cb956ca7a606', '2026-09-21 19:24:10.830533+05:30', '2026-09-21 19:24:10.830536+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_legal_method_b_a_l_l_b_all', 'B', 'usr_ajay', 60, 'fae77771-c5e4-4b19-ae8c-963b0d8828ec', '2026-09-21 19:24:10.842496+05:30', '2026-09-21 19:24:10.842499+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'A', 'usr_alexa', 60, '423bc2b1-a1bb-47d4-892d-0fb10f9cb943', '2026-09-21 19:24:10.853492+05:30', '2026-09-21 19:24:10.853495+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_political_science___i_b_a_l_l_b_all', 'B', 'usr_sobi', 60, '679a8019-ac75-4bf9-a42f-1ad3aac72672', '2026-09-21 19:24:10.863932+05:30', '2026-09-21 19:24:10.863935+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'A', 'usr_ajay', 60, '439f9685-4b23-4587-af36-42e420b617eb', '2026-09-21 19:24:10.873128+05:30', '2026-09-21 19:24:10.873131+05:30', false, NULL);
INSERT INTO public.sections VALUES ('crs_sociology___i_b_a_l_l_b_all', 'B', 'usr_arya', 60, '6e74ae5b-7c07-421a-84a5-4811ac355087', '2026-09-21 19:24:10.882028+05:30', '2026-09-21 19:24:10.88203+05:30', false, NULL);


--
-- Data for Name: session_summaries; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: staff_attendance; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.staff_attendance VALUES ('usr_dinesh', '2026-09-16', 'Absent', NULL, NULL, NULL, 'Manual', '62d749a8-3e64-4ad5-a478-4bdb79e60d8c', '2026-09-16 14:48:37.636131+05:30', '2026-09-16 14:48:37.636139+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_sobi', '2026-09-16', 'Absent', NULL, NULL, NULL, 'Manual', 'f22f327b-52ed-46c2-9c41-dc9d1e29af7d', '2026-09-16 15:06:19.055335+05:30', '2026-09-16 15:06:19.055344+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_madhan', '2026-09-16', 'Absent', NULL, NULL, NULL, 'Manual', '3cca4e24-79d7-425e-9305-9fb1b52f6757', '2026-09-16 15:07:05.575755+05:30', '2026-09-16 15:07:05.575761+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_arya', '2026-09-16', 'Absent', NULL, NULL, NULL, 'Manual', 'df9a6a80-fdc8-4db7-87d4-c634279d328c', '2026-09-16 15:12:57.98973+05:30', '2026-09-16 15:12:57.989734+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_ajay', '2026-09-16', 'Absent', NULL, NULL, NULL, 'Manual', '6e365304-864f-4d1e-96a6-f1a97bc1baa9', '2026-09-16 15:13:40.283348+05:30', '2026-09-16 15:13:40.283356+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_palani', '2026-09-16', 'Absent', NULL, NULL, NULL, 'Manual', '13ff2367-f761-4ac5-8463-49760ff29461', '2026-09-16 15:14:29.468896+05:30', '2026-09-16 15:14:29.4689+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_kavya', '2026-09-16', 'Absent', NULL, NULL, NULL, 'Manual', '89654eff-0613-4ce1-8bb3-c2b4202e3a0d', '2026-09-16 15:15:07.538377+05:30', '2026-09-16 15:15:07.538385+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_alexa', '2026-09-16', 'Absent', NULL, NULL, NULL, 'Manual', 'a3416a9f-e493-4812-bc5b-1151d1f61bd7', '2026-09-16 17:20:25.63791+05:30', '2026-09-16 17:20:25.637919+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_alexa', '2026-09-17', 'Absent', NULL, NULL, NULL, 'Manual', '3976f6b8-97b3-40d1-b1e1-89980758368a', '2026-09-17 05:31:00.20167+05:30', '2026-09-17 05:31:00.201677+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_dinesh', '2026-09-17', 'Absent', NULL, NULL, NULL, 'Manual', 'a9088322-e720-4493-a1eb-56984ebce38c', '2026-09-17 05:31:00.201688+05:30', '2026-09-17 05:31:00.201689+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_sobi', '2026-09-17', 'Absent', NULL, NULL, NULL, 'Manual', '7b98bbb8-e7eb-46df-808c-163311a0a13b', '2026-09-17 05:31:00.201696+05:30', '2026-09-17 05:31:00.201698+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_madhan', '2026-09-17', 'Absent', NULL, NULL, NULL, 'Manual', '62cda576-bc2b-4e68-be42-ae8015e380c2', '2026-09-17 05:31:00.201704+05:30', '2026-09-17 05:31:00.201706+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_arya', '2026-09-17', 'Absent', NULL, NULL, NULL, 'Manual', 'abf1fc17-3869-4738-82ad-a1b4dda681ff', '2026-09-17 05:31:00.201713+05:30', '2026-09-17 05:31:00.201714+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_ajay', '2026-09-17', 'Absent', NULL, NULL, NULL, 'Manual', '13353b07-ca97-4cb7-961d-cf7b53f21037', '2026-09-17 05:31:00.201722+05:30', '2026-09-17 05:31:00.201723+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_palani', '2026-09-17', 'Absent', NULL, NULL, NULL, 'Manual', '874730a2-448c-4511-9cdd-e079b399a7c8', '2026-09-17 05:31:00.201731+05:30', '2026-09-17 05:31:00.201732+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_kavya', '2026-09-17', 'Absent', NULL, NULL, NULL, 'Manual', '3cd94201-58a0-44c6-aa88-7ed4ce733bcf', '2026-09-17 05:31:00.20174+05:30', '2026-09-17 05:31:00.201741+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_alexa', '2026-09-18', 'Absent', NULL, NULL, NULL, 'Manual', '04b8d192-b44f-45a2-9cca-aac8eff718ee', '2026-09-18 05:31:00.127612+05:30', '2026-09-18 05:31:00.127617+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_dinesh', '2026-09-18', 'Absent', NULL, NULL, NULL, 'Manual', '6ba534bc-e468-4a7d-b455-b8a4f0571b21', '2026-09-18 05:31:00.127627+05:30', '2026-09-18 05:31:00.127629+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_sobi', '2026-09-18', 'Absent', NULL, NULL, NULL, 'Manual', 'be7670db-b895-4237-a5b4-17f77100aae4', '2026-09-18 05:31:00.127637+05:30', '2026-09-18 05:31:00.127638+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_madhan', '2026-09-18', 'Absent', NULL, NULL, NULL, 'Manual', '950ab6a4-6604-4ee1-8226-3b9225a62a5e', '2026-09-18 05:31:00.127644+05:30', '2026-09-18 05:31:00.127645+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_arya', '2026-09-18', 'Rest Leave', NULL, NULL, NULL, 'Manual', 'f42ecf41-66bf-4237-8d00-fd9dfd40d920', '2026-09-18 05:31:00.127652+05:30', '2026-09-18 05:31:00.127653+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_ajay', '2026-09-18', 'Absent', NULL, NULL, NULL, 'Manual', '6f669a78-4d6d-41c9-b64d-59429424940f', '2026-09-18 05:31:00.127659+05:30', '2026-09-18 05:31:00.12766+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_palani', '2026-09-18', 'Rest Leave', NULL, NULL, NULL, 'Manual', '23cdd08b-decd-430a-a0a9-b6d3c67020af', '2026-09-18 05:31:00.127667+05:30', '2026-09-18 05:31:00.127668+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_kavya', '2026-09-18', 'Rest Leave', NULL, NULL, NULL, 'Manual', '6633f635-b572-4b7e-8982-859841fa35e8', '2026-09-18 05:31:00.127674+05:30', '2026-09-18 05:31:00.127675+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_alexa', '2026-09-19', 'Absent', NULL, NULL, NULL, 'Manual', '8990be8f-6b53-4fa4-86c3-bc38282be0b7', '2026-09-19 05:31:00.219487+05:30', '2026-09-19 05:31:00.219495+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_dinesh', '2026-09-19', 'Absent', NULL, NULL, NULL, 'Manual', 'b22ed877-e7b3-43fc-9133-968ae40bf10e', '2026-09-19 05:31:00.219507+05:30', '2026-09-19 05:31:00.219509+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_sobi', '2026-09-19', 'Absent', NULL, NULL, NULL, 'Manual', '9dcdb0f4-7a3d-47f9-babe-0e19ee6da4fa', '2026-09-19 05:31:00.219517+05:30', '2026-09-19 05:31:00.219519+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_madhan', '2026-09-19', 'Absent', NULL, NULL, NULL, 'Manual', '0ec68c67-443c-4d8d-ab14-37676c97d4f1', '2026-09-19 05:31:00.219527+05:30', '2026-09-19 05:31:00.219529+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_arya', '2026-09-19', 'Rest Leave', NULL, NULL, NULL, 'Manual', 'e698a430-c4b6-4c28-bfe7-df99eff9e56b', '2026-09-19 05:31:00.219537+05:30', '2026-09-19 05:31:00.219538+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_ajay', '2026-09-19', 'Absent', NULL, NULL, NULL, 'Manual', '420e5322-ea79-499d-817f-c9f0eaa7cb0a', '2026-09-19 05:31:00.219546+05:30', '2026-09-19 05:31:00.219547+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_palani', '2026-09-19', 'Rest Leave', NULL, NULL, NULL, 'Manual', 'cf8bfbd7-5889-4f67-9d0d-d22ca2b5f766', '2026-09-19 05:31:00.219555+05:30', '2026-09-19 05:31:00.219556+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_kavya', '2026-09-19', 'Rest Leave', NULL, NULL, NULL, 'Manual', '7a282ac6-0618-4fb6-8567-b910db2c4777', '2026-09-19 05:31:00.219563+05:30', '2026-09-19 05:31:00.219565+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_alexa', '2026-09-20', 'Sunday', NULL, NULL, NULL, 'Manual', '0702d55e-f425-4e9b-be4b-4799d9a371ab', '2026-09-20 05:31:00.087711+05:30', '2026-09-20 05:31:00.087714+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_dinesh', '2026-09-20', 'Sunday', NULL, NULL, NULL, 'Manual', '60c02b1a-a87f-4516-a839-3534c9407f5b', '2026-09-20 05:31:00.087722+05:30', '2026-09-20 05:31:00.087723+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_sobi', '2026-09-20', 'Sunday', NULL, NULL, NULL, 'Manual', '9e205d9f-dada-4108-8ef3-553e83609409', '2026-09-20 05:31:00.087728+05:30', '2026-09-20 05:31:00.087729+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_madhan', '2026-09-20', 'Sunday', NULL, NULL, NULL, 'Manual', 'd8f5ec43-ceb1-456f-b04f-6b3dccba93d0', '2026-09-20 05:31:00.087734+05:30', '2026-09-20 05:31:00.087735+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_arya', '2026-09-20', 'Sunday', NULL, NULL, NULL, 'Manual', '33ce99fe-9a28-4d0f-b613-cd4a945696e5', '2026-09-20 05:31:00.087739+05:30', '2026-09-20 05:31:00.08774+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_ajay', '2026-09-20', 'Sunday', NULL, NULL, NULL, 'Manual', '6286d658-d7f1-4089-9c60-2193c2b81825', '2026-09-20 05:31:00.087744+05:30', '2026-09-20 05:31:00.087745+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_palani', '2026-09-20', 'Sunday', NULL, NULL, NULL, 'Manual', '7bd068d2-bb87-4ba2-8697-af01016979cd', '2026-09-20 05:31:00.08775+05:30', '2026-09-20 05:31:00.087751+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_kavya', '2026-09-20', 'Sunday', NULL, NULL, NULL, 'Manual', 'ce6ac00d-0505-42c5-9099-fb19cb8f48af', '2026-09-20 05:31:00.087757+05:30', '2026-09-20 05:31:00.087758+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_alexa', '2026-09-21', 'Absent', NULL, NULL, NULL, 'Manual', 'cc504263-3bc8-47e4-9188-25ce12223d31', '2026-09-21 05:31:00.17285+05:30', '2026-09-21 05:31:00.172856+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_dinesh', '2026-09-21', 'Absent', NULL, NULL, NULL, 'Manual', 'f33b8986-4b52-478f-9516-374e73fec20a', '2026-09-21 05:31:00.172869+05:30', '2026-09-21 05:31:00.17287+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_sobi', '2026-09-21', 'Absent', NULL, NULL, NULL, 'Manual', '4dae1309-bd56-4abb-9984-001852389a72', '2026-09-21 05:31:00.172878+05:30', '2026-09-21 05:31:00.172879+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_madhan', '2026-09-21', 'Absent', NULL, NULL, NULL, 'Manual', '4d69af7d-5c62-4ef7-b62a-9e0df8e03bd6', '2026-09-21 05:31:00.172887+05:30', '2026-09-21 05:31:00.172888+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_arya', '2026-09-21', 'Absent', NULL, NULL, NULL, 'Manual', '6613b380-3208-434b-9a0f-276fad8448e5', '2026-09-21 05:31:00.172895+05:30', '2026-09-21 05:31:00.172896+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_ajay', '2026-09-21', 'Absent', NULL, NULL, NULL, 'Manual', '93beebe8-b14b-4bc4-8de1-f856792283c7', '2026-09-21 05:31:00.172903+05:30', '2026-09-21 05:31:00.172904+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_palani', '2026-09-21', 'Rest Leave', NULL, NULL, NULL, 'Manual', 'ee61f952-12ac-45f3-8423-098f284530d2', '2026-09-21 05:31:00.172912+05:30', '2026-09-21 05:31:00.172913+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_kavya', '2026-09-21', 'Absent', NULL, NULL, NULL, 'Manual', '0062e3ee-993a-4ef6-83fa-76e372046eca', '2026-09-21 05:31:00.172924+05:30', '2026-09-21 05:31:00.172925+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_alexa', '2026-09-22', 'Absent', NULL, NULL, NULL, 'Manual', '1225b47f-e36b-4d0b-8a50-6228a3c78bc4', '2026-09-22 05:31:00.125618+05:30', '2026-09-22 05:31:00.125624+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_dinesh', '2026-09-22', 'Absent', NULL, NULL, NULL, 'Manual', '9204bda6-1590-4827-8a99-14e51dd75e26', '2026-09-22 05:31:00.125635+05:30', '2026-09-22 05:31:00.125637+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_sobi', '2026-09-22', 'Absent', NULL, NULL, NULL, 'Manual', 'af1259c3-09f7-4c33-a751-07e4925e14b2', '2026-09-22 05:31:00.125645+05:30', '2026-09-22 05:31:00.125646+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_madhan', '2026-09-22', 'Absent', NULL, NULL, NULL, 'Manual', '8303d09d-6862-46fe-8ea7-087017dd4f5f', '2026-09-22 05:31:00.125653+05:30', '2026-09-22 05:31:00.125655+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_arya', '2026-09-22', 'Absent', NULL, NULL, NULL, 'Manual', '2fa752a8-a46a-4b70-b011-11b4b779a31d', '2026-09-22 05:31:00.125662+05:30', '2026-09-22 05:31:00.125663+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_ajay', '2026-09-22', 'Absent', NULL, NULL, NULL, 'Manual', '32f1de02-ca55-46bc-962e-2a5f33e7c47e', '2026-09-22 05:31:00.12567+05:30', '2026-09-22 05:31:00.125671+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_palani', '2026-09-22', 'Rest Leave', NULL, NULL, NULL, 'Manual', '26649cde-fdc5-4577-9111-96755172d20f', '2026-09-22 05:31:00.125679+05:30', '2026-09-22 05:31:00.12568+05:30', false, NULL);
INSERT INTO public.staff_attendance VALUES ('usr_kavya', '2026-09-22', 'Absent', NULL, NULL, NULL, 'Manual', '3720f434-9d25-4ce6-95c7-dca1b409ec58', '2026-09-22 05:31:00.125687+05:30', '2026-09-22 05:31:00.125689+05:30', false, NULL);


--
-- Data for Name: staff_attendance_records; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student_concessions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student_council_initiatives; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student_council_members; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student_interactions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student_material_bookmarks; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student_material_downloads; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student_material_favorites; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student_papers; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.students VALUES ('usr_student3', 'LAW-007', 3, 2025, 'ACTIVE', NULL, NULL, NULL, NULL, 'deg_b_a_l_l_b_all', 'Government', NULL, '[]', '[]', '[]', '[]', NULL, '77ab8e38-3b95-4945-aab9-f05aaa6df564', '381940f2-d10b-4e26-aaa7-3c48d054e57e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'OBC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DRAFT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sch_type_sports_quota', 'std_law_007', '2026-09-16 15:18:05.163732+05:30', '2026-09-17 15:19:05.832935+05:30', false, NULL);
INSERT INTO public.students VALUES ('usr_student6', 'LAW-006', 1, 2026, 'ACTIVE', NULL, NULL, NULL, NULL, 'deg_l_l_b_all', 'Government', NULL, '[]', '[]', '[]', '[]', NULL, '5b130fcb-3ccb-41e6-b503-577bc9d7c9b7', '895142a8-e819-422e-8ff5-ab0cbfc30af1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'General', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DRAFT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sch_type_merit_scholarship', 'std_law_006', '2026-09-16 15:22:17.575072+05:30', '2026-09-17 15:19:38.950379+05:30', false, NULL);
INSERT INTO public.students VALUES ('usr_student7', 'LAW-010', 3, 2025, 'ACTIVE', NULL, NULL, NULL, NULL, 'deg_l_l_b_all', 'Management', NULL, '[]', '[]', '[]', '[]', NULL, 'bbab245c-fc6f-443a-83d0-9722918c5160', '526b40cc-615d-44b0-9a32-cada66c5ed0f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'General', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DRAFT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'std_law_010', '2026-09-16 15:23:22.385366+05:30', '2026-09-17 15:20:03.948278+05:30', false, NULL);
INSERT INTO public.students VALUES ('usr_student2', 'LAW-002', 1, 2026, 'ACTIVE', NULL, NULL, NULL, NULL, 'deg_b_a_l_l_b_all', 'Government', NULL, '[]', '[]', '[]', '[]', NULL, '8269988b-edc9-4c92-80a6-8b2ff0e87d54', 'd26b1827-d82b-49a3-8c5e-0e4e825cf50b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'General', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DRAFT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sch_type_merit_scholarship', 'std_law_002', '2026-09-16 15:16:51.437411+05:30', '2026-09-17 15:20:19.380562+05:30', false, NULL);
INSERT INTO public.students VALUES ('usr_student5', 'LAW-009', 1, 2026, 'ACTIVE', NULL, NULL, NULL, NULL, 'deg_l_l_b_all', 'Management', NULL, '[{"id": "cert-1789642654886", "title": "Certificate", "authority": "CubeAi", "date": "2026-09-17", "category": "Workshop & Seminar", "certificateUrl": "", "status": "Under Verification", "uploadedAt": "2026-09-17T10:57:34.886Z", "verified": true}]', '[]', '[]', '[]', NULL, 'bbab245c-fc6f-443a-83d0-9722918c5160', '63ea93a1-ac32-4b5c-80a5-83e6c9f7b10a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'OBC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DRAFT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'std_law_009', '2026-09-16 15:21:17.251812+05:30', '2026-09-17 16:30:28.851829+05:30', false, NULL);
INSERT INTO public.students VALUES ('usr_student4', 'LAW-008', 3, 2025, 'ACTIVE', NULL, NULL, NULL, NULL, 'deg_b_a_l_l_b_2025_2030', 'Government', NULL, '[{"id": "cert-1789642794619", "title": "Workshop winners", "authority": "nandha institution", "date": "2026-09-10", "category": "Workshop & Seminar", "certificateUrl": "/uploads/documents/certification_std_law_008_e7ab7922db144bbca86272ef4b1defac.png", "status": "Under Verification", "uploadedAt": "2026-09-17T10:59:54.619Z", "verified": true}, {"id": "cert-1789642059320", "title": "Hackathon Winner", "authority": "Nandha institution", "date": "2026-09-08", "category": "Workshop & Seminar", "certificateUrl": "", "status": "Under Verification", "uploadedAt": "2026-09-17T10:47:39.320Z", "verified": "REJECTED", "rejectionRemarks": "no documents", "rejectedBy": "Ajay", "rejectedAt": "2026-09-17T10:56:28.864327+00:00"}, {"id": "cert-1789642005053", "title": "national moot court champions Winners", "authority": "High Court Bar Assocation", "date": "2026-09-01", "category": "Moot Court", "certificateUrl": "", "status": "Under Verification", "uploadedAt": "2026-09-17T10:46:45.053Z", "verified": "REJECTED", "rejectionRemarks": "no documents", "rejectedBy": "Ajay", "rejectedAt": "2026-09-17T10:56:34.794570+00:00"}]', '[]', '[]', '[]', NULL, '8269988b-edc9-4c92-80a6-8b2ff0e87d54', 'c7aa3daf-f193-42be-b397-1069411a024b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DRAFT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'std_law_008', '2026-09-16 15:18:54.122368+05:30', '2026-09-17 16:30:50.782121+05:30', false, NULL);
INSERT INTO public.students VALUES ('usr_student8', 'LAW-011', 3, 2025, 'ACTIVE', NULL, NULL, NULL, NULL, 'deg_l_l_b_all', 'Government', NULL, '[{"id": "cert-1789642709138", "title": "intern", "authority": "cubeai", "date": "2026-09-10", "category": "Academic Honor", "certificateUrl": "/uploads/documents/certification_std_law_011_7f57e07ad2494c9b9fb750e7c2d46910.pdf", "status": "Under Verification", "uploadedAt": "2026-09-17T10:58:29.138Z"}]', '[]', '[]', '[]', NULL, '5b130fcb-3ccb-41e6-b503-577bc9d7c9b7', '07f0b2f5-6a35-481f-a1f7-c62846c1a475', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'OBC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DRAFT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sch_type_merit_scholarship', 'std_law_011', '2026-09-16 15:24:04.876372+05:30', '2026-09-17 16:28:29.168721+05:30', false, NULL);
INSERT INTO public.students VALUES ('usr_student1', 'LAW-001', 1, 2026, 'ACTIVE', NULL, NULL, NULL, NULL, 'deg_b_a_l_l_b_all', 'Government', NULL, '[{"id": "cert-1789642724140", "title": "Supreme Court of India Hackathon 2024", "authority": "Supreme court", "date": "2026-08-29", "category": "Workshop & Seminar", "certificateUrl": "/uploads/documents/certification_std_law_001_da4b7d7e8453422281e5558c19724bec.png", "status": "Under Verification", "uploadedAt": "2026-09-17T10:58:44.140Z"}, {"id": "cert-1789642002112", "title": "The leadership in court", "authority": "High court", "date": "2026-09-04", "category": "Workshop & Seminar", "certificateUrl": "", "status": "Under Verification", "uploadedAt": "2026-09-17T10:46:42.112Z", "verified": "REJECTED", "rejectionRemarks": "invalid document", "rejectedBy": "Arya", "rejectedAt": "2026-09-17T10:56:42.404313+00:00"}, {"id": "cert-1789641961304", "title": "National moot court championship winner", "authority": "High court", "date": "2026-09-09", "category": "Moot Court", "certificateUrl": "", "status": "Under Verification", "uploadedAt": "2026-09-17T10:46:01.304Z", "verified": "REJECTED", "rejectionRemarks": "invalid document", "rejectedBy": "Arya", "rejectedAt": "2026-09-17T10:56:52.547592+00:00"}]', '[]', '[]', '[]', NULL, '77ab8e38-3b95-4945-aab9-f05aaa6df564', '9122c767-8dc3-476b-bb2b-404c879eb50d', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'General', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DRAFT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'std_law_001', '2026-09-16 15:09:18.248293+05:30', '2026-09-17 16:28:41.542522+05:30', false, NULL);


--
-- Data for Name: study_materials; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: subject_allocations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '953fc462-9b21-4113-9d5e-6e7870d82106', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'e821eb20-ae83-4c3b-b0ce-f8fddf49fce4', '2026-09-16 17:12:47.329246+05:30', '2026-09-16 17:12:47.329251+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '8a1edd33-42fe-4e38-9e86-a846cdfe8d5a', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'eee2e652-f614-4727-add5-4e5a54bbe836', '2026-09-16 17:12:47.346133+05:30', '2026-09-16 17:12:47.346138+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '89504364-f8d5-49c2-b44e-667501be4c45', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '7bb14fb3-e31d-4951-9970-83ffc1f66f1f', '2026-09-16 17:16:44.717453+05:30', '2026-09-16 17:16:44.717458+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', 'a1b2bda6-0e80-4540-a9a8-3280a47a649f', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'ebd0a31d-52a2-4210-a3a9-d647a22a9082', '2026-09-16 17:16:44.736857+05:30', '2026-09-16 17:16:44.736863+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '53b35d03-0971-4581-801f-b10d55d83085', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '30d8dc37-e4c1-44f5-8b5d-635506467a88', '2026-09-16 17:16:44.749351+05:30', '2026-09-16 17:16:44.749355+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '9e73a8be-158f-44fa-832e-f97ebd3b055f', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '938d8a71-c4ed-470f-b05c-bd15c8f487f8', '2026-09-16 17:18:43.35622+05:30', '2026-09-16 17:18:43.356225+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '4539d7d6-6300-4c23-8693-65255ac0a7ab', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '5884f59a-41d6-4690-9982-26368d6bbbe8', '2026-09-16 17:18:43.367793+05:30', '2026-09-16 17:18:43.367796+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '1423421b-01c8-4543-92f5-6a3fb98f87a2', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'b9d71e42-1255-486d-af49-89e745b2d273', '2026-09-16 17:18:43.378527+05:30', '2026-09-16 17:18:43.37853+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '36ae5b25-355a-4fa2-ae25-419d475c9a57', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '5a180897-3d1f-4302-8404-3658b8de8931', '2026-09-16 17:18:43.388911+05:30', '2026-09-16 17:18:43.388914+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '5088136a-4458-4e7f-b1fb-e62b893d4933', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '0de2802b-79a0-4edb-b8e6-59670245ab5f', '2026-09-16 17:18:43.395969+05:30', '2026-09-16 17:18:43.395972+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2025_2030', 'crs_family_law___i_b_a_l_l_b_all', '7c9bd057-3aac-466e-88fc-45101c0a15aa', 'usr_ajay', 'deg_b_a_l_l_b_all', 3, 'usr_sobi', true, 'f6351f4f-7504-426f-b7cd-65ab74f6545a', '2026-09-16 17:32:52.328805+05:30', '2026-09-16 17:32:52.32881+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2025_2030', 'crs_law_of_contract___i_b_a_l_l_b_all', '620b7226-3d77-436b-8c67-8e5b331bd928', 'usr_arya', 'deg_b_a_l_l_b_all', 3, 'usr_sobi', true, '7a81d3a2-ec20-4a63-8d36-2a362ed5a4eb', '2026-09-16 17:32:52.345073+05:30', '2026-09-16 17:32:52.345079+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2025_2030', 'crs_family_law___i_b_a_l_l_b_all', '92b347b8-9115-49e0-8a82-709b60c421ba', 'usr_ajay', 'deg_b_a_l_l_b_all', 3, 'usr_sobi', true, '67161db1-218e-45f5-9278-7450e8ea4d37', '2026-09-16 17:33:11.267319+05:30', '2026-09-16 17:33:11.267324+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2025_2030', 'crs_family_law___i_b_a_l_l_b_all', 'f3ff06dc-7d85-478b-9b81-fb9a98b49022', 'usr_alexa', 'deg_b_a_l_l_b_all', 3, 'usr_sobi', true, 'a1edca05-7b20-4a9e-a5c8-f630e7d1299b', '2026-09-16 17:33:11.291588+05:30', '2026-09-16 17:33:11.291593+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2025_2030', 'crs_law_of_contract___i_b_a_l_l_b_all', 'b6bb2eff-9c29-443f-a433-a0dc8a3ba1a6', 'usr_arya', 'deg_b_a_l_l_b_all', 3, 'usr_sobi', true, '5ac5a52d-d23b-4e85-bb31-e7e083b83591', '2026-09-16 17:33:11.311573+05:30', '2026-09-16 17:33:11.311578+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2025_2030', 'crs_law_of_contract___i_b_a_l_l_b_all', '400ac41a-313e-4798-be0c-71e013edd658', 'usr_ajay', 'deg_b_a_l_l_b_all', 3, 'usr_sobi', true, '8487796e-0352-4eba-8812-e26d29c59eab', '2026-09-16 17:33:11.324434+05:30', '2026-09-16 17:33:11.324439+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', 'b460d376-1a42-4ff5-a129-59efa76e791b', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'd82e5484-2ef7-4053-885a-14a7f7e3d283', '2026-09-17 15:20:52.259874+05:30', '2026-09-17 15:20:52.259878+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '3343df3c-6eb7-4910-b690-afb5eb20f649', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '535043f5-b614-438b-b6ca-4c7b2074df45', '2026-09-17 15:20:52.280552+05:30', '2026-09-17 15:20:52.280556+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '8d919413-0b7b-4473-861c-5197194ebbca', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '9d6178fa-3ce2-41ac-a49c-cf62233a1c3a', '2026-09-17 15:20:52.29735+05:30', '2026-09-17 15:20:52.297354+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '6d0310f8-9189-4e40-9b17-836c51a66e04', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '26f2891f-ce10-4ce7-80f4-31150e040756', '2026-09-17 15:20:52.314021+05:30', '2026-09-17 15:20:52.314024+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '0c3a9757-21d4-470b-b409-9d3e6b67e67f', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'e84acec9-83e1-478f-b9b9-352f2cd6f11f', '2026-09-17 15:20:52.331735+05:30', '2026-09-17 15:20:52.331739+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', 'a6b6b7e7-a48f-4ed3-a7e3-6331d91ea57a', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '40d4587d-3866-44c3-ae6b-6ce2e5e961c3', '2026-09-17 15:20:52.343237+05:30', '2026-09-17 15:20:52.343241+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', 'f4c33be1-0ab4-43a5-84d9-49692881b663', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '38f4f91e-253a-4bf3-b521-753a4c3dd258', '2026-09-17 15:21:04.933849+05:30', '2026-09-17 15:21:04.933853+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '753cdf65-b390-419b-860f-1a6fcb38cdcf', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '5974468a-c517-41d7-9f69-a357014924c2', '2026-09-17 15:21:04.955697+05:30', '2026-09-17 15:21:04.9557+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '4d833fe1-caed-4c79-a5a0-be86fe186aa3', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '4ae361bd-e683-4856-bf4f-036f2ff744dc', '2026-09-17 15:21:04.968433+05:30', '2026-09-17 15:21:04.968436+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', 'ed42a79e-1559-4d5c-bb4b-cc742a0fcfb0', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'dbf89402-50ff-4fd1-a5f8-9c2a824c12f3', '2026-09-17 15:21:04.98116+05:30', '2026-09-17 15:21:04.981162+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '2d1e85fc-0438-42e5-bc15-a27fed1544c3', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '54f872c2-86f0-457a-aca6-34a037a32a30', '2026-09-17 15:21:04.993408+05:30', '2026-09-17 15:21:04.993411+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '15bb0641-19df-4abd-a590-3d240304b479', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'd158e066-3998-40f8-badf-44a480f253d6', '2026-09-17 15:21:05.005184+05:30', '2026-09-17 15:21:05.005186+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '882c2595-538f-4211-b120-9a612b50d3fb', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '3fe9c6e7-11e3-4a29-a0fb-0e26ac87018b', '2026-09-17 15:21:05.012878+05:30', '2026-09-17 15:21:05.012881+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '27df86bb-f564-4a3b-9c21-bf2f05865a2b', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '8b826fc6-7e2b-47b4-8b16-d3532aa3d565', '2026-09-17 15:21:30.83756+05:30', '2026-09-17 15:21:30.837564+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', 'f89230bc-b64e-41da-ab67-4ef7669c546c', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'ed9fc8dd-bee3-4d0e-8254-a3641b9b5936', '2026-09-17 15:21:30.850719+05:30', '2026-09-17 15:21:30.850722+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '1f2a72c1-eea9-42b3-97e3-090b6c743cc4', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'cd97d89f-c263-4a12-9cf3-dab8efdfdc34', '2026-09-17 15:21:30.861715+05:30', '2026-09-17 15:21:30.861718+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', 'c9d13c61-8fc9-4bb2-bbea-d30913083dcf', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '27d0c880-040c-46cd-8670-80a61419f0cf', '2026-09-17 15:21:30.871618+05:30', '2026-09-17 15:21:30.871621+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '61428bdf-4d3f-40aa-a5fb-48668292139c', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '439e84b5-ec4f-4812-996f-37cb1280f01f', '2026-09-17 15:21:30.88112+05:30', '2026-09-17 15:21:30.881123+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '64708448-e5d2-410c-b707-32100ca03dff', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'aab6c049-5e10-4d93-ac4a-d6ebfe497dcc', '2026-09-17 15:21:30.890882+05:30', '2026-09-17 15:21:30.890885+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '2a51b2cd-5326-4125-b6eb-37b3f4f17659', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'c803c532-88c7-402a-bbb4-aadf2778f6ad', '2026-09-17 15:21:30.899991+05:30', '2026-09-17 15:21:30.899993+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', 'c2f7c645-27d5-4e3c-a33a-2b7243dc2ad8', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '9e9171fd-f0e2-45ff-90f9-217c07b66a3f', '2026-09-17 15:21:30.905861+05:30', '2026-09-17 15:21:30.905864+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '13a0100e-3b10-474e-8ee1-8aa13ce38052', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '845511eb-dd97-42a3-85ab-b027020491a4', '2026-09-17 15:21:53.059041+05:30', '2026-09-17 15:21:53.059046+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '4518c531-3e07-47ca-8bec-4dc3f50daa96', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '003d0241-52f9-4d09-a051-616a22f25f2a', '2026-09-17 15:21:53.110066+05:30', '2026-09-17 15:21:53.110069+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', 'c35574aa-2ce2-4e8e-a5f0-9f538d26f127', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '68a6f523-cfdb-4281-aece-c2456067312e', '2026-09-17 15:21:53.122336+05:30', '2026-09-17 15:21:53.122339+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '6ca8bb0e-a265-4e25-9680-a4d789abc3a6', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '82153bfc-147f-4d42-aca8-ca28137dfade', '2026-09-17 15:21:53.134434+05:30', '2026-09-17 15:21:53.134436+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '11655ab7-a12e-4d39-aa30-58baf4178348', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'e3b6c14e-36ed-4c48-8c7b-c66312f11aea', '2026-09-17 15:21:53.145906+05:30', '2026-09-17 15:21:53.145908+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', 'fb86080b-77c7-475d-a86d-13aae855f3aa', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '3fd87780-8708-4817-89da-e028dfdf58ef', '2026-09-17 15:21:53.15711+05:30', '2026-09-17 15:21:53.157113+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '11faedad-0961-4e79-bd6c-14e144d15a68', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'd528a411-d765-4f16-a078-4467f896f251', '2026-09-17 15:21:53.167598+05:30', '2026-09-17 15:21:53.1676+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', 'a822fc84-2462-4a8f-9f7d-da46e80e9ab8', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '4618d302-9fea-4ee4-bfbc-e387290a55eb', '2026-09-17 15:21:53.173794+05:30', '2026-09-17 15:21:53.173797+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '1ad250eb-f3d4-4375-9357-3ef90c2a358a', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '7930417b-ea5c-4a74-ac29-1d98da5297ce', '2026-09-17 15:22:29.254143+05:30', '2026-09-17 15:22:29.254148+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '2e5f7f1c-346f-4f39-b13d-9a3f4efd282d', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'd3950bd0-7b23-455a-b30e-c72103eab4fc', '2026-09-17 15:22:29.277111+05:30', '2026-09-17 15:22:29.277116+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '596963c6-ed66-4e24-a2d3-3d8ee44c4f65', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'a75a3475-500e-4e26-a495-e86ddee66110', '2026-09-17 15:22:29.296377+05:30', '2026-09-17 15:22:29.296381+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', 'f2e8dc5e-1453-473b-95a8-42ddebb349c8', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '3bcb066e-f89c-4a0c-9fd4-0a9cc3c9012c', '2026-09-17 15:22:29.315617+05:30', '2026-09-17 15:22:29.315622+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', 'b83ea34d-a360-4880-9559-be6a8dc9de34', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '146450fc-fbd0-4700-9f5e-32f8107399d1', '2026-09-17 15:22:29.334112+05:30', '2026-09-17 15:22:29.334116+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '8f6257b2-ef3b-4944-b3ee-ac87c57cd479', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '39d1fcf4-38e3-41fa-ac59-133dd51f3573', '2026-09-17 15:22:29.351076+05:30', '2026-09-17 15:22:29.35108+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', 'ed87d512-9d65-4f54-aa4c-03730ce6fd28', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '18aefc92-00d1-4271-84c5-d0766f107e2c', '2026-09-17 15:22:29.365882+05:30', '2026-09-17 15:22:29.365886+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '5ac0e283-2da0-45e9-9f35-05ed4e9c7718', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'd3957840-c721-4a5f-b4fa-c826b36a2df3', '2026-09-17 15:22:29.378321+05:30', '2026-09-17 15:22:29.378325+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '13ab9384-fc0e-46a0-a5c5-45cecc8aebad', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '104edf0c-5767-44e3-84d1-9b79b2d46a84', '2026-09-17 15:22:29.388713+05:30', '2026-09-17 15:22:29.388715+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '0eb0f6c0-5820-46bf-bdad-881ef25a32ba', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '6e721815-1da2-4a45-a02d-80caba9aa3da', '2026-09-17 15:22:29.395061+05:30', '2026-09-17 15:22:29.395064+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_environmental_law_l_l_b_all', 'a18a5a3e-bc73-4746-b538-ca0aa522641b', 'usr_kavya', 'deg_l_l_b_all', 3, 'usr_madhan', true, '919e8db1-836c-4ee4-8724-0326c47c31f9', '2026-09-17 15:22:58.409982+05:30', '2026-09-17 15:22:58.409988+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', 'e0e95c89-acf3-461e-9aac-5733f8a29985', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'b25a697b-5acf-4e5f-817f-72614633f926', '2026-09-17 15:35:13.072714+05:30', '2026-09-17 15:35:13.072719+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '7e6a83a0-6138-42e4-a80f-05b9c6368074', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'f1f0cba1-68eb-4888-8317-8105ac732e86', '2026-09-17 15:35:13.093831+05:30', '2026-09-17 15:35:13.093836+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', 'bc877569-d15c-4cdf-954c-3427a44ec571', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '60ed1c62-1754-4756-80f5-e308bd2dc1de', '2026-09-17 15:35:13.112843+05:30', '2026-09-17 15:35:13.112848+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', 'a9e0811d-cfb9-4818-9d3a-8c630c7727ef', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '91e8a584-ea52-4914-87c9-48673679ecd6', '2026-09-17 15:35:13.132701+05:30', '2026-09-17 15:35:13.132706+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '77f0dd23-d554-4e4c-8abf-98ba898980dd', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '5a9b3d06-02f3-48e2-9888-83cf2bc8e963', '2026-09-17 15:35:13.151401+05:30', '2026-09-17 15:35:13.151405+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '7d51ddbd-7e1c-4592-ad6f-864ce9189dc1', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'e6abea66-43a1-4345-b0d2-dfb01f68eff1', '2026-09-17 15:35:13.169312+05:30', '2026-09-17 15:35:13.169317+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', 'af4edbca-704c-4eb7-b384-804d9ce8ccc7', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '3ef5eb27-ea6e-4744-8b72-c1f6f6188819', '2026-09-17 15:35:13.183883+05:30', '2026-09-17 15:35:13.183887+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '92427cb5-6d33-4e13-9bd0-b145b7bacada', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '3bd7eb25-620d-4576-8dc5-60d03f30dd32', '2026-09-17 15:35:13.195591+05:30', '2026-09-17 15:35:13.195594+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '3f0602d4-80ee-4697-896d-cc93c3c52fb6', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'dffe60cd-3324-4e4e-a3a8-5afdc49c77c0', '2026-09-17 15:35:13.205997+05:30', '2026-09-17 15:35:13.206+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', 'b42e5157-b876-4641-bb25-cdbd393ac067', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '3e36a655-fd78-449c-bf33-033c3c836cfd', '2026-09-17 15:35:13.213635+05:30', '2026-09-17 15:35:13.213638+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_civil_procedure_code_l_l_b_all', '0aebb289-2657-400d-b602-dd687016c430', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, '15e185a9-9a95-4a91-abde-aeebc9cd5824', '2026-09-17 15:35:34.610556+05:30', '2026-09-17 15:35:34.610562+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_civil_procedure_code_l_l_b_all', 'ca153080-927d-4559-b9a9-fbc5388b731b', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, '6addda6f-bacb-4d70-aac4-9955ac2f6efd', '2026-09-17 15:35:45.495756+05:30', '2026-09-17 15:35:45.495761+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_company_law_l_l_b_all', '0ad4719a-900e-4875-bf97-5b7f307288c5', 'usr_palani', 'deg_l_l_b_all', 1, 'usr_madhan', true, '2edce36a-7913-40d4-9b29-30650268354c', '2026-09-17 15:35:45.515713+05:30', '2026-09-17 15:35:45.515718+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_criminal_procedure_code_l_l_b_all', '9372d339-f6fe-424c-b51e-62b8ebcae451', 'usr_palani', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'b23088ba-c869-4f8b-987a-bc027e3108ef', '2026-09-17 15:35:45.527556+05:30', '2026-09-17 15:35:45.52756+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '51cf6953-8291-4c68-aa45-11aa8202e59a', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'e427b4d3-6ffe-4060-914f-bb426355a844', '2026-09-17 15:36:01.528675+05:30', '2026-09-17 15:36:01.528679+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', 'f2ca36d0-5f86-422d-8dcc-bd4b65c28f03', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '96599ca0-c120-467e-8832-d7a5619a980d', '2026-09-17 15:36:01.550606+05:30', '2026-09-17 15:36:01.550611+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '7fc69c2f-7b88-4714-971a-2ee3fee6d4bf', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'c5aa29db-3df5-49cf-8da9-6330e206180f', '2026-09-17 15:36:01.569437+05:30', '2026-09-17 15:36:01.56944+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '1ca63a78-1516-45e8-8512-15d5c2b1b845', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '677762a4-4074-454d-b85a-a9d678e1305d', '2026-09-17 15:36:01.586185+05:30', '2026-09-17 15:36:01.586189+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '9799589b-9cad-4f94-9686-387e4070db24', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '4bae3900-0aa0-42e7-b4e4-bcdf875ed25d', '2026-09-17 15:36:01.601346+05:30', '2026-09-17 15:36:01.601349+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '64fb19de-207f-4a46-b025-5b55b048f0b0', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'bd90619e-d100-42f7-ba6c-6298e9bafa48', '2026-09-17 15:36:01.613588+05:30', '2026-09-17 15:36:01.613592+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '7414073f-ba97-4713-85a9-b24d3167d09f', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '95722ce6-cc7f-430f-99b6-5ab2167e01df', '2026-09-17 15:36:01.623733+05:30', '2026-09-17 15:36:01.623737+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', 'becd10de-2d5f-402b-9189-7e6dcac47e2d', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '7e86ff93-8b9d-4ca0-9d91-71fa47b4cbe0', '2026-09-17 15:36:01.634383+05:30', '2026-09-17 15:36:01.634385+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', 'ff467e0b-8382-41c6-a07c-4185229c164c', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '7f1b4be8-6787-48d2-a725-56ffcc2ec560', '2026-09-17 15:36:01.643934+05:30', '2026-09-17 15:36:01.643936+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', 'dd8f5dc8-b023-4bb0-9a65-35b97d08daca', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '767df146-0f45-4e66-b80d-b0656edc16dd', '2026-09-17 15:36:01.650459+05:30', '2026-09-17 15:36:01.650462+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_civil_procedure_code_l_l_b_all', '67ae375b-88ab-4040-bf23-a65447179888', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'f643b75d-0f78-4bfd-b27e-8a2f024f3f4b', '2026-09-17 15:36:38.748172+05:30', '2026-09-17 15:36:38.748178+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_civil_procedure_code_l_l_b_all', '4b012915-2951-446e-9c5c-5ffb17632d82', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'f30690a0-b122-42f4-a8b9-da5a3be54368', '2026-09-17 15:36:38.76804+05:30', '2026-09-17 15:36:38.768045+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_company_law_l_l_b_all', '956de5f8-fd87-4073-9a22-10b674edc921', 'usr_palani', 'deg_l_l_b_all', 1, 'usr_madhan', true, '7c8d6fa4-2d64-4c40-8c22-9bfe30a9a62c', '2026-09-17 15:36:38.786699+05:30', '2026-09-17 15:36:38.786704+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_company_law_l_l_b_all', '4d90e4f0-6eba-4d1e-a87a-85a0f81aa062', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, '4455fa0e-dda6-4ae7-aed9-a60f8eb0b550', '2026-09-17 15:36:38.804753+05:30', '2026-09-17 15:36:38.804757+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_criminal_procedure_code_l_l_b_all', '67f68a57-2487-43ee-92e8-f0ea68aad7cf', 'usr_palani', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'ca8dc7b0-c71c-4405-a003-c210228b6be0', '2026-09-17 15:36:38.821956+05:30', '2026-09-17 15:36:38.82196+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_criminal_procedure_code_l_l_b_all', '240afb0a-786f-425a-8c95-ffd8e0574670', 'usr_madhan', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'cb6c4edb-4c49-4065-a4a0-f7761a55ade9', '2026-09-17 15:36:38.832764+05:30', '2026-09-17 15:36:38.832768+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_environmental_law_l_l_b_all', '82c42da8-1589-41ac-9a81-a06a21d9d029', 'usr_kavya', 'deg_l_l_b_all', 3, 'usr_madhan', true, 'b1459e29-6816-4115-b220-e7fad29b6261', '2026-09-17 15:36:51.755701+05:30', '2026-09-17 15:36:51.755706+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_interpretation_of_statutes_l_l_b_all', 'e7cdb1c0-fc75-45f3-90ac-57649ff42a3e', 'usr_palani', 'deg_l_l_b_all', 3, 'usr_madhan', true, '35efb36c-fd8d-4451-a390-4c3e75f64a0f', '2026-09-17 15:36:51.775961+05:30', '2026-09-17 15:36:51.775966+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_professional_l_l_b_all', 'cffc2627-60af-4776-a054-74f8a476ae7c', 'usr_palani', 'deg_l_l_b_all', 3, 'usr_madhan', true, '8b414e6f-e509-486f-b169-13a39cb3fbd7', '2026-09-17 15:36:51.788327+05:30', '2026-09-17 15:36:51.788331+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_environmental_law_l_l_b_all', '1dc577b9-c821-4593-b216-156607c28f81', 'usr_kavya', 'deg_l_l_b_all', 3, 'usr_madhan', true, 'f561936f-527e-44c5-8322-5654b5fdbd21', '2026-09-17 15:37:07.178905+05:30', '2026-09-17 15:37:07.178909+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_environmental_law_l_l_b_all', 'd391142d-1c7d-4f3b-bc27-6a53ccc8e5a2', 'usr_palani', 'deg_l_l_b_all', 3, 'usr_madhan', true, '2dcce20b-fc66-4102-bcce-7933bf6de5a5', '2026-09-17 15:37:07.195019+05:30', '2026-09-17 15:37:07.195023+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_interpretation_of_statutes_l_l_b_all', '9bc851f3-e5e4-4f21-9c65-db3ecde3d7b4', 'usr_palani', 'deg_l_l_b_all', 3, 'usr_madhan', true, '674dc33f-9e15-42f8-9fd0-b04675ea7a67', '2026-09-17 15:37:07.209188+05:30', '2026-09-17 15:37:07.209192+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_interpretation_of_statutes_l_l_b_all', '6fd27144-52b6-43b7-a75b-6c5689b45f9b', 'usr_kavya', 'deg_l_l_b_all', 3, 'usr_madhan', true, 'ba83138e-8b71-418b-99a2-15f480d90e66', '2026-09-17 15:37:07.220567+05:30', '2026-09-17 15:37:07.22057+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_professional_l_l_b_all', '3c9d02ca-0255-4cf4-a51f-6553bcca3fa0', 'usr_palani', 'deg_l_l_b_all', 3, 'usr_madhan', true, '19e43d51-e0cb-407f-b39e-8b262ede494f', '2026-09-17 15:37:07.230805+05:30', '2026-09-17 15:37:07.230807+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2025_2028', 'crs_professional_l_l_b_all', 'e624ba00-feda-4b6d-a808-8ee55700785b', 'usr_madhan', 'deg_l_l_b_all', 3, 'usr_madhan', true, '3fc8b7e3-2389-403e-9c38-8488b31fb825', '2026-09-17 15:37:07.237214+05:30', '2026-09-17 15:37:07.237217+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', 'e0728f81-8bfb-4d71-a66d-2e3aa05e9287', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '04186006-d307-4df9-b80a-b5ac7ce34c19', '2026-09-17 15:38:38.454602+05:30', '2026-09-17 15:38:38.454607+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '47b24546-c38b-4b4a-9181-1a00e9b3b3df', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '7144b308-6341-40e2-8430-46624af12a23', '2026-09-17 15:38:38.477623+05:30', '2026-09-17 15:38:38.477628+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '52104c46-410a-4222-98c8-17f3cf1d4902', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '1cd9c5d1-2914-4a6d-b476-4f67edffda65', '2026-09-17 15:38:38.497708+05:30', '2026-09-17 15:38:38.497713+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '298fe73b-8c76-42c9-a1ad-bbd94429cc04', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '78a108d7-7765-45f9-bd9b-9b8e31dedd7b', '2026-09-17 15:38:38.517397+05:30', '2026-09-17 15:38:38.517402+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', 'c5d1eb22-efef-4fa8-9d8e-4c052c9b6fb2', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'e9c9c215-c8a7-47a6-8058-28f72bbec322', '2026-09-17 15:38:38.535776+05:30', '2026-09-17 15:38:38.535781+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '9927cc03-e967-4411-ae0c-0241f5119d06', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '86bf2636-24d2-4e4f-a669-2d5fb0184a64', '2026-09-17 15:38:38.554042+05:30', '2026-09-17 15:38:38.554047+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', 'e606ae6f-3957-4ce1-8da4-05f69675852d', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'b40e444f-f618-4172-b558-a7a2c3e92dee', '2026-09-17 15:38:38.569447+05:30', '2026-09-17 15:38:38.569451+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '7f46d994-f9ce-4011-b7ac-670a26453e7b', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '9e2c6bdd-e739-4c3d-ade9-4fd5338cad2e', '2026-09-17 15:38:38.581828+05:30', '2026-09-17 15:38:38.581831+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '064aa62f-72dd-4211-a50b-537fab73e9f3', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '4af29548-cf48-4f8d-9a6f-9cedededb408', '2026-09-17 15:38:38.592217+05:30', '2026-09-17 15:38:38.59222+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '0c1597e5-c46d-414f-ae79-49ab7bc0ab1d', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '3cea5d8c-fd86-4be5-9ebf-8c146e35672a', '2026-09-17 15:38:38.598706+05:30', '2026-09-17 15:38:38.598709+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', 'f918ec74-3d56-4618-8827-b9ee9187e0bd', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '653baf8d-342c-4098-8c26-93092675fc70', '2026-09-17 15:41:50.313781+05:30', '2026-09-17 15:41:50.313786+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '879f3f4e-7ff3-4097-9e13-2533b9cad831', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '2cceee6a-395a-4cb4-8c54-5a2a1ef69bdb', '2026-09-17 15:41:50.328962+05:30', '2026-09-17 15:41:50.328965+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '674b6192-6d57-4c27-b158-2e7fd0e2263d', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '066d4a60-e45b-41c6-978b-67fa27a5c225', '2026-09-17 15:41:50.34146+05:30', '2026-09-17 15:41:50.341464+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '89bc496a-dcec-4fc3-978c-7072398ee747', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '65afb0cc-24a1-4ade-8992-0384ae8fd492', '2026-09-17 15:41:50.35267+05:30', '2026-09-17 15:41:50.352673+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '1e85c783-9a49-43b8-91cf-37568ad3901b', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '4abcc2a2-ee07-4b86-a108-7a2cda0bbbd2', '2026-09-17 15:41:50.362593+05:30', '2026-09-17 15:41:50.362596+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '996b3cd7-ecc3-4d21-b463-538769b2eb1d', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '8e55ccba-bcab-44ce-b4ee-d599d28734d2', '2026-09-17 15:41:50.372424+05:30', '2026-09-17 15:41:50.372427+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '0298b948-6443-4a93-8ec5-9da9cbf047b3', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '0016edcc-c93c-4b50-8b60-4f2b1586c843', '2026-09-17 15:41:50.382047+05:30', '2026-09-17 15:41:50.38205+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', 'cb4afb02-6b8b-45fd-b145-75eb0ce30b9e', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '95d4ac99-21c6-4fd1-b077-a36a7ce83fd9', '2026-09-17 15:41:50.391682+05:30', '2026-09-17 15:41:50.391685+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '17d2d6d9-8c5f-4844-aedf-6dae1c473cb4', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'c9adc000-2e1d-4a4f-bedc-1a4b3e7aaf69', '2026-09-17 15:41:50.401064+05:30', '2026-09-17 15:41:50.401066+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '827248b5-9ef9-454c-8759-bcbaf3299d25', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '969ae787-9b73-4298-b7a2-6fd56ecd116b', '2026-09-17 15:41:50.407135+05:30', '2026-09-17 15:41:50.407137+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '033f31e2-bfb7-46e7-a091-e67f348da3ee', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'ec3f5904-6004-4eee-bf67-ee5f8e7aea94', '2026-09-17 15:42:11.935181+05:30', '2026-09-17 15:42:11.935187+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '8b6544ea-7452-46da-87e9-7600ee17f7de', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'c772a52b-6a09-4a46-b1e2-efb78aa51f79', '2026-09-17 15:42:11.95961+05:30', '2026-09-17 15:42:11.959614+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '505c8ee9-1769-4911-a154-ed6ce03d3823', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '8882dd38-2ab1-4c09-b8ac-69db900ab54e', '2026-09-17 15:42:11.979151+05:30', '2026-09-17 15:42:11.979155+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '995e1b59-f5f9-4139-a3b9-d4214f3d6e0a', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '719ef02c-268e-47ec-8536-9efe8e352b95', '2026-09-17 15:42:11.998426+05:30', '2026-09-17 15:42:11.998431+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', 'b88fa291-6861-4f38-8fbd-db2b79b0cfdf', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'f13672e2-4f4e-4459-ac23-404392d8166d', '2026-09-17 15:42:12.017979+05:30', '2026-09-17 15:42:12.017984+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', 'e4c610b7-21a3-42b0-9a4a-b5eb42642d33', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'f62aed25-42e3-42b7-b92e-715d23bb8784', '2026-09-17 15:42:12.03619+05:30', '2026-09-17 15:42:12.036195+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '850e6f82-4538-44b0-bf58-105a9478ed84', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'f2f717d0-7f2b-402a-a14c-ee49b0a6c84f', '2026-09-17 15:42:12.052445+05:30', '2026-09-17 15:42:12.052449+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '255a968a-398f-42ae-b7ad-80db6fa26a3f', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '63a4ab31-994d-4958-a826-4df6f8557966', '2026-09-17 15:42:12.066177+05:30', '2026-09-17 15:42:12.066181+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '3d27c602-f52f-4386-98f0-d4f3f8774bd5', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '3bb53668-4090-4ff2-ad31-99513dcac5db', '2026-09-17 15:42:12.077867+05:30', '2026-09-17 15:42:12.077871+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '722f73b3-b855-492f-a0d4-c47b28adac02', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '12363b81-5807-479f-9432-0a373e81d8c8', '2026-09-17 15:42:12.084532+05:30', '2026-09-17 15:42:12.084535+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_civil_procedure_code_l_l_b_all', '57b8c7f6-3c99-4b7f-8dc1-337fd09b4616', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'cf49074f-a418-401a-9506-537986948d22', '2026-09-17 15:52:42.973786+05:30', '2026-09-17 15:52:42.97379+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_civil_procedure_code_l_l_b_all', '697f49e8-23b4-4db3-819d-2714b50fb331', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'e16af161-ab06-4c22-854c-68d9306d842d', '2026-09-17 15:52:42.985669+05:30', '2026-09-17 15:52:42.985672+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_company_law_l_l_b_all', '5e6efb00-6db7-4d72-991e-5f816a8a2aca', 'usr_palani', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'ae9ce5e3-a0b7-4af2-9124-52a90cc51b6c', '2026-09-17 15:52:42.995942+05:30', '2026-09-17 15:52:42.995946+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_company_law_l_l_b_all', '0690b31c-1d74-4b3e-af85-d6cbea1bba4b', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, '97e727cb-f3ce-458d-a635-ba2f1a769f6b', '2026-09-17 15:52:43.006417+05:30', '2026-09-17 15:52:43.006421+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_criminal_procedure_code_l_l_b_all', 'be565acd-1036-4ad7-96e4-f9197986c719', 'usr_madhan', 'deg_l_l_b_all', 1, 'usr_madhan', true, '653163e7-d1ee-4707-88f2-7afba9498b75', '2026-09-17 15:52:43.017004+05:30', '2026-09-17 15:52:43.017007+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_criminal_procedure_code_l_l_b_all', '8515637d-4513-4d56-b150-d1c7d8c19f55', 'usr_madhan', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'e6508e9f-d92a-49de-902e-e294326de66f', '2026-09-17 15:52:43.023283+05:30', '2026-09-17 15:52:43.023285+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_civil_procedure_code_l_l_b_all', '99f37e4d-1b88-4a9c-bdde-b14e08ab9c29', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, '6f444d89-aaf1-4c7a-9997-8becfd268638', '2026-09-17 15:54:32.20352+05:30', '2026-09-17 15:54:32.203525+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_company_law_l_l_b_all', 'bbab245c-fc6f-443a-83d0-9722918c5160', 'usr_kavya', 'deg_l_l_b_all', 1, 'usr_madhan', true, 'b27fa932-e320-4807-bf1d-060b671ef4ea', '2026-09-17 15:54:32.203537+05:30', '2026-09-17 15:54:32.203538+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_l_l_b_2026_2029', 'crs_criminal_procedure_code_l_l_b_all', '675c9af7-734d-4c86-bc0b-325dd7454f93', 'usr_palani', 'deg_l_l_b_all', 1, 'usr_madhan', true, '48cec29c-e2e6-4c42-a029-3b318fcb5b9b', '2026-09-17 15:54:32.203547+05:30', '2026-09-17 15:54:32.203548+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', '5ee56b9c-2737-461d-a77a-d5436bcdc4b2', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'c2f9457d-c255-414b-b450-075e577ce2d8', '2026-09-21 19:24:10.79491+05:30', '2026-09-21 19:24:10.794914+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_economics___i_b_a_l_l_b_all', 'dc9830a3-1360-462c-b9c4-fab114a31992', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'fa837a55-c4e7-4394-b5d5-3d90853459c7', '2026-09-21 19:24:10.808447+05:30', '2026-09-21 19:24:10.80845+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', 'e49da79a-418f-40df-8401-c28cc917e568', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'dd97188c-6d01-4d1d-9747-fc0740706bda', '2026-09-21 19:24:10.819933+05:30', '2026-09-21 19:24:10.819937+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_english___i_b_a_l_l_b_all', '55d6c405-e6c1-4a75-b220-393903de60e7', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '9ff2d566-6b3b-430f-9360-928487d6b427', '2026-09-21 19:24:10.831326+05:30', '2026-09-21 19:24:10.83133+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', '1d14fbcc-273c-4e63-a63d-cb956ca7a606', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'ed0806da-8a19-42d7-94e9-21eaaa0362e9', '2026-09-21 19:24:10.843192+05:30', '2026-09-21 19:24:10.843195+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_legal_method_b_a_l_l_b_all', 'fae77771-c5e4-4b19-ae8c-963b0d8828ec', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '6589f949-e234-4ebe-be05-b921e850c2dc', '2026-09-21 19:24:10.854153+05:30', '2026-09-21 19:24:10.854156+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '423bc2b1-a1bb-47d4-892d-0fb10f9cb943', 'usr_alexa', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'd6658553-9d09-47e5-9e2d-845e5ebf78dc', '2026-09-21 19:24:10.864515+05:30', '2026-09-21 19:24:10.864518+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_political_science___i_b_a_l_l_b_all', '679a8019-ac75-4bf9-a42f-1ad3aac72672', 'usr_sobi', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '8fd84fd8-6ace-47b4-ac58-1d557c16330f', '2026-09-21 19:24:10.873676+05:30', '2026-09-21 19:24:10.873678+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '439f9685-4b23-4587-af36-42e420b617eb', 'usr_ajay', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, '92a1dc75-940c-4ea4-8b99-564ec2b4c7a5', '2026-09-21 19:24:10.882721+05:30', '2026-09-21 19:24:10.882723+05:30', false, NULL);
INSERT INTO public.subject_allocations VALUES ('ay_2026_2027_b_a_l_l_b_2026_2031', 'crs_sociology___i_b_a_l_l_b_all', '6e74ae5b-7c07-421a-84a5-4811ac355087', 'usr_arya', 'deg_b_a_l_l_b_all', 1, 'usr_sobi', true, 'f90092b3-e221-4788-b0df-a68cf21bf7b9', '2026-09-21 19:24:10.888827+05:30', '2026-09-21 19:24:10.888831+05:30', false, NULL);


--
-- Data for Name: substitution_allocations; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: system_setting_history; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.system_settings VALUES ('CAMS Law College', NULL, '123 Academic Campus', 'AFF-98765', 'UGC-12345', 'NAAC A+', 'State Bank of India', '1234567890', 'SBIN0001234', 'Main Branch', '0915e596-55f3-4433-a849-ad5c54e9ea2f', '2026-09-22 10:22:29.633324+05:30', '2026-09-22 10:22:29.633332+05:30', false, NULL);


--
-- Data for Name: teaching_log_audits; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.teaching_log_audits VALUES ('Arya', 'FACULTY', 'Diary Created', '2026-09-17T10:37:50.264290', '127.0.0.1', 'Logged class for Political Science – I (2026-09-17)', '429eaeaa-a9aa-49b9-814f-f341a10b1e12', '2026-09-17 16:07:50.277214+05:30', '2026-09-17 16:07:50.277217+05:30', false, NULL);
INSERT INTO public.teaching_log_audits VALUES ('Ajay', 'FACULTY', 'Diary Created', '2026-09-17T10:38:35.504632', '127.0.0.1', 'Logged class for Sociology – I (2026-09-17)', '2f0db979-195d-45e1-b46a-3cb5e1e65f5d', '2026-09-17 16:08:35.520325+05:30', '2026-09-17 16:08:35.520331+05:30', false, NULL);
INSERT INTO public.teaching_log_audits VALUES ('Palani', 'FACULTY', 'Diary Created', '2026-09-17T10:46:26.009996', '127.0.0.1', 'Logged class for Company Law (2026-09-17)', '5db7b8b9-e0c2-455b-bb94-a4d1594a8f8a', '2026-09-17 16:16:26.025968+05:30', '2026-09-17 16:16:26.025972+05:30', false, NULL);
INSERT INTO public.teaching_log_audits VALUES ('Palani', 'FACULTY', 'Diary Created', '2026-09-17T10:46:49.606471', '127.0.0.1', 'Logged class for Interpretation of Statutes (2026-09-17)', '1c2eda6d-3da7-419c-8a1f-91b680e38942', '2026-09-17 16:16:49.617712+05:30', '2026-09-17 16:16:49.617717+05:30', false, NULL);
INSERT INTO public.teaching_log_audits VALUES ('Palani', 'FACULTY', 'Diary Created', '2026-09-17T10:50:45.182819', '127.0.0.1', 'Logged class for Interpretation of Statutes (2026-09-18)', 'f405ef33-ecc5-4a75-a1d6-e3061a8d25c2', '2026-09-17 16:20:45.194902+05:30', '2026-09-17 16:20:45.194905+05:30', false, NULL);
INSERT INTO public.teaching_log_audits VALUES ('Palani', 'FACULTY', 'Diary Created', '2026-09-17T10:55:08.574512', '127.0.0.1', 'Logged class for Environmental Law (2026-09-17)', '3dc0bd89-a6ac-42f8-8c51-989831945db6', '2026-09-17 16:25:08.58979+05:30', '2026-09-17 16:25:08.589795+05:30', false, NULL);
INSERT INTO public.teaching_log_audits VALUES ('kavya', 'FACULTY', 'Diary Created', '2026-09-17T10:55:28.112774', '127.0.0.1', 'Logged class for Environmental Law (2026-09-17)', '8511d3f9-829d-4795-b143-909965962dda', '2026-09-17 16:25:28.127738+05:30', '2026-09-17 16:25:28.127743+05:30', false, NULL);


--
-- Data for Name: teaching_log_notifications; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.teaching_log_notifications VALUES ('usr_sobi', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-16', false, '9d01b5af-6134-48f1-b797-19d00bebfa75', '2026-09-16 15:37:38.931714+05:30', '2026-09-16 15:37:38.931719+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_madhan', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-16', false, '6c956120-abe8-421c-a140-d368f8789e33', '2026-09-16 15:37:38.931721+05:30', '2026-09-16 15:37:38.931723+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_arya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-16', false, '5e5eaada-2cc7-4ad4-80cc-527a8771804e', '2026-09-16 15:37:38.931724+05:30', '2026-09-16 15:37:38.931725+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_ajay', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-16', false, '442ac593-d940-403c-873d-8eecbaeb5297', '2026-09-16 15:37:38.931727+05:30', '2026-09-16 15:37:38.931728+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_palani', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-16', false, 'a248f8c4-acbd-4d84-b548-a77ffd6682de', '2026-09-16 15:37:38.931729+05:30', '2026-09-16 15:37:38.93173+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_kavya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-16', false, 'b81eee5a-5881-4138-a9ba-77e20b81f430', '2026-09-16 15:37:38.931732+05:30', '2026-09-16 15:37:38.931733+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_alexa', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (16 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-16', false, '6cbc22f7-8a33-4dd4-b0dd-2336dd2f5172', '2026-09-16 17:28:20.212062+05:30', '2026-09-16 17:28:20.212069+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_alexa', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-17', false, 'b55a9649-aee2-4c22-8f83-16663e692b6d', '2026-09-17 09:49:29.362919+05:30', '2026-09-17 09:49:29.36293+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_sobi', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-17', false, '4c10e448-64ef-4551-85f7-667a906d1b33', '2026-09-17 09:49:29.362935+05:30', '2026-09-17 09:49:29.362937+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_madhan', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-17', false, '95592a37-39d8-49ed-ac3c-92406d4d9aa8', '2026-09-17 09:49:29.362942+05:30', '2026-09-17 09:49:29.362945+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_arya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-17', false, 'b8f36308-8c9f-46be-8c7a-5c2f4de1caec', '2026-09-17 09:49:29.362948+05:30', '2026-09-17 09:49:29.36295+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_ajay', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-17', false, '2648e70c-0183-4ec1-924e-f49632ab5177', '2026-09-17 09:49:29.362954+05:30', '2026-09-17 09:49:29.362957+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_palani', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-17', false, '2eee6d12-40d2-432f-94df-8086ce3a1974', '2026-09-17 09:49:29.36296+05:30', '2026-09-17 09:49:29.362963+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_kavya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (17 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-17', false, '35cf39fa-d98f-4ba7-8197-19ad5e572ac2', '2026-09-17 09:49:29.362966+05:30', '2026-09-17 09:49:29.362968+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_alexa', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-18', false, 'e8909b83-a1ca-4135-94fe-741656c8d76e', '2026-09-18 17:28:33.056654+05:30', '2026-09-18 17:28:33.056659+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_sobi', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-18', false, '229f1122-cca9-416e-855d-5543749df4bd', '2026-09-18 17:28:33.056661+05:30', '2026-09-18 17:28:33.056662+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_madhan', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-18', false, '6b2025f3-d739-4a93-9679-8e814d10a520', '2026-09-18 17:28:33.056663+05:30', '2026-09-18 17:28:33.056664+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_arya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-18', false, 'c8fdf240-4e7c-4f19-bd34-73c1840b9227', '2026-09-18 17:28:33.056665+05:30', '2026-09-18 17:28:33.056665+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_ajay', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-18', false, 'b352d895-66e1-4b8b-85d6-721928e091f3', '2026-09-18 17:28:33.056666+05:30', '2026-09-18 17:28:33.056667+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_kavya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (18 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-18', false, '8f47c031-e86d-47ad-b9f5-13982a014732', '2026-09-18 17:28:33.056668+05:30', '2026-09-18 17:28:33.056669+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_alexa', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-21', false, '9a9585c0-83bd-4c4c-8001-bbc60babc7c6', '2026-09-21 19:33:58.806448+05:30', '2026-09-21 19:33:58.806452+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_sobi', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-21', false, 'df0f0515-8769-4f1d-bd07-04c22b3cf281', '2026-09-21 19:33:58.806454+05:30', '2026-09-21 19:33:58.806455+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_madhan', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-21', false, '0fe1bf06-1d75-4c87-b2d8-e80a7b071877', '2026-09-21 19:33:58.806456+05:30', '2026-09-21 19:33:58.806457+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_arya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-21', false, '0c26a889-de99-40b2-93b6-2362c2d2d38a', '2026-09-21 19:33:58.806458+05:30', '2026-09-21 19:33:58.806459+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_ajay', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-21', false, 'e8f24007-f863-4c63-a9ca-140ecdf9035e', '2026-09-21 19:33:58.80646+05:30', '2026-09-21 19:33:58.806461+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_palani', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-21', false, '6e026ed0-f801-4a82-a4b7-841553295d32', '2026-09-21 19:33:58.806462+05:30', '2026-09-21 19:33:58.806463+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_kavya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (21 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-21', false, 'b02ed7dd-d4cb-4ebd-ad4c-7974c8f796fe', '2026-09-21 19:33:58.806464+05:30', '2026-09-21 19:33:58.806465+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_alexa', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-22', false, '4293f1b7-c3b4-471e-bff7-135105b7901f', '2026-09-22 10:23:55.523125+05:30', '2026-09-22 10:23:55.52313+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_sobi', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-22', false, '5689a039-5a98-4dfd-9021-4f250fbc8d96', '2026-09-22 10:23:55.523131+05:30', '2026-09-22 10:23:55.523132+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_madhan', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-22', false, '66c7b6e4-4310-4a97-9766-7283174a867a', '2026-09-22 10:23:55.523133+05:30', '2026-09-22 10:23:55.523134+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_arya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-22', false, '37182b7b-5441-4bf6-a772-2f49e6f8486a', '2026-09-22 10:23:55.523135+05:30', '2026-09-22 10:23:55.523136+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_ajay', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-22', false, '57f3f1a5-727c-47ea-8734-eb7312a5b366', '2026-09-22 10:23:55.523136+05:30', '2026-09-22 10:23:55.523137+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_palani', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-22', false, '66c5cc56-3ecd-4db0-a09d-236df0b82716', '2026-09-22 10:23:55.523138+05:30', '2026-09-22 10:23:55.523139+05:30', false, NULL);
INSERT INTO public.teaching_log_notifications VALUES ('usr_kavya', 'Daily Diary Log Reminder', 'Reminder: You have not submitted your Daily Diary / Teaching Log for today (22 Sep 2026). Please record your teaching activities before the end of the day.', '2026-09-22', false, '061adf75-bc55-41e0-a34d-80e4365627dd', '2026-09-22 10:23:55.52314+05:30', '2026-09-22 10:23:55.52314+05:30', false, NULL);


--
-- Data for Name: timetable; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.timetable VALUES ('bbab245c-fc6f-443a-83d0-9722918c5160', 'crs_company_law_l_l_b_all', 'usr_kavya', 'LH-1A', 'THURSDAY', '10:00:00', '10:50:00', true, false, '3688af54-d4b4-4feb-b000-6f6a469d07ea', '2026-09-17 15:50:28.995014+05:30', '2026-09-17 15:55:28.605224+05:30', true, '2026-09-17 15:55:28.594276+05:30');
INSERT INTO public.timetable VALUES ('bbab245c-fc6f-443a-83d0-9722918c5160', 'crs_company_law_l_l_b_all', 'usr_kavya', 'LH-1A', 'THURSDAY', '14:30:00', '15:20:00', true, false, '74cce898-ffee-4f4e-b3a3-28cbacf69f26', '2026-09-17 15:50:29.019931+05:30', '2026-09-17 15:55:34.207494+05:30', true, '2026-09-17 15:55:34.197702+05:30');
INSERT INTO public.timetable VALUES ('c34ee2a5-5e86-4029-bbfa-664ed3ef35c3', 'crs_economics___i_b_a_l_l_b_all', 'usr_ajay', 'LH-1J', 'THURSDAY', '13:40:00', '14:30:00', false, false, '1dd650ba-4482-41a7-a525-abd4084dbf30', '2026-09-17 15:53:09.081495+05:30', '2026-09-17 16:02:28.835714+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('9372d339-f6fe-424c-b51e-62b8ebcae451', 'crs_criminal_procedure_code_l_l_b_all', 'usr_palani', 'LH-1A', 'THURSDAY', '14:30:00', '15:20:00', true, false, '1a383d84-514a-4970-97f3-a0d032b8ffba', '2026-09-17 15:56:44.803196+05:30', '2026-09-17 15:57:44.42102+05:30', true, '2026-09-17 15:57:44.412438+05:30');
INSERT INTO public.timetable VALUES ('675c9af7-734d-4c86-bc0b-325dd7454f93', 'crs_criminal_procedure_code_l_l_b_all', 'usr_palani', 'LH-1A', 'THURSDAY', '12:05:00', '12:55:00', true, false, '2f9a7652-85f5-41ca-91a1-ca649a3f11f6', '2026-09-17 15:50:29.008591+05:30', '2026-09-17 15:57:47.602839+05:30', true, '2026-09-17 15:57:47.594138+05:30');
INSERT INTO public.timetable VALUES ('77ab8e38-3b95-4945-aab9-f05aaa6df564', 'crs_legal_method_b_a_l_l_b_all', 'usr_sobi', 'LH-1M', 'THURSDAY', '10:00:00', '10:50:00', false, false, '9ed1d9f6-3552-4727-8416-1efcda6e9de6', '2026-09-17 15:53:09.05882+05:30', '2026-09-17 16:02:28.835721+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('467d4535-3637-43c4-8c30-23fcb05e20fc', 'crs_sociology___i_b_a_l_l_b_all', 'usr_ajay', 'LH-1K', 'THURSDAY', '12:05:00', '12:55:00', false, false, 'e82b962c-44a5-4061-8729-dc6773db785d', '2026-09-17 15:53:09.074535+05:30', '2026-09-17 16:02:28.835722+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('01b45777-f5e9-42cc-ad29-e2da870f6f6a', 'crs_political_science___i_b_a_l_l_b_all', 'usr_arya', 'LH-1B', 'THURSDAY', '10:50:00', '11:40:00', false, false, 'e9b1c829-eeef-4bc9-ab24-a557bcafd1a2', '2026-09-17 15:53:09.066062+05:30', '2026-09-17 16:02:28.835724+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('540c2321-3edb-4ecd-96d3-a98180c05fe5', 'crs_english___i_b_a_l_l_b_all', 'usr_arya', 'LH-1U', 'THURSDAY', '14:30:00', '15:20:00', false, false, 'f67c7024-89b9-48aa-8fb8-0cc50eca9197', '2026-09-17 15:53:09.088312+05:30', '2026-09-17 16:02:28.835725+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('90afd3df-3b8b-46dc-91d4-7871dcbf9b24', 'crs_criminal_procedure_code_l_l_b_all', 'usr_madhan', 'LH-1B', 'THURSDAY', '12:05:00', '12:55:00', false, false, '92e1fc44-8d67-4c47-ad69-595d7bcc5a04', '2026-09-17 15:59:16.572717+05:30', '2026-09-17 16:02:43.886262+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('90afd3df-3b8b-46dc-91d4-7871dcbf9b24', 'crs_criminal_procedure_code_l_l_b_all', 'usr_madhan', 'LH-1B', 'THURSDAY', '10:00:00', '10:50:00', false, false, '9d9dc7a7-d878-458b-a6df-20c96ca4de90', '2026-09-17 15:59:16.568121+05:30', '2026-09-17 16:02:43.886269+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('7a1ca373-30b0-4fac-83c0-c76d0076ca21', 'crs_environmental_law_l_l_b_all', 'usr_palani', 'LH-3B', 'THURSDAY', '14:30:00', '15:20:00', false, false, '05ca5b00-8f76-4df9-a4ab-a678eba88883', '2026-09-17 16:00:22.880939+05:30', '2026-09-17 16:11:37.247048+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('cfb8ce0c-1eac-4d18-968d-fe84271684f8', 'crs_professional_l_l_b_all', 'usr_madhan', 'LH-3B', 'THURSDAY', '13:40:00', '14:30:00', false, false, '08050a1b-0281-4d39-9f8a-de6abedd416d', '2026-09-17 16:00:22.886097+05:30', '2026-09-17 16:11:37.247056+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('da247040-a46e-423e-810f-7806cb39c212', 'crs_family_law___i_b_a_l_l_b_all', 'usr_ajay', 'LH-3D', 'THURSDAY', '14:30:00', '15:20:00', false, false, '4a6dc3ef-872e-41b9-852f-4635b664c9a0', '2026-09-17 16:08:58.515031+05:30', '2026-09-17 16:11:53.172684+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('da247040-a46e-423e-810f-7806cb39c212', 'crs_family_law___i_b_a_l_l_b_all', 'usr_ajay', 'LH-3G', 'THURSDAY', '10:50:00', '11:40:00', false, false, '9cb7c896-c1ba-44a5-a0a1-a7f4b33650db', '2026-09-17 16:08:58.528473+05:30', '2026-09-17 16:11:53.172686+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('76f163b3-00d5-428e-8296-330e06dc1c90', 'crs_law_of_contract___i_b_a_l_l_b_all', 'usr_arya', 'LH-3H', 'THURSDAY', '10:00:00', '10:50:00', false, false, '12c04bc5-49e7-4f6c-9c24-4d24634f517d', '2026-09-17 16:08:58.521217+05:30', '2026-09-17 16:11:53.172675+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('76f163b3-00d5-428e-8296-330e06dc1c90', 'crs_law_of_contract___i_b_a_l_l_b_all', 'usr_arya', 'LH-3F', 'THURSDAY', '13:40:00', '14:30:00', false, false, '443c8960-93a8-4a92-8e29-60aceb5336c1', '2026-09-17 16:08:58.54029+05:30', '2026-09-17 16:11:53.172682+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('76f163b3-00d5-428e-8296-330e06dc1c90', 'crs_law_of_contract___i_b_a_l_l_b_all', 'usr_arya', 'LH-3V', 'THURSDAY', '12:05:00', '12:55:00', false, false, 'a3cb143b-394d-412a-a81b-122d4f3b2d3f', '2026-09-17 16:08:58.534497+05:30', '2026-09-17 16:11:53.172688+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('a2d272e3-8fa8-4572-a228-8131c00adf18', 'crs_interpretation_of_statutes_l_l_b_all', 'usr_palani', 'LH-3A', 'THURSDAY', '10:50:00', '11:40:00', false, false, '26bcbbe4-7f00-49cf-95cb-bb2316af0828', '2026-09-17 15:56:34.042006+05:30', '2026-09-17 16:11:54.075863+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('a2d272e3-8fa8-4572-a228-8131c00adf18', 'crs_interpretation_of_statutes_l_l_b_all', 'usr_palani', 'LH-3A', 'THURSDAY', '13:40:00', '14:30:00', false, false, '3f464adc-4ef2-4295-8508-d2567928b4d7', '2026-09-17 15:56:34.056054+05:30', '2026-09-17 16:11:54.07587+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('bc62d232-0f14-4502-bb02-9c02c9999c77', 'crs_environmental_law_l_l_b_all', 'usr_kavya', 'LH-3A', 'THURSDAY', '12:05:00', '12:55:00', false, false, '51755fcd-bb46-4ceb-a09e-f2a944d944d9', '2026-09-17 15:56:34.04976+05:30', '2026-09-17 16:11:54.075872+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('bc62d232-0f14-4502-bb02-9c02c9999c77', 'crs_environmental_law_l_l_b_all', 'usr_kavya', 'LH-3A', 'THURSDAY', '10:00:00', '10:50:00', false, false, '9ca863c8-4ca9-4fcf-8396-a31021e09623', '2026-09-17 15:56:34.035714+05:30', '2026-09-17 16:11:54.075875+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('bc62d232-0f14-4502-bb02-9c02c9999c77', 'crs_environmental_law_l_l_b_all', 'usr_kavya', 'LH-3A', 'THURSDAY', '14:30:00', '15:20:00', false, false, 'b51dd7c3-c4fe-4963-9328-bb83906b9138', '2026-09-17 15:56:34.06234+05:30', '2026-09-17 16:11:54.075876+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('0aebb289-2657-400d-b602-dd687016c430', 'crs_civil_procedure_code_l_l_b_all', 'usr_kavya', 'LH-1A', 'THURSDAY', '10:50:00', '11:40:00', false, false, '3c5c552b-c06d-44a0-845d-42ea8dbda9d0', '2026-09-17 16:00:30.919398+05:30', '2026-09-17 16:12:00.297433+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('9372d339-f6fe-424c-b51e-62b8ebcae451', 'crs_criminal_procedure_code_l_l_b_all', 'usr_palani', 'LH-1A', 'THURSDAY', '10:00:00', '10:50:00', false, false, '56c095a4-410d-4c53-82d8-78021745a6e1', '2026-09-17 16:00:30.932804+05:30', '2026-09-17 16:12:00.297442+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('0ad4719a-900e-4875-bf97-5b7f307288c5', 'crs_company_law_l_l_b_all', 'usr_kavya', 'LH-1A', 'THURSDAY', '13:40:00', '14:30:00', false, false, 'd93e56a6-d150-4676-8871-71df6a60562f', '2026-09-17 16:00:30.925462+05:30', '2026-09-17 16:12:00.297444+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('c34ee2a5-5e86-4029-bbfa-664ed3ef35c3', 'crs_economics___i_b_a_l_l_b_all', 'usr_ajay', 'LH-1J', 'THURSDAY', '13:40:00', '14:30:00', true, false, 'fba37391-327f-4c84-852d-c45c3540a545', '2026-09-21 19:32:46.217088+05:30', '2026-09-21 19:32:46.217095+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('77ab8e38-3b95-4945-aab9-f05aaa6df564', 'crs_legal_method_b_a_l_l_b_all', 'usr_sobi', 'LH-1M', 'THURSDAY', '10:00:00', '10:50:00', true, false, '6e96ed7b-d729-4b2e-9de9-252fd753182b', '2026-09-21 19:32:46.223682+05:30', '2026-09-21 19:32:46.223687+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('467d4535-3637-43c4-8c30-23fcb05e20fc', 'crs_sociology___i_b_a_l_l_b_all', 'usr_ajay', 'LH-1K', 'THURSDAY', '12:05:00', '12:55:00', true, false, 'c405211a-cba2-45ed-8325-7b69072596ff', '2026-09-21 19:32:46.231966+05:30', '2026-09-21 19:32:46.231971+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('01b45777-f5e9-42cc-ad29-e2da870f6f6a', 'crs_political_science___i_b_a_l_l_b_all', 'usr_arya', 'LH-1B', 'THURSDAY', '10:50:00', '11:40:00', true, false, '85d6c0e3-12c1-4d98-a521-fb81820fb647', '2026-09-21 19:32:46.237708+05:30', '2026-09-21 19:32:46.237714+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('540c2321-3edb-4ecd-96d3-a98180c05fe5', 'crs_english___i_b_a_l_l_b_all', 'usr_arya', 'LH-1U', 'THURSDAY', '14:30:00', '15:20:00', true, false, '3b0b0c70-32c0-45e3-997d-90d37a6b03ed', '2026-09-21 19:32:46.243217+05:30', '2026-09-21 19:32:46.243222+05:30', false, NULL);
INSERT INTO public.timetable VALUES ('77ab8e38-3b95-4945-aab9-f05aaa6df564', 'crs_legal_method_b_a_l_l_b_all', 'usr_sobi', '101 (A_Block)', 'TUESDAY', '10:50:00', '11:40:00', true, false, 'c1c4a7db-7c95-4892-9cea-e362a6f89c70', '2026-09-21 19:32:46.248858+05:30', '2026-09-21 19:32:46.248863+05:30', false, NULL);


--
-- Data for Name: timetable_action_history; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.timetable_action_history VALUES ('bbab245c-fc6f-443a-83d0-9722918c5160', 1, '2026-2029', 'SUBMITTED', 'usr_madhan', 'Timetable draft submitted for approval by HOD.', '59ed7db1-25a4-4925-9228-031a62b32e58', '2026-09-17 15:50:29.033566+05:30', '2026-09-17 15:50:29.033572+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('77ab8e38-3b95-4945-aab9-f05aaa6df564', 1, '2026-2031', 'SUBMITTED', 'usr_sobi', 'Timetable draft submitted for approval by HOD.', '9b9b6fc0-6363-4f12-bff3-5746a9ca3cdc', '2026-09-17 15:53:09.101907+05:30', '2026-09-17 15:53:09.101929+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('bc62d232-0f14-4502-bb02-9c02c9999c77', 3, '2025-2028', 'SUBMITTED', 'usr_madhan', 'Timetable draft submitted for approval by HOD.', '0e31227c-3217-449d-92d6-b380e2182ac0', '2026-09-17 15:56:34.08289+05:30', '2026-09-17 15:56:34.082896+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('90afd3df-3b8b-46dc-91d4-7871dcbf9b24', 1, '2026-2029', 'SUBMITTED', 'usr_madhan', 'Timetable draft submitted for approval by HOD.', '6958297a-836d-4bcc-84a0-f93527c99ee0', '2026-09-17 15:59:16.585029+05:30', '2026-09-17 15:59:16.585034+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('7a1ca373-30b0-4fac-83c0-c76d0076ca21', 3, '2025-2028', 'SUBMITTED', 'usr_madhan', 'Timetable draft submitted for approval by HOD.', 'd7e9301b-2d4b-40dc-82ff-c3f8b7f5f4ff', '2026-09-17 16:00:22.900601+05:30', '2026-09-17 16:00:22.900608+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('99f37e4d-1b88-4a9c-bdde-b14e08ab9c29', 1, '2026-2029', 'SUBMITTED', 'usr_madhan', 'Timetable draft submitted for approval by HOD.', '4fa4d086-8d09-464c-8c6b-3c9673f375bc', '2026-09-17 16:00:30.947632+05:30', '2026-09-17 16:00:30.947639+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('77ab8e38-3b95-4945-aab9-f05aaa6df564', 1, '2026-2031', 'APPROVED', 'usr_dinesh', NULL, 'c7d1fde5-a68f-4bcb-aa2f-2c6411c43411', '2026-09-17 16:02:28.844109+05:30', '2026-09-17 16:02:28.844114+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('90afd3df-3b8b-46dc-91d4-7871dcbf9b24', 1, '2026-2029', 'APPROVED', 'usr_dinesh', NULL, 'df98ba9d-3fef-4b48-b55a-159b457b5bd9', '2026-09-17 16:02:43.893745+05:30', '2026-09-17 16:02:43.89375+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('da247040-a46e-423e-810f-7806cb39c212', 3, '2025-2030', 'SUBMITTED', 'usr_sobi', 'Timetable draft submitted for approval by HOD.', 'b08e2419-3580-47d4-89ea-1e12eaf8c480', '2026-09-17 16:08:58.552343+05:30', '2026-09-17 16:08:58.552349+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('7a1ca373-30b0-4fac-83c0-c76d0076ca21', 3, '2025-2028', 'APPROVED', 'usr_dinesh', NULL, 'a4c0813b-97b8-4e3a-9b07-e1139d1b5528', '2026-09-17 16:11:37.255262+05:30', '2026-09-17 16:11:37.255268+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('76f163b3-00d5-428e-8296-330e06dc1c90', 3, '2025-2030', 'APPROVED', 'usr_dinesh', NULL, 'c36e5a0c-2c4d-4069-9648-e238b5003241', '2026-09-17 16:11:53.182266+05:30', '2026-09-17 16:11:53.182272+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('bc62d232-0f14-4502-bb02-9c02c9999c77', 3, '2025-2028', 'APPROVED', 'usr_dinesh', NULL, 'e56a2e18-f284-4e77-b2e9-043db83ea519', '2026-09-17 16:11:54.084513+05:30', '2026-09-17 16:11:54.084518+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('0aebb289-2657-400d-b602-dd687016c430', 1, '2026-2029', 'APPROVED', 'usr_dinesh', NULL, 'dadc1510-faf4-4aac-9068-b05977cc7f43', '2026-09-17 16:12:00.31239+05:30', '2026-09-17 16:12:00.312396+05:30', false, NULL);
INSERT INTO public.timetable_action_history VALUES ('c34ee2a5-5e86-4029-bbfa-664ed3ef35c3', 1, '2026-2031', 'SUBMITTED', 'usr_sobi', 'Timetable draft submitted for approval by HOD.', 'd13d797a-0bd1-4f09-b103-36629b5d8276', '2026-09-21 19:32:46.271288+05:30', '2026-09-21 19:32:46.271293+05:30', false, NULL);


--
-- Data for Name: timetable_approvals; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.timetable_approvals VALUES ('9ed1d9f6-3552-4727-8416-1efcda6e9de6', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '17b55f2b-ff25-40ac-8a93-f564a4e61ca1', '2026-09-17 15:53:09.068341+05:30', '2026-09-17 16:02:28.838519+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('e82b962c-44a5-4061-8729-dc6773db785d', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '3b2e0f6f-607f-49e8-a1dd-9085d6ba167c', '2026-09-17 15:53:09.083574+05:30', '2026-09-17 16:02:28.838524+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('e9b1c829-eeef-4bc9-ab24-a557bcafd1a2', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'b9887c4a-8cb5-46d5-84f3-bd5b457aa299', '2026-09-17 15:53:09.076641+05:30', '2026-09-17 16:02:28.838526+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('1dd650ba-4482-41a7-a525-abd4084dbf30', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'e8589d99-1be8-40da-90e9-a3988b5e5c6a', '2026-09-17 15:53:09.09048+05:30', '2026-09-17 16:02:28.838527+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('f67c7024-89b9-48aa-8fb8-0cc50eca9197', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'ee76e8f4-0b26-45b9-9174-c7274fd78829', '2026-09-17 15:53:09.098424+05:30', '2026-09-17 16:02:28.838529+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('92e1fc44-8d67-4c47-ad69-595d7bcc5a04', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '203f59ab-ba28-40fc-94a9-fdea33f1427d', '2026-09-17 15:59:16.582264+05:30', '2026-09-17 16:02:43.888884+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('9d9dc7a7-d878-458b-a6df-20c96ca4de90', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'cf19986d-d312-463c-a278-a76001533a55', '2026-09-17 15:59:16.574365+05:30', '2026-09-17 16:02:43.888891+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('08050a1b-0281-4d39-9f8a-de6abedd416d', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'dd2352e8-1739-4961-a448-1c0d98f8dbf3', '2026-09-17 16:00:22.897327+05:30', '2026-09-17 16:11:37.24982+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('05ca5b00-8f76-4df9-a4ab-a678eba88883', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'f67ec286-4ae7-4752-876d-f8a6545ce9d2', '2026-09-17 16:00:22.888692+05:30', '2026-09-17 16:11:37.249826+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('a3cb143b-394d-412a-a81b-122d4f3b2d3f', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '0560da4f-9cc3-4185-b79b-b7af26863c94', '2026-09-17 16:08:58.542092+05:30', '2026-09-17 16:11:53.175643+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('443c8960-93a8-4a92-8e29-60aceb5336c1', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '292dda73-e85b-4aea-aeeb-440487d0a387', '2026-09-17 16:08:58.549358+05:30', '2026-09-17 16:11:53.17565+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('4a6dc3ef-872e-41b9-852f-4635b664c9a0', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '6a080f95-bdaa-4e41-a388-a9151c445653', '2026-09-17 16:08:58.523455+05:30', '2026-09-17 16:11:53.175652+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('12c04bc5-49e7-4f6c-9c24-4d24634f517d', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'e4e2ea7f-c8fc-4e52-938e-d626d1137dbb', '2026-09-17 16:08:58.530361+05:30', '2026-09-17 16:11:53.175653+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('9cb7c896-c1ba-44a5-a0a1-a7f4b33650db', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'eca36e50-e489-447f-967c-0a162dd90572', '2026-09-17 16:08:58.536337+05:30', '2026-09-17 16:11:53.175655+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('26bcbbe4-7f00-49cf-95cb-bb2316af0828', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '30004743-91b5-4c56-af91-86c1d527ff33', '2026-09-17 15:56:34.051809+05:30', '2026-09-17 16:11:54.078311+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('9ca863c8-4ca9-4fcf-8396-a31021e09623', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '5db47ca5-579f-4ee4-b737-5d5e99d9b26c', '2026-09-17 15:56:34.044123+05:30', '2026-09-17 16:11:54.078317+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('3f464adc-4ef2-4295-8508-d2567928b4d7', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '68990912-8aef-4af2-8482-a5c786bd9e93', '2026-09-17 15:56:34.063972+05:30', '2026-09-17 16:11:54.078319+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('b51dd7c3-c4fe-4963-9328-bb83906b9138', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'd4c48462-77db-4e80-8e4d-5bc1f826236e', '2026-09-17 15:56:34.072657+05:30', '2026-09-17 16:11:54.078321+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('51755fcd-bb46-4ceb-a09e-f2a944d944d9', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'f74a3424-d96e-48e5-86ee-683ef18f38aa', '2026-09-17 15:56:34.058023+05:30', '2026-09-17 16:11:54.078323+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('d93e56a6-d150-4676-8871-71df6a60562f', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, '09ef8c47-973d-4ce5-b578-4f4d2802f3b9', '2026-09-17 16:00:30.935103+05:30', '2026-09-17 16:12:00.30715+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('56c095a4-410d-4c53-82d8-78021745a6e1', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'cc17e18d-8c64-4a14-b0cd-998c0b425287', '2026-09-17 16:00:30.944317+05:30', '2026-09-17 16:12:00.307156+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('3c5c552b-c06d-44a0-845d-42ea8dbda9d0', 'APPROVED', 'usr_dinesh', NULL, NULL, NULL, NULL, NULL, 'e721e2ed-1d6c-49c9-b7b4-94626ffceece', '2026-09-17 16:00:30.927867+05:30', '2026-09-17 16:12:00.307157+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('fba37391-327f-4c84-852d-c45c3540a545', 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, '33bf0121-9aa1-4a5a-b3fc-66ae8043ddc7', '2026-09-21 19:32:46.226892+05:30', '2026-09-21 19:32:46.226897+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('6e96ed7b-d729-4b2e-9de9-252fd753182b', 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, '2911d1d0-4124-4aad-93b7-12885bda97d6', '2026-09-21 19:32:46.233806+05:30', '2026-09-21 19:32:46.233811+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('c405211a-cba2-45ed-8325-7b69072596ff', 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, '976d25ad-b12e-40cf-8428-fe80bc80391f', '2026-09-21 19:32:46.239567+05:30', '2026-09-21 19:32:46.239572+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('85d6c0e3-12c1-4d98-a521-fb81820fb647', 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, '89452ca8-bbd6-4012-b91c-acccb008ddc2', '2026-09-21 19:32:46.245062+05:30', '2026-09-21 19:32:46.245067+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('3b0b0c70-32c0-45e3-997d-90d37a6b03ed', 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, 'cb873108-b44e-4fa0-8424-637893195b9d', '2026-09-21 19:32:46.25086+05:30', '2026-09-21 19:32:46.250865+05:30', false, NULL);
INSERT INTO public.timetable_approvals VALUES ('c1c4a7db-7c95-4892-9cea-e362a6f89c70', 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, 'dd3b1db7-8970-4a7a-8a92-dd4b7dd5b6c3', '2026-09-21 19:32:46.259544+05:30', '2026-09-21 19:32:46.25955+05:30', false, NULL);


--
-- Data for Name: timetable_templates; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user_preferences; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_sessions VALUES ('usr_admin', '59b71ca3add71166c6c7170945cf995b8f5b97c2a4c1c46a8294f510b74cece9', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-22 17:43:46.67691+05:30', '2026-09-15 17:43:46.683384+05:30', 'b45ede17-6828-41f0-8338-3643683f8d82', '2026-09-15 17:43:46.683564+05:30', '2026-09-15 17:43:46.683566+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', '0c8a79d429efa2c29a2d6de974385f61156164e8bcf8e80c6dd4120dde3b36c4', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-22 17:46:55.919834+05:30', '2026-09-16 10:47:59.54922+05:30', '05409b7c-25e3-407a-a3db-4b3136c3ac9f', '2026-09-15 17:46:55.92082+05:30', '2026-09-16 10:47:59.585913+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', '4a1e98cc7152f86546564527aff0f907d40d89e848a06f46b5db4d765700f71c', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-23 10:48:02.452715+05:30', '2026-09-16 10:48:02.45436+05:30', '287438ba-c450-426d-986c-4c1c67d9c7a9', '2026-09-16 10:48:02.454427+05:30', '2026-09-16 10:48:02.454429+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_sobi', '2bc6c3b922a9ee2104a13038f77df5fbac58e9774d675307fe6752d095e91f88', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-23 17:04:05.50744+05:30', '2026-09-16 17:04:05.508493+05:30', 'eac62328-3d51-4476-bf12-ae1af5cc0578', '2026-09-16 17:04:05.508585+05:30', '2026-09-16 17:04:05.508587+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', 'eb49bf0b5528f44b19b6a6d027e92f0b095a087989ef3a9ea9f215f0f56c7a69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-23 14:45:56.717472+05:30', '2026-09-17 09:49:28.644142+05:30', 'fc72ba2d-539d-4f13-952d-7d3f03c17211', '2026-09-16 14:45:56.720484+05:30', '2026-09-17 09:49:28.750727+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', '93db4c2bbd2b8837954ee12c6ea418a8b77ee53a988322e3a43f8006d921c5f9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:14:01.366995+05:30', '2026-09-17 15:14:01.372664+05:30', 'c419fdbf-9435-4f03-8cba-f2ffca036ae6', '2026-09-17 15:14:01.372732+05:30', '2026-09-17 15:14:01.372736+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_arya', '8e70c33700d8b0f7c035f8fa133bfad711d62b227ce2746d211e8fb283035b10', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:14:08.385917+05:30', '2026-09-17 15:14:08.386607+05:30', 'b08a7615-b512-46a3-bf81-00814ea6350b', '2026-09-17 15:14:08.386709+05:30', '2026-09-17 15:14:08.386711+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_madhan', '2c5dfbf25335ab693182931b0d662247492793295a345a29222b09c83795b2e4', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:14:31.405051+05:30', '2026-09-17 15:14:31.406864+05:30', 'c9a41314-4a73-4be9-b3ff-2823c9807783', '2026-09-17 15:14:31.407017+05:30', '2026-09-17 15:14:31.407019+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_arya', 'dea8062a6449978e437b4a47a296672114eca4ff82c6c798fc82aa8c0cc00b9d', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:15:32.88299+05:30', '2026-09-17 15:15:32.883556+05:30', 'f585f246-7505-4767-ac08-901d42717b6c', '2026-09-17 15:15:32.883617+05:30', '2026-09-17 15:15:32.883619+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_palani', '868de32b2b4d3ba314c4fb437fb29e648329882abccda0b961604ae3f95a4096', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:16:17.935973+05:30', '2026-09-17 15:16:17.936446+05:30', '95f1d373-b1f4-462e-bef1-c1b703ab5f7f', '2026-09-17 15:16:17.936471+05:30', '2026-09-17 15:16:17.936473+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_student1', '0be2119a74c6b40318288f7cdfcf41e2199e0091ccff226d3f6944850669f75d', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:16:18.522665+05:30', '2026-09-17 15:16:18.523127+05:30', '03cab0ef-c760-49ab-95ee-b4035c40c71d', '2026-09-17 15:16:18.523152+05:30', '2026-09-17 15:16:18.523153+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_student2', '34680202c4085d61ab547417b9e267f57bcdd07f256b3717d8fcbdd72fc270e4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:16:47.884822+05:30', '2026-09-17 15:16:47.88548+05:30', '1d9cc31d-7014-4660-945d-c52daf5d4d83', '2026-09-17 15:16:47.885513+05:30', '2026-09-17 15:16:47.885515+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_student5', '59ab62156e4864fd019aa134a86915dfe6f5112a27a754fe5299e0e28efecd50', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:17:41.230841+05:30', '2026-09-17 15:17:41.23134+05:30', 'd0ba6c56-5162-4ec6-b503-7028a481e346', '2026-09-17 15:17:41.231363+05:30', '2026-09-17 15:17:41.231364+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_student8', '57eb9daf4a4fa5b8a66bea2f1b1929692f19af89dbdada630a6cc7160d302170', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:18:00.972601+05:30', '2026-09-17 15:18:00.973942+05:30', 'e68cb200-b3ee-41ad-83bf-ed09a9ec9428', '2026-09-17 15:18:00.973973+05:30', '2026-09-17 15:18:00.973974+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_student3', '0d9989f4567dbf9961ca838ad8c18fd1fa3eee1a70b2d91c7873c6132a280e0d', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:18:04.332579+05:30', '2026-09-17 15:18:04.33302+05:30', '95f81245-88df-4d40-b02b-5116e15b264d', '2026-09-17 15:18:04.333041+05:30', '2026-09-17 15:18:04.333043+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_kavya', 'cd776ee26dc6817a9a0845b67a306e693cc9f0d0c794b7e8a35e761cfb945091', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:21:42.911151+05:30', '2026-09-17 15:21:42.911724+05:30', '30064a0f-a1f0-4392-a139-dea1942c5531', '2026-09-17 15:21:42.911746+05:30', '2026-09-17 15:21:42.911748+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_student4', '519db0e16f95606fbf5af15150b0dbecc86949af4818ee1ee194886a55b9670a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:28:21.541115+05:30', '2026-09-17 15:28:21.541694+05:30', '163714cb-7eca-47e9-aa0f-1e77a456645e', '2026-09-17 15:28:21.541722+05:30', '2026-09-17 15:28:21.541723+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_dinesh', '4f8d35a7b21d5b0545c4794bc835965158e45c09b095f95964e924f6c2fc7227', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:50:42.853144+05:30', '2026-09-17 15:50:42.853998+05:30', 'b4567c92-387c-4ce6-9bdd-4bc0d7c1ec95', '2026-09-17 15:50:42.85405+05:30', '2026-09-17 15:50:42.854051+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_kavya', 'f15713a102e315f07e79dfea781d6ddeeb01737895626c7b099750a91185ae66', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:56:41.558738+05:30', '2026-09-17 15:56:41.560548+05:30', 'f7f5ff91-cfce-46eb-872a-2fffa38d3995', '2026-09-17 15:56:41.560614+05:30', '2026-09-17 15:56:41.560616+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_madhan', '2f60cf13442c7b2672113dea3b701c6172360181be23b09cc7842105b60f5fa7', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 16:06:40.999126+05:30', '2026-09-17 16:06:40.999702+05:30', '44c155c7-1c62-4bfb-915d-4d13fac635d8', '2026-09-17 16:06:40.999724+05:30', '2026-09-17 16:06:40.999725+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_dinesh', '413023720368e963da4045a749e36fd5fb1857c4f90100ce043c8cadaedf91ac', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:18:15.611073+05:30', '2026-09-18 10:07:46.625844+05:30', 'd34be659-1c9e-43c1-90f8-bd1a9bd322fe', '2026-09-17 15:18:15.611574+05:30', '2026-09-18 10:07:46.722967+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_sobi', '1cc347bdbdd4bc7214b940f8cf12ff062f472ae68a123c8aa3545d622dc06b70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:31:22.53343+05:30', '2026-09-18 09:53:30.231435+05:30', '40d7bfec-f569-4552-b7d9-81d10567f69f', '2026-09-17 15:31:22.53407+05:30', '2026-09-18 09:53:30.247474+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_ajay', '8a62d5f1643c3d42ba9b73fa32de9f009d34f7da6acd65eee168ca0bfdb78ba0', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:15:53.441006+05:30', '2026-09-18 10:10:02.099678+05:30', 'a3a9e4f3-1082-4f73-9084-ce71a70d836f', '2026-09-17 15:15:53.441493+05:30', '2026-09-18 10:10:02.104828+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_sobi', 'dc3cc7ce00449464edd57c695e482607a11072b8cc246a87f48469b3f4c92309', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 15:15:46.099931+05:30', '2026-09-22 10:18:38.295103+05:30', 'a74d382c-149b-4db2-9c0a-94f9ec1f107b', '2026-09-17 15:15:46.101486+05:30', '2026-09-22 10:18:38.321253+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_madhan', '9c82374e0063350fe963014bb5312d50e06f641762b7cbe3922399b39a1808cf', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 16:12:44.306044+05:30', '2026-09-17 16:12:44.306867+05:30', '17410bef-c69b-43a7-8b66-5905fa75ff4a', '2026-09-17 16:12:44.306931+05:30', '2026-09-17 16:12:44.306933+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', '7ca9826823972e284e50a297ed801ef2f85604c7dca099fc0b3a0aa45cbb1752', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-24 16:41:19.335343+05:30', '2026-09-17 16:41:19.336898+05:30', '504b33a4-8351-4e5b-905a-6790fd9aebbf', '2026-09-17 16:41:19.336962+05:30', '2026-09-17 16:41:19.336964+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', '95727ff9f7956173424d4b9f26fc67c1cf4a1a45ddc509d63fdccdb1b760d9be', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '172.21.0.2', false, '2026-09-24 15:31:41.357444+05:30', '2026-09-18 09:53:09.152504+05:30', 'f217aa1c-e47d-4e28-ab07-2dc349029501', '2026-09-17 15:31:41.357967+05:30', '2026-09-18 09:53:09.247738+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', '00b1a7a85421844cf03ffe33ae9b01f97acf224d825baa206fc5544d4e328895', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-25 17:28:15.958386+05:30', '2026-09-18 17:28:15.959302+05:30', '22523b63-2b24-45ed-822e-ea347780b612', '2026-09-18 17:28:15.959364+05:30', '2026-09-18 17:28:15.959366+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_student1', '19f931dda945828c4679e4091bbb7b581ef5c41bf90f4a40f3b87edd8d4dd365', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-25 17:28:32.665997+05:30', '2026-09-18 17:28:32.666739+05:30', '7219c9be-7845-404a-b593-ffa6fbf08964', '2026-09-18 17:28:32.666774+05:30', '2026-09-18 17:28:32.666776+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_arya', 'e0a9b92f24a121e8d48cb7a95b8005c9d5918cbbe2ca1a4a11dbc4e96a4c5c8c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-25 17:29:44.353552+05:30', '2026-09-18 17:29:44.355294+05:30', 'ce28e976-3885-4948-a6e0-47b1b647debe', '2026-09-18 17:29:44.355343+05:30', '2026-09-18 17:29:44.355345+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', 'a8f81635a0b9e12f432fcac6dca12f1c171ec1ae781d7b016286242abc6f704f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.2', false, '2026-09-25 17:32:12.126304+05:30', '2026-09-21 19:21:04.392957+05:30', '1a034b40-74f1-4e7e-aded-b67f5f8813a7', '2026-09-18 17:32:12.127761+05:30', '2026-09-21 19:21:04.402448+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_sobi', 'e2d4dabe672a8419cf931e463a34d93ac59106c3c77716856955c76473e3b8e6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-28 19:22:02.291062+05:30', '2026-09-21 19:22:02.294807+05:30', 'ac5ace1d-7fe2-4ae6-846c-81a1bd92cb46', '2026-09-21 19:22:02.294881+05:30', '2026-09-21 19:22:02.294883+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_sobi', 'a4609d6bb25a1b42af909f2f06b949e9c7600963d0897ce7677e8d5a8a634660', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-28 19:25:34.418546+05:30', '2026-09-21 19:25:34.420965+05:30', '8d2976d0-4c60-4b1d-a043-6ae6f82e4d0e', '2026-09-21 19:25:34.421014+05:30', '2026-09-21 19:25:34.421016+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_dinesh', '472fb4fc099541d2729285614ee05b46283139c45406c6cf85a61f2345a4f9a7', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-28 19:27:08.07646+05:30', '2026-09-21 19:27:08.076935+05:30', '929ac019-f59d-4c57-b4d6-4c28ae74c3d1', '2026-09-21 19:27:08.076975+05:30', '2026-09-21 19:27:08.076977+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_sobi', '85cb3659d32f184910a9ee404cd59936325f85c8d52a11bbff91e6ee2fc7c354', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-28 19:31:09.006933+05:30', '2026-09-21 19:31:09.008901+05:30', '4a419bee-2e7e-4798-ba79-94baa5213fc3', '2026-09-21 19:31:09.008982+05:30', '2026-09-21 19:31:09.008984+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_student1', 'c50477a43357cb8f7377dfbae78f28ef1c928c568ca0cc00425fb3f923dc90f4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-28 19:33:56.310537+05:30', '2026-09-21 19:33:56.312453+05:30', 'b2c8327b-92f7-45e7-8ad7-dc062b362a9a', '2026-09-21 19:33:56.312527+05:30', '2026-09-21 19:33:56.312529+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_admin', 'c920a1f0f0eb6b86670081d1cf34b9b605068fc24a2ef201e9abb0ce1fa7249a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-29 10:22:18.191068+05:30', '2026-09-22 10:22:18.191767+05:30', 'a3f1549d-f7e5-4cee-929b-0d094e317f86', '2026-09-22 10:22:18.191829+05:30', '2026-09-22 10:22:18.191831+05:30', false, NULL);
INSERT INTO public.user_sessions VALUES ('usr_madhan', '9458a1338fa9926f2ff9b39baef04df5b17431e6fa59f6b312601cf129531e48', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '172.21.0.3', false, '2026-09-29 10:23:49.770357+05:30', '2026-09-22 10:23:49.773677+05:30', '41191915-e7df-496e-98b0-0b6f39fb3bcf', '2026-09-22 10:23:49.77375+05:30', '2026-09-22 10:23:49.773753+05:30', false, NULL);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES ('student5@gmail.com', '9742345678', 'student5', '$2b$12$ZsnUa.j98m56OGj/xQk3lO5JBKxIkNCG9DrBeGGgjfBBFFIVfvEjS', 'STUDENT', NULL, true, 'deg_l_l_b_all', 'usr_student5', '2026-09-16 15:21:17.247889+05:30', '2026-09-16 15:21:17.247894+05:30', false, NULL);
INSERT INTO public.users VALUES ('parent.student5@gmail.com', 'p_9742345678', 'Parent of student5', '$2b$12$1x.vCByJIoeLca/m3ANpAupBVj32g4iod0jlvMzuIp3BViVHKOPDW', 'PARENT', NULL, true, 'deg_l_l_b_all', 'usr_parent_student5', '2026-09-16 15:21:17.542152+05:30', '2026-09-16 15:21:17.542162+05:30', false, NULL);
INSERT INTO public.users VALUES ('student6@gmail.com', '9642234677', 'student6', '$2b$12$D3Y2GQfTvErGbZNzqQmrU.lToQMnzD91CdTq7av/.HDJqfybBE9Ra', 'STUDENT', NULL, true, 'deg_l_l_b_all', 'usr_student6', '2026-09-16 15:22:17.568666+05:30', '2026-09-16 15:22:17.568671+05:30', false, NULL);
INSERT INTO public.users VALUES ('parent.student6@gmail.com', 'p_9642234677', 'Parent of student6', '$2b$12$/AbTmKP704ggnnMoDWDTQe3dtLDmNViK8Gx/BYsJrH.hCAUZoilmG', 'PARENT', NULL, true, 'deg_l_l_b_all', 'usr_parent_student6', '2026-09-16 15:22:17.871003+05:30', '2026-09-16 15:22:17.871008+05:30', false, NULL);
INSERT INTO public.users VALUES ('student7@gmail.com', '9684587456', 'student7', '$2b$12$YqdvtEveMipjmAzajrLbCOFBPn3/gSDu8r/gun7xl9lwbI1sS0Yka', 'STUDENT', NULL, true, 'deg_l_l_b_all', 'usr_student7', '2026-09-16 15:23:22.379523+05:30', '2026-09-16 15:23:22.379528+05:30', false, NULL);
INSERT INTO public.users VALUES ('parent.student7@gmail.com', 'p_9684587456', 'Parent of student7', '$2b$12$AmXuLwaV3ZJHXCRvsLKVTOHWectPswIfwlcz4Qrz6WkjIjRPKHXeW', 'PARENT', NULL, true, 'deg_l_l_b_all', 'usr_parent_student7', '2026-09-16 15:23:22.676233+05:30', '2026-09-16 15:23:22.676237+05:30', false, NULL);
INSERT INTO public.users VALUES ('student8@gmail.com', '9721765532', 'student8', '$2b$12$Md0wcsmQvlg.bd7x9xQUQeGXHDuqUyXCveSj9.wvrch0W8lvUFCqG', 'STUDENT', NULL, true, 'deg_l_l_b_all', 'usr_student8', '2026-09-16 15:24:04.873362+05:30', '2026-09-16 15:24:04.873366+05:30', false, NULL);
INSERT INTO public.users VALUES ('parent.student8@gmail.com', 'p_9721765532', 'Parent of student8', '$2b$12$3p2ejqy1ZxdNWLa/mxtQ7e/a1AXap/GNePB2e0ApHqBh9w3HwqGeW', 'PARENT', NULL, true, 'deg_l_l_b_all', 'usr_parent_student8', '2026-09-16 15:24:05.162049+05:30', '2026-09-16 15:24:05.162052+05:30', false, NULL);
INSERT INTO public.users VALUES ('alexa@gmail.com', '9785734573', 'Alexa', '$2b$12$sQNbwOvPufwvv1lC5rN1veBt2dJZgoLXRFTZUfczGAPJzdQrI7r8m', 'FACULTY', NULL, true, 'deg_b_a_l_l_b_all', 'usr_alexa', '2026-09-16 17:20:25.59396+05:30', '2026-09-16 17:20:25.593964+05:30', false, NULL);
INSERT INTO public.users VALUES ('admin@gmail.com', NULL, 'System Administrator', '$2b$12$c97FUlsd6rIDVQKpQ6xYcO.dfAzSJwDBHhJqQBxXvndJ0QYFrQPQe', 'ADMIN', NULL, true, NULL, 'usr_admin', '2026-09-15 17:21:06.21803+05:30', '2026-09-20 22:06:23.151407+05:30', false, NULL);
INSERT INTO public.users VALUES ('dinesh@gmail.com', '8456756487', 'Dinesh', '$2b$12$UjE.oB5WPwzOnCiz0X.h0Ots4IdNVB/7zAwRM9E2rYdbX0/849STe', 'PRINCIPAL', NULL, true, NULL, 'usr_dinesh', '2026-09-16 14:48:37.561563+05:30', '2026-09-16 14:48:37.561573+05:30', false, NULL);
INSERT INTO public.users VALUES ('sobi@gmail.com', '9732576565', 'Sobiya', '$2b$12$vmAjDMjYcke4Nmq4HHOOfOLgnvg3N8N8kQHZWkqHYg.L5IBm0x5Hu', 'HOD', NULL, true, 'deg_b_a_l_l_b_all', 'usr_sobi', '2026-09-16 15:06:19.014469+05:30', '2026-09-16 15:06:19.014473+05:30', false, NULL);
INSERT INTO public.users VALUES ('madhan@gmail.com', '9568832564', 'Madhan', '$2b$12$FM.GJDO6CLcHnY8JRSPlt.9ovErw7Z590sOjxXLyVbEXjDQynRTP2', 'HOD', NULL, true, 'deg_l_l_b_all', 'usr_madhan', '2026-09-16 15:07:05.538192+05:30', '2026-09-16 15:07:05.538198+05:30', false, NULL);
INSERT INTO public.users VALUES ('student1@gmail.com', '9454375435', 'student1', '$2b$12$Z6FcTBI/NOo/JbAxDzonT.w6eDpPEzPwGKaogDqxXYvrf6.KWPmIq', 'STUDENT', NULL, true, 'deg_b_a_l_l_b_all', 'usr_student1', '2026-09-16 15:09:18.237731+05:30', '2026-09-16 15:09:18.237737+05:30', false, NULL);
INSERT INTO public.users VALUES ('parent.student1@gmail.com', 'p_9454375435', 'Parent of student1', '$2b$12$nILjiIuhqDW.gOE5/F5KGuWJDAu5d.3YyuhOmfE1mDHWupi/uyFyG', 'PARENT', NULL, true, 'deg_b_a_l_l_b_all', 'usr_parent_student1', '2026-09-16 15:09:18.538665+05:30', '2026-09-16 15:09:18.538669+05:30', false, NULL);
INSERT INTO public.users VALUES ('arya@gmail.com', '9754523456', 'Arya', '$2b$12$3GlhRB1..pNwJl3cPbtileQ/j/ZN1F755ZLKBgLGdz6MH1qGV4qwK', 'FACULTY', NULL, true, 'deg_b_a_l_l_b_all', 'usr_arya', '2026-09-16 15:12:57.964977+05:30', '2026-09-16 15:12:57.964987+05:30', false, NULL);
INSERT INTO public.users VALUES ('ajay@gmail.com', '9854565436', 'Ajay', '$2b$12$5aZ9kl0nXhB9.bZLS966Iu.CUPyETHGeUtriMZUX08N7Vhd7qxH2y', 'FACULTY', NULL, true, 'deg_b_a_l_l_b_all', 'usr_ajay', '2026-09-16 15:13:40.244961+05:30', '2026-09-16 15:13:40.244967+05:30', false, NULL);
INSERT INTO public.users VALUES ('palani@gmail.com', '9846536546', 'Palani', '$2b$12$PgrYSxR45O8BplJ0qUX2GuQ0bXQo7F2z0EjMzN5.PMmdSr0JvAWP2', 'FACULTY', NULL, true, 'deg_l_l_b_all', 'usr_palani', '2026-09-16 15:14:29.443155+05:30', '2026-09-16 15:14:29.443159+05:30', false, NULL);
INSERT INTO public.users VALUES ('kavya@gmail.com', '9234567876', 'kavya', '$2b$12$UzQwc/q.RjBaSoHwcEJIJu/opPtxl2yhfjgcCGXyQ4WGkDGv2MPRy', 'FACULTY', NULL, true, 'deg_l_l_b_all', 'usr_kavya', '2026-09-16 15:15:07.511719+05:30', '2026-09-16 15:15:07.511732+05:30', false, NULL);
INSERT INTO public.users VALUES ('student2@gmail.com', '9642345678', 'student2', '$2b$12$vzPOuRn19LNyz4p/Qxa0uOjEa5e644.4RTfcMbJMKiq0KG61J/1xO', 'STUDENT', NULL, true, 'deg_b_a_l_l_b_all', 'usr_student2', '2026-09-16 15:16:51.431386+05:30', '2026-09-16 15:16:51.431391+05:30', false, NULL);
INSERT INTO public.users VALUES ('parent.student2@gmail.com', 'p_9642345678', 'Parent of student2', '$2b$12$CSS8o5v4xOeafieNKJQ5meN48GqWy40rY7mQ2ym1lU6bPGqwEzh1q', 'PARENT', NULL, true, 'deg_b_a_l_l_b_all', 'usr_parent_student2', '2026-09-16 15:16:51.733407+05:30', '2026-09-16 15:16:51.733413+05:30', false, NULL);
INSERT INTO public.users VALUES ('student3@gmail.com', '9712345678', 'Student3', '$2b$12$27aIOD32XnKm44AgUWWrVeTJvN3QECfJG1.RsA5u4N4ZvLl3FJ8cC', 'STUDENT', NULL, true, 'deg_b_a_l_l_b_all', 'usr_student3', '2026-09-16 15:18:05.158659+05:30', '2026-09-16 15:18:05.158663+05:30', false, NULL);
INSERT INTO public.users VALUES ('parent.student3@gmail.com', 'p_9712345678', 'Parent of Student3', '$2b$12$UkNPAJ7WeMGPKG1ZxwjZCOHz64DYOk8yMVvX1d9Aao4xVGvAYIgtW', 'PARENT', NULL, true, 'deg_b_a_l_l_b_all', 'usr_parent_student3', '2026-09-16 15:18:05.459137+05:30', '2026-09-16 15:18:05.45914+05:30', false, NULL);
INSERT INTO public.users VALUES ('parent.student4@gmail.com', 'p_9368876512', 'Parent of student4', '$2b$12$iDR2A1g/77F0AQjDe6pZi.HEU0ihD1aZaqFj.6Ov.sEeQI7Rbv/ga', 'PARENT', NULL, true, 'deg_l_l_b_all', 'usr_parent_student4', '2026-09-16 15:18:54.407725+05:30', '2026-09-16 15:18:54.407728+05:30', false, NULL);
INSERT INTO public.users VALUES ('student4@gmail.com', '9368876512', 'student4', '$2b$12$SzY0mGSkyFJ/GOGDBCn7Yu.THfUnIKvN7Qfu/kbA17h..fFpX46..', 'STUDENT', NULL, true, 'deg_b_a_l_l_b_2025_2030', 'usr_student4', '2026-09-16 15:18:54.119589+05:30', '2026-09-16 15:19:13.153535+05:30', false, NULL);


--
-- Data for Name: working_day_config; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: academic_activities pk_academic_activities; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_activities
    ADD CONSTRAINT pk_academic_activities PRIMARY KEY (id);


--
-- Name: academic_calendar_date_events pk_academic_calendar_date_events; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendar_date_events
    ADD CONSTRAINT pk_academic_calendar_date_events PRIMARY KEY (id);


--
-- Name: academic_calendar_events pk_academic_calendar_events; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendar_events
    ADD CONSTRAINT pk_academic_calendar_events PRIMARY KEY (id);


--
-- Name: academic_calendar_setup pk_academic_calendar_setup; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendar_setup
    ADD CONSTRAINT pk_academic_calendar_setup PRIMARY KEY (id);


--
-- Name: academic_calendars pk_academic_calendars; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendars
    ADD CONSTRAINT pk_academic_calendars PRIMARY KEY (id);


--
-- Name: academic_years pk_academic_years; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_years
    ADD CONSTRAINT pk_academic_years PRIMARY KEY (id);


--
-- Name: activity_logs pk_activity_logs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT pk_activity_logs PRIMARY KEY (id);


--
-- Name: activity_point_applications pk_activity_point_applications; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_point_applications
    ADD CONSTRAINT pk_activity_point_applications PRIMARY KEY (id);


--
-- Name: allowance_types pk_allowance_types; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allowance_types
    ADD CONSTRAINT pk_allowance_types PRIMARY KEY (id);


--
-- Name: alumni_members pk_alumni_members; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alumni_members
    ADD CONSTRAINT pk_alumni_members PRIMARY KEY (id);


--
-- Name: assignment_submissions pk_assignment_submissions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT pk_assignment_submissions PRIMARY KEY (id);


--
-- Name: assignments pk_assignments; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT pk_assignments PRIMARY KEY (id);


--
-- Name: attendance pk_attendance; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT pk_attendance PRIMARY KEY (id);


--
-- Name: attendance_corrections pk_attendance_corrections; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_corrections
    ADD CONSTRAINT pk_attendance_corrections PRIMARY KEY (id);


--
-- Name: audit_logs pk_audit_logs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT pk_audit_logs PRIMARY KEY (id);


--
-- Name: backup_configurations pk_backup_configurations; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_configurations
    ADD CONSTRAINT pk_backup_configurations PRIMARY KEY (id);


--
-- Name: backup_history pk_backup_history; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_history
    ADD CONSTRAINT pk_backup_history PRIMARY KEY (id);


--
-- Name: batch_sections pk_batch_sections; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_sections
    ADD CONSTRAINT pk_batch_sections PRIMARY KEY (id);


--
-- Name: buildings pk_buildings; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT pk_buildings PRIMARY KEY (id);


--
-- Name: chat_messages pk_chat_messages; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT pk_chat_messages PRIMARY KEY (id);


--
-- Name: chat_sessions pk_chat_sessions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_sessions
    ADD CONSTRAINT pk_chat_sessions PRIMARY KEY (id);


--
-- Name: class_advisors pk_class_advisors; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_advisors
    ADD CONSTRAINT pk_class_advisors PRIMARY KEY (id);


--
-- Name: class_diaries pk_class_diaries; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_diaries
    ADD CONSTRAINT pk_class_diaries PRIMARY KEY (id);


--
-- Name: classroom_activities pk_classroom_activities; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classroom_activities
    ADD CONSTRAINT pk_classroom_activities PRIMARY KEY (id);


--
-- Name: club_memberships pk_club_memberships; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_memberships
    ADD CONSTRAINT pk_club_memberships PRIMARY KEY (id);


--
-- Name: clubs pk_clubs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clubs
    ADD CONSTRAINT pk_clubs PRIMARY KEY (id);


--
-- Name: community_service_logs pk_community_service_logs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_service_logs
    ADD CONSTRAINT pk_community_service_logs PRIMARY KEY (id);


--
-- Name: course_enrollment_requests pk_course_enrollment_requests; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollment_requests
    ADD CONSTRAINT pk_course_enrollment_requests PRIMARY KEY (id);


--
-- Name: course_enrollments pk_course_enrollments; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT pk_course_enrollments PRIMARY KEY (id);


--
-- Name: courses pk_courses; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT pk_courses PRIMARY KEY (id);


--
-- Name: custom_assignments pk_custom_assignments; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_assignments
    ADD CONSTRAINT pk_custom_assignments PRIMARY KEY (id);


--
-- Name: deductions pk_deductions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deductions
    ADD CONSTRAINT pk_deductions PRIMARY KEY (id);


--
-- Name: degrees pk_degrees; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.degrees
    ADD CONSTRAINT pk_degrees PRIMARY KEY (id);


--
-- Name: employee_allowance_overrides pk_employee_allowance_overrides; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_allowance_overrides
    ADD CONSTRAINT pk_employee_allowance_overrides PRIMARY KEY (id);


--
-- Name: employee_salary_assignments pk_employee_salary_assignments; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_salary_assignments
    ADD CONSTRAINT pk_employee_salary_assignments PRIMARY KEY (id);


--
-- Name: exam_settings pk_exam_settings; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_settings
    ADD CONSTRAINT pk_exam_settings PRIMARY KEY (id);


--
-- Name: exam_setup_splits pk_exam_setup_splits; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_setup_splits
    ADD CONSTRAINT pk_exam_setup_splits PRIMARY KEY (id);


--
-- Name: exam_setups pk_exam_setups; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_setups
    ADD CONSTRAINT pk_exam_setups PRIMARY KEY (id);


--
-- Name: exams pk_exams; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT pk_exams PRIMARY KEY (id);


--
-- Name: extracurricular_activities pk_extracurricular_activities; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_activities
    ADD CONSTRAINT pk_extracurricular_activities PRIMARY KEY (id);


--
-- Name: extracurricular_logs pk_extracurricular_logs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_logs
    ADD CONSTRAINT pk_extracurricular_logs PRIMARY KEY (id);


--
-- Name: extracurricular_slots pk_extracurricular_slots; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_slots
    ADD CONSTRAINT pk_extracurricular_slots PRIMARY KEY (id);


--
-- Name: faculty_absences pk_faculty_absences; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_absences
    ADD CONSTRAINT pk_faculty_absences PRIMARY KEY (id);


--
-- Name: faculty_profile_update_requests pk_faculty_profile_update_requests; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_profile_update_requests
    ADD CONSTRAINT pk_faculty_profile_update_requests PRIMARY KEY (id);


--
-- Name: faculty_profiles pk_faculty_profiles; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_profiles
    ADD CONSTRAINT pk_faculty_profiles PRIMARY KEY (id);


--
-- Name: faculty_research pk_faculty_research; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_research
    ADD CONSTRAINT pk_faculty_research PRIMARY KEY (id);


--
-- Name: faculty_workload pk_faculty_workload; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_workload
    ADD CONSTRAINT pk_faculty_workload PRIMARY KEY (id);


--
-- Name: fee_blueprints pk_fee_blueprints; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_blueprints
    ADD CONSTRAINT pk_fee_blueprints PRIMARY KEY (id);


--
-- Name: fee_records pk_fee_records; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_records
    ADD CONSTRAINT pk_fee_records PRIMARY KEY (id);


--
-- Name: fee_structure pk_fee_structure; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_structure
    ADD CONSTRAINT pk_fee_structure PRIMARY KEY (id);


--
-- Name: floors pk_floors; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.floors
    ADD CONSTRAINT pk_floors PRIMARY KEY (id);


--
-- Name: global_research_timelines pk_global_research_timelines; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_research_timelines
    ADD CONSTRAINT pk_global_research_timelines PRIMARY KEY (id);


--
-- Name: grade_template_allowances pk_grade_template_allowances; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grade_template_allowances
    ADD CONSTRAINT pk_grade_template_allowances PRIMARY KEY (id);


--
-- Name: grievances pk_grievances; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grievances
    ADD CONSTRAINT pk_grievances PRIMARY KEY (id);


--
-- Name: innovation_posts pk_innovation_posts; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.innovation_posts
    ADD CONSTRAINT pk_innovation_posts PRIMARY KEY (id);


--
-- Name: internal_marks pk_internal_marks; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internal_marks
    ADD CONSTRAINT pk_internal_marks PRIMARY KEY (id);


--
-- Name: internship_applications pk_internship_applications; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internship_applications
    ADD CONSTRAINT pk_internship_applications PRIMARY KEY (id);


--
-- Name: internship_drives pk_internship_drives; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internship_drives
    ADD CONSTRAINT pk_internship_drives PRIMARY KEY (id);


--
-- Name: internship_mentors pk_internship_mentors; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internship_mentors
    ADD CONSTRAINT pk_internship_mentors PRIMARY KEY (id);


--
-- Name: leave_approvals pk_leave_approvals; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_approvals
    ADD CONSTRAINT pk_leave_approvals PRIMARY KEY (id);


--
-- Name: leave_balances pk_leave_balances; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT pk_leave_balances PRIMARY KEY (id);


--
-- Name: leave_deduction_limits pk_leave_deduction_limits; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_deduction_limits
    ADD CONSTRAINT pk_leave_deduction_limits PRIMARY KEY (id);


--
-- Name: leaves pk_leaves; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT pk_leaves PRIMARY KEY (id);


--
-- Name: lecture_recordings pk_lecture_recordings; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lecture_recordings
    ADD CONSTRAINT pk_lecture_recordings PRIMARY KEY (id);


--
-- Name: legal_event_questions pk_legal_event_questions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_event_questions
    ADD CONSTRAINT pk_legal_event_questions PRIMARY KEY (id);


--
-- Name: legal_event_registrations pk_legal_event_registrations; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_event_registrations
    ADD CONSTRAINT pk_legal_event_registrations PRIMARY KEY (id);


--
-- Name: legal_events pk_legal_events; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_events
    ADD CONSTRAINT pk_legal_events PRIMARY KEY (id);


--
-- Name: lesson_plans pk_lesson_plans; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson_plans
    ADD CONSTRAINT pk_lesson_plans PRIMARY KEY (id);


--
-- Name: marks pk_marks; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT pk_marks PRIMARY KEY (id);


--
-- Name: mentorship_records pk_mentorship_records; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_records
    ADD CONSTRAINT pk_mentorship_records PRIMARY KEY (id);


--
-- Name: messages pk_messages; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT pk_messages PRIMARY KEY (id);


--
-- Name: notice_acknowledgements pk_notice_acknowledgements; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notice_acknowledgements
    ADD CONSTRAINT pk_notice_acknowledgements PRIMARY KEY (id);


--
-- Name: notices pk_notices; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notices
    ADD CONSTRAINT pk_notices PRIMARY KEY (id);


--
-- Name: notifications pk_notifications; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT pk_notifications PRIMARY KEY (id);


--
-- Name: online_meetings pk_online_meetings; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.online_meetings
    ADD CONSTRAINT pk_online_meetings PRIMARY KEY (id);


--
-- Name: parent_student_map pk_parent_student_map; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parent_student_map
    ADD CONSTRAINT pk_parent_student_map PRIMARY KEY (id);


--
-- Name: payments pk_payments; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT pk_payments PRIMARY KEY (id);


--
-- Name: payroll_runs pk_payroll_runs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payroll_runs
    ADD CONSTRAINT pk_payroll_runs PRIMARY KEY (id);


--
-- Name: publication_plans pk_publication_plans; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_plans
    ADD CONSTRAINT pk_publication_plans PRIMARY KEY (id);


--
-- Name: publication_proofs pk_publication_proofs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_proofs
    ADD CONSTRAINT pk_publication_proofs PRIMARY KEY (id);


--
-- Name: research_compliance pk_research_compliance; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_compliance
    ADD CONSTRAINT pk_research_compliance PRIMARY KEY (id);


--
-- Name: research_plans pk_research_plans; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_plans
    ADD CONSTRAINT pk_research_plans PRIMARY KEY (id);


--
-- Name: research_progress_updates pk_research_progress_updates; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_progress_updates
    ADD CONSTRAINT pk_research_progress_updates PRIMARY KEY (id);


--
-- Name: research_verifications pk_research_verifications; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_verifications
    ADD CONSTRAINT pk_research_verifications PRIMARY KEY (id);


--
-- Name: rooms pk_rooms; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT pk_rooms PRIMARY KEY (id);


--
-- Name: salary pk_salary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary
    ADD CONSTRAINT pk_salary PRIMARY KEY (id);


--
-- Name: salary_allowances pk_salary_allowances; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_allowances
    ADD CONSTRAINT pk_salary_allowances PRIMARY KEY (id);


--
-- Name: salary_deduction_configs pk_salary_deduction_configs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_deduction_configs
    ADD CONSTRAINT pk_salary_deduction_configs PRIMARY KEY (id);


--
-- Name: salary_revisions pk_salary_revisions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_revisions
    ADD CONSTRAINT pk_salary_revisions PRIMARY KEY (id);


--
-- Name: salary_slip_requests pk_salary_slip_requests; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_slip_requests
    ADD CONSTRAINT pk_salary_slip_requests PRIMARY KEY (id);


--
-- Name: salary_slips pk_salary_slips; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_slips
    ADD CONSTRAINT pk_salary_slips PRIMARY KEY (id);


--
-- Name: salary_structures pk_salary_structures; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_structures
    ADD CONSTRAINT pk_salary_structures PRIMARY KEY (id);


--
-- Name: scholarship_types pk_scholarship_types; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scholarship_types
    ADD CONSTRAINT pk_scholarship_types PRIMARY KEY (id);


--
-- Name: section_cohort_mappings pk_section_cohort_mappings; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.section_cohort_mappings
    ADD CONSTRAINT pk_section_cohort_mappings PRIMARY KEY (id);


--
-- Name: sections pk_sections; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT pk_sections PRIMARY KEY (id);


--
-- Name: session_summaries pk_session_summaries; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_summaries
    ADD CONSTRAINT pk_session_summaries PRIMARY KEY (id);


--
-- Name: staff_attendance pk_staff_attendance; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_attendance
    ADD CONSTRAINT pk_staff_attendance PRIMARY KEY (id);


--
-- Name: staff_attendance_records pk_staff_attendance_records; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_attendance_records
    ADD CONSTRAINT pk_staff_attendance_records PRIMARY KEY (id);


--
-- Name: student_concessions pk_student_concessions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_concessions
    ADD CONSTRAINT pk_student_concessions PRIMARY KEY (id);


--
-- Name: student_council_initiatives pk_student_council_initiatives; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_council_initiatives
    ADD CONSTRAINT pk_student_council_initiatives PRIMARY KEY (id);


--
-- Name: student_council_members pk_student_council_members; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_council_members
    ADD CONSTRAINT pk_student_council_members PRIMARY KEY (id);


--
-- Name: student_interactions pk_student_interactions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_interactions
    ADD CONSTRAINT pk_student_interactions PRIMARY KEY (id);


--
-- Name: student_material_bookmarks pk_student_material_bookmarks; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_bookmarks
    ADD CONSTRAINT pk_student_material_bookmarks PRIMARY KEY (id);


--
-- Name: student_material_downloads pk_student_material_downloads; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_downloads
    ADD CONSTRAINT pk_student_material_downloads PRIMARY KEY (id);


--
-- Name: student_material_favorites pk_student_material_favorites; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_favorites
    ADD CONSTRAINT pk_student_material_favorites PRIMARY KEY (id);


--
-- Name: student_papers pk_student_papers; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_papers
    ADD CONSTRAINT pk_student_papers PRIMARY KEY (id);


--
-- Name: students pk_students; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT pk_students PRIMARY KEY (id);


--
-- Name: study_materials pk_study_materials; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.study_materials
    ADD CONSTRAINT pk_study_materials PRIMARY KEY (id);


--
-- Name: subject_allocations pk_subject_allocations; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_allocations
    ADD CONSTRAINT pk_subject_allocations PRIMARY KEY (id);


--
-- Name: substitution_allocations pk_substitution_allocations; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.substitution_allocations
    ADD CONSTRAINT pk_substitution_allocations PRIMARY KEY (id);


--
-- Name: system_setting_history pk_system_setting_history; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_setting_history
    ADD CONSTRAINT pk_system_setting_history PRIMARY KEY (id);


--
-- Name: system_settings pk_system_settings; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT pk_system_settings PRIMARY KEY (id);


--
-- Name: teaching_log_audits pk_teaching_log_audits; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teaching_log_audits
    ADD CONSTRAINT pk_teaching_log_audits PRIMARY KEY (id);


--
-- Name: teaching_log_notifications pk_teaching_log_notifications; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teaching_log_notifications
    ADD CONSTRAINT pk_teaching_log_notifications PRIMARY KEY (id);


--
-- Name: timetable pk_timetable; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT pk_timetable PRIMARY KEY (id);


--
-- Name: timetable_action_history pk_timetable_action_history; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_action_history
    ADD CONSTRAINT pk_timetable_action_history PRIMARY KEY (id);


--
-- Name: timetable_approvals pk_timetable_approvals; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_approvals
    ADD CONSTRAINT pk_timetable_approvals PRIMARY KEY (id);


--
-- Name: timetable_templates pk_timetable_templates; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_templates
    ADD CONSTRAINT pk_timetable_templates PRIMARY KEY (id);


--
-- Name: user_preferences pk_user_preferences; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT pk_user_preferences PRIMARY KEY (id);


--
-- Name: user_sessions pk_user_sessions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT pk_user_sessions PRIMARY KEY (id);


--
-- Name: users pk_users; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: working_day_config pk_working_day_config; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.working_day_config
    ADD CONSTRAINT pk_working_day_config PRIMARY KEY (id);


--
-- Name: allowance_types uq_allowance_types_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allowance_types
    ADD CONSTRAINT uq_allowance_types_code UNIQUE (code);


--
-- Name: batch_sections uq_batch_section_degree_batch_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_sections
    ADD CONSTRAINT uq_batch_section_degree_batch_name UNIQUE (degree_id, batch, section_name);


--
-- Name: academic_calendar_date_events uq_cal_date_event; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendar_date_events
    ADD CONSTRAINT uq_cal_date_event UNIQUE (academic_calendar_id, event_date, event_name);


--
-- Name: academic_calendars uq_calendar_scope_version; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendars
    ADD CONSTRAINT uq_calendar_scope_version UNIQUE (academic_year_id, degree_id, batch_id, semester_id, version);


--
-- Name: class_advisors uq_class_advisor_assignment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_advisors
    ADD CONSTRAINT uq_class_advisor_assignment UNIQUE (degree_id, academic_year_id, batch, section_name);


--
-- Name: courses uq_courses_code_degree; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT uq_courses_code_degree UNIQUE (code, degree_id);


--
-- Name: degrees uq_degree_code_program_batch; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.degrees
    ADD CONSTRAINT uq_degree_code_program_batch UNIQUE (code, program_level, applicable_batch);


--
-- Name: employee_allowance_overrides uq_employee_allowance_override; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_allowance_overrides
    ADD CONSTRAINT uq_employee_allowance_override UNIQUE (employee_salary_assignment_id, allowance_type_id);


--
-- Name: faculty_profiles uq_faculty_profiles_user_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_profiles
    ADD CONSTRAINT uq_faculty_profiles_user_id UNIQUE (user_id);


--
-- Name: grade_template_allowances uq_grade_template_allowance; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grade_template_allowances
    ADD CONSTRAINT uq_grade_template_allowance UNIQUE (salary_structure_id, allowance_type_id);


--
-- Name: mentorship_records uq_mentorship_records_student_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_records
    ADD CONSTRAINT uq_mentorship_records_student_id UNIQUE (student_id);


--
-- Name: payments uq_payments_txn_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT uq_payments_txn_id UNIQUE (txn_id);


--
-- Name: payroll_runs uq_payroll_run_month_year; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payroll_runs
    ADD CONSTRAINT uq_payroll_run_month_year UNIQUE (month, year);


--
-- Name: salary_structures uq_salary_structures_designation; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_structures
    ADD CONSTRAINT uq_salary_structures_designation UNIQUE (designation);


--
-- Name: section_cohort_mappings uq_section_cohort_mapping; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.section_cohort_mappings
    ADD CONSTRAINT uq_section_cohort_mapping UNIQUE (section_id, batch_section_id);


--
-- Name: students uq_students_roll_no; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT uq_students_roll_no UNIQUE (roll_no);


--
-- Name: students uq_students_user_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT uq_students_user_id UNIQUE (user_id);


--
-- Name: users uq_users_phone; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_phone UNIQUE (phone);


--
-- Name: working_day_config uq_working_day_config_month_year; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.working_day_config
    ADD CONSTRAINT uq_working_day_config_month_year UNIQUE (month, year);


--
-- Name: ix_academic_calendar_date_events_academic_calendar_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_academic_calendar_date_events_academic_calendar_id ON public.academic_calendar_date_events USING btree (academic_calendar_id);


--
-- Name: ix_academic_calendar_date_events_event_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_academic_calendar_date_events_event_date ON public.academic_calendar_date_events USING btree (event_date);


--
-- Name: ix_academic_calendars_academic_year_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_academic_calendars_academic_year_id ON public.academic_calendars USING btree (academic_year_id);


--
-- Name: ix_academic_calendars_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_academic_calendars_batch_id ON public.academic_calendars USING btree (batch_id);


--
-- Name: ix_academic_calendars_degree_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_academic_calendars_degree_id ON public.academic_calendars USING btree (degree_id);


--
-- Name: ix_batch_sections_batch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_batch_sections_batch ON public.batch_sections USING btree (batch);


--
-- Name: ix_batch_sections_degree_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_batch_sections_degree_id ON public.batch_sections USING btree (degree_id);


--
-- Name: ix_buildings_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_buildings_id ON public.buildings USING btree (id);


--
-- Name: ix_chat_messages_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_chat_messages_session_id ON public.chat_messages USING btree (session_id);


--
-- Name: ix_chat_sessions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_chat_sessions_user_id ON public.chat_sessions USING btree (user_id);


--
-- Name: ix_class_advisors_batch_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_class_advisors_batch_section_id ON public.class_advisors USING btree (batch_section_id);


--
-- Name: ix_floors_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_floors_id ON public.floors USING btree (id);


--
-- Name: ix_grievances_grievance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_grievances_grievance_id ON public.grievances USING btree (grievance_id);


--
-- Name: ix_leave_balances_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_leave_balances_user_id ON public.leave_balances USING btree (user_id);


--
-- Name: ix_legal_events_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_legal_events_id ON public.legal_events USING btree (id);


--
-- Name: ix_lesson_plans_subject; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_lesson_plans_subject ON public.lesson_plans USING btree (subject);


--
-- Name: ix_rooms_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_rooms_id ON public.rooms USING btree (id);


--
-- Name: ix_section_cohort_mappings_batch_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_section_cohort_mappings_batch_section_id ON public.section_cohort_mappings USING btree (batch_section_id);


--
-- Name: ix_section_cohort_mappings_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_section_cohort_mappings_section_id ON public.section_cohort_mappings USING btree (section_id);


--
-- Name: ix_student_concessions_student_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_student_concessions_student_id ON public.student_concessions USING btree (student_id);


--
-- Name: ix_students_batch_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_students_batch_section_id ON public.students USING btree (batch_section_id);


--
-- Name: ix_user_preferences_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_preferences_key ON public.user_preferences USING btree (key);


--
-- Name: ix_user_preferences_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_preferences_user_id ON public.user_preferences USING btree (user_id);


--
-- Name: ix_user_sessions_refresh_token_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_sessions_refresh_token_hash ON public.user_sessions USING btree (refresh_token_hash);


--
-- Name: ix_user_sessions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_sessions_user_id ON public.user_sessions USING btree (user_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: uq_faculty_cycle_plan; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_faculty_cycle_plan ON public.research_plans USING btree (faculty_id, cycle_start_date) WHERE (is_deleted = false);


--
-- Name: academic_calendar_date_events fk_academic_calendar_date_events_academic_calendar_id_a_20ad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendar_date_events
    ADD CONSTRAINT fk_academic_calendar_date_events_academic_calendar_id_a_20ad FOREIGN KEY (academic_calendar_id) REFERENCES public.academic_calendars(id) ON DELETE CASCADE;


--
-- Name: academic_calendars fk_academic_calendars_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendars
    ADD CONSTRAINT fk_academic_calendars_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id) ON DELETE CASCADE;


--
-- Name: academic_years fk_academic_years_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_years
    ADD CONSTRAINT fk_academic_years_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: activity_logs fk_activity_logs_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT fk_activity_logs_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: activity_point_applications fk_activity_point_applications_student_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_point_applications
    ADD CONSTRAINT fk_activity_point_applications_student_id_users FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: allowance_types fk_allowance_types_created_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allowance_types
    ADD CONSTRAINT fk_allowance_types_created_by_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: assignment_submissions fk_assignment_submissions_assignment_id_custom_assignments; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT fk_assignment_submissions_assignment_id_custom_assignments FOREIGN KEY (assignment_id) REFERENCES public.custom_assignments(id);


--
-- Name: assignment_submissions fk_assignment_submissions_student_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT fk_assignment_submissions_student_id_users FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: assignments fk_assignments_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_assignments_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: assignments fk_assignments_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_assignments_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: attendance_corrections fk_attendance_corrections_attendance_id_attendance; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_corrections
    ADD CONSTRAINT fk_attendance_corrections_attendance_id_attendance FOREIGN KEY (attendance_id) REFERENCES public.attendance(id);


--
-- Name: attendance_corrections fk_attendance_corrections_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_corrections
    ADD CONSTRAINT fk_attendance_corrections_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: attendance fk_attendance_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: attendance fk_attendance_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: attendance fk_attendance_subject_id_courses; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_subject_id_courses FOREIGN KEY (subject_id) REFERENCES public.courses(id);


--
-- Name: audit_logs fk_audit_logs_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT fk_audit_logs_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: backup_history fk_backup_history_created_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_history
    ADD CONSTRAINT fk_backup_history_created_by_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: batch_sections fk_batch_sections_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_sections
    ADD CONSTRAINT fk_batch_sections_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: batch_sections fk_batch_sections_legacy_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_sections
    ADD CONSTRAINT fk_batch_sections_legacy_section_id_sections FOREIGN KEY (legacy_section_id) REFERENCES public.sections(id);


--
-- Name: chat_messages fk_chat_messages_session_id_chat_sessions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT fk_chat_messages_session_id_chat_sessions FOREIGN KEY (session_id) REFERENCES public.chat_sessions(id);


--
-- Name: chat_sessions fk_chat_sessions_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_sessions
    ADD CONSTRAINT fk_chat_sessions_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: class_advisors fk_class_advisors_academic_year_id_academic_years; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_advisors
    ADD CONSTRAINT fk_class_advisors_academic_year_id_academic_years FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id);


--
-- Name: class_advisors fk_class_advisors_batch_section_id_batch_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_advisors
    ADD CONSTRAINT fk_class_advisors_batch_section_id_batch_sections FOREIGN KEY (batch_section_id) REFERENCES public.batch_sections(id);


--
-- Name: class_advisors fk_class_advisors_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_advisors
    ADD CONSTRAINT fk_class_advisors_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: class_advisors fk_class_advisors_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_advisors
    ADD CONSTRAINT fk_class_advisors_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: classroom_activities fk_classroom_activities_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classroom_activities
    ADD CONSTRAINT fk_classroom_activities_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: classroom_activities fk_classroom_activities_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classroom_activities
    ADD CONSTRAINT fk_classroom_activities_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: club_memberships fk_club_memberships_club_id_clubs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_memberships
    ADD CONSTRAINT fk_club_memberships_club_id_clubs FOREIGN KEY (club_id) REFERENCES public.clubs(id);


--
-- Name: club_memberships fk_club_memberships_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.club_memberships
    ADD CONSTRAINT fk_club_memberships_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: community_service_logs fk_community_service_logs_student_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_service_logs
    ADD CONSTRAINT fk_community_service_logs_student_id_users FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: course_enrollment_requests fk_course_enrollment_requests_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollment_requests
    ADD CONSTRAINT fk_course_enrollment_requests_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: course_enrollment_requests fk_course_enrollment_requests_student_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollment_requests
    ADD CONSTRAINT fk_course_enrollment_requests_student_id_users FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: course_enrollments fk_course_enrollments_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT fk_course_enrollments_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: courses fk_courses_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT fk_courses_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: custom_assignments fk_custom_assignments_batch_section_id_batch_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_assignments
    ADD CONSTRAINT fk_custom_assignments_batch_section_id_batch_sections FOREIGN KEY (batch_section_id) REFERENCES public.batch_sections(id);


--
-- Name: custom_assignments fk_custom_assignments_course_id_courses; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_assignments
    ADD CONSTRAINT fk_custom_assignments_course_id_courses FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: custom_assignments fk_custom_assignments_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_assignments
    ADD CONSTRAINT fk_custom_assignments_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: deductions fk_deductions_salary_id_salary; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deductions
    ADD CONSTRAINT fk_deductions_salary_id_salary FOREIGN KEY (salary_id) REFERENCES public.salary(id);


--
-- Name: employee_allowance_overrides fk_employee_allowance_overrides_allowance_type_id_allow_104e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_allowance_overrides
    ADD CONSTRAINT fk_employee_allowance_overrides_allowance_type_id_allow_104e FOREIGN KEY (allowance_type_id) REFERENCES public.allowance_types(id) ON DELETE CASCADE;


--
-- Name: employee_allowance_overrides fk_employee_allowance_overrides_employee_salary_assignm_02ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_allowance_overrides
    ADD CONSTRAINT fk_employee_allowance_overrides_employee_salary_assignm_02ac FOREIGN KEY (employee_salary_assignment_id) REFERENCES public.employee_salary_assignments(id) ON DELETE CASCADE;


--
-- Name: employee_salary_assignments fk_employee_salary_assignments_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_salary_assignments
    ADD CONSTRAINT fk_employee_salary_assignments_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: employee_salary_assignments fk_employee_salary_assignments_salary_structure_id_sala_4771; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_salary_assignments
    ADD CONSTRAINT fk_employee_salary_assignments_salary_structure_id_sala_4771 FOREIGN KEY (salary_structure_id) REFERENCES public.salary_structures(id);


--
-- Name: exam_settings fk_exam_settings_exam_id_exams; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_settings
    ADD CONSTRAINT fk_exam_settings_exam_id_exams FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: exam_setup_splits fk_exam_setup_splits_exam_setup_id_exam_setups; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_setup_splits
    ADD CONSTRAINT fk_exam_setup_splits_exam_setup_id_exam_setups FOREIGN KEY (exam_setup_id) REFERENCES public.exam_setups(id);


--
-- Name: exam_setups fk_exam_setups_batch_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_setups
    ADD CONSTRAINT fk_exam_setups_batch_id_degrees FOREIGN KEY (batch_id) REFERENCES public.degrees(id);


--
-- Name: exams fk_exams_course_id_courses; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT fk_exams_course_id_courses FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: extracurricular_activities fk_extracurricular_activities_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_activities
    ADD CONSTRAINT fk_extracurricular_activities_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: extracurricular_activities fk_extracurricular_activities_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_activities
    ADD CONSTRAINT fk_extracurricular_activities_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: extracurricular_logs fk_extracurricular_logs_activity_id_extracurricular_activities; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_logs
    ADD CONSTRAINT fk_extracurricular_logs_activity_id_extracurricular_activities FOREIGN KEY (activity_id) REFERENCES public.extracurricular_activities(id);


--
-- Name: extracurricular_logs fk_extracurricular_logs_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_logs
    ADD CONSTRAINT fk_extracurricular_logs_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: extracurricular_logs fk_extracurricular_logs_slot_id_extracurricular_slots; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_logs
    ADD CONSTRAINT fk_extracurricular_logs_slot_id_extracurricular_slots FOREIGN KEY (slot_id) REFERENCES public.extracurricular_slots(id);


--
-- Name: extracurricular_slots fk_extracurricular_slots_activity_id_extracurricular_activities; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_slots
    ADD CONSTRAINT fk_extracurricular_slots_activity_id_extracurricular_activities FOREIGN KEY (activity_id) REFERENCES public.extracurricular_activities(id);


--
-- Name: extracurricular_slots fk_extracurricular_slots_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_slots
    ADD CONSTRAINT fk_extracurricular_slots_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: extracurricular_slots fk_extracurricular_slots_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extracurricular_slots
    ADD CONSTRAINT fk_extracurricular_slots_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: faculty_absences fk_faculty_absences_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_absences
    ADD CONSTRAINT fk_faculty_absences_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: faculty_profile_update_requests fk_faculty_profile_update_requests_processed_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_profile_update_requests
    ADD CONSTRAINT fk_faculty_profile_update_requests_processed_by_users FOREIGN KEY (processed_by) REFERENCES public.users(id);


--
-- Name: faculty_profile_update_requests fk_faculty_profile_update_requests_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_profile_update_requests
    ADD CONSTRAINT fk_faculty_profile_update_requests_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: faculty_profiles fk_faculty_profiles_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_profiles
    ADD CONSTRAINT fk_faculty_profiles_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: faculty_research fk_faculty_research_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_research
    ADD CONSTRAINT fk_faculty_research_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: faculty_workload fk_faculty_workload_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty_workload
    ADD CONSTRAINT fk_faculty_workload_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: fee_records fk_fee_records_fee_structure_id_fee_structure; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_records
    ADD CONSTRAINT fk_fee_records_fee_structure_id_fee_structure FOREIGN KEY (fee_structure_id) REFERENCES public.fee_structure(id);


--
-- Name: fee_records fk_fee_records_student_id_students; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_records
    ADD CONSTRAINT fk_fee_records_student_id_students FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: fee_structure fk_fee_structure_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_structure
    ADD CONSTRAINT fk_fee_structure_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: floors fk_floors_buildingId_buildings; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.floors
    ADD CONSTRAINT "fk_floors_buildingId_buildings" FOREIGN KEY ("buildingId") REFERENCES public.buildings(id);


--
-- Name: grade_template_allowances fk_grade_template_allowances_allowance_type_id_allowance_types; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grade_template_allowances
    ADD CONSTRAINT fk_grade_template_allowances_allowance_type_id_allowance_types FOREIGN KEY (allowance_type_id) REFERENCES public.allowance_types(id) ON DELETE CASCADE;


--
-- Name: grade_template_allowances fk_grade_template_allowances_salary_structure_id_salary_6358; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grade_template_allowances
    ADD CONSTRAINT fk_grade_template_allowances_salary_structure_id_salary_6358 FOREIGN KEY (salary_structure_id) REFERENCES public.salary_structures(id) ON DELETE CASCADE;


--
-- Name: grievances fk_grievances_assigned_to_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grievances
    ADD CONSTRAINT fk_grievances_assigned_to_users FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: grievances fk_grievances_raised_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grievances
    ADD CONSTRAINT fk_grievances_raised_by_users FOREIGN KEY (raised_by) REFERENCES public.users(id);


--
-- Name: innovation_posts fk_innovation_posts_student_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.innovation_posts
    ADD CONSTRAINT fk_innovation_posts_student_id_users FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: internal_marks fk_internal_marks_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internal_marks
    ADD CONSTRAINT fk_internal_marks_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: internal_marks fk_internal_marks_student_id_students; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internal_marks
    ADD CONSTRAINT fk_internal_marks_student_id_students FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: internal_marks fk_internal_marks_subject_id_courses; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internal_marks
    ADD CONSTRAINT fk_internal_marks_subject_id_courses FOREIGN KEY (subject_id) REFERENCES public.courses(id);


--
-- Name: leave_approvals fk_leave_approvals_approved_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_approvals
    ADD CONSTRAINT fk_leave_approvals_approved_by_users FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: leave_approvals fk_leave_approvals_leave_id_leaves; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_approvals
    ADD CONSTRAINT fk_leave_approvals_leave_id_leaves FOREIGN KEY (leave_id) REFERENCES public.leaves(id);


--
-- Name: leave_deduction_limits fk_leave_deduction_limits_deduction_config_id_salary_de_a730; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_deduction_limits
    ADD CONSTRAINT fk_leave_deduction_limits_deduction_config_id_salary_de_a730 FOREIGN KEY (deduction_config_id) REFERENCES public.salary_deduction_configs(id);


--
-- Name: leaves fk_leaves_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT fk_leaves_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: legal_event_registrations fk_legal_event_registrations_event_id_legal_events; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_event_registrations
    ADD CONSTRAINT fk_legal_event_registrations_event_id_legal_events FOREIGN KEY (event_id) REFERENCES public.legal_events(id);


--
-- Name: marks fk_marks_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT fk_marks_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: marks fk_marks_student_id_students; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT fk_marks_student_id_students FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: mentorship_records fk_mentorship_records_mentor_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_records
    ADD CONSTRAINT fk_mentorship_records_mentor_id_users FOREIGN KEY (mentor_id) REFERENCES public.users(id);


--
-- Name: mentorship_records fk_mentorship_records_student_id_students; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_records
    ADD CONSTRAINT fk_mentorship_records_student_id_students FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: messages fk_messages_receiver_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_messages_receiver_id_users FOREIGN KEY (receiver_id) REFERENCES public.users(id);


--
-- Name: messages fk_messages_sender_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_messages_sender_id_users FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: notice_acknowledgements fk_notice_acknowledgements_notice_id_notices; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notice_acknowledgements
    ADD CONSTRAINT fk_notice_acknowledgements_notice_id_notices FOREIGN KEY (notice_id) REFERENCES public.notices(id);


--
-- Name: notice_acknowledgements fk_notice_acknowledgements_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notice_acknowledgements
    ADD CONSTRAINT fk_notice_acknowledgements_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: notices fk_notices_created_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notices
    ADD CONSTRAINT fk_notices_created_by_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: notices fk_notices_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notices
    ADD CONSTRAINT fk_notices_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: notifications fk_notifications_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notifications_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: parent_student_map fk_parent_student_map_parent_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parent_student_map
    ADD CONSTRAINT fk_parent_student_map_parent_id_users FOREIGN KEY (parent_id) REFERENCES public.users(id);


--
-- Name: parent_student_map fk_parent_student_map_student_id_students; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parent_student_map
    ADD CONSTRAINT fk_parent_student_map_student_id_students FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: payments fk_payments_fee_record_id_fee_records; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payments_fee_record_id_fee_records FOREIGN KEY (fee_record_id) REFERENCES public.fee_records(id);


--
-- Name: payroll_runs fk_payroll_runs_approved_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payroll_runs
    ADD CONSTRAINT fk_payroll_runs_approved_by_users FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: payroll_runs fk_payroll_runs_generated_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payroll_runs
    ADD CONSTRAINT fk_payroll_runs_generated_by_users FOREIGN KEY (generated_by) REFERENCES public.users(id);


--
-- Name: publication_plans fk_publication_plans_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_plans
    ADD CONSTRAINT fk_publication_plans_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: publication_proofs fk_publication_proofs_plan_id_research_plans; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_proofs
    ADD CONSTRAINT fk_publication_proofs_plan_id_research_plans FOREIGN KEY (plan_id) REFERENCES public.research_plans(id);


--
-- Name: research_compliance fk_research_compliance_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_compliance
    ADD CONSTRAINT fk_research_compliance_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: research_plans fk_research_plans_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_plans
    ADD CONSTRAINT fk_research_plans_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: research_progress_updates fk_research_progress_updates_plan_id_research_plans; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_progress_updates
    ADD CONSTRAINT fk_research_progress_updates_plan_id_research_plans FOREIGN KEY (plan_id) REFERENCES public.research_plans(id);


--
-- Name: research_verifications fk_research_verifications_proof_id_publication_proofs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_verifications
    ADD CONSTRAINT fk_research_verifications_proof_id_publication_proofs FOREIGN KEY (proof_id) REFERENCES public.publication_proofs(id);


--
-- Name: research_verifications fk_research_verifications_verified_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_verifications
    ADD CONSTRAINT fk_research_verifications_verified_by_users FOREIGN KEY (verified_by) REFERENCES public.users(id);


--
-- Name: rooms fk_rooms_floorId_floors; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT "fk_rooms_floorId_floors" FOREIGN KEY ("floorId") REFERENCES public.floors(id);


--
-- Name: salary_allowances fk_salary_allowances_allowance_type_id_allowance_types; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_allowances
    ADD CONSTRAINT fk_salary_allowances_allowance_type_id_allowance_types FOREIGN KEY (allowance_type_id) REFERENCES public.allowance_types(id);


--
-- Name: salary_allowances fk_salary_allowances_salary_id_salary; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_allowances
    ADD CONSTRAINT fk_salary_allowances_salary_id_salary FOREIGN KEY (salary_id) REFERENCES public.salary(id) ON DELETE CASCADE;


--
-- Name: salary fk_salary_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary
    ADD CONSTRAINT fk_salary_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: salary fk_salary_payroll_run_id_payroll_runs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary
    ADD CONSTRAINT fk_salary_payroll_run_id_payroll_runs FOREIGN KEY (payroll_run_id) REFERENCES public.payroll_runs(id);


--
-- Name: salary_revisions fk_salary_revisions_approved_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_revisions
    ADD CONSTRAINT fk_salary_revisions_approved_by_users FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: salary_revisions fk_salary_revisions_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_revisions
    ADD CONSTRAINT fk_salary_revisions_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: salary_slip_requests fk_salary_slip_requests_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_slip_requests
    ADD CONSTRAINT fk_salary_slip_requests_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: salary_slip_requests fk_salary_slip_requests_salary_slip_id_salary_slips; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_slip_requests
    ADD CONSTRAINT fk_salary_slip_requests_salary_slip_id_salary_slips FOREIGN KEY (salary_slip_id) REFERENCES public.salary_slips(id);


--
-- Name: salary_slips fk_salary_slips_salary_id_salary; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_slips
    ADD CONSTRAINT fk_salary_slips_salary_id_salary FOREIGN KEY (salary_id) REFERENCES public.salary(id);


--
-- Name: section_cohort_mappings fk_section_cohort_mappings_batch_section_id_batch_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.section_cohort_mappings
    ADD CONSTRAINT fk_section_cohort_mappings_batch_section_id_batch_sections FOREIGN KEY (batch_section_id) REFERENCES public.batch_sections(id) ON DELETE CASCADE;


--
-- Name: section_cohort_mappings fk_section_cohort_mappings_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.section_cohort_mappings
    ADD CONSTRAINT fk_section_cohort_mappings_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: sections fk_sections_course_id_courses; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT fk_sections_course_id_courses FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: sections fk_sections_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT fk_sections_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: session_summaries fk_session_summaries_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_summaries
    ADD CONSTRAINT fk_session_summaries_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: session_summaries fk_session_summaries_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_summaries
    ADD CONSTRAINT fk_session_summaries_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: staff_attendance fk_staff_attendance_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_attendance
    ADD CONSTRAINT fk_staff_attendance_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: staff_attendance_records fk_staff_attendance_records_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_attendance_records
    ADD CONSTRAINT fk_staff_attendance_records_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: student_interactions fk_student_interactions_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_interactions
    ADD CONSTRAINT fk_student_interactions_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: student_interactions fk_student_interactions_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_interactions
    ADD CONSTRAINT fk_student_interactions_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: student_material_bookmarks fk_student_material_bookmarks_material_id_study_materials; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_bookmarks
    ADD CONSTRAINT fk_student_material_bookmarks_material_id_study_materials FOREIGN KEY (material_id) REFERENCES public.study_materials(id);


--
-- Name: student_material_bookmarks fk_student_material_bookmarks_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_bookmarks
    ADD CONSTRAINT fk_student_material_bookmarks_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: student_material_downloads fk_student_material_downloads_material_id_study_materials; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_downloads
    ADD CONSTRAINT fk_student_material_downloads_material_id_study_materials FOREIGN KEY (material_id) REFERENCES public.study_materials(id);


--
-- Name: student_material_downloads fk_student_material_downloads_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_downloads
    ADD CONSTRAINT fk_student_material_downloads_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: student_material_favorites fk_student_material_favorites_material_id_study_materials; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_favorites
    ADD CONSTRAINT fk_student_material_favorites_material_id_study_materials FOREIGN KEY (material_id) REFERENCES public.study_materials(id);


--
-- Name: student_material_favorites fk_student_material_favorites_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_material_favorites
    ADD CONSTRAINT fk_student_material_favorites_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: student_papers fk_student_papers_mentor_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_papers
    ADD CONSTRAINT fk_student_papers_mentor_id_users FOREIGN KEY (mentor_id) REFERENCES public.users(id);


--
-- Name: student_papers fk_student_papers_student_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_papers
    ADD CONSTRAINT fk_student_papers_student_user_id_users FOREIGN KEY (student_user_id) REFERENCES public.users(id);


--
-- Name: students fk_students_batch_section_id_batch_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_batch_section_id_batch_sections FOREIGN KEY (batch_section_id) REFERENCES public.batch_sections(id);


--
-- Name: students fk_students_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: students fk_students_mentor_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_mentor_id_users FOREIGN KEY (mentor_id) REFERENCES public.users(id);


--
-- Name: students fk_students_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: students fk_students_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: study_materials fk_study_materials_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.study_materials
    ADD CONSTRAINT fk_study_materials_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: study_materials fk_study_materials_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.study_materials
    ADD CONSTRAINT fk_study_materials_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: subject_allocations fk_subject_allocations_academic_year_id_academic_years; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_allocations
    ADD CONSTRAINT fk_subject_allocations_academic_year_id_academic_years FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id);


--
-- Name: subject_allocations fk_subject_allocations_allocated_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_allocations
    ADD CONSTRAINT fk_subject_allocations_allocated_by_users FOREIGN KEY (allocated_by) REFERENCES public.users(id);


--
-- Name: subject_allocations fk_subject_allocations_course_id_courses; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_allocations
    ADD CONSTRAINT fk_subject_allocations_course_id_courses FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: subject_allocations fk_subject_allocations_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_allocations
    ADD CONSTRAINT fk_subject_allocations_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: subject_allocations fk_subject_allocations_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_allocations
    ADD CONSTRAINT fk_subject_allocations_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: subject_allocations fk_subject_allocations_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_allocations
    ADD CONSTRAINT fk_subject_allocations_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: substitution_allocations fk_substitution_allocations_absence_id_faculty_absences; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.substitution_allocations
    ADD CONSTRAINT fk_substitution_allocations_absence_id_faculty_absences FOREIGN KEY (absence_id) REFERENCES public.faculty_absences(id);


--
-- Name: substitution_allocations fk_substitution_allocations_substitute_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.substitution_allocations
    ADD CONSTRAINT fk_substitution_allocations_substitute_faculty_id_users FOREIGN KEY (substitute_faculty_id) REFERENCES public.users(id);


--
-- Name: substitution_allocations fk_substitution_allocations_timetable_id_timetable; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.substitution_allocations
    ADD CONSTRAINT fk_substitution_allocations_timetable_id_timetable FOREIGN KEY (timetable_id) REFERENCES public.timetable(id);


--
-- Name: system_setting_history fk_system_setting_history_setting_id_system_settings; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_setting_history
    ADD CONSTRAINT fk_system_setting_history_setting_id_system_settings FOREIGN KEY (setting_id) REFERENCES public.system_settings(id);


--
-- Name: system_setting_history fk_system_setting_history_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_setting_history
    ADD CONSTRAINT fk_system_setting_history_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: timetable_action_history fk_timetable_action_history_action_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_action_history
    ADD CONSTRAINT fk_timetable_action_history_action_by_users FOREIGN KEY (action_by) REFERENCES public.users(id);


--
-- Name: timetable_action_history fk_timetable_action_history_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_action_history
    ADD CONSTRAINT fk_timetable_action_history_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: timetable_approvals fk_timetable_approvals_approved_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_approvals
    ADD CONSTRAINT fk_timetable_approvals_approved_by_users FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: timetable_approvals fk_timetable_approvals_rejected_by_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_approvals
    ADD CONSTRAINT fk_timetable_approvals_rejected_by_users FOREIGN KEY (rejected_by) REFERENCES public.users(id);


--
-- Name: timetable_approvals fk_timetable_approvals_timetable_id_timetable; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_approvals
    ADD CONSTRAINT fk_timetable_approvals_timetable_id_timetable FOREIGN KEY (timetable_id) REFERENCES public.timetable(id);


--
-- Name: timetable fk_timetable_faculty_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT fk_timetable_faculty_id_users FOREIGN KEY (faculty_id) REFERENCES public.users(id);


--
-- Name: timetable fk_timetable_section_id_sections; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT fk_timetable_section_id_sections FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: timetable fk_timetable_subject_id_courses; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT fk_timetable_subject_id_courses FOREIGN KEY (subject_id) REFERENCES public.courses(id);


--
-- Name: timetable_templates fk_timetable_templates_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable_templates
    ADD CONSTRAINT fk_timetable_templates_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- Name: user_preferences fk_user_preferences_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT fk_user_preferences_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_sessions fk_user_sessions_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT fk_user_sessions_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users fk_users_degree_id_degrees; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_degree_id_degrees FOREIGN KEY (degree_id) REFERENCES public.degrees(id);


--
-- PostgreSQL database dump complete
--

