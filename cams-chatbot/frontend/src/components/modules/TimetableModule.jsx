import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Sparkles } from 'lucide-react';

const API_BASE = import.meta.env.VITE_API_BASE_URL || '/api/v1';
const WEEKDAYS = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'];

export default function TimetableModule({ onAskAI, currentUser }) {
  const [timetable, setTimetable] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedDay, setSelectedDay] = useState('MONDAY');
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    fetchTimetable();
  }, []);

  const fetchTimetable = async () => {
    setLoading(true);
    try {
      const res = await axios.post(`${API_BASE}/data/query`, {
        domain: 'timetable',
        intent: 'weekly_schedule',
        entities: {},
        requested_output: 'table'
      });
      setTimetable(res.data.data || []);
    } catch (err) {
      console.error('Failed to load timetable:', err);
    } finally {
      setLoading(false);
    }
  };

  const daySchedule = timetable.filter((t) => {
    const matchesDay = t.weekday?.toUpperCase() === selectedDay || t.day_of_week?.toUpperCase() === selectedDay;
    const matchesSearch = !searchTerm || 
      (t.subject_name && t.subject_name.toLowerCase().includes(searchTerm.toLowerCase())) ||
      (t.faculty_name && t.faculty_name.toLowerCase().includes(searchTerm.toLowerCase())) ||
      (t.room && t.room.toLowerCase().includes(searchTerm.toLowerCase()));
    return matchesDay && matchesSearch;
  });

  return (
    <div className="timetable-page-wrapper" role="region" aria-label="Academic Schedule">
      {/* 1. Header */}
      <div className="editorial-page-header">
        <h1 className="page-title-royal">Academic Timetable</h1>
        <p className="editorial-subtitle">
          Weekly lecture hours, faculty assignments, and allocated classroom locations.
        </p>
        <div className="editorial-metadata-row">
          <span>Weekly Period Slots: {timetable.length}</span>
          <span className="editorial-metadata-dot">•</span>
          <span>Semester Academic Schedule</span>
          <span className="editorial-metadata-dot">•</span>
          <span>CAS Law College</span>
        </div>
      </div>

      {/* 2. Weekday Tab Selector */}
      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.75rem' }}>
        {WEEKDAYS.map((day) => (
          <button
            key={day}
            onClick={() => setSelectedDay(day)}
            className={`btn-secondary ${selectedDay === day ? 'active' : ''}`}
            style={{
              backgroundColor: selectedDay === day ? 'var(--color-primary-royal)' : 'var(--bg-card)',
              color: selectedDay === day ? '#FFFFFF' : 'var(--color-primary-royal)',
              borderColor: selectedDay === day ? 'var(--color-primary-royal)' : 'var(--border-color)',
              fontWeight: 600,
              fontSize: '0.8rem'
            }}
          >
            {day.charAt(0) + day.slice(1).toLowerCase()}
          </button>
        ))}

        <div style={{ marginLeft: 'auto' }}>
          <button 
            className="btn-primary"
            onClick={() => onAskAI("Show today's complete lecture timetable and faculty locations")}
          >
            <Sparkles size={14} />
            <span>Today's Schedule Query</span>
          </button>
        </div>
      </div>

      {/* 3. Schedule Blocks Grid */}
      <div className="editorial-table-container">
        <div className="editorial-table-header-bar">
          <div className="editorial-table-title">
            {selectedDay.charAt(0) + selectedDay.slice(1).toLowerCase()} Lectures & Practical Sessions
          </div>
          <div style={{ fontSize: '0.78rem', color: 'var(--text-secondary)' }}>
            {daySchedule.length} Scheduled Periods
          </div>
        </div>

        <div style={{ padding: '1.25rem 1.5rem' }}>
          {loading ? (
            <div style={{ padding: '2rem', textAlign: 'center', color: 'var(--text-secondary)' }}>
              Loading schedule from PostgreSQL...
            </div>
          ) : daySchedule.length === 0 ? (
            <div style={{ padding: '2.5rem', textAlign: 'center', color: 'var(--text-secondary)', fontSize: '0.86rem' }}>
              No classes scheduled for {selectedDay.toLowerCase()}.
            </div>
          ) : (
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: '1rem' }}>
              {daySchedule.map((slot, idx) => (
                <div 
                  key={idx}
                  style={{
                    background: 'var(--bg-main)',
                    border: '1px solid var(--border-color)',
                    borderRadius: 'var(--radius-md)',
                    padding: '1.1rem',
                    display: 'flex',
                    flexDirection: 'column',
                    justifyContent: 'space-between',
                    gap: '0.75rem',
                    transition: 'border-color 0.15s ease'
                  }}
                >
                  <div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.35rem' }}>
                      <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.74rem', fontWeight: 700, color: 'var(--color-primary-royal)' }}>
                        {slot.start_time ? `${slot.start_time} - ${slot.end_time}` : `Period ${idx + 1}`}
                      </span>
                      {slot.room && (
                        <span className="cams-badge badge-royal">Room {slot.room}</span>
                      )}
                    </div>
                    <div style={{ fontSize: '0.92rem', fontWeight: 700, color: 'var(--color-dark-navy)' }}>
                      {slot.subject_name || slot.course_name || 'Law Course'}
                    </div>
                    <div style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', marginTop: '2px' }}>
                      {slot.faculty_name || 'Prof. Faculty Member'}
                    </div>
                  </div>

                  <div style={{ borderTop: '1px solid var(--border-color)', paddingTop: '0.5rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: '0.72rem', color: 'var(--text-secondary)' }}>
                    <span>{slot.section_name || 'Section A'}</span>
                    <button 
                      style={{ background: 'transparent', border: 'none', color: 'var(--color-primary-royal)', fontWeight: 600, cursor: 'pointer' }}
                      onClick={() => onAskAI(`What is the curriculum and upcoming topics for ${slot.subject_name || 'this course'}?`)}
                    >
                      Inquire Details →
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
