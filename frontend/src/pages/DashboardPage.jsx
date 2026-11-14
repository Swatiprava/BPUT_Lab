import { useState, useEffect, useMemo } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  HiAcademicCap,
  HiChevronDown,
  HiBeaker,
  HiUserCircle,
  HiArrowRightOnRectangle,
  HiClock,
  HiCheckCircle,
  HiCodeBracket,
  HiCalendarDays,
} from 'react-icons/hi2'
import { subjectsAPI, experimentsAPI, submissionsAPI } from '../lib/api'
import { getExperimentSchedule, groupExperimentsByWeek, SUBJECT_SCHEDULES } from '../lib/schedule'
import { formatISTDateTime, formatISTFullWithDay } from '../lib/dateUtils'
import ReactMarkdown from 'react-markdown'

export default function DashboardPage({ user, onLogout }) {
  const navigate = useNavigate()
  const [subjects, setSubjects] = useState([])
  const [selectedSubject, setSelectedSubject] = useState(null)
  const [experiments, setExperiments] = useState([])
  const [selectedExperiment, setSelectedExperiment] = useState(null)
  const [submissions, setSubmissions] = useState({})
  const [loadingSubjects, setLoadingSubjects] = useState(true)
  const [loadingExperiments, setLoadingExperiments] = useState(false)
  const [subjectDropdownOpen, setSubjectDropdownOpen] = useState(false)
  const [showProfile, setShowProfile] = useState(false)

  // Fetch subjects for student's semester
  useEffect(() => {
    let cancelled = false
    const fetchSubjects = async () => {
      try {
        const response = await subjectsAPI.getAll(user.semester)
        if (cancelled) return
        setSubjects(response.data.subjects)
        if (response.data.subjects.length > 0) {
          setSelectedSubject((prev) => {
            if (prev && response.data.subjects.some((s) => s.id === prev.id)) return prev
            return response.data.subjects[0]
          })
        }
      } catch (err) {
        console.error('Failed to fetch subjects:', err)
      } finally {
        if (!cancelled) setLoadingSubjects(false)
      }
    }
    fetchSubjects()
    return () => { cancelled = true }
  }, [user.semester])

  // Fetch experiments when subject changes
  useEffect(() => {
    if (!selectedSubject) return
    let cancelled = false
    const fetchExperiments = async () => {
      setLoadingExperiments(true)
      try {
        const response = await experimentsAPI.getAll(selectedSubject.id)
        if (cancelled) return
        setExperiments(response.data.experiments)
        if (response.data.experiments.length > 0) {
          setSelectedExperiment((prev) => {
            if (prev && response.data.experiments.some((e) => e.id === prev.id)) return prev
            return response.data.experiments[0]
          })
        } else {
          setSelectedExperiment(null)
        }

        // Fetch submissions for all experiments
        const effectiveStudentId = user?.id || user?.student?.id || user?.student_id
        const subsResponse = await submissionsAPI.getAll(effectiveStudentId)
        if (cancelled) return
        const subsMap = {}
          ; (subsResponse.data.submissions || []).forEach((sub) => {
            subsMap[sub.experiment_id] = sub
          })
        setSubmissions(subsMap)
      } catch (err) {
        if (!cancelled) console.error('Failed to fetch experiments:', err)
      } finally {
        if (!cancelled) setLoadingExperiments(false)
      }
    }
    fetchExperiments()
    return () => { cancelled = true }
  }, [selectedSubject?.id, user.id])

  // Group experiments into 2 questions per week
  const weekGroups = useMemo(() => {
    return groupExperimentsByWeek(selectedSubject?.code, experiments)
  }, [selectedSubject?.code, experiments])

  // Active subject schedule metadata
  const subjectSchedule = selectedSubject ? SUBJECT_SCHEDULES[selectedSubject.code] : null

  // Active experiment schedule metadata
  const experimentSchedule = selectedExperiment && selectedSubject
    ? getExperimentSchedule(selectedSubject.code, selectedExperiment.experiment_number)
    : null

  const getStatusBadge = (experimentId) => {
    const sub = submissions[experimentId]
    if (!sub) return <span className="badge badge-pending"><HiClock className="w-3 h-3" />Pending</span>
    if (sub.status === 'submitted') return <span className="badge badge-submitted"><HiCheckCircle className="w-3 h-3" />Submitted</span>
    if (sub.status === 'evaluated') return <span className="badge badge-evaluated"><HiCheckCircle className="w-3 h-3" />Evaluated</span>
    return <span className="badge badge-pending"><HiClock className="w-3 h-3" />Pending</span>
  }

  return (
    <div className="flex h-screen overflow-hidden">
      {/* ===== LEFT SIDEBAR ===== */}
      <aside className="sidebar w-80 flex flex-col flex-shrink-0">
        {/* Logo */}
        <div className="p-4 border-b border-white/5">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-primary-500 to-accent-600 flex items-center justify-center">
              <HiAcademicCap className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="text-sm font-bold text-white">PPD Lab Platform</h1>
              <p className="text-[10px] text-slate-500">BPUT Rourkela • CSE Dept</p>
            </div>
          </div>
        </div>

        {/* Subject Dropdown */}
        <div className="p-3 pb-2">
          <div className="relative">
            <button
              id="subject-dropdown"
              onClick={() => setSubjectDropdownOpen(!subjectDropdownOpen)}
              className="w-full flex items-center justify-between gap-2 px-3 py-2.5 rounded-xl bg-surface-700 border border-white/5 text-sm text-slate-200 hover:border-primary-500/30 transition-all"
            >
              <span className="truncate font-medium">
                {selectedSubject ? selectedSubject.name : 'Choose Subject'}
              </span>
              <HiChevronDown className={`w-4 h-4 text-slate-400 transition-transform ${subjectDropdownOpen ? 'rotate-180' : ''}`} />
            </button>

            {subjectDropdownOpen && (
              <div className="absolute z-50 top-full left-0 right-0 mt-1 py-1 rounded-xl bg-surface-700 border border-white/10 shadow-xl fade-in">
                {subjects.map((subject) => {
                  const sSched = SUBJECT_SCHEDULES[subject.code]
                  return (
                    <button
                      key={subject.id}
                      onClick={() => {
                        setSelectedSubject(subject)
                        setSubjectDropdownOpen(false)
                      }}
                      className={`w-full text-left px-3 py-2 text-sm transition-colors ${selectedSubject?.id === subject.id
                          ? 'bg-primary-600/15 text-primary-300'
                          : 'text-slate-300 hover:bg-surface-600'
                        }`}
                    >
                      <div className="font-medium">{subject.name}</div>
                      <div className="text-[10px] text-slate-400 flex items-center justify-between mt-0.5">
                        <span>{subject.code} • {subject.language.toUpperCase()}</span>
                        {sSched && (
                          <span className="text-primary-400 font-semibold">{sSched.dayOfWeek}</span>
                        )}
                      </div>
                    </button>
                  )
                })}
              </div>
            )}
          </div>
        </div>

        {/* Subject Lab Schedule Card */}
        {subjectSchedule && (
          <div className="mx-3 mb-2 p-2.5 rounded-xl bg-surface-800/80 border border-white/5 space-y-1">
            <div className="flex items-center justify-between text-xs">
              <span className="font-semibold text-primary-300 flex items-center gap-1.5">
                <HiClock className="w-3.5 h-3.5 text-accent-400" />
                Every {subjectSchedule.dayOfWeek}
              </span>
              <span className="text-[10px] text-accent-300 font-mono bg-accent-500/10 px-1.5 py-0.5 rounded border border-accent-500/20">
                2 Questions / Week
              </span>
            </div>
            <div className="text-[11px] text-slate-400 flex items-center justify-between">
              <span>{subjectSchedule.timeSlot}</span>
              <span className="text-[10px] text-slate-500">{subjectSchedule.labRoom}</span>
            </div>
          </div>
        )}

        {/* Experiments List (Organized: 2 questions per week with exact dates) */}
        <div className="flex-1 overflow-y-auto px-3 pb-3 custom-scrollbar">
          <div className="flex items-center justify-between px-1 mb-2">
            <p className="text-[10px] uppercase tracking-wider text-slate-500 font-semibold">
              Weekly Lab Work ({experiments.length} Exps)
            </p>
            <span className="text-[10px] text-slate-500 font-mono">
              {weekGroups.length} Weeks
            </span>
          </div>

          {loadingExperiments ? (
            <div className="flex justify-center py-8">
              <div className="spinner" />
            </div>
          ) : (
            <div className="space-y-3">
              {weekGroups.map((week) => (
                <div key={week.weekNumber} className="space-y-1">
                  {/* Week Header with Date */}
                  <div className="flex items-center justify-between px-2.5 py-1 rounded-lg bg-surface-800/60 border border-white/5 text-[10px] font-mono">
                    <span className="font-bold text-primary-300 flex items-center gap-1.5">
                      <HiCalendarDays className="w-3 h-3 text-accent-400" />
                      WEEK {week.weekNumber}
                    </span>
                    <span className="text-slate-400 font-medium">
                      {week.dayOfWeek.slice(0, 3)}, {week.formattedDate}
                    </span>
                  </div>

                  {/* 2 Experiments for this week */}
                  {week.experiments.map((exp) => (
                    <button
                      key={exp.id}
                      onClick={() => setSelectedExperiment(exp)}
                      className={`exp-item w-full text-left ${selectedExperiment?.id === exp.id ? 'active' : ''}`}
                    >
                      <span className="flex items-center justify-center w-6 h-6 rounded-lg bg-surface-600 text-[10px] font-bold flex-shrink-0 text-slate-200">
                        Q{exp.schedule.questionIndexInWeek}
                      </span>
                      <div className="truncate flex-1 min-w-0">
                        <p className="truncate text-xs font-medium text-slate-200">{exp.title}</p>
                        <p className="text-[10px] text-slate-500">Exp {exp.experiment_number}</p>
                      </div>
                      {submissions[exp.id] && (
                        <span className={`w-2 h-2 rounded-full flex-shrink-0 ${submissions[exp.id].status === 'submitted' ? 'bg-success-400' :
                            submissions[exp.id].status === 'evaluated' ? 'bg-primary-400' :
                              'bg-warning-400'
                          }`} />
                      )}
                    </button>
                  ))}
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Profile Section */}
        <div className="p-3 border-t border-white/5">
          <button
            id="profile-toggle"
            onClick={() => setShowProfile(!showProfile)}
            className="w-full flex items-center gap-3 px-3 py-2 rounded-xl hover:bg-surface-700 transition-colors"
          >
            <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary-400 to-accent-500 flex items-center justify-center text-xs font-bold text-white">
              {user.name?.charAt(0)}
            </div>
            <div className="flex-1 text-left">
              <p className="text-sm font-medium text-white truncate">{user.name}</p>
              <p className="text-[10px] text-slate-500">{user.registration_number}</p>
            </div>
          </button>

          {showProfile && (
            <div className="mt-2 p-3 rounded-xl bg-surface-700 border border-white/5 fade-in space-y-2">
              <div className="text-xs text-slate-400">
                <span className="text-slate-500">Semester:</span> {user.semester}
              </div>
              <div className="text-xs text-slate-400">
                <span className="text-slate-500">Username:</span> {user.username}
              </div>
              <button
                onClick={onLogout}
                className="w-full flex items-center gap-2 px-3 py-2 mt-2 rounded-lg text-sm text-danger-400 hover:bg-danger-500/10 transition-colors"
              >
                <HiArrowRightOnRectangle className="w-4 h-4" />
                Sign Out
              </button>
            </div>
          )}
        </div>
      </aside>

      {/* ===== MAIN CONTENT ===== */}
      <main className="flex-1 flex flex-col overflow-hidden bg-mesh">
        {/* Top Header */}
        {selectedExperiment && (
          <>
            <header className="flex items-center justify-between px-8 py-4 border-b border-white/5 bg-surface-900/50 backdrop-blur-sm">
              <div>
                <div className="flex items-center gap-2 mb-1 flex-wrap">
                  <span className="text-xs font-semibold text-primary-400">
                    {selectedSubject?.code}
                  </span>
                  <span className="text-xs text-slate-600">•</span>
                  <span className="text-xs text-slate-400 font-medium">
                    Experiment {selectedExperiment.experiment_number}
                  </span>
                  {experimentSchedule && (
                    <>
                      <span className="text-xs text-slate-600">•</span>
                      <span className="px-2 py-0.5 rounded bg-primary-500/10 text-primary-300 text-[11px] font-mono border border-primary-500/20 font-medium">
                        Week {experimentSchedule.weekNumber} (Question {experimentSchedule.questionIndexInWeek} of 2)
                      </span>
                      <span className="px-2 py-0.5 rounded bg-surface-700 text-accent-300 text-[11px] font-mono border border-white/5">
                        📅 {experimentSchedule.fullDateStr}
                      </span>
                    </>
                  )}
                </div>
                <h2 className="text-xl font-bold text-white">
                  {selectedExperiment.title}
                </h2>
              </div>

              <div className="flex items-center gap-4">
                <div className="text-right">
                  {submissions[selectedExperiment.id] ? (
                    <div className="space-y-1">
                      <div className="flex items-center justify-end gap-1.5 text-xs font-mono text-emerald-400 font-semibold">
                        <HiCheckCircle className="w-4 h-4 text-emerald-400 flex-shrink-0" />
                        <span>Submitted: {formatISTDateTime(submissions[selectedExperiment.id]?.submitted_at) || 'Recorded in Database'}</span>
                      </div>
                      <div className="flex justify-end">
                        {getStatusBadge(selectedExperiment.id)}
                      </div>
                    </div>
                  ) : (
                    <div className="space-y-1">
                      <div className="flex items-center justify-end gap-1.5 text-xs font-mono text-amber-400">
                        <HiClock className="w-3.5 h-3.5 text-amber-400 flex-shrink-0" />
                        <span>Not Submitted Yet</span>
                      </div>
                      <div className="flex justify-end">
                        {getStatusBadge(selectedExperiment.id)}
                      </div>
                    </div>
                  )}
                </div>

                <button
                  id="open-code-lab"
                  onClick={() => navigate(`/lab/${selectedExperiment.id}`)}
                  className="btn-primary"
                >
                  <span className="flex items-center gap-2">
                    <HiCodeBracket className="w-4 h-4" />
                    Open Code Lab
                  </span>
                </button>
              </div>
            </header>

            {/* Experiment Description */}
            <div className="flex-1 overflow-y-auto p-8 fade-in">
              <div className="max-w-4xl">
                <div className="glass-card p-8">
                  <div className="prose prose-invert max-w-none">
                    <ReactMarkdown
                      components={{
                        h1: ({ node, ...props }) => (
                          <h1 className="text-2xl font-extrabold text-white mt-2 mb-4 pb-3 border-b border-white/10" {...props} />
                        ),
                        h2: ({ node, ...props }) => (
                          <h2 className="text-lg font-bold text-primary-300 mt-6 mb-3 flex items-center gap-2 border-l-2 border-primary-500 pl-2.5" {...props} />
                        ),
                        h3: ({ node, ...props }) => (
                          <h3 className="text-base font-semibold text-slate-200 mt-4 mb-2" {...props} />
                        ),
                        p: ({ node, ...props }) => (
                          <p className="text-sm text-slate-300 mb-3 leading-relaxed" {...props} />
                        ),
                        ul: ({ node, ...props }) => (
                          <ul className="list-disc list-outside pl-5 space-y-1.5 text-sm text-slate-300 mb-3" {...props} />
                        ),
                        ol: ({ node, ...props }) => (
                          <ol className="list-decimal list-outside pl-5 space-y-1.5 text-sm text-slate-300 mb-3" {...props} />
                        ),
                        li: ({ node, ...props }) => (
                          <li className="text-slate-300 leading-relaxed" {...props} />
                        ),
                        code: ({ node, inline, className, children, ...props }) => {
                          if (inline) {
                            return (
                              <code className="px-1.5 py-0.5 rounded bg-surface-700 text-accent-300 text-xs font-mono font-medium border border-white/5" {...props}>
                                {children}
                              </code>
                            )
                          }
                          return (
                            <div className="my-3 rounded-xl overflow-hidden border border-white/10 bg-[#0d1117]">
                              <div className="flex items-center justify-between px-3 py-1.5 bg-surface-800/80 border-b border-white/5 text-[11px] text-slate-400 font-mono">
                                <span>Code / Specification</span>
                              </div>
                              <pre className="p-3.5 text-xs text-slate-200 font-mono overflow-x-auto leading-relaxed">
                                <code {...props}>{children}</code>
                              </pre>
                            </div>
                          )
                        },
                        blockquote: ({ node, ...props }) => (
                          <blockquote className="p-3.5 my-3 rounded-xl bg-primary-900/20 border-l-4 border-primary-500 text-slate-300 text-sm" {...props} />
                        ),
                        table: ({ node, ...props }) => (
                          <div className="overflow-x-auto my-4 rounded-xl border border-white/10">
                            <table className="w-full text-left text-xs text-slate-300" {...props} />
                          </div>
                        ),
                        thead: ({ node, ...props }) => (
                          <thead className="bg-surface-700/80 text-white font-semibold uppercase text-[11px]" {...props} />
                        ),
                        th: ({ node, ...props }) => (
                          <th className="px-3 py-2.5 border-b border-white/10 font-semibold" {...props} />
                        ),
                        td: ({ node, ...props }) => (
                          <td className="px-3 py-2 border-b border-white/5" {...props} />
                        ),
                      }}
                    >
                      {selectedExperiment.description || '*No manual description available.*'}
                    </ReactMarkdown>
                  </div>
                </div>

                {/* Quick Info Cards */}
                <div className="grid grid-cols-3 gap-4 mt-6">
                  <div className="glass-card p-4">
                    <p className="text-[10px] uppercase tracking-wider text-slate-500 mb-1">Language</p>
                    <p className="text-lg font-bold text-primary-400">
                      {selectedSubject?.language?.toUpperCase()}
                    </p>
                  </div>
                  <div className="glass-card p-4">
                    <p className="text-[10px] uppercase tracking-wider text-slate-500 mb-1">Subject</p>
                    <p className="text-sm font-medium text-slate-200 truncate">
                      {selectedSubject?.name}
                    </p>
                  </div>
                  <div className="glass-card p-4">
                    <p className="text-[10px] uppercase tracking-wider text-slate-500 mb-1">Status</p>
                    <div className="space-y-1">
                      {getStatusBadge(selectedExperiment.id)}
                      {submissions[selectedExperiment.id]?.submitted_at && (
                        <p className="text-[11px] font-mono text-emerald-400 font-semibold pt-1">
                          {formatISTDateTime(submissions[selectedExperiment.id]?.submitted_at)}
                        </p>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </>
        )}

        {!selectedExperiment && !loadingExperiments && (
          <div className="flex-1 flex items-center justify-center">
            <div className="text-center">
              <HiBeaker className="w-16 h-16 text-slate-600 mx-auto mb-4" />
              <h3 className="text-lg font-semibold text-slate-400">Select an experiment</h3>
              <p className="text-sm text-slate-500 mt-1">
                Choose a subject and experiment from the sidebar
              </p>
            </div>
          </div>
        )}

        {loadingSubjects && (
          <div className="flex-1 flex items-center justify-center">
            <div className="text-center">
              <div className="spinner mx-auto mb-4" style={{ width: 32, height: 32 }} />
              <p className="text-sm text-slate-400">Loading subjects...</p>
            </div>
          </div>
        )}
      </main>
    </div>
  )
}
