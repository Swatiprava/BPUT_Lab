import { useEffect, useRef, useImperativeHandle, forwardRef } from 'react'
import { Terminal } from '@xterm/xterm'
import { FitAddon } from '@xterm/addon-fit'
import '@xterm/xterm/css/xterm.css'

const TerminalView = forwardRef(function TerminalView(_, ref) {
  const containerRef = useRef(null)
  const termRef = useRef(null)
  const fitAddonRef = useRef(null)
  const inputBufferRef = useRef('')   // Current line being typed
  const stdinLinesRef = useRef([])    // All completed lines (Enter-pressed)
  const isPromptActiveRef = useRef(true)

  useEffect(() => {
    if (!containerRef.current) return

    const term = new Terminal({
      cursorBlink: true,
      convertEol: true,
      fontFamily: "'JetBrains Mono', 'Fira Code', 'Cascadia Code', Menlo, monospace",
      fontSize: 13,
      lineHeight: 1.35,
      cursorStyle: 'block',
      scrollback: 5000,
      theme: {
        background: '#0d1117',
        foreground: '#c9d1d9',
        cursor: '#58a6ff',
        cursorAccent: '#0d1117',
        selectionBackground: 'rgba(56, 139, 253, 0.4)',
        black: '#21262d',
        red: '#ff7b72',
        green: '#3fb950',
        yellow: '#d29922',
        blue: '#58a6ff',
        magenta: '#bc8cff',
        cyan: '#39c5cf',
        white: '#b1bac4',
        brightBlack: '#6e7681',
        brightRed: '#ffa198',
        brightGreen: '#56d364',
        brightYellow: '#e3b341',
        brightBlue: '#79c0ff',
        brightMagenta: '#d2a8ff',
        brightCyan: '#56d4dd',
        brightWhite: '#f0f6fc',
      },
    })

    const fitAddon = new FitAddon()
    term.loadAddon(fitAddon)
    term.open(containerRef.current)

    termRef.current = term
    fitAddonRef.current = fitAddon

    // Greeting banner
    term.writeln('\x1b[1;34m========================================================\x1b[0m')
    term.writeln('\x1b[1;36m  BPUT Virtual Terminal — CSE Laboratory\x1b[0m')
    term.writeln('\x1b[90m  Type program input below. Press "Run" to execute.\x1b[0m')
    term.writeln('\x1b[1;34m========================================================\x1b[0m')
    writePrompt(term)

    // Handle keyboard input
    term.onData((data) => {
      if (!isPromptActiveRef.current) return

      for (const char of data) {
        if (char === '\r' || char === '\n') {
          // Enter — commit current line
          stdinLinesRef.current.push(inputBufferRef.current)
          inputBufferRef.current = ''
          term.write('\r\n')
          writePrompt(term)
        } else if (char === '\x7f' || char === '\b') {
          // Backspace
          if (inputBufferRef.current.length > 0) {
            inputBufferRef.current = inputBufferRef.current.slice(0, -1)
            term.write('\b \b')
          }
        } else if (char === '\x03') {
          // Ctrl+C — clear current line
          inputBufferRef.current = ''
          stdinLinesRef.current = []
          term.write('^C\r\n')
          writePrompt(term)
        } else if (char === '\x15') {
          // Ctrl+U — clear current line only
          const len = inputBufferRef.current.length
          inputBufferRef.current = ''
          term.write('\b \b'.repeat(len))
        } else if (char >= ' ') {
          // Printable characters
          inputBufferRef.current += char
          term.write(char)
        }
      }
    })

    // Fit on mount
    try { fitAddon.fit() } catch {}

    // Resize observer
    const resizeObserver = new ResizeObserver(() => {
      try {
        if (containerRef.current && containerRef.current.clientWidth > 0) {
          fitAddon.fit()
        }
      } catch {}
    })
    resizeObserver.observe(containerRef.current)

    return () => {
      resizeObserver.disconnect()
      term.dispose()
    }
  }, [])

  function writePrompt(term) {
    term.write('\x1b[1;32mbput-lab@cse\x1b[0m:\x1b[1;34m~$\x1b[0m ')
  }

  useImperativeHandle(ref, () => ({
    /** Get all buffered stdin (completed lines + current unfinished line) */
    getStdin() {
      const lines = [...stdinLinesRef.current]
      if (inputBufferRef.current.length > 0) {
        lines.push(inputBufferRef.current)
      }
      return lines.join('\n')
    },
    /** Clear stdin buffer */
    clearStdin() {
      stdinLinesRef.current = []
      inputBufferRef.current = ''
    },
    clear() {
      if (termRef.current) {
        termRef.current.clear()
        stdinLinesRef.current = []
        inputBufferRef.current = ''
        isPromptActiveRef.current = true
        writePrompt(termRef.current)
      }
    },
    write(data) {
      if (termRef.current) termRef.current.write(data)
    },
    writeln(data) {
      if (termRef.current) termRef.current.writeln(data)
    },
    fit() {
      if (fitAddonRef.current) {
        try { fitAddonRef.current.fit() } catch {}
      }
    },
    /** Disable keyboard input during execution */
    lockInput() {
      isPromptActiveRef.current = false
    },
    /** Re-enable keyboard input after execution */
    unlockInput() {
      isPromptActiveRef.current = true
    },
    startExecution(lang) {
      if (!termRef.current) return
      isPromptActiveRef.current = false
      termRef.current.writeln(`\r\n\x1b[1;33m[EXEC]\x1b[0m Compiling and executing \x1b[1m${lang.toUpperCase()}\x1b[0m program...`)
    },
    displayResult(result, elapsed) {
      if (!termRef.current) return
      const term = termRef.current

      // Compile errors
      if (result.compile_output) {
        term.writeln('\r\n\x1b[1;31m[COMPILE ERROR]:\x1b[0m')
        term.writeln(`\x1b[31m${result.compile_output.replace(/\n/g, '\r\n')}\x1b[0m`)
      }

      // Standard output
      if (result.stdout) {
        term.writeln('\r\n\x1b[1;36m[OUTPUT]:\x1b[0m')
        term.writeln(result.stdout.replace(/\n/g, '\r\n'))
      }

      // Standard error
      if (result.stderr) {
        term.writeln('\r\n\x1b[1;33m[STDERR]:\x1b[0m')
        term.writeln(`\x1b[33m${result.stderr.replace(/\n/g, '\r\n')}\x1b[0m`)
      }

      // Status banner
      const timeTaken = result.time || elapsed || '0.00'
      const memoryUsed = result.memory ? `${(result.memory / 1024).toFixed(1)} MB` : 'N/A'

      if (result.status === 'Accepted') {
        term.writeln(`\r\n\x1b[1;32m[SUCCESS] Status: ${result.status} | Time: ${timeTaken}s | Memory: ${memoryUsed}\x1b[0m`)
      } else {
        term.writeln(`\r\n\x1b[1;31m[FAILED] Status: ${result.status} | Time: ${timeTaken}s | Memory: ${memoryUsed}\x1b[0m`)
      }

      // Re-enable input
      isPromptActiveRef.current = true
      stdinLinesRef.current = []
      inputBufferRef.current = ''
      term.write('\r\n\x1b[90mType input for next run, then press "Run".\x1b[0m\r\n')
      writePrompt(term)
    },
    displayError(errMsg) {
      if (!termRef.current) return
      termRef.current.writeln(`\r\n\x1b[1;31m[ERROR] ${errMsg}\x1b[0m`)
      isPromptActiveRef.current = true
      stdinLinesRef.current = []
      inputBufferRef.current = ''
      writePrompt(termRef.current)
    },
    displaySubmitted() {
      if (!termRef.current) return
      termRef.current.writeln('\r\n\x1b[1;32m[SUBMIT] Code successfully submitted and recorded for evaluation!\x1b[0m')
      writePrompt(termRef.current)
    },
  }))

  return (
    <div
      ref={containerRef}
      className="w-full h-full bg-[#0d1117] overflow-hidden p-2"
      style={{ minHeight: '100%' }}
    />
  )
})

export default TerminalView
