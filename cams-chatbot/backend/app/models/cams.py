from sqlalchemy import Column, String, Boolean, DateTime, Date, Time, Numeric, Integer, Text, ForeignKey
from sqlalchemy.dialects.postgresql import ENUM
from sqlalchemy.orm import relationship
from app.models.base import Base

user_role_enum = ENUM(
    'SUPER_ADMIN', 'ADMIN', 'PRINCIPAL', 'HOD', 'FACULTY', 'STUDENT', 'PARENT',
    name='user_role',
    create_type=False
)

fee_status_enum = ENUM(
    'PAID', 'PENDING', 'OVERDUE', 'PARTIALLY_PAID',
    name='fee_status',
    create_type=False
)

weekday_enum = ENUM(
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY',
    name='weekday',
    create_type=False
)


class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True)
    email = Column(String, unique=True, nullable=False)
    phone = Column(String, nullable=True)
    full_name = Column(String, nullable=False)
    hashed_password = Column(String, nullable=True)
    role = Column(user_role_enum, nullable=False)
    additional_roles = Column(String, nullable=True)
    is_active = Column(Boolean, default=True)
    degree_id = Column(String, ForeignKey("degrees.id"), nullable=True)
    created_at = Column(DateTime(timezone=True))
    updated_at = Column(DateTime(timezone=True))
    is_deleted = Column(Boolean, default=False)
    deleted_at = Column(DateTime(timezone=True), nullable=True)


class Degree(Base):
    __tablename__ = "degrees"

    id = Column(String, primary_key=True)
    code = Column(String, nullable=False)
    name = Column(String, nullable=False)
    program_level = Column(String, nullable=True)
    duration_years = Column(Integer, nullable=True)
    is_deleted = Column(Boolean, default=False)


class Student(Base):
    __tablename__ = "students"

    id = Column(String, primary_key=True)
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    roll_no = Column(String, unique=True, nullable=False)
    full_name = Column(String, nullable=False)
    semester = Column(Integer, nullable=False)
    batch_year = Column(String, nullable=True)
    academic_status = Column(String, nullable=True)
    cgpa = Column(Numeric, nullable=True)
    degree_id = Column(String, ForeignKey("degrees.id"), nullable=True)
    section_id = Column(String, ForeignKey("sections.id"), nullable=True)
    is_deleted = Column(Boolean, default=False)


class Course(Base):
    __tablename__ = "courses"

    id = Column(String, primary_key=True)
    degree_id = Column(String, ForeignKey("degrees.id"), nullable=False)
    code = Column(String, nullable=False)
    name = Column(String, nullable=False)
    credits = Column(Integer, nullable=False)
    semester = Column(Integer, nullable=False)
    is_deleted = Column(Boolean, default=False)


class Section(Base):
    __tablename__ = "sections"

    id = Column(String, primary_key=True)
    course_id = Column(String, ForeignKey("courses.id"), nullable=True)
    section_name = Column(String, nullable=False)
    faculty_id = Column(String, ForeignKey("users.id"), nullable=True)
    capacity = Column(Integer, nullable=True)
    is_deleted = Column(Boolean, default=False)


class Attendance(Base):
    __tablename__ = "attendance"

    id = Column(String, primary_key=True)
    section_id = Column(String, ForeignKey("sections.id"), nullable=False)
    subject_id = Column(String, ForeignKey("courses.id"), nullable=False)
    faculty_id = Column(String, ForeignKey("users.id"), nullable=False)
    date = Column(Date, nullable=False)
    hour = Column(Integer, nullable=False)
    absentee_ids = Column(String, nullable=True)
    od_ids = Column(String, nullable=True)
    is_locked = Column(Boolean, default=False)
    is_deleted = Column(Boolean, default=False)


class Timetable(Base):
    __tablename__ = "timetable"

    id = Column(String, primary_key=True)
    section_id = Column(String, ForeignKey("sections.id"), nullable=False)
    subject_id = Column(String, ForeignKey("courses.id"), nullable=False)
    faculty_id = Column(String, ForeignKey("users.id"), nullable=False)
    room = Column(String, nullable=True)
    weekday = Column(weekday_enum, nullable=False)
    start_time = Column(Time, nullable=False)
    end_time = Column(Time, nullable=False)
    is_draft = Column(Boolean, default=False)
    is_deleted = Column(Boolean, default=False)


class InternalMark(Base):
    __tablename__ = "internal_marks"

    id = Column(String, primary_key=True)
    student_id = Column(String, nullable=False)
    section_id = Column(String, ForeignKey("sections.id"), nullable=False)
    subject_id = Column(String, ForeignKey("courses.id"), nullable=False)
    academic_year = Column(String, nullable=False)
    semester = Column(String, nullable=False)
    internal_exam_mark = Column(Numeric, nullable=True)
    assignment_mark = Column(Numeric, nullable=True)
    presentation_mark = Column(Numeric, nullable=True)
    viva_voice_mark = Column(Numeric, nullable=True)
    attendance_mark = Column(Numeric, nullable=True)
    total_mark = Column(Numeric, nullable=True)
    status = Column(String, nullable=True)
    is_deleted = Column(Boolean, default=False)


class FeeStructure(Base):
    __tablename__ = "fee_structure"

    id = Column(String, primary_key=True)
    degree_id = Column(String, ForeignKey("degrees.id"), nullable=False)
    semester = Column(Integer, nullable=False)
    amount = Column(Numeric, nullable=False)
    due_date = Column(Date, nullable=True)
    fee_type = Column(String, nullable=False)
    is_deleted = Column(Boolean, default=False)


class FeeRecord(Base):
    __tablename__ = "fee_records"

    id = Column(String, primary_key=True)
    student_id = Column(String, ForeignKey("users.id"), nullable=False)
    fee_structure_id = Column(String, ForeignKey("fee_structure.id"), nullable=False)
    status = Column(fee_status_enum, nullable=False)
    is_deleted = Column(Boolean, default=False)


class Notice(Base):
    __tablename__ = "notices"

    id = Column(String, primary_key=True)
    created_by = Column(String, ForeignKey("users.id"), nullable=False)
    title = Column(String, nullable=False)
    body = Column(Text, nullable=False)
    audience_type = Column(String, nullable=True)
    publish_date = Column(Date, nullable=True)
    category = Column(String, nullable=True)
    expiry_date = Column(Date, nullable=True)
    priority = Column(String, nullable=True)
    status = Column(String, nullable=False)
    is_deleted = Column(Boolean, default=False)


class AcademicYear(Base):
    __tablename__ = "academic_years"

    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    degree_id = Column(String, ForeignKey("degrees.id"), nullable=True)
    current_semester = Column(Integer, nullable=True)
    is_active = Column(Boolean, default=True)
    is_deleted = Column(Boolean, default=False)
