import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Sidebar from './components/Sidebar';
import TopHeader from './components/TopHeader';
import ChatArea from './components/ChatArea';
import OverviewModule from './components/modules/OverviewModule';
import CoursesModule from './components/modules/CoursesModule';
import UsersModule from './components/modules/UsersModule';
import AttendanceModule from './components/modules/AttendanceModule';
import TimetableModule from './components/modules/TimetableModule';
import LeavesModule from './components/modules/LeavesModule';
import NotificationsModule from './components/modules/NotificationsModule';

const API_BASE = import.meta.env.VITE_API_BASE_URL || '/api/v1';
const HEALTH_URL = API_BASE.startsWith('http') 
  ? new URL('/health', API_BASE).origin + '/health'
  : (API_BASE.replace('/api/v1', '') || '') + '/health';

// Setup axios token interceptor
axios.interceptors.request.use((config) => {
  const token = localStorage.getItem('cams_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default function App() {
  const [activeTab, setActiveTab] = useState('overview');
  const [sessions, setSessions] = useState([]);
  const [currentSessionId, setCurrentSessionId] = useState(null);
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [isCollapsed, setIsCollapsed] = useState(false);

  const [dbInfo, setDbInfo] = useState({
    connected: true,
    tablesCount: 122
  });

  const [userProfile, setUserProfile] = useState({
    id: 'usr_admin',
    email: 'admin@gmail.com',
    full_name: 'Administrator',
    role: 'ADMIN'
  });

  const [demoUsers, setDemoUsers] = useState([
    { id: 'usr_admin', email: 'admin@gmail.com', full_name: 'Administrator', role: 'ADMIN' },
    { id: 'usr_faculty', email: 'dinesh@gmail.com', full_name: 'Prof. Dinesh', role: 'FACULTY' },
    { id: 'usr_student', email: 'student1@gmail.com', full_name: 'Arun Kumar', role: 'STUDENT' }
  ]);

  // 1. Initial Load: Check Health, Demo Users & Initialize Auth
  useEffect(() => {
    fetchHealth();
    fetchDemoUsers();
    initAuth();
  }, []);

  // Keyboard shortcut Ctrl+B or Cmd+B to toggle sidebar collapse
  useEffect(() => {
    const handleKeyDown = (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
        e.preventDefault();
        setIsCollapsed((prev) => !prev);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  // 2. Load Messages when Active Session changes
  useEffect(() => {
    if (currentSessionId) {
      fetchMessages(currentSessionId);
    } else {
      setMessages([]);
    }
  }, [currentSessionId]);

  const fetchHealth = async () => {
    try {
      const res = await axios.get(HEALTH_URL);
      setDbInfo({
        connected: res.data.database_connected,
        tablesCount: res.data.database_tables_count
      });
    } catch (err) {
      setDbInfo({ connected: false, tablesCount: 0 });
      console.warn('Health check warning:', err);
    }
  };

  const fetchDemoUsers = async () => {
    try {
      const res = await axios.get(`${API_BASE}/auth/demo-users`);
      if (res.data && res.data.length > 0) {
        setDemoUsers(res.data);
      }
    } catch (err) {
      console.warn('Could not fetch demo users list:', err);
    }
  };

  const initAuth = async () => {
    const savedToken = localStorage.getItem('cams_token');
    if (savedToken) {
      try {
        const res = await axios.get(`${API_BASE}/auth/me`);
        setUserProfile(res.data);
        fetchSessions();
        return;
      } catch (err) {
        console.warn('Stored token invalid or expired, resetting to default demo login.');
        localStorage.removeItem('cams_token');
      }
    }
    // Default login as Admin for seamless initial access
    await handleSwitchUser('admin@gmail.com');
  };

  const handleSwitchUser = async (email) => {
    setLoading(true);
    try {
      const res = await axios.post(`${API_BASE}/auth/demo-token`, { email });
      localStorage.setItem('cams_token', res.data.access_token);
      setUserProfile({
        id: res.data.user_id,
        email: res.data.email,
        full_name: res.data.full_name || email.split('@')[0],
        role: res.data.role
      });
      setError(null);
      await fetchSessions();
    } catch (err) {
      setError(`Failed to switch to user ${email}.`);
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('cams_token');
    setUserProfile({
      id: '',
      email: '',
      full_name: 'Guest User',
      role: 'STUDENT'
    });
    setSessions([]);
    setCurrentSessionId(null);
    setMessages([]);
  };

  const fetchSessions = async () => {
    try {
      const res = await axios.get(`${API_BASE}/chat/sessions`);
      setSessions(res.data);
      if (res.data.length > 0) {
        setCurrentSessionId(res.data[0].id);
      } else {
        setCurrentSessionId(null);
      }
    } catch (err) {
      console.error('Error fetching sessions:', err);
    }
  };

  const fetchMessages = async (sessionId) => {
    try {
      const res = await axios.get(`${API_BASE}/chat/sessions/${sessionId}/messages`);
      setMessages(res.data);
    } catch (err) {
      setError('Could not load session messages.');
    }
  };

  const handleNewSession = async () => {
    try {
      const res = await axios.post(`${API_BASE}/chat/sessions`, {
        title: 'New Conversation'
      });
      setSessions([res.data, ...sessions]);
      setCurrentSessionId(res.data.id);
      setMessages([]);
      setError(null);
      setActiveTab('ai_assistant');
      setSidebarOpen(false);
    } catch (err) {
      setError('Failed to create new conversation session.');
    }
  };

  const handleDeleteSession = async (sessionId) => {
    try {
      await axios.delete(`${API_BASE}/chat/sessions/${sessionId}`);
      const updated = sessions.filter(s => s.id !== sessionId);
      setSessions(updated);
      if (currentSessionId === sessionId) {
        setCurrentSessionId(updated.length > 0 ? updated[0].id : null);
      }
    } catch (err) {
      setError('Could not delete session.');
    }
  };

  const handleSendMessage = async (textToSend) => {
    if (!textToSend.trim()) return;

    setError(null);
    setLoading(true);

    let activeSessionId = currentSessionId;

    // Create session if none exists
    if (!activeSessionId) {
      try {
        const newSessionRes = await axios.post(`${API_BASE}/chat/sessions`, {
          title: textToSend.slice(0, 32)
        });
        activeSessionId = newSessionRes.data.id;
        setSessions([newSessionRes.data, ...sessions]);
        setCurrentSessionId(activeSessionId);
      } catch (err) {
        setError('Failed to initiate conversation session.');
        setLoading(false);
        return;
      }
    }

    // Optimistically add user message to UI
    const tempUserMsg = {
      id: `temp_${Date.now()}`,
      role: 'USER',
      content: textToSend,
      created_at: new Date().toISOString()
    };
    setMessages((prev) => [...prev, tempUserMsg]);
    setInput('');

    try {
      const res = await axios.post(`${API_BASE}/chat`, {
        session_id: activeSessionId,
        message: textToSend
      });

      // Update session title in sidebar if it was a new session
      setSessions(prev => prev.map(s => {
        if (s.id === activeSessionId && s.title === 'New Conversation') {
          return { ...s, title: textToSend.slice(0, 32) };
        }
        return s;
      }));

      const assistantMsg = {
        id: `asst_${Date.now()}`,
        role: 'ASSISTANT',
        content: res.data.message,
        created_at: new Date().toISOString(),
        metadata: {
          response_type: res.data.response_type,
          domain: res.data.domain,
          data: res.data.data,
          chart: res.data.chart,
          calculation: res.data.calculation
        }
      };

      setMessages(prev => [...prev, assistantMsg]);
    } catch (err) {
      const detail = err.response?.data?.detail || err.response?.data?.message || 'Failed to process inquiry with CAMS AI.';
      setError(detail);
      const errorMsg = {
        id: `err_${Date.now()}`,
        role: 'ASSISTANT',
        content: `Error: ${detail}`,
        created_at: new Date().toISOString(),
        metadata: { response_type: 'error' },
        lastQuery: textToSend
      };
      setMessages(prev => [...prev, errorMsg]);
    } finally {
      setLoading(false);
    }
  };

  const handleRetryMessage = (queryText) => {
    if (queryText && !loading) {
      handleSendMessage(queryText);
    }
  };

  const handleAskAI = (promptText) => {
    setActiveTab('ai_assistant');
    handleSendMessage(promptText);
  };

  const currentSession = sessions.find(s => s.id === currentSessionId);

  return (
    <div className={`cams-application-layout ${isCollapsed ? 'sidebar-is-collapsed' : 'sidebar-is-expanded'}`}>
      {/* Mobile Drawer Backdrop */}
      {sidebarOpen && (
        <div 
          className="sidebar-backdrop" 
          onClick={() => setSidebarOpen(false)}
          aria-hidden="true"
        />
      )}

      {/* Left Sidebar (Deep Forest Green: 256px expanded, 72px collapsed) */}
      <Sidebar
        activeTab={activeTab}
        onSelectTab={(tabId) => setActiveTab(tabId)}
        sessions={sessions}
        currentSessionId={currentSessionId}
        onSelectSession={(id) => {
          setCurrentSessionId(id);
          setActiveTab('ai_assistant');
          setSidebarOpen(false);
        }}
        onNewSession={handleNewSession}
        onDeleteSession={handleDeleteSession}
        dbInfo={dbInfo}
        isOpen={sidebarOpen}
        onClose={() => setSidebarOpen(false)}
        isCollapsed={isCollapsed}
        onToggleCollapse={() => setIsCollapsed(!isCollapsed)}
        currentUser={userProfile}
        onLogout={handleLogout}
      />

      {/* Main Workspace (Light/Cool Lavender Tint) */}
      <div className="main-workspace-wrapper">
        {/* Top Header Bar */}
        <TopHeader
          activeTab={activeTab}
          onSelectTab={(tabId) => setActiveTab(tabId)}
          dbInfo={dbInfo}
          userProfile={userProfile}
          demoUsers={demoUsers}
          onSwitchUser={handleSwitchUser}
          onLogout={handleLogout}
          onToggleSidebar={() => setSidebarOpen(!sidebarOpen)}
          isCollapsed={isCollapsed}
          onToggleCollapse={() => setIsCollapsed(!isCollapsed)}
        />

        {/* Workspace Body with subtle fade/slide animation */}
        <main className="workspace-main-content">
          <div key={activeTab} className="cams-page-transition">
            {activeTab === 'overview' && (
              <OverviewModule 
                onAskAI={handleAskAI}
                onSelectTab={setActiveTab}
                currentUser={userProfile}
              />
            )}

            {activeTab === 'ai_assistant' && (
              <ChatArea
                currentSession={currentSession}
                messages={messages}
                input={input}
                setInput={setInput}
                onSendMessage={handleSendMessage}
                onRetry={handleRetryMessage}
                loading={loading}
                error={error}
                onClearError={() => setError(null)}
              />
            )}

            {activeTab === 'courses' && (
              <CoursesModule 
                onAskAI={handleAskAI} 
                currentUser={userProfile}
              />
            )}

            {activeTab === 'users' && (
              <UsersModule 
                onAskAI={handleAskAI} 
                currentUser={userProfile}
              />
            )}

            {activeTab === 'attendance' && (
              <AttendanceModule 
                onAskAI={handleAskAI} 
                currentUser={userProfile}
              />
            )}

            {activeTab === 'timetable' && (
              <TimetableModule 
                onAskAI={handleAskAI} 
                currentUser={userProfile}
              />
            )}

            {activeTab === 'leaves' && (
              <LeavesModule 
                onAskAI={handleAskAI} 
                currentUser={userProfile}
              />
            )}

            {activeTab === 'notifications' && (
              <NotificationsModule 
                onAskAI={handleAskAI} 
                currentUser={userProfile}
              />
            )}
          </div>
        </main>
      </div>
    </div>
  );
}
