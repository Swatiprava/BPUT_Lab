import { useState, useEffect, useRef } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import Editor from '@monaco-editor/react'
import ReactMarkdown from 'react-markdown'
import {
  HiPlay,
  HiPaperAirplane,
  HiArrowLeft,
  HiCommandLine,
  HiCheckCircle,
  HiXCircle,
  HiClock,
  HiChevronDown,
  HiBookOpen,
  HiLightBulb,
  HiClipboardDocumentCheck,
  HiArrowPath,
  HiDocumentDuplicate,
  HiTrash,
  HiCalendarDays,
} from 'react-icons/hi2'
import { experimentsAPI, codeAPI, submissionsAPI } from '../lib/api'
import { getExperimentSchedule } from '../lib/schedule'

// Language to Monaco language mapping
const MONACO_LANG_MAP = {
  c: 'c',
  'c++': 'cpp',
  cpp: 'cpp',
  java: 'java',
  python: 'python',
  python3: 'python',
  sql: 'sql',
  mysql: 'sql',
  bash: 'shell',
  shell: 'shell',
  javascript: 'javascript',
}

// Language boilerplate defaults
const DEFAULT_CODE = {
  c: '#include <stdio.h>\n\nint main() {\n    printf("Hello, World!\\n");\n    return 0;\n}',
  java: 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}',
  python: '# Write your code here\nprint("Hello, World!")',
  sql: '-- Write your SQL queries here\nSELECT 1;',
  mysql: '-- Write your MySQL queries here\nSELECT 1;',
}

export default function CodeLabPage({ user }) {
  const { experimentId } = useParams()
  const navigate = useNavigate()
  const editorRef = useRef(null)
  const consoleEndRef = useRef(null)
  const inlineInputRef = useRef(null)
  const bottomInputRef = useRef(null)

  const [experiment, setExperiment] = useState(null)
  const [code, setCode] = useState('')
  const [language, setLanguage] = useState('python')
  const [stdin, setStdin] = useState('')
  const [output, setOutput] = useState('')
  const [consoleLog, setConsoleLog] = useState([])  // Array of {type, text, ...} entries
  const [outputType, setOutputType] = useState('') // 'success', 'error', 'info'
  const [running, setRunning] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [loading, setLoading] = useState(true)
  const [executionTime, setExecutionTime] = useState(null)
  const [executionMemory, setExecutionMemory] = useState(null)
  const [copied, setCopied] = useState(false)
  const [activeTab, setActiveTab] = useState('terminal') // 'problems', 'output', 'terminal'

  // Interactive input states
  const [waitingForInput, setWaitingForInput] = useState(false)
  const [currentPromptText, setCurrentPromptText] = useState('')
  const [activeInputVal, setActiveInputVal] = useState('')
  const [bottomInputVal, setBottomInputVal] = useState('')
  const [allPrompts, setAllPrompts] = useState([])        // All prompts for multi-input programs
  const [collectedInputs, setCollectedInputs] = useState([]) // Inputs collected so far

  // Build the prompt based on language
  const getPrompt = () => {
    const langMap = { c: 'C', 'c++': 'CPP', cpp: 'CPP', java: 'JAVA', python: 'PYTHON', python3: 'PYTHON', sql: 'SQL', mysql: 'MYSQL' }
    return `C:\\BPUT\\LAB\\${langMap[language] || language.toUpperCase()}>`
  }

  const getLangDisplayName = () => {
    const map = { c: 'C', 'c++': 'C++', cpp: 'C++', java: 'Java', python: 'Python', python3: 'Python', sql: 'SQL', mysql: 'MySQL' }
    return map[language] || language.toUpperCase()
  }

  // Detect if source code contains input operations
  const codeRequiresInput = (src, lang) => {
    if (!src) return false
    const l = (lang || '').toLowerCase()
    if (l === 'c' || l === 'cpp' || l === 'c++') {
      return /\b(scanf|cin|gets|fgets|getchar|getch|getline)\b/.test(src)
    }
    if (l === 'python' || l === 'python3') {
      return /\b(input|sys\.stdin)\b/.test(src)
    }
    if (l === 'java') {
      return /\b(Scanner|BufferedReader|System\.in|readln|readLine)\b/.test(src)
    }
    return /\b(scanf|cin|input|readline)\b/i.test(src)
  }

  // Extract prompt string like "Enter a string containing only a and b: "
  const extractInputPrompt = (src, lang) => {
    if (!src) return 'Enter your input: '
    const l = (lang || '').toLowerCase()

    if (l === 'c' || l === 'cpp' || l === 'c++') {
      const inputIdx = src.search(/\b(scanf|cin|gets|fgets|getchar|getch|getline)\b/)
      const textBeforeInput = inputIdx !== -1 ? src.slice(0, inputIdx) : src

      const printfRegex = /printf\s*\(\s*"([^"\\]*(?:\\.[^"\\]*)*)"\s*\)/g
      const matches = [...textBeforeInput.matchAll(printfRegex)]
      if (matches.length > 0) {
        const lastMatch = matches[matches.length - 1]
        let p = lastMatch[1].replace(/\\n/g, '').replace(/\\t/g, ' ').trim()
        if (p) {
          if (!p.endsWith(':') && !p.endsWith('?') && !p.endsWith('>')) p += ':'
          return p + ' '
        }
      }

      const coutRegex = /cout\s*<<\s*"([^"\\]*(?:\\.[^"\\]*)*)"/g
      const coutMatches = [...textBeforeInput.matchAll(coutRegex)]
      if (coutMatches.length > 0) {
        const lastMatch = coutMatches[coutMatches.length - 1]
        let p = lastMatch[1].replace(/\\n/g, '').replace(/\\t/g, ' ').trim()
        if (p) {
          if (!p.endsWith(':') && !p.endsWith('?') && !p.endsWith('>')) p += ':'
          return p + ' '
        }
      }
    } else if (l === 'python' || l === 'python3') {
      const pyRegex = /input\s*\(\s*["']([^"'\\]*(?:\\.[^"'\\]*)*)["']\s*\)/g
      const matches = [...src.matchAll(pyRegex)]
      if (matches.length > 0) {
        let p = matches[0][1].replace(/\\n/g, '').trim()
        if (p) {
          if (!p.endsWith(':') && !p.endsWith('?') && !p.endsWith('>')) p += ':'
          return p + ' '
        }
      }
    } else if (l === 'java') {
      const inputIdx = src.search(/\b(Scanner|BufferedReader|System\.in|next|readLine)\b/)
      const textBeforeInput = inputIdx !== -1 ? src.slice(0, inputIdx) : src
      const javaRegex = /System\.out\.print(?:ln)?\s*\(\s*"([^"\\]*(?:\\.[^"\\]*)*)"\s*\)/g
      const matches = [...textBeforeInput.matchAll(javaRegex)]
      if (matches.length > 0) {
        const lastMatch = matches[matches.length - 1]
        let p = lastMatch[1].replace(/\\n/g, '').trim()
        if (p) {
          if (!p.endsWith(':') && !p.endsWith('?') && !p.endsWith('>')) p += ':'
          return p + ' '
        }
      }
    }

    return 'Enter your input: '
  }

  // Extract ALL input prompts from source code (for multi-input programs)
  const extractAllInputPrompts = (src, lang) => {
    if (!src) return ['Enter your input: ']
    const l = (lang || '').toLowerCase()
    const prompts = []

    if (l === 'c' || l === 'cpp' || l === 'c++') {
      const inputRegex = /\b(scanf|cin\s*>>|gets|fgets|getchar|getch|getline)\b/g
      const inputPositions = []
      let m
      while ((m = inputRegex.exec(src)) !== null) {
        inputPositions.push(m.index)
      }

      let lastEnd = 0
      for (const inputIdx of inputPositions) {
        const segment = src.slice(lastEnd, inputIdx)
        let found = false

        // Check printf in this segment
        const printfRegex = /printf\s*\(\s*"([^"\\]*(?:\\.[^"\\]*)*)"\s*\)/g
        const printfMatches = [...segment.matchAll(printfRegex)]
        if (printfMatches.length > 0) {
          let p = printfMatches[printfMatches.length - 1][1].replace(/\\n/g, '').replace(/\\t/g, ' ').trim()
          if (p) {
            if (!p.endsWith(':') && !p.endsWith('?') && !p.endsWith('>')) p += ':'
            prompts.push(p + ' ')
            found = true
          }
        }

        // Check cout for C++
        if (!found) {
          const coutRegex = /cout\s*<<\s*"([^"\\]*(?:\\.[^"\\]*)*)"/g
          const coutMatches = [...segment.matchAll(coutRegex)]
          if (coutMatches.length > 0) {
            let p = coutMatches[coutMatches.length - 1][1].replace(/\\n/g, '').replace(/\\t/g, ' ').trim()
            if (p) {
              if (!p.endsWith(':') && !p.endsWith('?') && !p.endsWith('>')) p += ':'
              prompts.push(p + ' ')
              found = true
            }
          }
        }

        if (!found) prompts.push(`Enter input ${prompts.length + 1}: `)
        lastEnd = inputIdx
      }
    } else if (l === 'python' || l === 'python3') {
      const pyRegex = /input\s*\(\s*(?:["']([^"'\\]*(?:\\.[^"'\\]*)*)["'])?\s*\)/g
      let m
      while ((m = pyRegex.exec(src)) !== null) {
        if (m[1]) {
          let p = m[1].replace(/\\n/g, '').trim()
          if (!p.endsWith(':') && !p.endsWith('?') && !p.endsWith('>')) p += ':'
          prompts.push(p + ' ')
        } else {
          prompts.push(`Enter input ${prompts.length + 1}: `)
        }
      }
    } else if (l === 'java') {
      const inputRegex = /\.(next\w*|readLine)\s*\(\s*\)/g
      const inputPositions = []
      let m
      while ((m = inputRegex.exec(src)) !== null) {
        inputPositions.push(m.index)
      }

      let lastEnd = 0
      for (const inputIdx of inputPositions) {
        const segment = src.slice(lastEnd, inputIdx)
        const javaRegex = /System\.out\.print(?:ln)?\s*\(\s*"([^"\\]*(?:\\.[^"\\]*)*)"\s*\)/g
        const matches = [...segment.matchAll(javaRegex)]
        if (matches.length > 0) {
          let p = matches[matches.length - 1][1].replace(/\\n/g, '').trim()
          if (p) {
            if (!p.endsWith(':') && !p.endsWith('?') && !p.endsWith('>')) p += ':'
            prompts.push(p + ' ')
          } else {
            prompts.push(`Enter input ${prompts.length + 1}: `)
          }
        } else {
          prompts.push(`Enter input ${prompts.length + 1}: `)
        }
        lastEnd = inputIdx
      }
    }

    return prompts.length > 0 ? prompts : ['Enter your input: ']
  }

  // Auto-scroll console to bottom
  useEffect(() => {
    consoleEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [consoleLog, waitingForInput])

  // Fetch experiment details and load starter code
  useEffect(() => {
    let cancelled = false
    const fetchExperiment = async () => {
      try {
        const response = await experimentsAPI.getById(experimentId)
        if (cancelled) return
        const exp = response.data.experiment
        setExperiment(exp)

        const lang = exp.subjects?.language || 'python'
        setLanguage(lang)

        // Check for existing submission, otherwise keep full blank
        try {
          const effectiveStudentId = user?.id || user?.student?.id || user?.student_id
          const subsResponse = await submissionsAPI.getAll(effectiveStudentId, experimentId)
          if (cancelled) return
          if (subsResponse.data.submissions.length > 0) {
            setCode(subsResponse.data.submissions[0].code)
          } else {
            setCode('')
          }
        } catch {
          if (!cancelled) setCode('')
        }
      } catch (err) {
        console.error('Failed to fetch experiment:', err)
      } finally {
        if (!cancelled) setLoading(false)
      }
    }
    fetchExperiment()
    return () => { cancelled = true }
  }, [experimentId, user?.id])

  // Execute program on backend with stdin
  const executeProgram = async (stdinData = '', promptsToClean = []) => {
    setRunning(true)
    setOutputType('info')
    const startTime = Date.now()

    try {
      const response = await codeAPI.run(code, language, stdinData)
      const result = response.data
      const elapsed = ((Date.now() - startTime) / 1000).toFixed(2)
      const timeTaken = result.time || elapsed
      const memoryUsed = result.memory ? `${(result.memory / 1024).toFixed(1)} MB` : '2.0 MB'

      const resultEntries = []

      if (result.compile_output) {
        resultEntries.push({ type: 'error', text: result.compile_output })
      }

      if (result.stdout) {
        let cleanStdout = result.stdout
        // Clean prompt strings from stdout (supports single string or array)
        const prompts = Array.isArray(promptsToClean) ? promptsToClean : (promptsToClean ? [promptsToClean] : [])
        for (const p of prompts) {
          const target = p.trim()
          if (target) {
            // Remove all occurrences of the prompt text
            while (cleanStdout.includes(target)) {
              cleanStdout = cleanStdout.replace(target, '')
            }
          }
        }
        cleanStdout = cleanStdout.replace(/^[\s\r\n]+/, '')

        if (cleanStdout.trim()) {
          resultEntries.push({ type: 'stdout', text: cleanStdout.trimEnd() })
        }
      }

      if (result.stderr) {
        resultEntries.push({ type: 'warn', text: result.stderr })
      }

      const isAccepted = result.status === 'Accepted'
      setOutputType(isAccepted ? 'success' : 'error')

      resultEntries.push({
        type: isAccepted ? 'status-success' : 'status-error',
        text: `${isAccepted ? '✓' : '✗'} ${result.status} | ${timeTaken}s | ${memoryUsed}`
      })

      setExecutionTime(timeTaken)
      setExecutionMemory(result.memory || 2048)
      setOutput(result.stdout || result.compile_output || result.stderr || '')
      setConsoleLog(prev => [...prev, ...resultEntries])
    } catch (err) {
      setOutputType('error')
      const errDetail = err.response?.data?.detail || err.message || 'Execution failed'
      setOutput(`Error: ${errDetail}`)
      setConsoleLog(prev => [
        ...prev,
        { type: 'error', text: `Error: ${errDetail}` },
        { type: 'status-error', text: `✗ Failed | 0.00s | N/A` }
      ])
    } finally {
      setRunning(false)
      setTimeout(() => {
        bottomInputRef.current?.focus()
      }, 50)
    }
  }

  // Handle Run button click
  const handleRun = async () => {
    setActiveTab('terminal')
    if (running) return

    // If code expects input, prompt for input first!
    if (codeRequiresInput(code, language)) {
      const prompts = extractAllInputPrompts(code, language)
      setAllPrompts(prompts)
      setCollectedInputs([])
      setCurrentPromptText(prompts[0])
      setWaitingForInput(true)
      setActiveInputVal('')
      setBottomInputVal('')

      const runCommand = `$ run ${language === 'python' ? 'python' : language === 'java' ? 'java' : 'c'}`
      setConsoleLog(prev => [
        ...prev,
        { type: 'cmd', text: runCommand },
        { type: 'prompt-wait', prompt: prompts[0] }
      ])

      setTimeout(() => {
        inlineInputRef.current?.focus()
      }, 50)
      return
    }

    // Otherwise run directly without waiting for input
    const runCommand = `$ run ${language === 'python' ? 'python' : language === 'java' ? 'java' : 'c'}`
    setConsoleLog(prev => [
      ...prev,
      { type: 'cmd', text: runCommand }
    ])
    await executeProgram('', '')
  }

  // Handle input submission from inline prompt or bottom prompt
  const handleInputSubmit = async (val) => {
    const inputVal = (val !== undefined ? val : (activeInputVal || bottomInputVal)).trim()

    if (waitingForInput) {
      const promptText = currentPromptText
      setActiveInputVal('')
      setBottomInputVal('')

      // Convert prompt-wait entry into completed input-line
      setConsoleLog(prev => {
        const updated = [...prev]
        for (let i = updated.length - 1; i >= 0; i--) {
          if (updated[i].type === 'prompt-wait') {
            updated[i] = {
              type: 'input-line',
              prompt: promptText,
              input: inputVal
            }
            break
          }
        }
        return updated
      })

      // Add to collected inputs
      const newCollected = [...collectedInputs, inputVal]
      setCollectedInputs(newCollected)

      const nextIndex = newCollected.length
      if (nextIndex < allPrompts.length) {
        // More inputs needed — show next prompt
        const nextPrompt = allPrompts[nextIndex]
        setCurrentPromptText(nextPrompt)
        setConsoleLog(prev => [
          ...prev,
          { type: 'prompt-wait', prompt: nextPrompt }
        ])
        setTimeout(() => {
          inlineInputRef.current?.focus()
        }, 50)
        return
      }

      // All inputs collected — execute with all inputs joined by newlines
      setWaitingForInput(false)
      const allInputs = newCollected.join('\n')
      await executeProgram(allInputs, allPrompts)
    } else {
      const cmd = inputVal
      setBottomInputVal('')
      if (!cmd) return

      if (cmd.toLowerCase() === 'clear' || cmd.toLowerCase() === 'cls') {
        setConsoleLog([])
        setOutput('')
        return
      }

      if (cmd.toLowerCase() === 'run' || cmd.toLowerCase() === `run ${language}`) {
        handleRun()
        return
      }

      // If user typed input directly at '>', e.g. "aab"
      if (codeRequiresInput(code, language)) {
        const prompts = extractAllInputPrompts(code, language)
        const runCommand = `$ run ${language === 'python' ? 'python' : language === 'java' ? 'java' : 'c'}`

        if (prompts.length > 1) {
          // Multiple inputs needed — start sequential input flow
          setAllPrompts(prompts)
          setCollectedInputs([cmd])
          setConsoleLog(prev => [
            ...prev,
            { type: 'cmd', text: runCommand },
            { type: 'input-line', prompt: prompts[0], input: cmd }
          ])

          const nextPrompt = prompts[1]
          setCurrentPromptText(nextPrompt)
          setWaitingForInput(true)
          setActiveInputVal('')
          setConsoleLog(prev => [
            ...prev,
            { type: 'prompt-wait', prompt: nextPrompt }
          ])
          setTimeout(() => {
            inlineInputRef.current?.focus()
          }, 50)
          return
        }

        // Single input — execute immediately
        const promptText = prompts[0]
        setConsoleLog(prev => [
          ...prev,
          { type: 'cmd', text: runCommand },
          { type: 'input-line', prompt: promptText, input: cmd }
        ])
        await executeProgram(cmd, prompts)
        return
      }

      const runCommand = `$ run ${language === 'python' ? 'python' : language === 'java' ? 'java' : 'c'}`
      setConsoleLog(prev => [
        ...prev,
        { type: 'cmd', text: runCommand }
      ])
      await executeProgram(cmd, '')
    }
  }

  // Submit code
  const handleSubmit = async () => {
    setSubmitting(true)
    const effectiveStudentId = user?.id || user?.student?.id || user?.student_id
    const effectiveOutput = output || consoleLog.map(e => e.text || (e.input ? `${e.prompt} ${e.input}` : '')).filter(Boolean).join('\n')
    try {
      await submissionsAPI.create({
        student_id: effectiveStudentId,
        experiment_id: experimentId,
        code: code,
        output: effectiveOutput,
        status: 'submitted',
      })
      setOutputType('success')
      setConsoleLog(prev => [
        ...prev,
        { type: 'status-success', text: '✓ Code submitted successfully!' }
      ])
    } catch (err) {
      setOutputType('error')
      const errDetail = err.response?.data?.detail || err.message
      setConsoleLog(prev => [
        ...prev,
        { type: 'error', text: `Submission failed: ${errDetail}` }
      ])
    } finally {
      setSubmitting(false)
    }
  }

  // Clear code / reset to full blank
  const handleClearCode = () => {
    setCode('')
    if (editorRef.current) {
      editorRef.current.setValue('')
    }
  }

  // Copy current code
  const handleCopyCode = () => {
    navigator.clipboard.writeText(code)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  // Define custom full-black theme before Monaco mounts
  const handleBeforeMount = (monaco) => {
    monaco.editor.defineTheme('full-black', {
      base: 'vs-dark',
      inherit: true,
      rules: [
        { background: '000000' },
      ],
      colors: {
        'editor.background': '#000000',
        'editorGutter.background': '#000000',
        'editor.lineHighlightBackground': '#0a0a0a',
        'editorLineNumber.foreground': '#484f58',
        'editorLineNumber.activeForeground': '#c9d1d9',
        'editorIndentGuide.background': '#161b22',
        'editorIndentGuide.activeBackground': '#30363d',
      },
    })
  }

  // Editor mount handler
  const handleEditorDidMount = (editor) => {
    editorRef.current = editor
  }

  if (loading) {
    return (
      <div className="h-screen flex items-center justify-center bg-surface-900">
        <div className="text-center">
          <div className="spinner mx-auto mb-4" style={{ width: 32, height: 32 }} />
          <p className="text-sm text-slate-400">Loading experiment...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="h-screen flex flex-col overflow-hidden bg-surface-900">
      {/* ===== TOP TOOLBAR ===== */}
      <header className="flex items-center justify-between px-4 py-2 bg-surface-800 border-b border-white/5 flex-shrink-0">
        <div className="flex items-center gap-3">
          {/* Back button */}
          <button
            id="back-to-dashboard"
            onClick={() => navigate('/dashboard')}
            className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg text-sm text-slate-400 hover:text-white hover:bg-surface-700 transition-all"
          >
            <HiArrowLeft className="w-4 h-4" />
            Back
          </button>

          <div className="w-px h-6 bg-white/10" />

          {/* Experiment info */}
          <div className="flex items-center gap-2 flex-wrap">
            <span className="text-xs text-primary-400 font-semibold">
              {experiment?.subjects?.code}
            </span>
            <span className="text-xs text-slate-500">•</span>
            <span className="text-sm text-white font-medium">
              Exp {experiment?.experiment_number}: {experiment?.title}
            </span>
            {experiment?.subjects?.code && experiment?.experiment_number && (
              (() => {
                const sched = getExperimentSchedule(experiment.subjects.code, experiment.experiment_number)
                return (
                  <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-surface-700 text-primary-300 text-[11px] font-mono border border-white/5 font-medium ml-1">
                    <HiCalendarDays className="w-3.5 h-3.5 text-accent-400" />
                    Week {sched.weekNumber} (Q{sched.questionIndexInWeek}/2) • {sched.formattedDate}
                  </span>
                )
              })()
            )}
          </div>
        </div>

        <div className="flex items-center gap-2">
          {/* Language indicator */}
          <span className="px-2.5 py-1 rounded-lg bg-surface-700 text-xs font-medium text-accent-400 border border-white/5">
            {language.toUpperCase()}
          </span>

          {/* Run Button */}
          <button
            id="run-code"
            onClick={handleRun}
            disabled={running}
            className="btn-primary !py-2 !px-4 !text-sm"
          >
            <span className="flex items-center gap-1.5">
              {running ? (
                <>
                  <div className="spinner" style={{ width: 14, height: 14 }} />
                  Running...
                </>
              ) : (
                <>
                  <HiPlay className="w-4 h-4" />
                  Run
                </>
              )}
            </span>
          </button>

          {/* Submit Button */}
          <button
            id="submit-code"
            onClick={handleSubmit}
            disabled={submitting || !code.trim()}
            className="btn-success !py-2 !px-4 !text-sm"
          >
            <span className="flex items-center gap-1.5">
              {submitting ? (
                <>
                  <div className="spinner" style={{ width: 14, height: 14 }} />
                  Submitting...
                </>
              ) : (
                <>
                  <HiPaperAirplane className="w-4 h-4" />
                  Submit
                </>
              )}
            </span>
          </button>
        </div>
      </header>

      {/* ===== MAIN CONTENT — SPLIT PANELS ===== */}
      <div className="flex-1 flex overflow-hidden">
        {/* LEFT PANEL — Lab Manual */}
        <div className="w-[42%] flex flex-col border-r border-white/5 overflow-hidden" style={{ minWidth: 340 }}>
          <div className="px-4 py-3 border-b border-white/5 bg-surface-800/80 flex items-center justify-between flex-shrink-0">
            <h3 className="text-sm font-semibold text-slate-200 flex items-center gap-2">
              <HiBookOpen className="w-4 h-4 text-primary-400" />
              <span>Lab Manual &amp; Experiment Guide</span>
            </h3>
            <span className="text-[11px] font-medium px-2 py-0.5 rounded-full bg-primary-500/10 text-primary-400 border border-primary-500/20">
              BPUT CSE Syllabus
            </span>
          </div>

          <div className="flex-1 overflow-y-auto p-5 space-y-4 custom-scrollbar">
            <ReactMarkdown
              components={{
                h1: ({ node, ...props }) => (
                  <h1 className="text-xl font-bold text-white mb-3 pb-2 border-b border-white/10" {...props} />
                ),
                h2: ({ node, ...props }) => (
                  <h2 className="text-base font-semibold text-primary-300 mt-6 mb-2.5 flex items-center gap-2" {...props} />
                ),
                h3: ({ node, ...props }) => (
                  <h3 className="text-sm font-semibold text-slate-200 mt-4 mb-2" {...props} />
                ),
                p: ({ node, ...props }) => (
                  <p className="text-slate-300 text-sm leading-relaxed mb-3" {...props} />
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
                        <span>code / sample data</span>
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
                  <th className="px-3 py-2.5 border-b border-white/10" {...props} />
                ),
                td: ({ node, ...props }) => (
                  <td className="px-3 py-2 border-b border-white/5" {...props} />
                ),
              }}
            >
              {experiment?.description || '*No manual description available.*'}
            </ReactMarkdown>
          </div>
        </div>

        {/* RIGHT PANEL — Code Editor + Terminal */}
        <div className="flex-1 flex flex-col overflow-hidden bg-surface-900">
          {/* Editor Header / Action Bar */}
          <div className="flex items-center justify-between px-4 py-2 bg-black border-b border-white/10 flex-shrink-0">
            <div className="flex items-center gap-2">
              <span className="text-[11px] font-mono font-semibold px-2 py-0.5 rounded bg-surface-800 text-accent-300 border border-white/10">
                {MONACO_LANG_MAP[language]?.toUpperCase() || language.toUpperCase()}
              </span>
              <span className="text-[11px] text-slate-500 font-mono">
                {code.split('\n').length} lines • {code.length} chars
              </span>
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={handleClearCode}
                title="Clear code editor to blank"
                className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs text-slate-400 hover:text-white hover:bg-surface-800 transition-colors"
              >
                <HiTrash className="w-3.5 h-3.5" />
                Clear Editor
              </button>

              <button
                onClick={handleCopyCode}
                title="Copy code to clipboard"
                className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs text-slate-400 hover:text-white hover:bg-surface-800 transition-colors"
              >
                {copied ? (
                  <>
                    <HiCheckCircle className="w-3.5 h-3.5 text-success-400" />
                    <span className="text-success-400">Copied!</span>
                  </>
                ) : (
                  <>
                    <HiDocumentDuplicate className="w-3.5 h-3.5" />
                    Copy
                  </>
                )}
              </button>
            </div>
          </div>

          {/* Monaco Code Editor */}
          <div className="flex-1 overflow-hidden bg-black" style={{ minHeight: '45%' }}>
            <Editor
              height="100%"
              language={MONACO_LANG_MAP[language] || 'plaintext'}
              value={code}
              onChange={(value) => setCode(value || '')}
              beforeMount={handleBeforeMount}
              onMount={handleEditorDidMount}
              theme="full-black"
              options={{
                fontSize: 14,
                fontFamily: "'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace",
                fontLigatures: true,
                minimap: { enabled: false },
                scrollBeyondLastLine: false,
                wordWrap: 'on',
                padding: { top: 12, bottom: 12 },
                lineNumbers: 'on',
                renderLineHighlight: 'all',
                bracketPairColorization: { enabled: true },
                automaticLayout: true,
                tabSize: 4,
                smoothScrolling: true,
                cursorBlinking: 'smooth',
                cursorSmoothCaretAnimation: 'on',
                // Disable all autocomplete & suggestions
                quickSuggestions: false,
                suggestOnTriggerCharacters: false,
                acceptSuggestionOnEnter: 'off',
                tabCompletion: 'off',
                wordBasedSuggestions: 'off',
                snippetSuggestions: 'none',
                parameterHints: { enabled: false },
                suggest: {
                  showWords: false,
                  showSnippets: false,
                  showFunctions: false,
                  showKeywords: false,
                  showVariables: false,
                  showClasses: false,
                  showStructs: false,
                  showInterfaces: false,
                  showModules: false,
                  showProperties: false,
                  showEvents: false,
                  showOperators: false,
                  showUnits: false,
                  showValues: false,
                  showConstants: false,
                  showEnums: false,
                  showEnumMembers: false,
                  showFiles: false,
                  showReferences: false,
                  showFolders: false,
                  showTypeParameters: false,
                  showIssues: false,
                  showUsers: false,
                },
                hover: { enabled: false },
                inlineSuggest: { enabled: false },
                lightbulb: { enabled: 'off' },
              }}
            />
          </div>

          {/* Integrated Terminal Panel */}
          <div className="flex flex-col border-t border-white/10" style={{ height: '42%', minHeight: 180 }}>
            {/* Tab Bar — Problems | Output | Terminal + action buttons */}
            <div className="flex items-center justify-between bg-[#12161f] border-b border-white/10 px-2 flex-shrink-0">
              <div className="flex items-center">
                <button
                  onClick={() => setActiveTab('problems')}
                  className={`px-3 py-1.5 text-[12px] font-medium border-b-2 transition-colors flex items-center gap-1.5 ${
                    activeTab === 'problems'
                      ? 'text-white border-blue-500 font-semibold'
                      : 'text-slate-400 border-transparent hover:text-slate-200'
                  }`}
                >
                  Problems
                  {outputType === 'error' && (
                    <span className="w-2 h-2 rounded-full bg-red-500"></span>
                  )}
                </button>
                <button
                  onClick={() => setActiveTab('output')}
                  className={`px-3 py-1.5 text-[12px] font-medium border-b-2 transition-colors ${
                    activeTab === 'output'
                      ? 'text-white border-blue-500 font-semibold'
                      : 'text-slate-400 border-transparent hover:text-slate-200'
                  }`}
                >
                  Output
                </button>
                <button
                  onClick={() => setActiveTab('terminal')}
                  className={`px-3 py-1.5 text-[12px] font-medium border-b-2 transition-colors ${
                    activeTab === 'terminal'
                      ? 'text-white border-blue-500 font-semibold'
                      : 'text-slate-400 border-transparent hover:text-slate-200'
                  }`}
                >
                  Terminal
                </button>
              </div>

              {/* Right side: time/mem metrics, + button and clear */}
              <div className="flex items-center gap-1.5 pr-2">
                {executionTime && (
                  <span className="text-[11px] font-mono text-slate-400 mr-2">
                    {executionTime}s {executionMemory ? `${(executionMemory / 1024).toFixed(1)}MB` : '2.0MB'}
                  </span>
                )}
                <button
                  onClick={() => {
                    setActiveTab('terminal')
                    setConsoleLog([])
                    setWaitingForInput(false)
                    setOutput('')
                  }}
                  title="New Terminal Session"
                  className="w-6 h-6 flex items-center justify-center text-[16px] text-slate-400 hover:text-white hover:bg-white/10 rounded transition-colors font-light"
                >
                  +
                </button>
                <button
                  onClick={() => {
                    setConsoleLog([])
                    setOutput('')
                    setWaitingForInput(false)
                  }}
                  title="Clear Terminal"
                  className="w-6 h-6 flex items-center justify-center text-slate-400 hover:text-white hover:bg-white/10 rounded transition-colors"
                >
                  <HiTrash className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>

            {/* Terminal Body */}
            <div className="flex-1 flex flex-col overflow-hidden bg-black font-mono">
              {activeTab === 'terminal' ? (
                <>
                  {/* Blue Banner Header — exact match with reference photo */}
                  <div className="flex items-center justify-between px-3 py-1 bg-[#1e40af] text-white text-[12px] font-mono font-semibold flex-shrink-0 select-none shadow-sm">
                    <div className="flex items-center gap-2">
                      <span>C:\BPUT\LAB&gt; {getLangDisplayName()} Program Output</span>
                    </div>
                    <div className="text-[11px] text-blue-200">
                      {executionTime ? `${executionTime}s ${(executionMemory ? executionMemory / 1024 : 2.0).toFixed(1)}MB` : 'Ready'}
                    </div>
                  </div>

                  {/* Scrollable Terminal Output */}
                  <div
                    onClick={() => {
                      if (waitingForInput) {
                        inlineInputRef.current?.focus()
                      } else {
                        bottomInputRef.current?.focus()
                      }
                    }}
                    className="flex-1 overflow-y-auto px-4 py-2.5 text-[13px] leading-[1.65] bg-black text-slate-100 cursor-text"
                    style={{ scrollbarWidth: 'thin' }}
                  >
                    {consoleLog.length === 0 && (
                      <div className="text-slate-500 select-none py-1">
                        <div>Microsoft Windows [BPUT CSE Lab]</div>
                        <div>(c) BPUT University. All rights reserved.</div>
                      </div>
                    )}

                    {/* Log Entries */}
                    {consoleLog.map((entry, idx) => {
                      if (entry.type === 'cmd') {
                        return (
                          <div key={idx} className="mt-2 first:mt-0 font-bold">
                            <span className="text-emerald-400">$ </span>
                            <span className="text-emerald-300">{entry.text.replace(/^\$\s*/, '')}</span>
                          </div>
                        )
                      }
                      if (entry.type === 'prompt-wait') {
                        return (
                          <div key={idx} className="flex items-center flex-wrap mt-0.5">
                            <span className="text-white font-medium">{entry.prompt}</span>
                            <input
                              ref={inlineInputRef}
                              type="text"
                              value={activeInputVal}
                              onChange={(e) => setActiveInputVal(e.target.value)}
                              onKeyDown={(e) => {
                                if (e.key === 'Enter') {
                                  e.preventDefault()
                                  handleInputSubmit(activeInputVal)
                                }
                              }}
                              className="bg-transparent text-amber-300 font-mono text-[13px] outline-none border-none p-0 ml-1.5 flex-1 min-w-[80px] caret-white"
                              autoFocus
                              spellCheck={false}
                              autoComplete="off"
                            />
                          </div>
                        )
                      }
                      if (entry.type === 'input-line') {
                        return (
                          <div key={idx} className="mt-0.5">
                            <span className="text-white font-medium">{entry.prompt}</span>
                            <span className="text-amber-300 font-semibold ml-1.5">{entry.input}</span>
                          </div>
                        )
                      }
                      if (entry.type === 'stdout') {
                        return (
                          <div key={idx} className="text-white font-mono whitespace-pre-wrap mt-0.5">
                            {entry.text}
                          </div>
                        )
                      }
                      if (entry.type === 'status-success') {
                        return (
                          <div key={idx} className="text-emerald-400 font-semibold mt-1 flex items-center gap-1.5">
                            {entry.text}
                          </div>
                        )
                      }
                      if (entry.type === 'status-error') {
                        return (
                          <div key={idx} className="text-red-400 font-semibold mt-1 flex items-center gap-1.5">
                            {entry.text}
                          </div>
                        )
                      }
                      if (entry.type === 'error') {
                        return (
                          <div key={idx} className="text-red-400 whitespace-pre-wrap mt-0.5">
                            {entry.text}
                          </div>
                        )
                      }
                      if (entry.type === 'warn') {
                        return (
                          <div key={idx} className="text-amber-400 whitespace-pre-wrap mt-0.5">
                            {entry.text}
                          </div>
                        )
                      }
                      return (
                        <div key={idx} className="text-slate-300 whitespace-pre-wrap mt-0.5">
                          {entry.text}
                        </div>
                      )
                    })}

                    {/* Running status indicator */}
                    {running && (
                      <div className="text-blue-400 animate-pulse text-[12px] mt-1">
                        Executing program...
                      </div>
                    )}

                    {/* Bottom Prompt Line (when not waiting inline) */}
                    {!waitingForInput && (
                      <div className="flex items-center gap-2 mt-2">
                        <span className="text-slate-400 font-bold">&gt;</span>
                        <input
                          ref={bottomInputRef}
                          type="text"
                          value={bottomInputVal}
                          onChange={(e) => setBottomInputVal(e.target.value)}
                          onKeyDown={(e) => {
                            if (e.key === 'Enter') {
                              e.preventDefault()
                              handleInputSubmit(bottomInputVal)
                            }
                          }}
                          placeholder={running ? '' : 'Type command or input (e.g. aab, run, clear)...'}
                          disabled={running}
                          className="bg-transparent text-slate-100 placeholder-slate-600 font-mono text-[13px] outline-none border-none p-0 flex-1 caret-white"
                          spellCheck={false}
                          autoComplete="off"
                        />
                      </div>
                    )}

                    <div ref={consoleEndRef} />
                  </div>
                </>
              ) : activeTab === 'output' ? (
                <div className="flex-1 overflow-y-auto p-4 text-[13px] leading-relaxed bg-[#0c1017] text-slate-200">
                  {output ? (
                    <pre className="whitespace-pre-wrap font-mono">{output}</pre>
                  ) : (
                    <span className="text-slate-500 italic">No output yet. Run your program first.</span>
                  )}
                </div>
              ) : (
                <div className="flex-1 overflow-y-auto p-4 text-[13px] leading-relaxed bg-[#0c1017] text-slate-200">
                  {outputType === 'error' && output ? (
                    <pre className="text-red-400 whitespace-pre-wrap font-mono">{output}</pre>
                  ) : (
                    <span className="text-slate-500 italic">No problems detected.</span>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
