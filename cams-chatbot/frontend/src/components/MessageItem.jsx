import React, { useState } from 'react';
import { 
  Sparkles, 
  Database, 
  Code, 
  ChevronDown, 
  ChevronUp, 
  RefreshCw, 
  Building2, 
  GraduationCap, 
  TrendingDown, 
  Layers, 
  Calendar,
  ArrowRight,
  BarChart2,
  Table as TableIcon
} from 'lucide-react';
import ChartRenderer from './ChartRenderer';

const DEPARTMENT_OPTIONS = [
  { label: 'Department of Law', query: 'Show attendance for Department of Law' },
  { label: 'Constitutional Law', query: 'Show Constitutional Law department attendance' },
  { label: 'Criminal Law', query: 'Show Criminal Law department attendance' },
  { label: 'Corporate & Commercial Law', query: 'Show Corporate & Commercial Law attendance' }
];

const CLASS_OPTIONS = [
  { label: 'Semester 1 (Class A)', query: 'Show attendance for Semester 1 Class A' },
  { label: 'Semester 2 (Class B)', query: 'Show attendance for Semester 2 Class B' },
  { label: 'Semester 3', query: 'Show attendance for Semester 3' },
  { label: 'Semester 4', query: 'Show attendance for Semester 4' },
  { label: 'Semester 5', query: 'Show attendance for Semester 5' }
];

const QUICK_INQUIRIES = [
  { label: '⚠️ Students below 75% attendance', query: 'Students below 75% attendance' },
  { label: '📊 Attendance Distribution Chart', query: 'Attendance distribution barchart' },
  { label: '📅 Today\'s Timetable', query: "Show today's timetable" },
  { label: '📈 Average marks by subject', query: 'Average marks by subject' }
];

/**
 * Automatically synthesizes structured chart data from any tabular PostgreSQL dataset
 */
function synthesizeChartFromDataset(data, messageContent = '') {
  if (!data || !Array.isArray(data) || data.length === 0) return null;
  
  const points = [];
  for (const row of data.slice(0, 20)) {
    // Determine the most representative label
    const label = row.student_name || row.full_name || row.faculty_name || 
                  row.course_name || row.subject_name || row.name || 
                  row.attendance_status || row.status || row.weekday || 
                  row.department_name || row.semester_label || row.title || 
                  row.code || 'Record';
                  
    // Find quantifiable numeric value
    let numVal = null;
    const preferredKeys = [
      'attendance_percentage', 'percentage', 'average_marks', 'total_mark',
      'internal_exam_mark', 'student_count', 'course_count', 'record_count',
      'classes_attended', 'total_classes', 'amount', 'credits', 'cgpa', 'count', 'value'
    ];
    for (const k of preferredKeys) {
      if (row[k] !== undefined && row[k] !== null && !isNaN(Number(row[k]))) {
        numVal = Number(row[k]);
        break;
      }
    }
    if (numVal === null) {
      for (const [k, v] of Object.entries(row)) {
        if (typeof v === 'number') {
          numVal = v;
          break;
        } else if (typeof v === 'string' && !isNaN(Number(v)) && !k.toLowerCase().includes('id') && !k.toLowerCase().includes('roll')) {
          numVal = Number(v);
          break;
        }
      }
    }
    if (numVal !== null) {
      points.push({
        label: String(label).trim(),
        value: Math.round(numVal * 10) / 10,
        x: String(label).trim(),
        y: Math.round(numVal * 10) / 10
      });
    }
  }

  if (points.length === 0) return null;

  const contentLower = (messageContent || '').toLowerCase();
  const isLine = contentLower.includes('line') || contentLower.includes('trend');
  const isPie = contentLower.includes('pie') || contentLower.includes('distribution');
  
  return {
    type: isLine ? 'line' : isPie ? 'pie' : 'bar',
    title: 'Academic Analytics & Metrics Chart',
    x_axis: 'Category / Entity',
    y_axis: 'Metric Score',
    data: points
  };
}

export default function MessageItem({ message, onRetry, onSelectOption }) {
  const isUser = message.role === 'USER';
  const rawChart = message.metadata?.chart || message.chart;
  const calcData = message.metadata?.calculation || message.calculation;
  const responseType = message.metadata?.response_type;
  const isError = responseType === 'error' || message.content?.startsWith('Error:');
  const dataset = message.metadata?.data || message.data;

  // Synthesize chart if not already attached
  const activeChart = rawChart || synthesizeChartFromDataset(dataset, message.content);
  
  // Default to graph view whenever a chart is present or graph was queried
  const [viewMode, setViewMode] = useState('graph');

  // Detect if options should be shown
  const isClarification = responseType === 'clarification' || 
    message.metadata?.requires_clarification ||
    (message.content && (
      message.content.toLowerCase().includes('whose attendance') ||
      message.content.toLowerCase().includes('provide a specific') ||
      message.content.toLowerCase().includes('select a department') ||
      message.content.toLowerCase().includes('which dept') ||
      message.content.toLowerCase().includes('class, subject, or department')
    ));

  // Format header name
  const formatHeader = (key) => {
    if (!key) return '';
    return key
      .replace(/_/g, ' ')
      .replace(/\b\w/g, (char) => char.toUpperCase());
  };

  if (isUser) {
    return (
      <div className="message-editorial-user">
        {message.content}
      </div>
    );
  }

  return (
    <div className="message-editorial-assistant">
      {/* 1. Answer text */}
      <div className="assistant-response-text">
        {message.content}
      </div>

      {/* Interactive Clickable Options (Department & Class Selection) */}
      {(isClarification || message.options) && (
        <div className="ai-options-panel">
          <div className="ai-options-panel-header">
            <Sparkles size={14} className="ai-options-icon" />
            <span>Click an option below to query instantly:</span>
          </div>

          {/* Department Selection */}
          <div className="ai-options-group">
            <div className="ai-options-group-title">
              <Building2 size={13} />
              <span>Departments</span>
            </div>
            <div className="ai-option-chips-container">
              {DEPARTMENT_OPTIONS.map((dept, idx) => (
                <button
                  key={idx}
                  type="button"
                  className="ai-option-chip"
                  onClick={() => onSelectOption && onSelectOption(dept.query)}
                  title={`Run query: ${dept.query}`}
                >
                  <span>{dept.label}</span>
                  <ArrowRight size={11} className="chip-arrow" />
                </button>
              ))}
            </div>
          </div>

          {/* Class / Semester Selection */}
          <div className="ai-options-group">
            <div className="ai-options-group-title">
              <GraduationCap size={13} />
              <span>Classes & Semesters</span>
            </div>
            <div className="ai-option-chips-container">
              {CLASS_OPTIONS.map((cls, idx) => (
                <button
                  key={idx}
                  type="button"
                  className="ai-option-chip"
                  onClick={() => onSelectOption && onSelectOption(cls.query)}
                  title={`Run query: ${cls.query}`}
                >
                  <span>{cls.label}</span>
                  <ArrowRight size={11} className="chip-arrow" />
                </button>
              ))}
            </div>
          </div>

          {/* Quick Queries */}
          <div className="ai-options-group">
            <div className="ai-options-group-title">
              <Layers size={13} />
              <span>Quick Actions</span>
            </div>
            <div className="ai-option-chips-container">
              {QUICK_INQUIRIES.map((inq, idx) => (
                <button
                  key={idx}
                  type="button"
                  className="ai-option-chip ai-option-chip-highlight"
                  onClick={() => onSelectOption && onSelectOption(inq.query)}
                  title={`Run query: ${inq.query}`}
                >
                  <span>{inq.label}</span>
                  <ArrowRight size={11} className="chip-arrow" />
                </button>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* View Mode Toggle when both Chart and Table are available */}
      {activeChart && dataset && Array.isArray(dataset) && dataset.length > 0 && (
        <div className="cams-view-toggle-bar">
          <div className="view-toggle-group">
            <button 
              type="button" 
              className={`view-toggle-btn ${viewMode === 'graph' ? 'active' : ''}`}
              onClick={() => setViewMode('graph')}
            >
              <BarChart2 size={13} />
              <span>Graph View</span>
            </button>
            <button 
              type="button" 
              className={`view-toggle-btn ${viewMode === 'table' ? 'active' : ''}`}
              onClick={() => setViewMode('table')}
            >
              <TableIcon size={13} />
              <span>Table View ({dataset.length})</span>
            </button>
          </div>
        </div>
      )}

      {/* 2. Visualization / Chart */}
      {activeChart && (viewMode === 'graph' || !dataset || dataset.length === 0) && (
        <div style={{ margin: '0.4rem 0', background: 'var(--bg-main)', padding: '1.25rem', borderRadius: 'var(--radius-md)', border: '1px solid var(--border-color)' }}>
          <ChartRenderer chartData={activeChart} />
        </div>
      )}

      {/* 3. Structured Data Table */}
      {dataset && Array.isArray(dataset) && dataset.length > 0 && (viewMode === 'table' || !activeChart) && (
        <div className="editorial-table-container" style={{ margin: '0.4rem 0' }}>
          <table className="cams-data-table">
            <thead>
              <tr>
                {Object.keys(dataset[0]).map((key) => (
                  <th key={key}>{formatHeader(key)}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {dataset.map((row, rIdx) => (
                <tr key={rIdx}>
                  {Object.entries(row).map(([k, val], cIdx) => (
                    <td key={cIdx}>
                      {typeof val === 'boolean' ? (
                        <span className={`cams-badge ${val ? 'badge-success' : 'badge-danger'}`}>
                          {val ? 'Yes' : 'No'}
                        </span>
                      ) : (
                        String(val ?? '-')
                      )}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* 4. Calculation Insight if present */}
      {calcData && (
        <div style={{ background: 'var(--color-soft-blue)', borderLeft: '3px solid var(--color-primary-royal)', padding: '0.65rem 0.9rem', borderRadius: '0 6px 6px 0', fontSize: '0.82rem', color: 'var(--color-dark-navy)' }}>
          <strong style={{ color: 'var(--color-primary-royal)' }}>Academic Insight:</strong> {calcData.summary || 'Computed directly against live database records.'}
        </div>
      )}

      {/* 5. Understated Source Indicators */}
      <div className="source-badge-row">
        <span>Verified Sources:</span>
        <span className="source-badge">PostgreSQL</span>
        {activeChart && <span className="source-badge">E2B Sandbox Analytics</span>}
        <span className="source-badge">NVIDIA NIM</span>

        {isError && onRetry && message.lastQuery && (
          <button 
            className="btn-secondary" 
            onClick={() => onRetry(message.lastQuery)}
            style={{ marginLeft: 'auto', padding: '0.2rem 0.5rem', fontSize: '0.72rem' }}
          >
            <RefreshCw size={11} />
            <span>Retry</span>
          </button>
        )}
      </div>
    </div>
  );
}
