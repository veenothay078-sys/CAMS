import React from 'react';
import { MessageSquarePlus, Trash2, Database, ShieldCheck } from 'lucide-react';

export default function Sidebar({
  sessions,
  currentSessionId,
  onSelectSession,
  onNewSession,
  onDeleteSession,
  dbInfo
}) {
  return (
    <aside className="sidebar">
      <div className="sidebar-header">
        <div className="sidebar-brand">
          <div className="brand-icon">CA</div>
          <div>
            <div className="brand-title">CAMS AI Chatbot</div>
            <div className="brand-subtitle">College Management System</div>
          </div>
        </div>
      </div>

      <button className="new-chat-btn" onClick={onNewSession} id="btn-new-chat">
        <MessageSquarePlus size={16} />
        <span>New Conversation</span>
      </button>

      <div className="sidebar-history">
        <div className="history-label">Recent Inquiries</div>
        {sessions.length === 0 ? (
          <div style={{ padding: '0.75rem', fontSize: '0.78rem', color: '#64748b' }}>
            No previous sessions
          </div>
        ) : (
          sessions.map((session) => (
            <div
              key={session.id}
              className={`session-item ${session.id === currentSessionId ? 'active' : ''}`}
              onClick={() => onSelectSession(session.id)}
              id={`session-item-${session.id}`}
            >
              <span className="session-title" title={session.title}>
                {session.title || 'Untitled Query'}
              </span>
              <button
                className="session-delete-btn"
                title="Delete Session"
                onClick={(e) => {
                  e.stopPropagation();
                  onDeleteSession(session.id);
                }}
              >
                <Trash2 size={13} />
              </button>
            </div>
          ))
        )}
      </div>

      <div className="sidebar-footer">
        <div className="status-pill">
          <span className="status-dot"></span>
          <span>{dbInfo.connected ? `PostgreSQL Live (${dbInfo.tablesCount} Tables)` : 'Database Degraded'}</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.35rem', color: '#94a3b8' }}>
          <ShieldCheck size={12} />
          <span>Safe Read-Only Query Layer</span>
        </div>
      </div>
    </aside>
  );
}
