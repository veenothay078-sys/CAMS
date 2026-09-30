import React, { useState } from 'react';
import { Sparkles, CheckCircle2, Clock, AlertCircle } from 'lucide-react';

export default function LeavesModule({ onAskAI, currentUser }) {
  const [activeLeaveTab, setActiveLeaveTab] = useState('ALL');

  const leaveRecords = [
    { id: 'LV-2026-081', student_name: 'Arun Kumar', roll_no: '2024-LLB-001', type: 'On-Duty (OD)', dates: '24 Sep - 26 Sep', reason: 'National Moot Court Competition', status: 'APPROVED' },
    { id: 'LV-2026-084', student_name: 'Priya Sharma', roll_no: '2024-LLB-004', type: 'Medical', dates: '28 Sep - 30 Sep', reason: 'Viral fever (Hospital certified)', status: 'PENDING' },
    { id: 'LV-2026-079', student_name: 'Kavitha R', roll_no: '2024-LLB-007', type: 'Personal', dates: '18 Sep - 19 Sep', reason: 'Family engagement', status: 'REJECTED' }
  ];

  const filteredLeaves = activeLeaveTab === 'ALL' 
    ? leaveRecords 
    : leaveRecords.filter(l => l.status === activeLeaveTab);

  return (
    <div className="leaves-page-wrapper" role="region" aria-label="Leave Management">
      {/* 1. Header */}
      <div className="editorial-page-header">
        <h1 className="page-title-royal">Leave & Absence Management</h1>
        <p className="editorial-subtitle">
          Institutional leave application workflows, on-duty (OD) event permits, and medical condonations.
        </p>
        <div className="editorial-metadata-row">
          <span>College Regulations</span>
          <span className="editorial-metadata-dot">•</span>
          <span>Attendance Impact Calculator Integrated</span>
        </div>
      </div>

      {/* 2. Institutional Policy Cards */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1.25rem', marginBottom: '1.75rem' }}>
        <div style={{ background: 'var(--bg-card)', border: '1px solid var(--border-color)', borderRadius: 'var(--radius-lg)', padding: '1.25rem', boxShadow: 'var(--shadow-card)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '0.5rem' }}>
            <CheckCircle2 size={16} style={{ color: 'var(--status-success)' }} />
            <strong style={{ fontSize: '0.88rem', color: 'var(--color-dark-navy)' }}>On-Duty (OD) Permits</strong>
          </div>
          <p style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', lineHeight: 1.45 }}>
            Granted for students representing CAS Law College in moot courts, legal seminars, and sports tournaments.
          </p>
          <button 
            style={{ marginTop: '0.75rem', background: 'transparent', border: 'none', color: 'var(--color-primary-royal)', fontSize: '0.74rem', fontWeight: 600, cursor: 'pointer', padding: 0 }}
            onClick={() => onAskAI('How does On-Duty (OD) leave affect my overall attendance percentage in CAMS?')}
          >
            Check OD Policy →
          </button>
        </div>

        <div style={{ background: 'var(--bg-card)', border: '1px solid var(--border-color)', borderRadius: 'var(--radius-lg)', padding: '1.25rem', boxShadow: 'var(--shadow-card)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '0.5rem' }}>
            <Clock size={16} style={{ color: 'var(--status-warning)' }} />
            <strong style={{ fontSize: '0.88rem', color: 'var(--color-dark-navy)' }}>Medical Condonation</strong>
          </div>
          <p style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', lineHeight: 1.45 }}>
            Requires valid medical certificate submitted to the Dean's office within 3 working days of resumption.
          </p>
          <button 
            style={{ marginTop: '0.75rem', background: 'transparent', border: 'none', color: 'var(--color-primary-royal)', fontSize: '0.74rem', fontWeight: 600, cursor: 'pointer', padding: 0 }}
            onClick={() => onAskAI('What is the minimum attendance required after medical leave condonation?')}
          >
            Check Medical Rules →
          </button>
        </div>

        <div style={{ background: 'var(--bg-card)', border: '1px solid var(--border-color)', borderRadius: 'var(--radius-lg)', padding: '1.25rem', boxShadow: 'var(--shadow-card)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '0.5rem' }}>
            <AlertCircle size={16} style={{ color: 'var(--color-primary-royal)' }} />
            <strong style={{ fontSize: '0.88rem', color: 'var(--color-dark-navy)' }}>Faculty Approval</strong>
          </div>
          <p style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', lineHeight: 1.45 }}>
            Faculty members review duty allocations and arrange makeup tutorial sessions to ensure curriculum compliance.
          </p>
          <button 
            style={{ marginTop: '0.75rem', background: 'transparent', border: 'none', color: 'var(--color-primary-royal)', fontSize: '0.74rem', fontWeight: 600, cursor: 'pointer', padding: 0 }}
            onClick={() => onAskAI('Show faculty leave guidelines and makeup lecture procedures')}
          >
            Faculty Guidelines →
          </button>
        </div>
      </div>

      {/* 3. Leave Applications Administrative Table */}
      <div className="editorial-table-container">
        <div className="editorial-table-header-bar" style={{ flexWrap: 'wrap', gap: '0.75rem' }}>
          <div className="editorial-table-title">Registered Leave & Exemption Requests</div>
          
          <div style={{ display: 'flex', gap: '0.4rem' }}>
            {['ALL', 'PENDING', 'APPROVED', 'REJECTED'].map((st) => (
              <button
                key={st}
                onClick={() => setActiveLeaveTab(st)}
                className={`btn-secondary ${activeLeaveTab === st ? 'active' : ''}`}
                style={{
                  padding: '0.3rem 0.65rem',
                  fontSize: '0.72rem',
                  backgroundColor: activeLeaveTab === st ? 'var(--color-primary-royal)' : 'var(--bg-card)',
                  color: activeLeaveTab === st ? '#FFFFFF' : 'var(--color-primary-royal)',
                  borderColor: activeLeaveTab === st ? 'var(--color-primary-royal)' : 'var(--border-color)'
                }}
              >
                {st}
              </button>
            ))}
          </div>
        </div>

        <table className="cams-data-table">
          <thead>
            <tr>
              <th>Reference ID</th>
              <th>Applicant</th>
              <th>Leave Category</th>
              <th>Duration</th>
              <th>Reason</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {filteredLeaves.map((l) => (
              <tr key={l.id}>
                <td style={{ fontFamily: 'var(--font-mono)', fontSize: '0.78rem', fontWeight: 600, color: 'var(--color-primary-royal)' }}>
                  {l.id}
                </td>
                <td>
                  <strong>{l.student_name}</strong>
                  <span style={{ display: 'block', fontSize: '0.7rem', color: 'var(--text-secondary)' }}>{l.roll_no}</span>
                </td>
                <td>{l.type}</td>
                <td style={{ fontSize: '0.78rem' }}>{l.dates}</td>
                <td style={{ fontSize: '0.78rem', color: 'var(--text-secondary)' }}>{l.reason}</td>
                <td>
                  <span className={`cams-badge ${l.status === 'APPROVED' ? 'badge-success' : l.status === 'PENDING' ? 'badge-warning' : 'badge-danger'}`}>
                    {l.status}
                  </span>
                </td>
                <td>
                  <button 
                    className="btn-secondary"
                    style={{ padding: '0.2rem 0.55rem', fontSize: '0.72rem' }}
                    onClick={() => onAskAI(`What is the attendance status and approved leave record for ${l.student_name}?`)}
                  >
                    <Sparkles size={11} />
                    <span>Inquire</span>
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
