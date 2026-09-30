import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { 
  Users, 
  BookOpen, 
  GraduationCap, 
  Calendar, 
  UserCheck, 
  ArrowRight, 
  Clock, 
  Sparkles,
  MapPin,
  Bell
} from 'lucide-react';

const API_BASE = import.meta.env.VITE_API_BASE_URL || '/api/v1';

export default function OverviewModule({ onAskAI, onSelectTab, currentUser }) {
  const [stats, setStats] = useState({
    studentsCount: 8,
    facultyCount: 8,
    coursesCount: 16,
    timetableCount: 28,
    attendanceRate: 82.4
  });
  const [schedule, setSchedule] = useState([]);
  const [notices, setNotices] = useState([]);
  const [attendanceSummary, setAttendanceSummary] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchOverviewData();
  }, []);

  const fetchOverviewData = async () => {
    setLoading(true);
    try {
      const [attRes, ttRes, notRes, coursesRes, usersRes] = await Promise.allSettled([
        axios.get(`${API_BASE}/attendance/summary`),
        axios.post(`${API_BASE}/data/query`, {
          domain: 'timetable',
          intent: 'weekly_schedule',
          entities: {},
          requested_output: 'table'
        }),
        axios.get(`${API_BASE}/data/notices/recent`),
        axios.post(`${API_BASE}/data/query`, {
          domain: 'courses',
          intent: 'list_courses',
          entities: {},
          requested_output: 'table'
        }),
        axios.get(`${API_BASE}/auth/demo-users`)
      ]);

      if (attRes.status === 'fulfilled' && attRes.value?.data) {
        setAttendanceSummary(attRes.value.data);
        if (attRes.value.data.overall_percentage) {
          setStats(prev => ({ ...prev, attendanceRate: attRes.value.data.overall_percentage }));
        }
      }

      if (ttRes.status === 'fulfilled' && ttRes.value?.data?.data) {
        setSchedule(ttRes.value.data.data.slice(0, 4));
        setStats(prev => ({ ...prev, timetableCount: ttRes.value.data.data.length }));
      }

      if (notRes.status === 'fulfilled' && notRes.value?.data) {
        setNotices(notRes.value.data.slice(0, 3));
      }

      if (coursesRes.status === 'fulfilled' && coursesRes.value?.data?.data) {
        setStats(prev => ({ ...prev, coursesCount: coursesRes.value.data.data.length }));
      }

      if (usersRes.status === 'fulfilled' && usersRes.value?.data) {
        const users = usersRes.value.data;
        const students = users.filter(u => u.role === 'STUDENT').length;
        const faculty = users.filter(u => u.role === 'FACULTY').length;
        if (students > 0) setStats(prev => ({ ...prev, studentsCount: students }));
        if (faculty > 0) setStats(prev => ({ ...prev, facultyCount: faculty }));
      }
    } catch (err) {
      console.warn('Overview data fetch warning:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="overview-page-wrapper" role="region" aria-label="Academic Overview">
      {/* 1. Editorial Header */}
      <div className="editorial-page-header">
        <h1 className="page-title-royal">Academic Overview</h1>
        <p className="editorial-subtitle">
          Institutional operations, daily academic schedules, and real-time attendance intelligence.
        </p>
        <div className="editorial-metadata-row">
          <span>College Management System</span>
          <span className="editorial-metadata-dot">•</span>
          <span>Semester Academic Session</span>
          <span className="editorial-metadata-dot">•</span>
          <span>122 PostgreSQL Tables Connected</span>
        </div>
      </div>

      {/* 2. Asymmetric Grid */}
      <div className="editorial-overview-grid">
        {/* LEFT COLUMN: Large Hero Metric + Sub-metrics */}
        <div className="overview-left-col">
          <div className="overview-editorial-hero">
            <div className="hero-large-metric">{stats.studentsCount}</div>
            <div className="hero-metric-label">Enrolled Students • Degree Programs</div>
            <div className="overview-sub-metrics">
              <div className="sub-metric-card" onClick={() => onSelectTab('courses')} style={{ cursor: 'pointer' }}>
                <div className="sub-metric-val">{stats.coursesCount}</div>
                <div className="sub-metric-label">Active Courses</div>
              </div>
              <div className="sub-metric-card" onClick={() => onSelectTab('users')} style={{ cursor: 'pointer' }}>
                <div className="sub-metric-val">{stats.facultyCount}</div>
                <div className="sub-metric-label">Faculty Members</div>
              </div>
              <div className="sub-metric-card" onClick={() => onSelectTab('attendance')} style={{ cursor: 'pointer' }}>
                <div className="sub-metric-val" style={{ color: 'var(--color-primary-royal)' }}>{stats.attendanceRate}%</div>
                <div className="sub-metric-label">Average Attendance</div>
              </div>
            </div>
          </div>

          {/* Attendance Intelligence Wide Section */}
          <div className="editorial-table-container" style={{ marginTop: '1.75rem' }}>
            <div className="editorial-table-header-bar">
              <div className="editorial-table-title">Attendance Intelligence</div>
              <button 
                className="btn-secondary" 
                style={{ padding: '0.35rem 0.65rem', fontSize: '0.75rem' }}
                onClick={() => onSelectTab('attendance')}
              >
                <span>View Full Records</span>
                <ArrowRight size={13} />
              </button>
            </div>
            
            <div style={{ padding: '1.4rem', display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '1.5rem' }}>
              <div>
                <div style={{ fontSize: '0.85rem', color: 'var(--text-primary)', marginBottom: '0.35rem', fontWeight: 600 }}>
                  Institutional Attendance Standard: <span style={{ color: 'var(--color-primary-royal)' }}>75% Minimum</span>
                </div>
                <p style={{ fontSize: '0.82rem', color: 'var(--text-secondary)', maxWidth: '420px', lineHeight: 1.45 }}>
                  Current records indicate active student presence across law lecture periods and practical tutorials.
                </p>
              </div>

              <button 
                className="btn-primary"
                onClick={() => onAskAI('List all students with attendance below 75% threshold')}
              >
                <Sparkles size={14} />
                <span>Query At-Risk Students</span>
              </button>
            </div>
          </div>

          {/* Suggested Intelligence Inquiries */}
          <div style={{ marginTop: '1.75rem' }}>
            <div style={{ fontSize: '0.78rem', fontWeight: 700, color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '0.75rem' }}>
              Suggested Intelligence Inquiries
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '0.45rem' }}>
              <div className="ai-prompt-link-row" onClick={() => onAskAI("Show today's class schedule and classroom locations")}>
                <span>Show today's class schedule and faculty allocations</span>
                <span className="ai-prompt-arrow">→</span>
              </div>
              <div className="ai-prompt-link-row" onClick={() => onAskAI("List all 16 semester courses with credit distribution")}>
                <span>List all curriculum courses and credit allocations</span>
                <span className="ai-prompt-arrow">→</span>
              </div>
              <div className="ai-prompt-link-row" onClick={() => onAskAI("Show students with attendance below 75%")}>
                <span>Analyze students below 75% attendance threshold</span>
                <span className="ai-prompt-arrow">→</span>
              </div>
            </div>
          </div>
        </div>

        {/* RIGHT COLUMN: Today's Schedule + Recent Circulars */}
        <div className="overview-right-col">
          {/* Today's Schedule */}
          <div className="editorial-table-container">
            <div className="editorial-table-header-bar">
              <div className="editorial-table-title">Today's Academic Schedule</div>
              <button 
                className="btn-secondary" 
                style={{ padding: '0.35rem 0.65rem', fontSize: '0.75rem' }}
                onClick={() => onSelectTab('timetable')}
              >
                <span>Timetable</span>
                <ArrowRight size={13} />
              </button>
            </div>
            
            <div style={{ padding: '1rem 1.4rem' }}>
              {schedule.length === 0 ? (
                <div style={{ padding: '1rem 0', color: 'var(--text-secondary)', fontSize: '0.84rem' }}>
                  No classes scheduled for the current slot.
                </div>
              ) : (
                <div className="schedule-editorial-timeline">
                  {schedule.map((item, idx) => (
                    <div key={idx} className="schedule-editorial-item">
                      <div className="schedule-time-col">
                        {item.start_time ? `${item.start_time} - ${item.end_time}` : `Period ${idx + 1}`}
                      </div>
                      <div className="schedule-content-col">
                        <div className="schedule-item-subject">{item.subject_name || item.course_name || 'Law Lecture'}</div>
                        <div className="schedule-item-meta">{item.faculty_name || 'Faculty Member'}</div>
                        {item.room && <div className="schedule-item-room">Room {item.room}</div>}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>

          {/* Recent Campus Circulars */}
          <div className="editorial-table-container" style={{ marginTop: '1.75rem' }}>
            <div className="editorial-table-header-bar">
              <div className="editorial-table-title">Recent Circulars & Notices</div>
              <button 
                className="btn-secondary" 
                style={{ padding: '0.35rem 0.65rem', fontSize: '0.75rem' }}
                onClick={() => onSelectTab('notifications')}
              >
                <span>All Notices</span>
                <ArrowRight size={13} />
              </button>
            </div>

            <div style={{ padding: '1rem 1.4rem' }}>
              {notices.length === 0 ? (
                <div className="notifications-editorial-list">
                  <div className="notification-editorial-item">
                    <span className="notification-dot-indicator" />
                    <div>
                      <div className="notification-item-text" style={{ fontWeight: 600 }}>Semester Examination Timetable published by Academic Dean.</div>
                      <div className="notification-item-time">Today • Examination Office</div>
                    </div>
                  </div>
                  <div className="notification-editorial-item">
                    <span className="notification-dot-indicator" />
                    <div>
                      <div className="notification-item-text" style={{ fontWeight: 600 }}>National Moot Court Competition registration open.</div>
                      <div className="notification-item-time">Yesterday • Student Affairs</div>
                    </div>
                  </div>
                  <div className="notification-editorial-item">
                    <span className="notification-dot-indicator" style={{ backgroundColor: 'var(--color-primary-royal)' }} />
                    <div>
                      <div className="notification-item-text" style={{ fontWeight: 600 }}>Attendance condonation review for Medical & On-Duty leaves.</div>
                      <div className="notification-item-time">2 days ago • Administration</div>
                    </div>
                  </div>
                </div>
              ) : (
                <div className="notifications-editorial-list">
                  {notices.map((n, idx) => (
                    <div key={idx} className="notification-editorial-item">
                      <span className="notification-dot-indicator" />
                      <div>
                        <div className="notification-item-text" style={{ fontWeight: 600 }}>{n.title}</div>
                        <div className="notification-item-time">{n.category || 'Announcement'}</div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
