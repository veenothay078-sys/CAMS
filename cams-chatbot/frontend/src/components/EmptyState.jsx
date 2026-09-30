import React from 'react';
import { Sparkles } from 'lucide-react';

const SUGGESTED_PROMPTS = [
  "Show today's timetable",
  "Students below 75% attendance",
  "Average marks by subject",
  "Show all courses",
  "List all faculty members and designations",
  "Attendance distribution barchart"
];

export default function EmptyState({ onSelectPrompt }) {
  return (
    <div className="ai-empty-state-editorial" role="region" aria-label="CAMS Intelligence">
      <div style={{ display: 'flex', alignItems: 'center', gap: '0.65rem', marginBottom: '0.35rem' }}>
        <div style={{ width: '32px', height: '32px', borderRadius: '8px', backgroundColor: 'var(--color-soft-blue)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--color-primary-royal)' }}>
          <Sparkles size={18} />
        </div>
        <h1 className="ai-empty-title">CAMS Intelligence</h1>
      </div>
      <p className="ai-empty-subtitle">
        Ask questions about students, courses, attendance, schedules and academic records.
      </p>

      <div className="ai-prompt-list">
        <div style={{ fontSize: '0.74rem', fontWeight: 700, color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: '0.25rem' }}>
          Suggested Inquiries
        </div>
        {SUGGESTED_PROMPTS.map((prompt, idx) => (
          <button
            key={idx}
            className="ai-prompt-link-row"
            onClick={() => onSelectPrompt(prompt)}
            type="button"
          >
            <span>{prompt}</span>
            <span className="ai-prompt-arrow">→</span>
          </button>
        ))}
      </div>
    </div>
  );
}
