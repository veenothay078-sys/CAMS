import React from 'react';
import { School, UserCheck, Award, Calendar, BookOpen, Clock, AlertCircle } from 'lucide-react';

const SUGGESTIONS = [
  {
    icon: School,
    title: 'Student Profiles',
    prompt: 'Show student academic profile and roll numbers',
    domain: 'student'
  },
  {
    icon: UserCheck,
    title: 'Attendance Records',
    prompt: 'Show recent attendance records and status',
    domain: 'attendance'
  },
  {
    icon: Award,
    title: 'Internal Marks',
    prompt: 'Show internal examination marks and scores',
    domain: 'marks'
  },
  {
    icon: BookOpen,
    title: 'Course Catalog',
    prompt: 'List courses offered across semesters',
    domain: 'courses'
  },
  {
    icon: Clock,
    title: 'Class Timetable',
    prompt: 'What is the weekly schedule and classroom timetable?',
    domain: 'timetable'
  },
  {
    icon: AlertCircle,
    title: 'Campus Notices',
    prompt: 'Show published official college notices',
    domain: 'notices'
  }
];

export default function EmptyState({ onSelectPrompt }) {
  return (
    <div className="empty-state">
      <div className="empty-icon">
        <School size={24} />
      </div>
      <h2 className="empty-title">CAMS AI Information System</h2>
      <p className="empty-desc">
        Ask natural-language questions directly over the College Academic Management System database.
        Queries are securely evaluated and executed through the Safe Query Layer.
      </p>

      <div className="domain-grid">
        {SUGGESTIONS.map((s, idx) => {
          const Icon = s.icon;
          return (
            <div
              key={idx}
              className="domain-card"
              onClick={() => onSelectPrompt(s.prompt)}
              id={`empty-card-${s.domain}`}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                <Icon size={14} color="#1e3a8a" />
                <div className="domain-card-title">{s.title}</div>
              </div>
              <div className="domain-card-prompt">{s.prompt}</div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
