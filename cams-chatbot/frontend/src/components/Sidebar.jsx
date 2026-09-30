import React, { useState } from 'react';
import { 
  LayoutDashboard, 
  Sparkles, 
  BookOpen, 
  Users, 
  UserCheck, 
  Calendar, 
  FileText, 
  Bell, 
  Plus, 
  Trash2, 
  ChevronLeft, 
  ChevronRight, 
  LogOut 
} from 'lucide-react';

export default function Sidebar({
  activeTab,
  onSelectTab,
  sessions = [],
  currentSessionId,
  onSelectSession,
  onNewSession,
  onDeleteSession,
  dbInfo,
  isOpen,
  onClose,
  isCollapsed,
  onToggleCollapse,
  currentUser,
  onLogout
}) {
  const [hoveredTab, setHoveredTab] = useState(null);

  const navItems = [
    { id: 'overview', label: 'Overview', icon: LayoutDashboard },
    { id: 'ai_assistant', label: 'AI Assistant', icon: Sparkles },
    { id: 'courses', label: 'Courses', icon: BookOpen },
    { id: 'users', label: 'Students', icon: Users },
    { id: 'attendance', label: 'Attendance', icon: UserCheck },
    { id: 'timetable', label: 'Timetable', icon: Calendar },
    { id: 'leaves', label: 'Leaves', icon: FileText },
    { id: 'notifications', label: 'Notifications', icon: Bell },
  ];

  const userInitials = currentUser?.full_name 
    ? currentUser.full_name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
    : 'AD';

  return (
    <aside 
      className={`cams-sidebar ${isOpen ? 'sidebar-mobile-open' : ''} ${isCollapsed ? 'sidebar-collapsed' : 'sidebar-expanded'}`} 
      aria-label="CAMS Navigation"
    >
      {/* 1. Top Brand Header */}
      <div className="sidebar-header-brand">
        <div className="sidebar-brand-box" onClick={() => onSelectTab('overview')}>
          <div className="brand-logo-mark" aria-hidden="true">
            <span>C</span>
          </div>
          {!isCollapsed && (
            <div className="brand-text-col">
              <span className="brand-name">CAMS</span>
              <span className="brand-sub">AI DATA ASSISTANT</span>
            </div>
          )}
        </div>

        <button 
          className="sidebar-collapse-toggle-btn"
          onClick={onToggleCollapse}
          title={isCollapsed ? "Expand sidebar" : "Collapse sidebar"}
          aria-label={isCollapsed ? "Expand sidebar" : "Collapse sidebar"}
        >
          {isCollapsed ? <ChevronRight size={16} /> : <ChevronLeft size={16} />}
        </button>
      </div>

      {/* 2. New Inquiry Action */}
      <div className="sidebar-action-area">
        <button 
          className="cams-sidebar-new-btn"
          onClick={() => {
            onNewSession && onNewSession();
            onSelectTab('ai_assistant');
          }}
          title="New AI Inquiry"
        >
          <Plus size={15} />
          {!isCollapsed && <span>New Inquiry</span>}
        </button>
      </div>

      {/* 3. Navigation Section */}
      <div className="cams-nav-section">
        {!isCollapsed && <div className="cams-nav-label">NAVIGATION</div>}
        <nav className="cams-nav-list" role="navigation">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = activeTab === item.id;
            return (
              <div 
                key={item.id} 
                className="cams-nav-item-wrapper"
                onMouseEnter={() => isCollapsed && setHoveredTab(item.id)}
                onMouseLeave={() => isCollapsed && setHoveredTab(null)}
              >
                <button
                  className={`cams-nav-item ${isActive ? 'active' : ''}`}
                  onClick={() => onSelectTab(item.id)}
                  aria-current={isActive ? 'page' : undefined}
                >
                  {isActive && <div className="cams-active-indicator" />}
                  <Icon size={16} className="cams-nav-icon" />
                  {!isCollapsed && <span className="cams-nav-text">{item.label}</span>}
                </button>

                {isCollapsed && hoveredTab === item.id && (
                  <div className="cams-hover-tooltip" role="tooltip">
                    {item.label}
                  </div>
                )}
              </div>
            );
          })}
        </nav>
      </div>

      {/* 4. Recent Inquiries */}
      {!isCollapsed && sessions && sessions.length > 0 && (
        <div className="sidebar-sessions-section">
          <div className="cams-nav-label">RECENT INQUIRIES</div>
          <div className="sidebar-session-list">
            {sessions.slice(0, 5).map((s) => (
              <div 
                key={s.id}
                className={`sidebar-session-row ${currentSessionId === s.id ? 'active' : ''}`}
                onClick={() => {
                  onSelectSession(s.id);
                  onSelectTab('ai_assistant');
                }}
              >
                <span className="sidebar-session-title">{s.title || 'Inquiry'}</span>
                <button 
                  className="session-delete-btn"
                  onClick={(e) => {
                    e.stopPropagation();
                    onDeleteSession(s.id);
                  }}
                  title="Delete inquiry"
                  aria-label="Delete inquiry"
                >
                  <Trash2 size={12} />
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      <div style={{ flex: 1 }} />

      {/* 5. Lower Area: Status & Profile */}
      <div className="cams-sidebar-footer">
        {!isCollapsed ? (
          <>
            <div className="sidebar-status-row">
              <span>System Status</span>
              <span>
                <span className="status-dot-connected" />
                {dbInfo?.connected ? 'Connected' : 'Offline'}
              </span>
            </div>
            <div className="sidebar-status-row" style={{ color: 'var(--color-light-blue)', fontSize: '0.68rem' }}>
              <span>PostgreSQL Database</span>
              <span>122 Tables</span>
            </div>

            <div className="sidebar-user-block">
              <div className="sidebar-user-info">
                <div className="sidebar-user-avatar">{userInitials}</div>
                <div>
                  <div className="sidebar-user-name">{currentUser?.full_name || 'Administrator'}</div>
                  <div className="sidebar-user-role">{currentUser?.role || 'ADMIN'}</div>
                </div>
              </div>
              {onLogout && (
                <button className="sidebar-logout-btn" onClick={onLogout} title="Sign Out">
                  <LogOut size={14} />
                </button>
              )}
            </div>
          </>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '0.5rem' }}>
            <div className="sidebar-user-avatar" title={currentUser?.full_name || 'User'}>
              {userInitials}
            </div>
          </div>
        )}
      </div>
    </aside>
  );
}
