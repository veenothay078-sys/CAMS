import React, { useRef, useEffect } from 'react';
import { ArrowUp, AlertTriangle, X } from 'lucide-react';
import MessageItem from './MessageItem';
import EmptyState from './EmptyState';

export default function ChatArea({
  currentSession,
  messages = [],
  input,
  setInput,
  onSendMessage,
  onRetry,
  loading,
  error,
  onClearError
}) {
  const messagesEndRef = useRef(null);

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

  return (
    <div className="ai-workspace-container" role="region" aria-label="CAMS Intelligence">
      {/* Error Banner */}
      {error && (
        <div style={{ background: 'var(--status-danger-bg)', border: '1px solid var(--status-danger)', borderRadius: 'var(--radius-md)', padding: '0.75rem 1rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem', color: 'var(--status-danger)', fontSize: '0.84rem' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <AlertTriangle size={15} />
            <span>{error}</span>
          </div>
          <button onClick={onClearError} style={{ background: 'transparent', border: 'none', cursor: 'pointer', color: 'var(--status-danger)' }}>
            <X size={14} />
          </button>
        </div>
      )}

      {/* Messages Scroll Area */}
      <div className="chat-messages-scroll" role="log">
        {messages.length === 0 ? (
          <EmptyState onSelectPrompt={(prompt) => onSendMessage(prompt)} />
        ) : (
          messages.map((msg, idx) => (
            <MessageItem 
              key={msg.id || idx} 
              message={msg} 
              onRetry={onRetry} 
              onSelectOption={onSendMessage}
            />
          ))
        )}

        {/* Subtle Three-Line Skeleton Loading */}
        {loading && (
          <div className="message-editorial-assistant" style={{ opacity: 0.9 }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '0.55rem' }}>
              <div style={{ height: '12px', width: '85%', backgroundColor: 'var(--color-soft-blue)', borderRadius: '4px' }} />
              <div style={{ height: '12px', width: '65%', backgroundColor: 'var(--color-soft-blue)', borderRadius: '4px' }} />
              <div style={{ height: '12px', width: '40%', backgroundColor: 'var(--color-soft-blue)', borderRadius: '4px' }} />
            </div>
            <div style={{ fontSize: '0.74rem', color: 'var(--text-secondary)', marginTop: '0.25rem', fontWeight: 500 }}>
              Grounded in PostgreSQL • Querying database...
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* AI Chat Input Bar */}
      <div className="ai-input-bar-container">
        <form onSubmit={handleSubmit} className="ai-input-wrapper">
          <input
            type="text"
            className="ai-text-input"
            placeholder="Ask anything about students, courses, attendance, or timetable..."
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={handleKeyDown}
            disabled={loading}
          />
          <button 
            type="submit" 
            className="ai-send-btn" 
            disabled={!input.trim() || loading}
            title="Send Inquiry"
            aria-label="Send Inquiry"
          >
            <ArrowUp size={16} />
          </button>
        </form>
      </div>
    </div>
  );
}
