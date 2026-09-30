import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Search, Sparkles, X, ChevronRight } from 'lucide-react';

const API_BASE = import.meta.env.VITE_API_BASE_URL || '/api/v1';

export default function CoursesModule({ onAskAI, currentUser }) {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [semesterFilter, setSemesterFilter] = useState('ALL');
  const [selectedCourse, setSelectedCourse] = useState(null);

  useEffect(() => {
    fetchCourses();
  }, []);

  const fetchCourses = async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await axios.post(`${API_BASE}/data/query`, {
        domain: 'courses',
        intent: 'list_courses',
        entities: {},
        requested_output: 'table'
      });
      setCourses(res.data.data || []);
    } catch (err) {
      console.error('Failed to load courses:', err);
      setError('Unable to fetch courses directly from PostgreSQL.');
    } finally {
      setLoading(false);
    }
  };

  const filteredCourses = courses.filter((c) => {
    const matchesSearch = 
      (c.name && c.name.toLowerCase().includes(searchTerm.toLowerCase())) ||
      (c.code && c.code.toLowerCase().includes(searchTerm.toLowerCase())) ||
      (c.degree_name && c.degree_name.toLowerCase().includes(searchTerm.toLowerCase()));
    
    const matchesSemester = semesterFilter === 'ALL' || String(c.semester) === semesterFilter;
    return matchesSearch && matchesSemester;
  });

  return (
    <div className="courses-page-wrapper" role="region" aria-label="Courses Catalog">
      {/* 1. Page Header */}
      <div className="editorial-page-header">
        <h1 className="page-title-royal">Courses & Curriculum</h1>
        <p className="editorial-subtitle">
          Browse academic courses, credit allocations, and semester curriculum structure.
        </p>
        <div className="editorial-metadata-row">
          <span>{courses.length} Curriculum Courses Registered</span>
          <span className="editorial-metadata-dot">•</span>
          <span>Degree Programs</span>
          <span className="editorial-metadata-dot">•</span>
          <span>College Academic Management</span>
        </div>
      </div>

      {/* 2. Controls & Search Bar */}
      <div className="editorial-table-container">
        <div className="editorial-table-header-bar" style={{ flexWrap: 'wrap', gap: '0.75rem' }}>
          <div style={{ display: 'flex', gap: '0.75rem', alignItems: 'center', flex: 1, maxWidth: '480px' }}>
            <div style={{ position: 'relative', width: '100%' }}>
              <input
                type="text"
                placeholder="Search course code, title, or degree..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="cams-input"
                style={{ width: '100%', paddingLeft: '2rem' }}
              />
              <Search size={14} style={{ position: 'absolute', left: '0.65rem', top: '50%', transform: 'translateY(-50%)', color: 'var(--text-secondary)' }} />
            </div>

            <select
              value={semesterFilter}
              onChange={(e) => setSemesterFilter(e.target.value)}
              className="cams-input"
            >
              <option value="ALL">All Semesters</option>
              <option value="1">Semester 1</option>
              <option value="2">Semester 2</option>
              <option value="3">Semester 3</option>
              <option value="4">Semester 4</option>
            </select>
          </div>

          <button 
            className="btn-primary"
            onClick={() => onAskAI('List all courses with credit distribution across all semesters')}
          >
            <Sparkles size={14} />
            <span>Curriculum Intelligence</span>
          </button>
        </div>

        {/* 3. Courses Catalog Table */}
        <table className="cams-data-table">
          <thead>
            <tr>
              <th>Course Code</th>
              <th>Course Title</th>
              <th>Credits</th>
              <th>Semester</th>
              <th>Program</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={6} style={{ textAlign: 'center', padding: '2rem', color: 'var(--text-secondary)' }}>
                  Loading academic catalog from PostgreSQL...
                </td>
              </tr>
            ) : filteredCourses.length === 0 ? (
              <tr>
                <td colSpan={6} style={{ textAlign: 'center', padding: '2rem', color: 'var(--text-secondary)' }}>
                  No courses matching the selected filters.
                </td>
              </tr>
            ) : (
              filteredCourses.map((c, idx) => (
                <tr 
                  key={c.code || idx}
                  onClick={() => setSelectedCourse(c)}
                  style={{ cursor: 'pointer' }}
                >
                  <td style={{ fontFamily: 'var(--font-mono)', fontWeight: 700, color: 'var(--color-primary-royal)' }}>
                    {c.code}
                  </td>
                  <td style={{ fontWeight: 600, color: 'var(--text-primary)' }}>
                    {c.name}
                  </td>
                  <td>
                    <span className="cams-badge badge-royal">{c.credits} Credits</span>
                  </td>
                  <td>Semester {c.semester}</td>
                  <td>{c.degree_name || 'B.A. LL.B.'}</td>
                  <td>
                    <button 
                      className="btn-secondary" 
                      style={{ padding: '0.25rem 0.6rem', fontSize: '0.74rem' }}
                      onClick={(e) => {
                        e.stopPropagation();
                        setSelectedCourse(c);
                      }}
                    >
                      <span>Overview</span>
                      <ChevronRight size={12} />
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* 4. Slide-over Detail Drawer */}
      {selectedCourse && (
        <div className="cams-drawer-overlay" onClick={() => setSelectedCourse(null)}>
          <div className="cams-drawer-card" onClick={(e) => e.stopPropagation()}>
            <div className="drawer-header">
              <div>
                <h3 className="drawer-title">{selectedCourse.name}</h3>
                <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginTop: '2px', fontFamily: 'var(--font-mono)' }}>
                  Code: {selectedCourse.code}
                </div>
              </div>
              <button 
                onClick={() => setSelectedCourse(null)}
                style={{ background: 'transparent', border: 'none', cursor: 'pointer', color: 'var(--text-secondary)' }}
              >
                <X size={18} />
              </button>
            </div>

            <div className="drawer-body">
              <div style={{ background: 'var(--color-soft-blue)', padding: '1rem', borderRadius: 'var(--radius-md)', border: '1px solid var(--color-light-blue)' }}>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem', fontSize: '0.8rem' }}>
                  <div>
                    <span style={{ color: 'var(--text-secondary)' }}>Semester:</span>
                    <strong style={{ display: 'block', color: 'var(--color-dark-navy)' }}>Sem {selectedCourse.semester}</strong>
                  </div>
                  <div>
                    <span style={{ color: 'var(--text-secondary)' }}>Credits:</span>
                    <strong style={{ display: 'block', color: 'var(--color-dark-navy)' }}>{selectedCourse.credits} Credits</strong>
                  </div>
                  <div>
                    <span style={{ color: 'var(--text-secondary)' }}>Degree Program:</span>
                    <strong style={{ display: 'block', color: 'var(--color-dark-navy)' }}>{selectedCourse.degree_name || 'B.A. LL.B.'}</strong>
                  </div>
                  <div>
                    <span style={{ color: 'var(--text-secondary)' }}>Academic Department:</span>
                    <strong style={{ display: 'block', color: 'var(--color-dark-navy)' }}>Faculty of Law</strong>
                  </div>
                </div>
              </div>

              <div>
                <h4 style={{ fontSize: '0.84rem', fontWeight: 700, color: 'var(--color-dark-navy)', marginBottom: '0.65rem' }}>
                  AI Academic Intelligence
                </h4>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                  <button 
                    className="btn-primary"
                    onClick={() => {
                      onAskAI(`Show syllabus, timetable, and allocated faculty for course ${selectedCourse.code} (${selectedCourse.name})`);
                      setSelectedCourse(null);
                    }}
                  >
                    <Sparkles size={14} />
                    <span>Inquire Timetable & Faculty</span>
                  </button>
                  <button 
                    className="btn-secondary"
                    onClick={() => {
                      onAskAI(`What is the average student attendance in ${selectedCourse.name} (${selectedCourse.code})?`);
                      setSelectedCourse(null);
                    }}
                  >
                    <span>Analyze Course Attendance</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
