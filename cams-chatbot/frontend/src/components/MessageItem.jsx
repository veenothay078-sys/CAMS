import React from 'react';
import { User, Bot, Clock, Database, Tag } from 'lucide-react';

export default function MessageItem({ message }) {
  const isUser = message.role === 'USER';

  // Helper to parse markdown table if present
  const renderFormattedContent = (content) => {
    if (!content.includes('|')) {
      return <div style={{ whiteSpace: 'pre-wrap' }}>{content}</div>;
    }

    const lines = content.split('\n');
    const introLines = [];
    const tableLines = [];
    const outroLines = [];
    let inTable = false;

    lines.forEach((line) => {
      if (line.trim().startsWith('|') && line.trim().endsWith('|')) {
        inTable = true;
        tableLines.push(line);
      } else if (inTable) {
        outroLines.push(line);
      } else {
        introLines.push(line);
      }
    });

    if (tableLines.length >= 2) {
      const headerCells = tableLines[0].split('|').map(c => c.trim()).filter(Boolean);
      // Skip separator row (tableLines[1])
      const dataRows = tableLines.slice(2).map(row => 
        row.split('|').map(c => c.trim()).filter((_, idx, arr) => idx > 0 && idx < arr.length - 1)
      );

      return (
        <div>
          {introLines.length > 0 && (
            <div style={{ marginBottom: '0.5rem', whiteSpace: 'pre-wrap' }}>
              {introLines.join('\n')}
            </div>
          )}
          <div className="table-wrapper">
            <table className="cams-table">
              <thead>
                <tr>
                  {headerCells.map((h, i) => <th key={i}>{h}</th>)}
                </tr>
              </thead>
              <tbody>
                {dataRows.map((row, rIdx) => (
                  <tr key={rIdx}>
                    {row.map((cell, cIdx) => <td key={cIdx}>{cell}</td>)}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          {outroLines.length > 0 && (
            <div style={{ marginTop: '0.5rem', fontSize: '0.8rem', color: '#64748b' }}>
              {outroLines.join('\n')}
            </div>
          )}
        </div>
      );
    }

    return <div style={{ whiteSpace: 'pre-wrap' }}>{content}</div>;
  };

  return (
    <div className="message-wrapper">
      <div className={`message-avatar ${isUser ? 'avatar-user' : 'avatar-assistant'}`}>
        {isUser ? <User size={16} /> : <Bot size={16} />}
      </div>
      <div className="message-body">
        <div className="message-meta">
          <span className="message-sender">{isUser ? 'You' : 'CAMS Assistant'}</span>
          <span className="message-time">
            {message.created_at ? new Date(message.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : ''}
          </span>
        </div>

        <div className={`message-bubble ${isUser ? 'bubble-user' : 'bubble-assistant'}`}>
          {renderFormattedContent(message.content)}
        </div>

        {!isUser && message.metadata && (
          <div className="query-meta-bar">
            {message.metadata.domain && (
              <span className="meta-chip" style={{ display: 'inline-flex', alignItems: 'center', gap: '3px' }}>
                <Tag size={10} /> Domain: {message.metadata.domain}
              </span>
            )}
            {message.metadata.data && (
              <span className="meta-chip" style={{ display: 'inline-flex', alignItems: 'center', gap: '3px' }}>
                <Database size={10} /> {message.metadata.data.length} records
              </span>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
