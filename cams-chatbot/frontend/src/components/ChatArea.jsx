import React, { useRef, useEffect } from 'react';
import { Send, AlertTriangle, ShieldCheck, X } from 'lucide-react';
import MessageItem from './MessageItem';
import EmptyState from './EmptyState';

export default function ChatArea({
  currentSession,
  messages,
  input,
  setInput,
  onSendMessage,
  loading,
  error,
  onClearError,
  userProfile,
  dbInfo
}) {
  const messagesEndRef = useRef(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, loading]);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (input.trim() && !loading) {
      onSendMessage(input);
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSubmit(e);
    }
  };

  return (
    <div className="chat-main">
      {/* Top Navbar */}
      <header className="top-navbar">
        <div className="navbar-title">
          <span className="nav-heading">{currentSession ? currentSession.title : 'CAMS Assistant'}</span>
          <span className="badge-tag">Safe SQL</span>
        </div>

        <div className="navbar-controls">
          <div className="user-selector">
            <span>Logged in as:</span>
            <span className="role-badge">{userProfile.role} ({userProfile.email})</span>
          </div>
        </div>
      </header>

      {/* Error Banner */}
      {error && (
        <div className="error-banner">
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <AlertTriangle size={15} />
            <span>{error}</span>
          </div>
          <button onClick={onClearError} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'inherit' }}>
            <X size={14} />
          </button>
        </div>
      )}

      {/* Messages Scroll Area */}
      <div className="messages-container">
        {messages.length === 0 ? (
          <EmptyState onSelectPrompt={(prompt) => setInput(prompt)} />
        ) : (
          messages.map((msg) => (
            <MessageItem key={msg.id} message={msg} />
          ))
        )}

        {/* Loading Indicator */}
        {loading && (
          <div className="message-wrapper">
            <div className="message-avatar avatar-assistant">CA</div>
            <div className="loading-indicator">
              <div className="spinner"></div>
              <span>Querying CAMS PostgreSQL & generating response...</span>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Bottom Input Area */}
      <div className="input-area-container">
        <form className="input-form" onSubmit={handleSubmit}>
          <div className="input-box-wrapper">
            <input
              type="text"
              className="chat-input"
              placeholder="Ask questions about student details, attendance, marks, courses, timetable, fees, notices..."
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKeyDown}
              disabled={loading}
              id="input-chat-query"
            />
            <button
              type="submit"
              className="send-button"
              disabled={!input.trim() || loading}
              id="btn-send-query"
            >
              <Send size={14} />
              <span>Send</span>
            </button>
          </div>
          <div className="input-footnote">
            <span>Read-Only SQL access • 122 tables verified • Soft-delete safe</span>
            <span>Press Enter to send</span>
          </div>
        </form>
      </div>
    </div>
  );
}
