import React from 'react';
import { User, Bot, AlertCircle, HelpCircle, Database, Tag, Calculator, BarChart2, RefreshCw } from 'lucide-react';
import ChartRenderer from './ChartRenderer';

export default function MessageItem({ message, onRetry }) {
  const isUser = message.role === 'USER';
  const chartData = message.metadata?.chart || message.chart;
  const calcData = message.metadata?.calculation || message.calculation;
  const responseType = message.metadata?.response_type;
  const isError = responseType === 'error' || message.content?.startsWith('Error:');
  const isClarification = responseType === 'clarification';

  // Helper to parse markdown table if present
  const renderFormattedContent = (content) => {
    if (!content) return null;
    if (!content.includes('|')) {
      return <div className="message-text-block">{content}</div>;
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
            <div className="table-intro-text">{introLines.join('\n')}</div>
          )}
          <div className="table-wrapper" tabIndex={0} role="region" aria-label="Query results table">
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
            <div className="table-outro-text">{outroLines.join('\n')}</div>
          )}
        </div>
      );
    }

    return <div className="message-text-block">{content}</div>;
  };

  return (
    <div className={`message-wrapper ${isUser ? 'message-user' : 'message-asst'}`}>
      <div 
        className={`message-avatar ${isUser ? 'avatar-user' : isError ? 'avatar-error' : isClarification ? 'avatar-clarify' : 'avatar-assistant'}`}
        aria-hidden="true"
      >
        {isUser ? (
          <User size={16} />
        ) : isError ? (
          <AlertCircle size={16} />
        ) : isClarification ? (
          <HelpCircle size={16} />
        ) : (
          <Bot size={16} />
        )}
      </div>

      <div className="message-body">
        <div className="message-meta">
          <span className="message-sender">
            {isUser ? 'You' : isClarification ? 'CAMS Assistant (Clarification Needed)' : 'CAMS Assistant'}
          </span>
          <span className="message-time">
            {message.created_at ? new Date(message.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : ''}
          </span>
        </div>

        <div className={`message-bubble ${isUser ? 'bubble-user' : isError ? 'bubble-error' : isClarification ? 'bubble-clarify' : 'bubble-assistant'}`}>
          {renderFormattedContent(message.content)}

          {/* Render Calculation Card if present */}
          {!isUser && calcData && (
            <div className="calculation-badge-card" aria-label="Computed calculation result">
              <div className="calc-header">
                <Calculator size={14} aria-hidden="true" />
                <span>Computed: {calcData.operation ? calcData.operation.toUpperCase() : 'CALCULATION'}</span>
              </div>
              <div className="calc-value">
                {typeof calcData.result === 'number' ? calcData.result.toLocaleString() : String(calcData.result)}
              </div>
            </div>
          )}

          {/* Render Chart if response is chart type or chart data is attached */}
          {!isUser && chartData && (
            <div className="message-chart-wrapper">
              <ChartRenderer chart={chartData} />
            </div>
          )}

          {/* Retry Button if Error */}
          {isError && message.lastQuery && (
            <button 
              className="message-retry-btn"
              onClick={onRetry}
              aria-label="Retry query"
            >
              <RefreshCw size={13} />
              <span>Retry Query</span>
            </button>
          )}
        </div>

        {!isUser && message.metadata && !isError && (
          <div className="query-meta-bar" aria-label="Query metadata">
            {responseType && (
              <span className="meta-chip">
                {responseType === 'chart' ? <BarChart2 size={11} aria-hidden="true" /> : <Tag size={11} aria-hidden="true" />}
                Type: {responseType}
              </span>
            )}
            {message.metadata.domain && (
              <span className="meta-chip">
                <Tag size={11} aria-hidden="true" /> Domain: {message.metadata.domain}
              </span>
            )}
            {message.metadata.data && Array.isArray(message.metadata.data) && (
              <span className="meta-chip">
                <Database size={11} aria-hidden="true" /> {message.metadata.data.length} records
              </span>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
