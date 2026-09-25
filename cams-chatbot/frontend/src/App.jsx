import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Sidebar from './components/Sidebar';
import ChatArea from './components/ChatArea';

const API_BASE = '/api/v1';

export default function App() {
  const [sessions, setSessions] = useState([]);
  const [currentSessionId, setCurrentSessionId] = useState(null);
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const [dbInfo, setDbInfo] = useState({
    connected: true,
    tablesCount: 122
  });

  const [userProfile, setUserProfile] = useState({
    id: 'usr_admin',
    email: 'admin@gmail.com',
    role: 'ADMIN'
  });

  // 1. Initial Load: Check Health, User Profile & Fetch Sessions
  useEffect(() => {
    fetchHealth();
    fetchUserProfile();
    fetchSessions();
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
      const res = await axios.get('/health');
      setDbInfo({
        connected: res.data.database_connected,
        tablesCount: res.data.database_tables_count
      });
    } catch (err) {
      console.warn('Health check warning:', err);
    }
  };

  const fetchUserProfile = async () => {
    try {
      const res = await axios.get(`${API_BASE}/auth/me`);
      setUserProfile(res.data);
    } catch (err) {
      console.warn('Auth user fetch warning:', err);
    }
  };

  const fetchSessions = async () => {
    try {
      const res = await axios.get(`${API_BASE}/chat/sessions`);
      setSessions(res.data);
      if (res.data.length > 0 && !currentSessionId) {
        setCurrentSessionId(res.data[0].id);
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
      const res = await axios.post(`${API_BASE}/chat/sessions/${activeSessionId}/messages`, {
        content: textToSend
      });

      // Update session title in sidebar if it was a new session
      setSessions(prev => prev.map(s => {
        if (s.id === activeSessionId && s.title === 'New Conversation') {
          return { ...s, title: textToSend.slice(0, 32) };
        }
        return s;
      }));

      // Replace with confirmed messages from backend response
      setMessages(prev => [
        ...prev.filter(m => m.id !== tempUserMsg.id),
        res.data.user_message,
        res.data.assistant_message
      ]);
    } catch (err) {
      const detail = err.response?.data?.detail || 'Failed to process inquiry with CAMS AI.';
      setError(detail);
    } finally {
      setLoading(false);
    }
  };

  const currentSession = sessions.find(s => s.id === currentSessionId);

  return (
    <div className="app-container">
      <Sidebar
        sessions={sessions}
        currentSessionId={currentSessionId}
        onSelectSession={(id) => setCurrentSessionId(id)}
        onNewSession={handleNewSession}
        onDeleteSession={handleDeleteSession}
        dbInfo={dbInfo}
      />
      <ChatArea
        currentSession={currentSession}
        messages={messages}
        input={input}
        setInput={setInput}
        onSendMessage={handleSendMessage}
        loading={loading}
        error={error}
        onClearError={() => setError(null)}
        userProfile={userProfile}
        dbInfo={dbInfo}
      />
    </div>
  );
}
