import React, { useState } from 'react';
import { 
  Bell, 
  HelpCircle, 
  LogOut, 
  Menu, 
  X
} from 'lucide-react';

const TAB_TITLES = {
  overview: 'Overview',
  ai_assistant: 'AI Assistant',
  courses: 'Courses',
  users: 'Students',
  attendance: 'Attendance',
  timetable: 'Timetable',
  leaves: 'Leaves',
  notifications: 'Notifications'
};

export default function TopHeader({
  activeTab,
  onSelectTab,
  dbInfo,
  userProfile,
  demoUsers = [],
  onSwitchUser,
  onLogout,
  onToggleSidebar
}) {
  const [profileOpen, setProfileOpen] = useState(false);
  const [helpOpen, setHelpOpen] = useState(false);

  const currentTitle = TAB_TITLES[activeTab] || 'Overview';
  const userInitials = userProfile?.full_name
    ? userProfile.full_name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
    : 'AD';

  return (
    <header className="cams-top-header" role="banner">
      {/* Left: Breadcrumbs */}
      <div className="header-left">
        <button 
          className="header-icon-btn mobile-only" 
          onClick={onToggleSidebar} 
          aria-label="Open navigation"
          style={{ display: 'none' }}
        >
          <Menu size={16} />
        </button>

        <nav className="header-breadcrumb" aria-label="Breadcrumb">
          <span className="breadcrumb-root" onClick={() => onSelectTab('overview')} style={{ cursor: 'pointer' }}>
            CAMS
          </span>
          <span className="breadcrumb-sep">/</span>
          <span className="breadcrumb-current">{currentTitle}</span>
        </nav>
      </div>

      {/* Right: Status, Notifications, Help & Profile */}
      <div className="header-right">
        {/* System status pill */}
        <div className="system-status-indicator" title="Connected to PostgreSQL Database">
          <span className="dot-connected" />
          <span>PostgreSQL Active</span>
        </div>

        {/* Notifications Shortcut */}
        <button 
          className="header-icon-btn" 
          onClick={() => onSelectTab('notifications')}
          title="View Notifications"
          aria-label="Notifications"
        >
          <Bell size={15} />
        </button>

        {/* Help Modal */}
        <button 
          className="header-icon-btn" 
          onClick={() => setHelpOpen(true)}
          title="CAMS Academic System Information"
          aria-label="Help"
        >
          <HelpCircle size={15} />
        </button>

        {/* User Profile dropdown */}
        <div className="user-profile-menu-wrapper" style={{ position: 'relative' }}>
          <button 
            className="user-profile-circle-btn"
            onClick={() => setProfileOpen(!profileOpen)}
            title={`Active: ${userProfile?.full_name || 'Administrator'} (${userProfile?.role || 'ADMIN'})`}
            aria-label="User menu"
            aria-expanded={profileOpen}
          >
            {userInitials}
          </button>

          {profileOpen && (
            <div className="profile-dropdown-menu" role="menu">
              <div className="profile-menu-header">
                <div style={{ fontSize: '0.84rem', fontWeight: 700, color: 'var(--color-dark-navy)' }}>
                  {userProfile?.full_name || 'Administrator'}
                </div>
                <div style={{ fontSize: '0.72rem', color: 'var(--text-secondary)' }}>
                  {userProfile?.email || 'admin@gmail.com'}
                </div>
                <div style={{ marginTop: '0.35rem' }}>
                  <span className="cams-badge badge-royal">{userProfile?.role || 'ADMIN'}</span>
                </div>
              </div>

              <div className="profile-menu-section">
                <div className="profile-menu-label">Switch Role Account</div>
                {demoUsers.map((u) => (
                  <button
                    key={u.email}
                    className={`profile-switch-item ${userProfile?.email === u.email ? 'active' : ''}`}
                    onClick={() => {
                      onSwitchUser(u.email);
                      setProfileOpen(false);
                    }}
                  >
                    <span>{u.full_name}</span>
                    <span style={{ fontSize: '0.65rem', fontWeight: 700, color: 'var(--color-primary-royal)' }}>
                      {u.role}
                    </span>
                  </button>
                ))}
              </div>

              <div className="profile-menu-footer">
                <button 
                  className="profile-logout-btn"
                  onClick={() => {
                    onLogout();
                    setProfileOpen(false);
                  }}
                >
                  <LogOut size={13} />
                  <span>Sign Out</span>
                </button>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Help Modal */}
      {helpOpen && (
        <div className="cams-drawer-overlay" onClick={() => setHelpOpen(false)} style={{ alignItems: 'center', justifyContent: 'center' }}>
          <div 
            style={{
              background: 'var(--bg-card)',
              border: '1px solid var(--border-color)',
              borderRadius: 'var(--radius-lg)',
              maxWidth: '520px',
              width: '90%',
              padding: '1.75rem',
              boxShadow: 'var(--shadow-dropdown)'
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
              <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--color-dark-navy)' }}>
                CAMS Academic Intelligence
              </h3>
              <button 
                onClick={() => setHelpOpen(false)}
                style={{ background: 'transparent', border: 'none', cursor: 'pointer', color: 'var(--text-secondary)' }}
              >
                <X size={18} />
              </button>
            </div>
            <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', lineHeight: 1.5, marginBottom: '1rem' }}>
              College Academic Management & Intelligence System with grounded access to PostgreSQL 17, E2B calculation sandbox, and NVIDIA NIM intelligence layer.
            </p>
            <div style={{ background: 'var(--color-soft-blue)', padding: '0.85rem 1rem', borderRadius: 'var(--radius-md)', fontSize: '0.8rem', color: 'var(--color-dark-navy)', border: '1px solid var(--color-light-blue)' }}>
              <strong>Connected Database:</strong> 122 ACID tables with Role-Based Access Control (Admin, Faculty, Student).
            </div>
            <div style={{ marginTop: '1.25rem', textAlign: 'right' }}>
              <button className="btn-primary" onClick={() => setHelpOpen(false)}>
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </header>
  );
}
