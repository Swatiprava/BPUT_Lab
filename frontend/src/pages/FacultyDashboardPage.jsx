import { useState, useEffect, useMemo } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  HiAcademicCap,
  HiChevronDown,
  HiUserGroup,
  HiClock,
  HiCheckCircle,
  HiCommandLine,
  HiCodeBracket,
  HiArrowRightOnRectangle,
  HiArrowLeft,
  HiClipboardDocumentCheck,
  HiChatBubbleLeftRight,
  HiSparkles,
  HiBeaker,
  HiCalendarDays,
  HiEye,
  HiArrowPath,
  HiDocumentDuplicate,
  HiCheck,
} from 'react-icons/hi2'
import { TEACHERS } from '../lib/teachers'
import { STUDENTS_DATA } from '../lib/studentsData'
import { subjectsAPI, experimentsAPI, submissionsAPI, studentsAPI } from '../lib/api'
import { formatISTDateTime, formatISTFullWithDay } from '../lib/dateUtils'

export default function FacultyDashboardPage({ faculty, onLogout }) {
  const navigate = useNavigate()

  // Active Teacher state (defaults to passed faculty or stored faculty_id)
  const [selectedTeacherId, setSelectedTeacherId] = useState(() => {
    return faculty?.id || localStorage.getItem('faculty_id') || TEACHERS[0].id
  })

  const currentTeacher = useMemo(() => {
    return TEACHERS.find((t) => t.id === selectedTeacherId) || TEACHERS[0]
  }, [selectedTeacherId])

  // Navigation tab: 'dashboard' | 'tickets' | 'exam'
  const [activeTab, setActiveTab] = useState('dashboard')

  // Subjects & experiments
  const [teacherSubjects, setTeacherSubjects] = useState([])
  const [selectedSubject, setSelectedSubject] = useState(null)
  const [experiments, setExperiments] = useState([])
  const [selectedExp, setSelectedExp] = useState(null)
  const [loadingExp, setLoadingExp] = useState(false)

  // Real Database Data
  const [dbStudents, setDbStudents] = useState([])
  const [loadingStudents, setLoadingStudents] = useState(false)
  const [realSubmissions, setRealSubmissions] = useState([])
  const [loadingSubmissions, setLoadingSubmissions] = useState(false)

  // UI state
  const [teacherDropdownOpen, setTeacherDropdownOpen] = useState(false)
  const [subjectDropdownOpen, setSubjectDropdownOpen] = useState(false)
  const [expDropdownOpen, setExpDropdownOpen] = useState(false)
  const [reviewModalData, setReviewModalData] = useState(null) // { student, submission }
  const [copiedCode, setCopiedCode] = useState(false)
  const [showLiveSessionsModal, setShowLiveSessionsModal] = useState(false)

  // Sync teacher selection to localStorage
  const handleTeacherChange = (teacher) => {
    setSelectedTeacherId(teacher.id)
    localStorage.setItem('faculty_id', teacher.id)
    setTeacherDropdownOpen(false)
  }

  // 1. Fetch subjects corresponding to the teacher's assigned subject codes
  useEffect(() => {
    let cancelled = false
    const fetchTeacherSubjects = async () => {
      try {
        const res = await subjectsAPI.getAll()
        if (cancelled) return
        const allSubs = res.data.subjects || []
        const matched = allSubs.filter((s) => currentTeacher.subjectCodes.includes(s.code))
        setTeacherSubjects(matched)
        if (matched.length > 0) {
          setSelectedSubject((prev) => {
            // Only update if we don't already have a valid selection from this teacher
            if (prev && matched.some((m) => m.id === prev.id)) return prev
            return matched[0]
          })
        } else {
          setSelectedSubject(null)
        }
      } catch (err) {
        console.error('Failed to load teacher subjects:', err)
      }
    }
    fetchTeacherSubjects()
    return () => { cancelled = true }
  }, [currentTeacher])

  // 2. Fetch experiments when selected subject changes
  useEffect(() => {
    if (!selectedSubject) {
      setExperiments([])
      setSelectedExp(null)
      return
    }

    let cancelled = false
    const fetchExp = async () => {
      setLoadingExp(true)
      try {
        const res = await experimentsAPI.getAll(selectedSubject.id)
        if (cancelled) return
        const expList = res.data.experiments || []
        setExperiments(expList)
        if (expList.length > 0) {
          setSelectedExp((prev) => {
            // Keep current selection if it belongs to the same subject
            if (prev && expList.some((e) => e.id === prev.id)) return prev
            return expList[0]
          })
        } else {
          setSelectedExp(null)
        }
      } catch (err) {
        console.error('Failed to load experiments:', err)
      } finally {
        if (!cancelled) setLoadingExp(false)
      }
    }
    fetchExp()
    return () => { cancelled = true }
  }, [selectedSubject?.id])

  // 3. Fetch REAL students from the database for the selected subject's semester
  useEffect(() => {
    if (!selectedSubject) {
      setDbStudents([])
      return
    }

    let cancelled = false
    const fetchStudents = async () => {
      setLoadingStudents(true)
      try {
        const res = await studentsAPI.getAll(selectedSubject.semester)
        if (cancelled) return
        if (res.data?.students && res.data.students.length > 0) {
          setDbStudents(res.data.students)
        } else {
          // Fallback to local dataset if DB empty
          const fallback = STUDENTS_DATA[selectedSubject.semester] || []
          setDbStudents(
            fallback.map((s, idx) => ({
              id: `fallback-${idx}`,
              name: s.name,
              registration_number: s.regNo,
              semester: s.semester,
              username: s.username,
            }))
          )
        }
      } catch (err) {
        if (cancelled) return
        console.warn('Students API warning, falling back to registered dataset:', err)
        const fallback = STUDENTS_DATA[selectedSubject.semester] || []
        setDbStudents(
          fallback.map((s, idx) => ({
            id: `fallback-${idx}`,
            name: s.name,
            registration_number: s.regNo,
            semester: s.semester,
            username: s.username,
          }))
        )
      } finally {
        if (!cancelled) setLoadingStudents(false)
      }
    }
    fetchStudents()
    return () => { cancelled = true }
  }, [selectedSubject?.id, selectedSubject?.semester])

  // 4. Fetch REAL submissions from the database for this experiment
  const refreshSubmissions = async (expId) => {
    const targetExpId = expId || selectedExp?.id
    if (!targetExpId) {
      setRealSubmissions([])
      return
    }
    setLoadingSubmissions(true)
    try {
      const res = await submissionsAPI.getAll(null, targetExpId)
      setRealSubmissions(res.data?.submissions || [])
    } catch (err) {
      console.warn('Failed to load submissions:', err)
      // DON'T clear existing data on error — keep previous data visible
    } finally {
      setLoadingSubmissions(false)
    }
  }

  useEffect(() => {
    let cancelled = false
    if (!selectedExp) {
      setRealSubmissions([])
      return
    }
    const fetchSubs = async () => {
      setLoadingSubmissions(true)
      try {
        const res = await submissionsAPI.getAll(null, selectedExp.id)
        if (cancelled) return
        setRealSubmissions(res.data?.submissions || [])
      } catch (err) {
        if (cancelled) return
        console.warn('Failed to load submissions:', err)
        // DON'T clear existing data on error
      } finally {
        if (!cancelled) setLoadingSubmissions(false)
      }
    }
    fetchSubs()
    return () => { cancelled = true }
  }, [selectedExp?.id])

  // Helper to find a student's real submission record
  const getStudentSubmission = (student) => {
    const sId = student.id
    const sAuth = student.auth_user_id
    const sReg = student.registration_number || student.regNo
    const sUser = student.username

    return realSubmissions.find((sub) => {
      return (
        (sId && sub.student_id === sId) ||
        (sAuth && sub.student_id === sAuth) ||
        (sReg && sub.student_id === sReg) ||
        (sUser && sub.student_id === sUser)
      )
    })
  }

  // Calculate REAL stats strictly for TWO statuses: Submitted vs Pending
  const stats = useMemo(() => {
    const total = dbStudents.length || 0
    let submittedCount = 0

    dbStudents.forEach((student) => {
      if (getStudentSubmission(student)) {
        submittedCount++
      }
    })

    const pendingCount = total - submittedCount
    const submittedPct = total > 0 ? Math.round((submittedCount / total) * 100) : 0
    const pendingPct = total > 0 ? 100 - submittedPct : 0

    return {
      total,
      submitted: submittedCount,
      pending: pendingCount,
      submittedPct,
      pendingPct,
    }
  }, [dbStudents, realSubmissions])

  // Real students who have submitted code for this experiment (for the Real Time Status section)
  const activeSubmissionsList = useMemo(() => {
    const list = []
    dbStudents.forEach((student) => {
      const sub = getStudentSubmission(student)
      if (sub) {
        list.push({ student, submission: sub })
      }
    })
    return list
  }, [dbStudents, realSubmissions])

  const copyCodeToClipboard = (text) => {
    navigator.clipboard.writeText(text)
    setCopiedCode(true)
    setTimeout(() => setCopiedCode(false), 2000)
  }

  return (
    <div className="flex h-screen overflow-hidden bg-surface-900 text-slate-100">
      {/* ============================================================ */}
      {/* 1. LEFT SIDEBAR */}
      {/* ============================================================ */}
      <aside className="w-72 bg-surface-800 border-r border-white/5 flex flex-col flex-shrink-0">
        {/* Brand Header */}
        <div className="p-4 border-b border-white/5 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-br from-primary-500 via-primary-600 to-accent-600 flex items-center justify-center shadow-lg shadow-primary-500/20">
              <HiAcademicCap className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-sm font-bold text-white tracking-tight">Faculty Portal</h1>
              <p className="text-[10px] text-slate-400 font-mono">BPUT CSE • Real Submissions</p>
            </div>
          </div>

          <button
            onClick={() => navigate('/')}
            title="Return to Public Portal"
            className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-surface-700 transition-colors"
          >
            <HiArrowLeft className="w-4 h-4" />
          </button>
        </div>

        {/* Navigation Menu */}
        <div className="flex-1 overflow-y-auto p-3 space-y-5 custom-scrollbar">
          {/* Main Dashboard item */}
          <div>
            <button
              onClick={() => setActiveTab('dashboard')}
              className={`w-full flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-sm font-semibold transition-all ${activeTab === 'dashboard'
                  ? 'bg-primary-600 text-white shadow-lg shadow-primary-600/30'
                  : 'text-slate-300 hover:text-white hover:bg-surface-700'
                }`}
            >
              <HiCommandLine className="w-4 h-4" />
              <span>Dashboard</span>
            </button>
          </div>

          {/* "My student" with assigned subjects */}
          <div className="space-y-1.5">
            <div className="flex items-center justify-between px-3 text-[11px] font-bold uppercase tracking-wider text-slate-400 font-mono">
              <span className="flex items-center gap-1.5">
                <HiUserGroup className="w-3.5 h-3.5 text-accent-400" />
                My Students
              </span>
              <span className="text-[10px] text-slate-500 font-mono">
                {teacherSubjects.length} Courses
              </span>
            </div>

            <div className="space-y-1 pl-2">
              {teacherSubjects.map((sub) => {
                const isSelected = selectedSubject?.id === sub.id && activeTab === 'dashboard'
                return (
                  <button
                    key={sub.id}
                    onClick={() => {
                      setSelectedSubject(sub)
                      setActiveTab('dashboard')
                    }}
                    className={`w-full text-left px-3 py-2 rounded-xl text-xs transition-all flex items-center justify-between group ${isSelected
                        ? 'bg-surface-700 text-primary-300 font-semibold border border-primary-500/30 shadow-sm'
                        : 'text-slate-400 hover:text-slate-200 hover:bg-surface-700/60'
                      }`}
                  >
                    <div className="truncate pr-1">
                      <div className="truncate font-medium">{sub.name}</div>
                      <div className="text-[10px] text-slate-500 font-mono mt-0.5">
                        {sub.code} • Semester {sub.semester}
                      </div>
                    </div>
                    {isSelected && (
                      <span className="w-1.5 h-1.5 rounded-full bg-primary-400 flex-shrink-0" />
                    )}
                  </button>
                )
              })}
            </div>
          </div>

          {/* Ticket History */}
          <div>
            <button
              onClick={() => setActiveTab('tickets')}
              className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-semibold transition-all ${activeTab === 'tickets'
                  ? 'bg-primary-600 text-white shadow-lg shadow-primary-600/30'
                  : 'text-slate-300 hover:text-white hover:bg-surface-700'
                }`}
            >
              <div className="flex items-center gap-2.5">
                <HiChatBubbleLeftRight className="w-4 h-4" />
                <span>Ticket History</span>
              </div>
              <span className="text-[10px] font-mono px-1.5 py-0.5 rounded bg-amber-500/20 text-amber-300 border border-amber-500/30">
                2 Open
              </span>
            </button>
          </div>

          {/* Exam / Assessment */}
          <div>
            <button
              onClick={() => setActiveTab('exam')}
              className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-semibold transition-all ${activeTab === 'exam'
                  ? 'bg-primary-600 text-white shadow-lg shadow-primary-600/30'
                  : 'text-slate-300 hover:text-white hover:bg-surface-700'
                }`}
            >
              <div className="flex items-center gap-2.5">
                <HiClipboardDocumentCheck className="w-4 h-4" />
                <span>Exam &amp; Viva</span>
              </div>
              <span className="text-[10px] font-mono px-1.5 py-0.5 rounded bg-emerald-500/20 text-emerald-300 border border-emerald-500/30">
                Active
              </span>
            </button>
          </div>
        </div>

        {/* Profile Section at Bottom */}
        <div className="p-3 border-t border-white/5 bg-surface-850">
          <div className="flex items-center gap-3 p-2 rounded-xl bg-surface-700/60 border border-white/5">
            <div
              className={`w-9 h-9 rounded-xl bg-gradient-to-br ${currentTeacher.avatarColor} flex items-center justify-center text-xs font-bold text-white shadow`}
            >
              {currentTeacher.name.split(' ').map((n) => n[0]).slice(0, 2).join('')}
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-xs font-semibold text-white truncate">{currentTeacher.name}</p>
              <p className="text-[10px] text-slate-400 truncate">{currentTeacher.designation}</p>
            </div>
            <button
              onClick={() => {
                if (onLogout) onLogout()
                navigate('/faculty/login')
              }}
              title="Sign Out"
              className="p-1.5 rounded-lg text-rose-400 hover:bg-rose-500/10 transition-colors"
            >
              <HiArrowRightOnRectangle className="w-4 h-4" />
            </button>
          </div>
        </div>
      </aside>

      {/* ============================================================ */}
      {/* 2. MAIN CONTENT AREA */}
      {/* ============================================================ */}
      <main className="flex-1 flex flex-col overflow-hidden bg-mesh">
        {/* Top Header Bar */}
        <header className="px-8 py-4 border-b border-white/5 bg-surface-900/60 backdrop-blur-md flex items-center justify-between flex-shrink-0">
          <div>
            <div className="flex items-center gap-2 text-xs text-slate-400">
              <span className="text-primary-400 font-semibold">BPUT CSE Practical Evaluation</span>
              <span>•</span>
              <span className="text-emerald-400 font-mono flex items-center gap-1">
                <span className="w-2 h-2 rounded-full bg-emerald-400" />
                Live Database Connected
              </span>
            </div>
            <h2 className="text-xl font-bold text-white mt-0.5">
              Welcome back, <span className="gradient-text">{currentTeacher.name}</span>
            </h2>
          </div>

          <div className="flex items-center gap-3">
            {/* Refresh Data button */}
            <button
              onClick={() => refreshSubmissions()}
              title="Refresh real-time submissions from database"
              className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-surface-700 hover:bg-surface-600 border border-white/5 text-xs text-slate-300 hover:text-white transition-all"
            >
              <HiArrowPath className={`w-3.5 h-3.5 ${loadingSubmissions ? 'animate-spin text-primary-400' : ''}`} />
              <span>Refresh</span>
            </button>

            {/* Switch Faculty Dropdown */}
            <div className="relative">
              <button
                onClick={() => setTeacherDropdownOpen(!teacherDropdownOpen)}
                className="flex items-center gap-2 px-3 py-2 rounded-xl bg-surface-700 border border-white/10 text-xs font-medium text-slate-200 hover:border-primary-500/40 transition-all"
              >
                <span>Account:</span>
                <span className="text-primary-300 font-bold">{currentTeacher.name}</span>
                <HiChevronDown className={`w-3.5 h-3.5 text-slate-400 transition-transform ${teacherDropdownOpen ? 'rotate-180' : ''}`} />
              </button>

              {teacherDropdownOpen && (
                <div className="absolute right-0 top-full mt-1.5 w-80 py-2 rounded-2xl bg-surface-800 border border-white/10 shadow-2xl z-50 fade-in">
                  <div className="px-3 pb-2 mb-1 border-b border-white/5 text-[10px] font-mono text-slate-400 uppercase font-semibold">
                    Select Faculty (6 Members)
                  </div>
                  {TEACHERS.map((t) => (
                    <button
                      key={t.id}
                      onClick={() => handleTeacherChange(t)}
                      className={`w-full text-left px-3.5 py-2 text-xs flex items-center gap-3 transition-colors ${t.id === currentTeacher.id
                          ? 'bg-primary-600/20 text-primary-300 font-semibold'
                          : 'text-slate-300 hover:bg-surface-700'
                        }`}
                    >
                      <div className={`w-7 h-7 rounded-lg bg-gradient-to-br ${t.avatarColor} flex items-center justify-center text-[10px] font-bold text-white flex-shrink-0`}>
                        {t.name.split(' ').map((n) => n[0]).slice(0, 2).join('')}
                      </div>
                      <div className="truncate flex-1">
                        <div className="truncate font-medium">{t.name}</div>
                        <div className="text-[10px] text-slate-400 truncate">
                          {t.subjectNames.join(', ')}
                        </div>
                      </div>
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>
        </header>

        {/* Dashboard Tab Content */}
        {activeTab === 'dashboard' && (
          <div className="flex-1 overflow-y-auto p-6 space-y-6 custom-scrollbar">
            {/* ============================================================ */}
            {/* A. REAL TIME STATUS (wireframe top card) */}
            {/* ============================================================ */}
            <div className="glass-card p-5 border border-white/10">
              <div className="flex items-center justify-between pb-3 border-b border-white/5 mb-3.5">
                <div className="flex items-center gap-2.5">
                  <span className="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-ping" />
                  <h3 className="text-sm font-bold text-white tracking-wide uppercase font-mono">
                    Real Time Status
                  </h3>
                  <span className="text-xs text-slate-400">
                    • Show who is currently working on IDE ({activeSubmissionsList.length} recorded submissions)
                  </span>
                </div>
                {activeSubmissionsList.length > 0 && (
                  <button
                    onClick={() => setShowLiveSessionsModal(true)}
                    className="text-xs font-semibold text-primary-400 hover:text-primary-300 flex items-center gap-1 transition-colors"
                  >
                    <span>View all submissions ({activeSubmissionsList.length})...</span>
                  </button>
                )}
              </div>

              {/* Real Submissions Cards or Empty State */}
              {activeSubmissionsList.length > 0 ? (
                <div className="grid grid-cols-1 md:grid-cols-3 gap-3.5">
                  {activeSubmissionsList.map(({ student, submission }, idx) => (
                    <div
                      key={idx}
                      onClick={() => setReviewModalData({ student, submission })}
                      className="p-3.5 rounded-xl bg-surface-800/90 border border-white/5 hover:border-emerald-500/40 transition-all flex items-start gap-3 cursor-pointer group"
                    >
                      <div className="w-8 h-8 rounded-full bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center text-xs font-bold text-white flex-shrink-0">
                        {student.name.charAt(0)}
                      </div>
                      <div className="flex-1 min-w-0 text-xs">
                        <div className="flex items-center justify-between">
                          <p className="font-semibold text-slate-200 truncate group-hover:text-emerald-300 transition-colors">
                            {student.name}
                          </p>
                          <span className="text-[10px] text-emerald-400 font-mono font-medium flex items-center gap-1">
                            <HiCheckCircle className="w-3.5 h-3.5" />
                            Submitted
                          </span>
                        </div>
                        <p className="text-[10px] text-slate-400 font-mono">{student.registration_number}</p>
                        <div className="mt-1.5 text-[11px] text-primary-300 font-medium truncate">
                          Code: {submission.code ? `${submission.code.split('\n').length} lines written` : 'Empty'}
                        </div>
                        <div className="flex items-center justify-between text-[10px] text-slate-500 mt-1">
                          <span className="text-emerald-400 font-mono font-medium">
                            {formatISTDateTime(submission.submitted_at) || 'Turned In'}
                          </span>
                          <span className="text-emerald-400 font-semibold group-hover:underline">Review Code &rarr;</span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="py-6 text-center">
                  <div className="inline-flex items-center justify-center w-10 h-10 rounded-xl bg-surface-700 text-slate-400 mb-2">
                    <HiClock className="w-5 h-5" />
                  </div>
                  <p className="text-xs text-slate-300 font-medium">
                    No student submissions recorded yet for {selectedExp?.title || 'this experiment'}.
                  </p>
                  <p className="text-[11px] text-slate-500 mt-0.5">
                    All {dbStudents.length} students currently show as <span className="text-amber-400 font-semibold">Pending</span>. Submissions will appear in real-time as students hit "Submit".
                  </p>
                </div>
              )}
            </div>

            {/* ============================================================ */}
            {/* B. FILTER CONTROLS: "Select Subject" & "Select exp" */}
            {/* ============================================================ */}
            <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-4 bg-surface-800/70 p-3.5 rounded-2xl border border-white/5">
              {/* Select Subject Dropdown */}
              <div className="flex-1 relative">
                <label className="block text-[10px] font-mono uppercase text-slate-400 font-semibold mb-1">
                  Select Subject
                </label>
                <button
                  onClick={() => setSubjectDropdownOpen(!subjectDropdownOpen)}
                  className="w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl bg-surface-700 border border-white/10 text-sm font-semibold text-slate-200 hover:border-primary-500/40 transition-all"
                >
                  <span className="truncate">
                    {selectedSubject ? `${selectedSubject.code}: ${selectedSubject.name}` : 'Choose Subject'}
                  </span>
                  <HiChevronDown className={`w-4 h-4 text-slate-400 transition-transform ${subjectDropdownOpen ? 'rotate-180' : ''}`} />
                </button>

                {subjectDropdownOpen && (
                  <div className="absolute left-0 right-0 top-full mt-1 py-1 rounded-xl bg-surface-700 border border-white/10 shadow-xl z-30 fade-in">
                    {teacherSubjects.map((sub) => (
                      <button
                        key={sub.id}
                        onClick={() => {
                          setSelectedSubject(sub)
                          setSubjectDropdownOpen(false)
                        }}
                        className={`w-full text-left px-3.5 py-2 text-xs transition-colors ${selectedSubject?.id === sub.id ? 'bg-primary-600/20 text-primary-300 font-bold' : 'text-slate-300 hover:bg-surface-600'
                          }`}
                      >
                        <div className="font-semibold">{sub.code}: {sub.name}</div>
                        <div className="text-[10px] text-slate-400">Semester {sub.semester} • {sub.language?.toUpperCase()}</div>
                      </button>
                    ))}
                  </div>
                )}
              </div>

              {/* Select Experiment Dropdown */}
              <div className="flex-1 relative">
                <label className="block text-[10px] font-mono uppercase text-slate-400 font-semibold mb-1">
                  Select Experiment
                </label>
                <button
                  onClick={() => setExpDropdownOpen(!expDropdownOpen)}
                  className="w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl bg-surface-700 border border-white/10 text-sm font-semibold text-slate-200 hover:border-primary-500/40 transition-all"
                >
                  <span className="truncate">
                    {selectedExp ? `Exp ${selectedExp.experiment_number}: ${selectedExp.title}` : 'Choose Experiment'}
                  </span>
                  <HiChevronDown className={`w-4 h-4 text-slate-400 transition-transform ${expDropdownOpen ? 'rotate-180' : ''}`} />
                </button>

                {expDropdownOpen && (
                  <div className="absolute left-0 right-0 top-full mt-1 py-1 rounded-xl bg-surface-700 border border-white/10 shadow-xl max-h-60 overflow-y-auto z-30 custom-scrollbar fade-in">
                    {experiments.map((exp) => (
                      <button
                        key={exp.id}
                        onClick={() => {
                          setSelectedExp(exp)
                          setExpDropdownOpen(false)
                        }}
                        className={`w-full text-left px-3.5 py-2 text-xs transition-colors ${selectedExp?.id === exp.id ? 'bg-primary-600/20 text-primary-300 font-bold' : 'text-slate-300 hover:bg-surface-600'
                          }`}
                      >
                        <span className="font-mono text-accent-300 font-semibold">Exp {exp.experiment_number}:</span>{' '}
                        <span>{exp.title}</span>
                      </button>
                    ))}
                  </div>
                )}
              </div>
            </div>

            {/* ============================================================ */}
            {/* C. TWO SIDE-BY-SIDE CARDS: Recent Activity & Pie Chart */}
            {/* ============================================================ */}
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
              {/* LEFT CARD: Recent Activity (60% width) */}
              <div className="lg:col-span-7 glass-card p-5 flex flex-col justify-between">
                <div>
                  <div className="flex items-center justify-between pb-3 border-b border-white/5 mb-3">
                    <div>
                      <h3 className="text-sm font-bold text-white tracking-wide uppercase font-mono">
                        Recent Activity
                      </h3>
                      <p className="text-[11px] text-slate-400 mt-0.5">
                        {selectedSubject?.code} • {selectedExp ? `Exp ${selectedExp.experiment_number}: ${selectedExp.title}` : 'All experiments'}
                      </p>
                    </div>
                    <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-primary-500/10 text-primary-300 border border-primary-500/20">
                      {dbStudents.length} Students in Cohort
                    </span>
                  </div>

                  {/* Real Student Table with ONLY TWO STATUSES: Submitted or Pending */}
                  <div className="divide-y divide-white/5 overflow-hidden">
                    {dbStudents.map((student) => {
                      const submission = getStudentSubmission(student)
                      const isSubmitted = !!submission

                      return (
                        <div
                          key={student.registration_number || student.id}
                          className="py-2.5 flex items-center justify-between gap-3 text-xs hover:bg-white/[0.02] px-2 rounded-lg transition-colors"
                        >
                          <div className="flex items-center gap-2.5 min-w-0">
                            <div className="w-7 h-7 rounded-full bg-surface-700 flex items-center justify-center font-bold text-slate-300 text-[11px] flex-shrink-0">
                              {student.name.charAt(0)}
                            </div>
                            <div className="truncate">
                              <p className="font-semibold text-slate-200 truncate">{student.name}</p>
                              <p className="text-[10px] text-slate-500 font-mono">{student.registration_number}</p>
                            </div>
                          </div>

                          <div className="flex items-center gap-3">
                            {/* STRICTLY TWO STATUSES: Submitted or Pending */}
                            {isSubmitted ? (
                              <div className="flex flex-col items-end sm:flex-row sm:items-center gap-1.5">
                                <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-emerald-500/15 text-emerald-300 border border-emerald-500/25">
                                  <HiCheckCircle className="w-3.5 h-3.5" />
                                  Submitted
                                </span>
                                {submission?.submitted_at && (
                                  <span className="text-[10px] font-mono text-emerald-400 whitespace-nowrap">
                                    {formatISTDateTime(submission.submitted_at)}
                                  </span>
                                )}
                              </div>
                            ) : (
                              <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-amber-500/15 text-amber-300 border border-amber-500/25">
                                <HiClock className="w-3.5 h-3.5" />
                                Pending
                              </span>
                            )}

                            {/* Action Button */}
                            {isSubmitted ? (
                              <button
                                onClick={() => setReviewModalData({ student, submission })}
                                className="px-2.5 py-1 rounded-lg bg-emerald-600/20 hover:bg-emerald-600 text-[11px] font-semibold text-emerald-300 hover:text-white transition-all flex items-center gap-1 border border-emerald-500/30"
                              >
                                <HiEye className="w-3 h-3" />
                                <span>Review Code</span>
                              </button>
                            ) : (
                              <span className="text-[11px] text-slate-600 font-mono italic pr-2">
                                Not submitted
                              </span>
                            )}
                          </div>
                        </div>
                      )
                    })}
                  </div>
                </div>

                <div className="pt-3 border-t border-white/5 flex items-center justify-between text-xs text-slate-400">
                  <span>Actual database records for Semester {selectedSubject?.semester}</span>
                  <span className="font-mono text-primary-400">
                    {stats.submitted} of {stats.total} submitted
                  </span>
                </div>
              </div>

              {/* RIGHT CARD: Pie Chart for Submitted or Pending ONLY */}
              <div className="lg:col-span-5 glass-card p-5 flex flex-col justify-between">
                <div>
                  <div className="flex items-center justify-between pb-3 border-b border-white/5 mb-4">
                    <h3 className="text-sm font-bold text-white tracking-wide uppercase font-mono">
                      Submissions Breakdown
                    </h3>
                    <span className="text-[10px] text-slate-400 font-mono">
                      {selectedExp ? `Exp ${selectedExp.experiment_number}` : ''}
                    </span>
                  </div>

                  {/* SVG Pie / Donut Chart with ONLY TWO SLICES: Submitted (Green) & Pending (Amber) */}
                  <div className="flex flex-col items-center justify-center py-2">
                    <div className="relative w-44 h-44 flex items-center justify-center">
                      <svg viewBox="0 0 100 100" className="w-full h-full -rotate-90">
                        {/* Background ring */}
                        <circle
                          cx="50"
                          cy="50"
                          r="38"
                          fill="transparent"
                          stroke="#1e293b"
                          strokeWidth="14"
                        />
                        {/* Submitted slice (Emerald #10b981) */}
                        {stats.submittedPct > 0 && (
                          <circle
                            cx="50"
                            cy="50"
                            r="38"
                            fill="transparent"
                            stroke="#10b981"
                            strokeWidth="14"
                            strokeDasharray={`${stats.submittedPct * 2.3876} 238.76`}
                            strokeDashoffset="0"
                          />
                        )}
                        {/* Pending slice (Amber #f59e0b) */}
                        {stats.pendingPct > 0 && (
                          <circle
                            cx="50"
                            cy="50"
                            r="38"
                            fill="transparent"
                            stroke="#f59e0b"
                            strokeWidth="14"
                            strokeDasharray={`${stats.pendingPct * 2.3876} 238.76`}
                            strokeDashoffset={`${-stats.submittedPct * 2.3876}`}
                          />
                        )}
                      </svg>

                      {/* Donut Center Info */}
                      <div className="absolute inset-0 flex flex-col items-center justify-center text-center select-none pointer-events-none">
                        <span className="text-2xl font-extrabold text-white tracking-tight">
                          {stats.submitted} / {stats.total}
                        </span>
                        <span className="text-[10px] text-emerald-400 font-semibold uppercase tracking-wider">
                          Submitted
                        </span>
                      </div>
                    </div>
                  </div>

                  {/* Legend / Metrics: Strictly TWO rows */}
                  <div className="space-y-2 mt-4 pt-4 border-t border-white/5">
                    <div className="flex items-center justify-between text-xs p-2 rounded-lg bg-surface-800/60">
                      <div className="flex items-center gap-2">
                        <span className="w-3 h-3 rounded-full bg-emerald-500" />
                        <span className="text-slate-200 font-medium">Submitted</span>
                      </div>
                      <span className="font-mono font-bold text-emerald-400">
                        {stats.submitted} ({stats.submittedPct}%)
                      </span>
                    </div>

                    <div className="flex items-center justify-between text-xs p-2 rounded-lg bg-surface-800/60">
                      <div className="flex items-center gap-2">
                        <span className="w-3 h-3 rounded-full bg-amber-500" />
                        <span className="text-slate-200 font-medium">Pending</span>
                      </div>
                      <span className="font-mono font-bold text-amber-400">
                        {stats.pending} ({stats.pendingPct}%)
                      </span>
                    </div>
                  </div>
                </div>

                <div className="pt-3 border-t border-white/5 text-[11px] text-slate-500 text-center font-mono">
                  Real DB Status: {stats.submitted} turned in, {stats.pending} awaiting submission
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Ticket History Tab */}
        {activeTab === 'tickets' && (
          <div className="flex-1 overflow-y-auto p-6 space-y-4 custom-scrollbar">
            <div className="flex items-center justify-between pb-3 border-b border-white/5">
              <div>
                <h3 className="text-lg font-bold text-white">Student Lab Doubt Tickets</h3>
                <p className="text-xs text-slate-400">Questions submitted by students during active lab sessions</p>
              </div>
              <span className="px-3 py-1 rounded-full bg-amber-500/10 text-amber-300 text-xs font-mono font-semibold border border-amber-500/20">
                2 Pending Questions
              </span>
            </div>

            <div className="space-y-3">
              {[
                {
                  id: 'TCK-2024-08',
                  student: 'Aarav Sharma',
                  regNo: 'BPUT2024CS001',
                  subject: 'Data Structures Lab (CSPC2202)',
                  topic: 'Sparse matrix 3-tuple row indexing discrepancy',
                  desc: 'Sir, when calculating non-zero elements, does the triplet representation header row count as index 0 or should array start directly from index 1?',
                  time: '18 mins ago',
                  status: 'Open',
                },
                {
                  id: 'TCK-2024-05',
                  student: 'Siddharth Mohapatra',
                  regNo: 'BPUT2023CS011',
                  subject: 'COA Lab (CSPC2205)',
                  topic: "Booth's multiplier negative number arithmetic right shift",
                  desc: "When running the Booth's algorithm with Q = -4, the right shift in C keeps the sign bit 1 forever. Should we mask with ((1 << n) - 1)?",
                  time: '42 mins ago',
                  status: 'Resolved',
                },
              ].map((t) => (
                <div key={t.id} className="glass-card p-4 space-y-2">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <span className="text-xs font-mono text-primary-400 font-bold">{t.id}</span>
                      <span className="text-xs text-slate-400">•</span>
                      <span className="text-xs font-semibold text-slate-200">{t.student} ({t.regNo})</span>
                    </div>
                    <span className={`text-[10px] font-mono px-2 py-0.5 rounded-full font-semibold ${t.status === 'Open' ? 'bg-amber-500/20 text-amber-300 border border-amber-500/30' : 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/30'
                      }`}>
                      {t.status}
                    </span>
                  </div>
                  <h4 className="text-sm font-semibold text-white">{t.topic}</h4>
                  <p className="text-xs text-slate-300 leading-relaxed">{t.desc}</p>
                  <div className="flex items-center justify-between text-[11px] text-slate-500 pt-2 border-t border-white/5">
                    <span>{t.subject}</span>
                    <span>{t.time}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Exam / Viva Tab */}
        {activeTab === 'exam' && (
          <div className="flex-1 overflow-y-auto p-6 space-y-5 custom-scrollbar">
            <div className="flex items-center justify-between pb-3 border-b border-white/5">
              <div>
                <h3 className="text-lg font-bold text-white">Semester Lab Practical &amp; Viva Assessment</h3>
                <p className="text-xs text-slate-400">Formal BPUT practical exam marks allocation and model viva questions</p>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="glass-card p-5 space-y-3">
                <h4 className="text-sm font-bold text-white flex items-center gap-2">
                  <HiBeaker className="w-4 h-4 text-primary-400" />
                  Practical Rubric Breakdown (BPUT Regulations)
                </h4>
                <ul className="space-y-2 text-xs text-slate-300">
                  <li className="flex justify-between p-2 rounded bg-surface-800">
                    <span>Algorithm &amp; Logic Implementation</span>
                    <span className="font-bold text-primary-400">30 Marks</span>
                  </li>
                  <li className="flex justify-between p-2 rounded bg-surface-800">
                    <span>Compilation &amp; Clean Execution</span>
                    <span className="font-bold text-primary-400">20 Marks</span>
                  </li>
                  <li className="flex justify-between p-2 rounded bg-surface-800">
                    <span>Boundary &amp; Negative Test Vectors</span>
                    <span className="font-bold text-primary-400">20 Marks</span>
                  </li>
                  <li className="flex justify-between p-2 rounded bg-surface-800">
                    <span>Viva-Voce Interactive Defense</span>
                    <span className="font-bold text-primary-400">30 Marks</span>
                  </li>
                </ul>
              </div>

              <div className="glass-card p-5 space-y-3">
                <h4 className="text-sm font-bold text-white flex items-center gap-2">
                  <HiCalendarDays className="w-4 h-4 text-accent-400" />
                  Assigned Lab Schedule
                </h4>
                <div className="space-y-2 text-xs">
                  {teacherSubjects.map((s) => (
                    <div key={s.id} className="p-2.5 rounded bg-surface-800 border border-white/5 flex items-center justify-between">
                      <div>
                        <p className="font-semibold text-slate-200">{s.name}</p>
                        <p className="text-[10px] text-slate-500 font-mono">{s.code} • Sem {s.semester}</p>
                      </div>
                      <span className="px-2 py-0.5 rounded bg-primary-500/15 text-primary-300 font-mono text-[10px] font-semibold">
                        2 Questions / Week
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        )}
      </main>

      {/* ============================================================ */}
      {/* 3. REAL CODE REVIEW MODAL */}
      {/* ============================================================ */}
      {reviewModalData && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm fade-in">
          <div className="w-full max-w-3xl glass-card border border-white/10 overflow-hidden shadow-2xl flex flex-col max-h-[90vh]">
            <div className="px-5 py-3.5 bg-surface-800 border-b border-white/10 flex items-center justify-between">
              <div>
                <h3 className="text-sm font-bold text-white flex items-center gap-2">
                  <HiCodeBracket className="w-4 h-4 text-emerald-400" />
                  <span>Real Code Submission: {reviewModalData.student.name}</span>
                </h3>
                <p className="text-[10px] text-slate-400 font-mono">
                  {reviewModalData.student.registration_number} • {selectedSubject?.code}: {selectedExp?.title}
                </p>
              </div>
              <button
                onClick={() => setReviewModalData(null)}
                className="w-7 h-7 flex items-center justify-center rounded-lg text-slate-400 hover:text-white hover:bg-surface-700"
              >
                ✕
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-5 space-y-4 custom-scrollbar text-xs">
              {/* Submission Metadata */}
              <div className="p-3 rounded-xl bg-surface-800/80 border border-white/5 flex items-center justify-between text-xs">
                <div>
                  <span className="text-slate-400">Status: </span>
                  <span className="font-semibold text-emerald-400">✓ Submitted</span>
                </div>
                <div>
                  <span className="text-slate-400">Submitted at: </span>
                  <span className="font-mono text-slate-200">
                    {reviewModalData.submission?.submitted_at
                      ? formatISTFullWithDay(reviewModalData.submission.submitted_at)
                      : 'Recently submitted'}
                  </span>
                </div>
              </div>

              {/* REAL Student Source Code */}
              <div>
                <div className="flex items-center justify-between text-slate-400 font-mono text-[11px] mb-1.5">
                  <span>Student Source Code ({selectedSubject?.language?.toUpperCase()}):</span>
                  <button
                    onClick={() => copyCodeToClipboard(reviewModalData.submission?.code || '')}
                    className="flex items-center gap-1 text-primary-400 hover:text-primary-300 transition-colors"
                  >
                    {copiedCode ? <HiCheck className="w-3.5 h-3.5 text-emerald-400" /> : <HiDocumentDuplicate className="w-3.5 h-3.5" />}
                    <span>{copiedCode ? 'Copied' : 'Copy Code'}</span>
                  </button>
                </div>
                <div className="p-3.5 rounded-xl bg-black border border-white/10 font-mono text-slate-200 text-xs leading-relaxed overflow-x-auto max-h-60">
                  <pre>{reviewModalData.submission?.code || '// No code found in submission'}</pre>
                </div>
              </div>

              {/* REAL Terminal Output */}
              <div>
                <div className="text-slate-400 font-mono text-[11px] mb-1.5">Terminal Execution Output:</div>
                <div className="p-3 rounded-xl bg-[#0b0e14] border border-white/10 font-mono text-emerald-400 text-xs overflow-x-auto max-h-36">
                  <pre className="whitespace-pre-wrap">{reviewModalData.submission?.output || 'Execution passed.'}</pre>
                </div>
              </div>
            </div>

            <div className="p-4 bg-surface-800 border-t border-white/10 flex items-center justify-end">
              <button
                onClick={() => setReviewModalData(null)}
                className="btn-secondary !py-2 !px-5 !text-xs"
              >
                Close Review
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ============================================================ */}
      {/* 4. FULL SESSIONS MODAL */}
      {/* ============================================================ */}
      {showLiveSessionsModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm fade-in">
          <div className="w-full max-w-2xl glass-card border border-white/10 overflow-hidden shadow-2xl flex flex-col max-h-[85vh]">
            <div className="px-5 py-3.5 bg-surface-800 border-b border-white/10 flex items-center justify-between">
              <h3 className="text-sm font-bold text-white flex items-center gap-2">
                <span className="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-ping" />
                <span>All Cohort Submissions • {selectedSubject?.code}</span>
              </h3>
              <button
                onClick={() => setShowLiveSessionsModal(false)}
                className="w-7 h-7 flex items-center justify-center rounded-lg text-slate-400 hover:text-white hover:bg-surface-700"
              >
                ✕
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-5 divide-y divide-white/5 custom-scrollbar">
              {dbStudents.map((s) => {
                const sub = getStudentSubmission(s)
                return (
                  <div key={s.registration_number || s.id} className="py-2.5 flex items-center justify-between text-xs">
                    <div className="flex items-center gap-3">
                      <span className={`w-2 h-2 rounded-full ${sub ? 'bg-emerald-400' : 'bg-amber-400'}`} />
                      <div>
                        <p className="font-semibold text-slate-200">{s.name}</p>
                        <p className="text-[10px] text-slate-500 font-mono">{s.registration_number}</p>
                      </div>
                    </div>
                    {sub ? (
                      <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-emerald-500/15 text-emerald-300 border border-emerald-500/30">
                        Submitted ({sub.code?.split('\n').length || 1} lines)
                      </span>
                    ) : (
                      <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-amber-500/15 text-amber-300 border border-amber-500/30">
                        Pending
                      </span>
                    )}
                  </div>
                )
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
