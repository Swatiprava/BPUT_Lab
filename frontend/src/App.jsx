import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { useState, useEffect } from 'react'
import LoginPage from './pages/LoginPage'
import DashboardPage from './pages/DashboardPage'
import CodeLabPage from './pages/CodeLabPage'
import LandingPage from './pages/LandingPage'
import FacultyDashboardPage from './pages/FacultyDashboardPage'
import FacultyLoginPage from './pages/FacultyLoginPage'

function App() {
  const [user, setUser] = useState(null)
  const [faculty, setFaculty] = useState(() => {
    try {
      const stored = localStorage.getItem('faculty')
      return stored ? JSON.parse(stored) : null
    } catch {
      return null
    }
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Check for existing session
    const token = localStorage.getItem('access_token')
    const studentData = localStorage.getItem('student')
    if (token && studentData) {
      try {
        setUser(JSON.parse(studentData))
      } catch {
        localStorage.clear()
      }
    }
    setLoading(false)
  }, [])

  const handleLogin = (studentData, token) => {
    localStorage.setItem('access_token', token)
    localStorage.setItem('student', JSON.stringify(studentData))
    setUser(studentData)
  }

  const handleLogout = () => {
    localStorage.clear()
    setUser(null)
  }

  const handleFacultyLogin = (facultyData) => {
    localStorage.setItem('faculty', JSON.stringify(facultyData))
    localStorage.setItem('faculty_id', facultyData.id)
    setFaculty(facultyData)
  }

  const handleFacultyLogout = () => {
    localStorage.removeItem('faculty')
    localStorage.removeItem('faculty_id')
    setFaculty(null)
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-surface-900">
        <div className="spinner" style={{ width: 40, height: 40, borderWidth: 3 }}></div>
      </div>
    )
  }

  return (
    <Router>
      <Routes>
        <Route path="/" element={<LandingPage user={user} faculty={faculty} />} />
        <Route
          path="/faculty"
          element={<FacultyDashboardPage faculty={faculty} onLogout={handleFacultyLogout} />}
        />
        <Route
          path="/faculty/login"
          element={<FacultyLoginPage onLogin={handleFacultyLogin} />}
        />
        <Route
          path="/login"
          element={
            user ? <Navigate to="/dashboard" replace /> : <LoginPage onLogin={handleLogin} />
          }
        />
        <Route
          path="/dashboard"
          element={
            user ? (
              <DashboardPage user={user} onLogout={handleLogout} />
            ) : (
              <Navigate to="/login" replace />
            )
          }
        />
        <Route
          path="/lab/:experimentId"
          element={
            user ? (
              <CodeLabPage user={user} onLogout={handleLogout} />
            ) : (
              <Navigate to="/login" replace />
            )
          }
        />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  )
}

export default App
