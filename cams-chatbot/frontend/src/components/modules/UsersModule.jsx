import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Search, Sparkles, User, Shield, GraduationCap } from 'lucide-react';

const API_BASE = import.meta.env.VITE_API_BASE_URL || '/api/v1';

export default function UsersModule({ onAskAI, currentUser }) {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [roleFilter, setRoleFilter] = useState('STUDENT');

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    setLoading(true);
    try {
      const res = await axios.get(`${API_BASE}/auth/demo-users`);
      setUsers(res.data || []);
    } catch (err) {
      console.error('Failed to load users:', err);
    } finally {
      setLoading(false);
    }
  };

  const filteredUsers = users.filter((u) => {
    const matchesSearch = 
      (u.full_name && u.full_name.toLowerCase().includes(searchTerm.toLowerCase())) ||
      (u.email && u.email.toLowerCase().includes(searchTerm.toLowerCase())) ||
      (u.id && u.id.toLowerCase().includes(searchTerm.toLowerCase()));
    
    const matchesRole = roleFilter === 'ALL' || u.role?.toUpperCase() === roleFilter;
    return matchesSearch && matchesRole;
  });

  return (
    <div className="users-page-wrapper" role="region" aria-label="Student Directory">
      {/* 1. Header */}
      <div className="editorial-page-header">
        <h1 className="page-title-royal">Students & Academic Directory</h1>
        <p className="editorial-subtitle">
          Institutional directory of verified students, faculty members, and administrators.
        </p>
        <div className="editorial-metadata-row">
          <span>{users.length} Total Registered Accounts</span>
          <span className="editorial-metadata-dot">•</span>
          <span>Role-Based Access Control Active</span>
          <span className="editorial-metadata-dot">•</span>
          <span>PostgreSQL Grounded</span>
        </div>
      </div>

      {/* 2. Controls & Search Bar */}
      <div className="editorial-table-container">
        <div className="editorial-table-header-bar" style={{ flexWrap: 'wrap', gap: '0.75rem' }}>
          <div style={{ display: 'flex', gap: '0.75rem', alignItems: 'center', flex: 1, maxWidth: '480px' }}>
            <div style={{ position: 'relative', width: '100%' }}>
              <input
                type="text"
                placeholder="Search by student name, ID, or email..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="cams-input"
                style={{ width: '100%', paddingLeft: '2rem' }}
              />
              <Search size={14} style={{ position: 'absolute', left: '0.65rem', top: '50%', transform: 'translateY(-50%)', color: 'var(--text-secondary)' }} />
            </div>

            <select
              value={roleFilter}
              onChange={(e) => setRoleFilter(e.target.value)}
              className="cams-input"
            >
              <option value="ALL">All Roles</option>
              <option value="STUDENT">Students</option>
              <option value="FACULTY">Faculty</option>
              <option value="ADMIN">Administrators</option>
            </select>
          </div>

          <button 
            className="btn-primary"
            onClick={() => onAskAI(roleFilter === 'FACULTY' ? 'List all faculty and allocated subjects' : 'Show all students with attendance summary')}
          >
            <Sparkles size={14} />
            <span>Query Directory AI</span>
          </button>
        </div>

        {/* 3. Directory Table */}
        <table className="cams-data-table">
          <thead>
            <tr>
              <th>User / Student</th>
              <th>System ID</th>
              <th>Email Address</th>
              <th>Institutional Role</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={6} style={{ textAlign: 'center', padding: '2rem', color: 'var(--text-secondary)' }}>
                  Loading institutional records from PostgreSQL...
                </td>
              </tr>
            ) : filteredUsers.length === 0 ? (
              <tr>
                <td colSpan={6} style={{ textAlign: 'center', padding: '2rem', color: 'var(--text-secondary)' }}>
                  No directory records matching the selected search criteria.
                </td>
              </tr>
            ) : (
              filteredUsers.map((u, idx) => {
                const initials = u.full_name 
                  ? u.full_name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
                  : 'US';
                return (
                  <tr key={u.id || idx}>
                    <td>
                      <span className="user-initials-badge">{initials}</span>
                      <strong style={{ color: 'var(--text-primary)' }}>{u.full_name}</strong>
                    </td>
                    <td style={{ fontFamily: 'var(--font-mono)', fontSize: '0.78rem' }}>{u.id}</td>
                    <td style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>{u.email}</td>
                    <td>
                      <span className={`cams-badge ${u.role === 'ADMIN' ? 'badge-warning' : u.role === 'FACULTY' ? 'badge-royal' : 'badge-neutral'}`}>
                        {u.role}
                      </span>
                    </td>
                    <td>
                      <span className="cams-badge badge-success">Active</span>
                    </td>
                    <td>
                      <button 
                        className="btn-secondary"
                        style={{ padding: '0.25rem 0.6rem', fontSize: '0.74rem' }}
                        onClick={() => onAskAI(
                          u.role === 'FACULTY' 
                            ? `What courses and timetable schedule does ${u.full_name} handle?`
                            : `Show academic attendance and record profile for ${u.full_name}`
                        )}
                      >
                        <Sparkles size={11} />
                        <span>Inquire</span>
                      </button>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
