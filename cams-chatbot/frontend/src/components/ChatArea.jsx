import React, { useRef, useEffect } from 'react';
import { Send, AlertTriangle, ShieldCheck, X, Menu, Trash2, User, RefreshCw } from 'lucide-react';
import MessageItem from './MessageItem';
import EmptyState from './EmptyState';

export default function ChatArea({
  currentSession,
  messages,
  input,
  setInput,
  onSendMessage,
  onRetry,
  onClearMessages,
  loading,
  error,
  onClearError,
  userProfile,
  demoUsers,
  onSwitchUser,
  onLogout,
  dbInfo,
  onToggleSidebar
}) {
  const messagesEndRef = useRef(null);
  const inputRef = useRef(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, loading]);

  const handleSubmit = (e) => {
    if (e) e.preventDefault();
    if (input.trim() && !loading) {
      onSendMessage(input);
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSubmit();
    }
  };

  const getRoleBadgeStyle = (role) => {
    switch (role?.toUpperCase()) {
      case 'ADMIN': return { background: '#f3e8ff', color: '#6b21a8', border: '1px solid #d8b4fe' };
      case 'FACULTY': return { background: '#ccfbf1', color: '#115e59', border: '1px solid #99f6e4' };
      case 'STUDENT': return { background: '#dbeafe', color: '#1e40af', border: '1px solid #bfdbfe' };
      default: return { background: '#f1f5f9', color: '#475569', border: '1px solid #cbd5e1' };
    }
  };

  return (
    <main className="chat-main" role="main" aria-label="CAMS Chat Area">
      {/* Top Navbar */}
      <header className="top-navbar">
        <div className="navbar-left">
          {/* Mobile hamburger menu toggle */}
          <button 
            className="mobile-menu-btn" 
            onClick={onToggleSidebar}
            aria-label="Open sidebar menu"
            title="Menu"
          >
            <Menu size={20} />
          </button>

          <div className="navbar-title">
            <span className="nav-heading" title={currentSession ? currentSession.title : 'CAMS Assistant'}>
              {currentSession ? currentSession.title : 'CAMS Assistant'}
            </span>
            <span className="badge-tag" title="Protected by Safe SQL Parser">
              <ShieldCheck size={11} style={{ marginRight: '3px' }} />
              Safe SQL
            </span>
          </div>
        </div>

        <div className="navbar-controls">
          {messages.length > 0 && (
            <button 
              className="navbar-action-btn"
              onClick={onClearMessages}
              title="Clear messages in this conversation"
              aria-label="Clear conversation"
            >
              <Trash2 size={14} />
              <span className="hide-mobile">Clear</span>
            </button>
          )}

          <div className="user-profile-badge" style={getRoleBadgeStyle(userProfile?.role)}>
            <User size={13} />
            <span className="user-role-text">{userProfile?.role || 'STUDENT'}</span>
            <span className="user-email-pill hide-mobile">({userProfile?.email})</span>
          </div>
        </div>
      </header>

      {/* Error Banner */}
      {error && (
        <div className="error-banner" role="alert">
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <AlertTriangle size={16} aria-hidden="true" />
            <span>{error}</span>
          </div>
          <button 
            onClick={onClearError} 
            className="error-close-btn"
            aria-label="Dismiss error"
          >
            <X size={14} />
          </button>
        </div>
      )}

      {/* Messages Scroll Area */}
      <div className="messages-container" role="log" aria-live="polite" aria-label="Conversation Messages">
        {messages.length === 0 ? (
          <EmptyState onSelectPrompt={(prompt) => {
            setInput(prompt);
            inputRef.current?.focus();
          }} />
        ) : (
          messages.map((msg) => (
            <MessageItem 
              key={msg.id} 
              message={msg} 
              onRetry={() => onRetry(msg.lastQuery)}
            />
          ))
        )}

        {/* Loading Indicator */}
        {loading && (
          <div className="message-wrapper">
            <div className="message-avatar avatar-assistant" aria-hidden="true">CA</div>
            <div className="loading-indicator">
              <div className="spinner" aria-hidden="true"></div>
              <span>Querying CAMS PostgreSQL & analyzing via Safe Query Engine...</span>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Bottom Input Area */}
      <footer className="input-area-container">
        <form className="input-form" onSubmit={handleSubmit} aria-label="Chat input form">
          <div className="input-box-wrapper">
            <textarea
              ref={inputRef}
              rows={1}
              className="chat-input"
              placeholder="Ask about student profiles, attendance %, marks, courses, timetable, faculty, fees..."
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKeyDown}
              disabled={loading}
              id="input-chat-query"
              aria-label="Message input"
            />
            <button
              type="submit"
              className="send-button"
              disabled={!input.trim() || loading}
              id="btn-send-query"
              aria-label="Send message"
              title="Send (Enter)"
            >
              {loading ? (
                <RefreshCw size={14} className="spin-icon" />
              ) : (
                <Send size={14} />
              )}
              <span className="hide-mobile">Send</span>
            </button>
          </div>
          <div className="input-footnote">
            <span>Read-Only SQL access • 122 tables verified • RBAC enforced</span>
            <span className="hide-mobile">Shift + Enter for new line • Enter to send</span>
          </div>
        </form>
      </footer>
    </main>
  );
}
