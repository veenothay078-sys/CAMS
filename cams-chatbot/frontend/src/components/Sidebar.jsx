import React from 'react';
import { MessageSquarePlus, Trash2, Database, ShieldCheck, UserCheck, X, LogOut, ChevronDown } from 'lucide-react';

export default function Sidebar({
  sessions,
  currentSessionId,
  onSelectSession,
  onNewSession,
  onDeleteSession,
  dbInfo,
  userProfile,
  demoUsers,
  onSwitchUser,
  onLogout,
  isOpen,
  onClose
}) {
  const getRoleBadgeColor = (role) => {
    switch (role?.toUpperCase()) {
      case 'ADMIN': return '#7c3aed';
      case 'FACULTY': return '#0d9488';
      case 'STUDENT': return '#2563eb';
      default: return '#64748b';
    }
  };

  return (
    <aside className={`sidebar ${isOpen ? 'sidebar-open' : ''}`} aria-label="Chat Sessions & Navigation">
      <div className="sidebar-header">
        <div className="sidebar-brand">
          <div className="brand-icon" aria-hidden="true">CA</div>
          <div>
            <div className="brand-title">CAMS AI Chatbot</div>
            <div className="brand-subtitle">College Management System</div>
          </div>
        </div>
        {/* Mobile Close Button */}
        <button 
          className="mobile-close-btn" 
          onClick={onClose}
          aria-label="Close sidebar navigation"
        >
          <X size={18} />
        </button>
      </div>

      {/* User Switcher Quick Card */}
      <div className="sidebar-user-card">
        <div className="user-card-header">
          <span className="user-card-label">Active Role & Context</span>
          <span 
            className="user-role-pill" 
            style={{ backgroundColor: getRoleBadgeColor(userProfile?.role) }}
          >
            {userProfile?.role || 'STUDENT'}
          </span>
        </div>
        <div className="user-email-text" title={userProfile?.email}>
          {userProfile?.full_name || userProfile?.email || 'User'}
        </div>

        {/* Quick Role Switcher */}
        <div className="role-switch-container">
          <label htmlFor="role-select" className="sr-only">Switch User Role</label>
          <select 
            id="role-select"
            className="role-select-dropdown"
            value={userProfile?.email}
            onChange={(e) => onSwitchUser(e.target.value)}
          >
            {demoUsers.map((u) => (
              <option key={u.email} value={u.email}>
                {u.role}: {u.full_name || u.email}
              </option>
            ))}
          </select>
        </div>
      </div>

      <button className="new-chat-btn" onClick={onNewSession} id="btn-new-chat" aria-label="Start a new conversation">
        <MessageSquarePlus size={16} aria-hidden="true" />
        <span>New Conversation</span>
      </button>

      <div className="sidebar-history" role="navigation" aria-label="Conversation History">
        <div className="history-label">Recent Inquiries</div>
        {sessions.length === 0 ? (
          <div className="empty-history-text">
            No previous sessions
          </div>
        ) : (
          sessions.map((session) => {
            const isActive = session.id === currentSessionId;
            return (
              <div
                key={session.id}
                className={`session-item ${isActive ? 'active' : ''}`}
                onClick={() => onSelectSession(session.id)}
                id={`session-item-${session.id}`}
                role="button"
                tabIndex={0}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' || e.key === ' ') {
                    onSelectSession(session.id);
                  }
                }}
                aria-current={isActive ? 'true' : 'false'}
              >
                <span className="session-title" title={session.title}>
                  {session.title || 'Untitled Query'}
                </span>
                <button
                  className="session-delete-btn"
                  title="Delete Session"
                  aria-label={`Delete conversation ${session.title}`}
                  onClick={(e) => {
                    e.stopPropagation();
                    onDeleteSession(session.id);
                  }}
                >
                  <Trash2 size={13} aria-hidden="true" />
                </button>
              </div>
            );
          })
        )}
      </div>

      <div className="sidebar-footer">
        <div className="status-pill" title="Database status">
          <span className={`status-dot ${dbInfo.connected ? 'status-dot-online' : 'status-dot-offline'}`} aria-hidden="true"></span>
          <span>{dbInfo.connected ? `PostgreSQL Live (${dbInfo.tablesCount} Tables)` : 'Database Degraded'}</span>
        </div>
        <div className="security-notice">
          <ShieldCheck size={12} aria-hidden="true" />
          <span>Safe Read-Only Query Layer</span>
        </div>
      </div>
    </aside>
  );
}
