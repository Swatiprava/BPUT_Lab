import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  HiAcademicCap,
  HiEye,
  HiEyeSlash,
  HiArrowRight,
  HiShieldCheck,
  HiArrowLeft,
  HiKey,
  HiUser,
  HiSparkles,
} from 'react-icons/hi2'
import { TEACHERS } from '../lib/teachers'

export default function FacultyLoginPage({ onLogin }) {
  const navigate = useNavigate()
  const [identifier, setIdentifier] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const handleLoginSubmit = (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    const cleanInput = identifier.trim().toLowerCase()
    const cleanPass = password.trim()

    // Match with TEACHERS list
    const foundTeacher = TEACHERS.find((t) => {
      const emailMatch = t.email.toLowerCase() === cleanInput || `${t.username.toLowerCase()}@bput.ac.in` === cleanInput
      const userMatch = t.username.toLowerCase() === cleanInput
      const idMatch = t.id.toLowerCase() === cleanInput
      return (emailMatch || userMatch || idMatch) && t.password === cleanPass
    })

    setTimeout(() => {
      if (foundTeacher) {
        onLogin(foundTeacher)
        navigate('/faculty')
      } else {
        setError('Invalid faculty credentials. Please check your username/email and password.')
        setLoading(false)
      }
    }, 400)
  }

  // Quick 1-click login for test/demo
  const handleQuickSelect = (teacher) => {
    setIdentifier(teacher.username)
    setPassword(teacher.password)
    setError('')
    onLogin(teacher)
    navigate('/faculty')
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-mesh relative overflow-hidden py-12 px-4 sm:px-6 lg:px-8">
      {/* Background glowing orbs */}
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-accent-600/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-primary-600/10 rounded-full blur-3xl pointer-events-none" />

      {/* Back to Home Button */}
      <button
        onClick={() => navigate('/')}
        className="absolute top-6 left-6 flex items-center gap-2 px-3 py-1.5 rounded-xl bg-surface-800/80 border border-white/5 text-xs text-slate-300 hover:text-white hover:bg-surface-700 transition-all backdrop-blur-md"
      >
        <HiArrowLeft className="w-4 h-4" />
        <span>Back to Home</span>
      </button>

      <div className="w-full max-w-md mx-auto space-y-6 fade-in relative z-10">
        {/* Header / Brand */}
        <div className="text-center">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-br from-accent-500 via-primary-600 to-indigo-700 mb-4 shadow-xl shadow-accent-600/25 ring-1 ring-white/20">
            <HiShieldCheck className="w-9 h-9 text-white" />
          </div>
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-accent-500/10 border border-accent-500/20 text-accent-300 text-xs font-mono font-semibold mb-2">
            <HiSparkles className="w-3.5 h-3.5" />
            <span>Faculty &amp; Lab Evaluator Portal</span>
          </div>
          <h1 className="text-3xl font-bold text-white tracking-tight">Faculty Sign In</h1>
          <p className="text-sm text-slate-400 mt-1">
            Biju Patnaik University of Technology, Rourkela
          </p>
          <p className="text-xs text-slate-500">
            Department of Computer Science &amp; Engineering
          </p>
        </div>

        {/* Login Card */}
        <div className="glass-card p-8 border border-white/10 shadow-2xl relative">
          <div className="mb-6">
            <h2 className="text-lg font-semibold text-white">Welcome, Professor</h2>
            <p className="text-xs text-slate-400 mt-0.5">
              Sign in to monitor active IDE sessions, verify student submissions, and award marks.
            </p>
          </div>

          {error && (
            <div className="mb-5 p-3 rounded-xl bg-danger-500/10 border border-danger-500/25 text-danger-400 text-xs flex items-center gap-2 fade-in">
              <span>{error}</span>
            </div>
          )}

          <form onSubmit={handleLoginSubmit} className="space-y-4">
            {/* Username / Email */}
            <div>
              <label className="block text-xs font-semibold uppercase font-mono text-slate-300 mb-1.5">
                Faculty Email or Username
              </label>
              <div className="relative">
                <input
                  type="text"
                  value={identifier}
                  onChange={(e) => setIdentifier(e.target.value)}
                  placeholder="e.g. rajesh.mohapatra"
                  required
                  autoFocus
                  className="input-field pl-10"
                />
                <HiUser className="w-5 h-5 text-slate-500 absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" />
              </div>
            </div>

            {/* Password */}
            <div>
              <label className="block text-xs font-semibold uppercase font-mono text-slate-300 mb-1.5">
                Portal Password
              </label>
              <div className="relative">
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Enter your faculty password"
                  required
                  className="input-field pl-10 pr-10"
                />
                <HiKey className="w-5 h-5 text-slate-500 absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-200 transition-colors"
                >
                  {showPassword ? <HiEyeSlash className="w-5 h-5" /> : <HiEye className="w-5 h-5" />}
                </button>
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={loading}
              className="w-full btn-primary !py-3 !text-sm group mt-2 shadow-lg shadow-primary-600/30"
            >
              <span className="flex items-center justify-center gap-2">
                {loading ? (
                  <>
                    <div className="spinner" style={{ width: 16, height: 16 }} />
                    Authenticating Faculty...
                  </>
                ) : (
                  <>
                    <span>Enter Faculty Dashboard</span>
                    <HiArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                  </>
                )}
              </span>
            </button>
          </form>

          {/* Quick Select Teacher Pills */}
          <div className="mt-6 pt-5 border-t border-white/5">
            <p className="text-[11px] font-mono uppercase text-slate-400 font-semibold mb-2.5 flex items-center justify-between">
              <span>Quick Fill (Select Faculty):</span>
              <span className="text-primary-400 text-[10px]">6 Allocated</span>
            </p>

            <div className="grid grid-cols-2 gap-1.5 max-h-36 overflow-y-auto custom-scrollbar p-1">
              {TEACHERS.map((t) => (
                <button
                  key={t.id}
                  type="button"
                  onClick={() => handleQuickSelect(t)}
                  className="p-2 rounded-lg bg-surface-700/60 hover:bg-surface-700 text-left border border-white/5 transition-all text-[11px] group"
                >
                  <p className="font-semibold text-slate-200 truncate group-hover:text-primary-300">
                    {t.name.split(' ')[0]} {t.name.split(' ')[1]}
                  </p>
                  <p className="text-[10px] text-accent-400 font-mono truncate">
                    {t.subjectCodes.join(', ')}
                  </p>
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* Link to Student Portal */}
        <div className="text-center pt-2">
          <button
            onClick={() => navigate('/login')}
            className="text-xs text-slate-400 hover:text-primary-400 transition-colors inline-flex items-center gap-1.5"
          >
            <HiAcademicCap className="w-4 h-4" />
            <span>Are you a student? Go to Student Portal &rarr;</span>
          </button>
        </div>
      </div>
    </div>
  )
}

