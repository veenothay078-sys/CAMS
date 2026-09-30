import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Bell, Sparkles } from 'lucide-react';

const API_BASE = import.meta.env.VITE_API_BASE_URL || '/api/v1';

export default function NotificationsModule({ onAskAI, currentUser }) {
  const [notices, setNotices] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchNotices();
  }, []);

  const fetchNotices = async () => {
    setLoading(true);
    try {
      const res = await axios.get(`${API_BASE}/data/notices/recent`);
      setNotices(res.data || []);
    } catch (err) {
      console.error('Failed to load notices:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="notifications-page-wrapper" role="region" aria-label="Campus Notifications">
      {/* 1. Header */}
      <div className="editorial-page-header">
        <h1 className="page-title-royal">Campus Notifications & Circulars</h1>
        <p className="editorial-subtitle">
          Official academic circulars, examination alerts, and institutional notices.
        </p>
        <div className="editorial-metadata-row">
          <span>Office of the Academic Dean</span>
          <span className="editorial-metadata-dot">•</span>
          <span>CAS Law College</span>
        </div>
      </div>

      {/* 2. Chronological Notifications Layout */}
      <div className="editorial-table-container">
        <div className="editorial-table-header-bar">
          <div className="editorial-table-title">Chronological Notice Board</div>
          <button 
            className="btn-primary"
            onClick={() => onAskAI('List recent academic notices, examination schedules, and holidays')}
          >
            <Sparkles size={14} />
            <span>Query Notices AI</span>
          </button>
        </div>

        <div style={{ padding: '1.25rem 1.5rem' }}>
          {notices.length === 0 ? (
            <div className="notifications-editorial-list">
              {/* Section: Today */}
              <div style={{ fontSize: '0.74rem', fontWeight: 700, color: 'var(--color-primary-royal)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: '0.5rem' }}>
                Today
              </div>

              <div className="notification-editorial-item">
                <span className="notification-dot-indicator" style={{ backgroundColor: 'var(--status-danger)' }} />
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div className="notification-item-text" style={{ fontWeight: 700, color: 'var(--color-dark-navy)' }}>
                      End-Semester Examination Schedule & Hall Ticket Distribution
                    </div>
                    <span className="cams-badge badge-danger">High Priority</span>
                  </div>
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', marginTop: '3px' }}>
                    Eligible students with verified 75% attendance can download examination hall passes from the student portal.
                  </p>
                  <div className="notification-item-time">Published by Examination Controller • Today at 09:30 AM</div>
                </div>
              </div>

              <div className="notification-editorial-item">
                <span className="notification-dot-indicator" style={{ backgroundColor: 'var(--color-primary-royal)' }} />
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div className="notification-item-text" style={{ fontWeight: 700, color: 'var(--color-dark-navy)' }}>
                      Guest Lecture on Constitutional Law & Judicial Review
                    </div>
                    <span className="cams-badge badge-royal">Academic</span>
                  </div>
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', marginTop: '3px' }}>
                    Senior Advocate address scheduled in Moot Court Hall at 02:00 PM for all Semester 2 & 4 students.
                  </p>
                  <div className="notification-item-time">Published by Faculty of Law • Today at 11:15 AM</div>
                </div>
              </div>

              {/* Section: Earlier */}
              <div style={{ fontSize: '0.74rem', fontWeight: 700, color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '0.08em', marginTop: '1.5rem', marginBottom: '0.5rem' }}>
                Earlier This Week
              </div>

              <div className="notification-editorial-item">
                <span className="notification-dot-indicator" style={{ backgroundColor: 'var(--color-secondary)' }} />
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div className="notification-item-text" style={{ fontWeight: 700, color: 'var(--color-dark-navy)' }}>
                      Attendance Condonation Application Deadline for Medical Cases
                    </div>
                    <span className="cams-badge badge-neutral">Administration</span>
                  </div>
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', marginTop: '3px' }}>
                    Students seeking exemption for genuine medical leaves must submit certified hospital reports to the Dean.
                  </p>
                  <div className="notification-item-time">Published 3 days ago • Administration</div>
                </div>
              </div>
            </div>
          ) : (
            <div className="notifications-editorial-list">
              {notices.map((n, idx) => (
                <div key={idx} className="notification-editorial-item">
                  <span className="notification-dot-indicator" />
                  <div style={{ flex: 1 }}>
                    <div className="notification-item-text" style={{ fontWeight: 700, color: 'var(--color-dark-navy)' }}>{n.title}</div>
                    <p style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', marginTop: '2px' }}>{n.body}</p>
                    <div className="notification-item-time">{n.category || 'General'}</div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
