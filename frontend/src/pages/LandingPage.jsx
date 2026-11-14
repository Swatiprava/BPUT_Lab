import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  HiAcademicCap,
  HiArrowRight,
  HiCommandLine,
  HiCodeBracket,
  HiBookOpen,
  HiClock,
  HiCheckCircle,
  HiShieldCheck,
  HiSparkles,
  HiCpuChip,
  HiServerStack,
  HiCalendarDays,
  HiPlay,
  HiArrowUpRight,
  HiChevronRight,
  HiBeaker,
  HiQuestionMarkCircle,
  HiUsers,
} from 'react-icons/hi2'
import { SUBJECT_SCHEDULES } from '../lib/schedule'

const SEMESTERS_DATA = {
  3: {
    title: 'Semester 3 (Monsoon)',
    tag: 'Core Fundamentals',
    description: 'Foundations of algorithms, memory structures, and object-oriented paradigms.',
    subjects: [
      {
        code: 'CSPC2202',
        name: 'Data Structures Lab',
        lang: 'C / C++',
        exps: 10,
        day: 'Monday',
        room: 'Lab 1 (Turing Hall)',
        highlights: ['Linked Lists & Trees', 'Sorting & Searching', 'Stack & Queue Systems'],
      },
      {
        code: 'CSPC2203',
        name: 'Object Oriented Programming Lab',
        lang: 'Java',
        exps: 10,
        day: 'Thursday',
        room: 'Lab 2 (Gosling Center)',
        highlights: ['Inheritance & Polymorphism', 'Multithreading', 'Exception Frameworks'],
      },
    ],
  },
  4: {
    title: 'Semester 4 (Spring)',
    tag: 'Systems & Architecture',
    description: 'Algorithms efficiency, hardware simulation, relation databases, and network sockets.',
    subjects: [
      {
        code: 'CSPC2206',
        name: 'Design & Analysis of Algorithms Lab',
        lang: 'C / C++',
        exps: 12,
        day: 'Monday',
        room: 'Lab 1 (Knuth Suite)',
        highlights: ['Divide & Conquer', 'Dynamic Programming', 'Greedy & Graph Algorithms'],
      },
      {
        code: 'CSPC2204',
        name: 'Database Engineering Lab',
        lang: 'SQL / MySQL',
        exps: 10,
        day: 'Tuesday',
        room: 'Lab 3 (Codd Lab)',
        highlights: ['Complex Joins & DDL/DML', 'PL/SQL Triggers', 'ACID Transactions'],
      },
      {
        code: 'CSPC2205',
        name: 'Computer Organization & Architecture Lab',
        lang: 'C',
        exps: 10,
        day: 'Wednesday',
        room: 'Lab 4 (Hardware Sim)',
        highlights: ["Booth's Multiplication", 'Restoring Division', 'Cache Simulation'],
      },
      {
        code: 'CSPC2207',
        name: 'Computer Networks Lab',
        lang: 'C / Socket',
        exps: 10,
        day: 'Friday',
        room: 'Lab 2 (Cerf Network Center)',
        highlights: ['TCP/UDP Sockets', 'CRC & Sliding Window', 'Routing Simulations'],
      },
    ],
  },
  5: {
    title: 'Semester 5 (Monsoon)',
    tag: 'Intelligence & Systems',
    description: 'Kernel system calls, machine learning architectures, and formal automata theory.',
    subjects: [
      {
        code: 'CSPC3202',
        name: 'Operating Systems Laboratory',
        lang: 'C / Linux',
        exps: 10,
        day: 'Tuesday',
        room: 'Lab 1 (Unix & Systems)',
        highlights: ['Process Fork & IPC', 'CPU Scheduling & Semaphores', 'Deadlock Detection'],
      },
      {
        code: 'CSPC3203',
        name: 'Machine Learning Laboratory',
        lang: 'Python',
        exps: 10,
        day: 'Thursday',
        room: 'Lab 5 (AI / GPU Compute)',
        highlights: ['Supervised Classifiers', 'Neural Net Backpropagation', 'Clustering & PCA'],
      },
      {
        code: 'CSPC3201',
        name: 'Theory of Computation Laboratory',
        lang: 'Python / C',
        exps: 10,
        day: 'Friday',
        room: 'Lab 3 (Automata Lab)',
        highlights: ['DFA / NFA Simulators', 'Turing Machine States', 'Grammar Parsers'],
      },
    ],
  },
  6: {
    title: 'Semester 6 (Spring)',
    tag: 'Compilers & Engineering',
    description: 'Lexical analysis, syntax trees, agile pipelines, and automated test harnesses.',
    subjects: [
      {
        code: 'CSPC3204',
        name: 'Compiler Design Laboratory',
        lang: 'C / Lex & Yacc',
        exps: 10,
        day: 'Monday',
        room: 'Lab 1 (Language Lab)',
        highlights: ['Lexical Analyzer', 'Yacc Grammar Syntax Trees', 'Intermediate Code Gen'],
      },
      {
        code: 'CSPC3205',
        name: 'Software Engineering Laboratory',
        lang: 'Python / Java',
        exps: 10,
        day: 'Wednesday',
        room: 'Lab 2 (DevOps Suite)',
        highlights: ['UML Modeling', 'Unit & Integration Testing', 'CI/CD Pipeline Flow'],
      },
    ],
  },
}

const DEMO_SNIPPETS = {
  c: {
    lang: 'C99',
    title: "Booth's Multiplication (COA Lab)",
    code: `#include <stdio.h>

int main() {
    int m = 3, q = -4, n = 4;
    int mask = (1 << n) - 1;
    int Q = q & mask, A = 0, q_minus_1 = 0;
    
    // 4-bit Arithmetic Shift Cycles
    for (int i = 0; i < n; i++) {
        int q0 = Q & 1;
        if (q0 == 1 && q_minus_1 == 0) A -= m;
        else if (q0 == 0 && q_minus_1 == 1) A += m;
        
        q_minus_1 = q0;
        Q = ((Q >> 1) & (mask >> 1)) | ((A & 1) << (n - 1));
        A >>= 1;
    }
    int res = ((A & mask) << n) | (Q & mask);
    if (res & (1 << (2*n - 1))) res -= (1 << (2*n));
    printf("Multiplication: %d * %d = %d\\n", m, q, res);
    return 0;
}`,
    output: `C:\\BPUT\\LAB\\C> run booth.c
Initial Registers: A=0000, Q=1100, Q_-1=0
Cycle 1 [00]: No-op  -> ARS [0000 0110 0]
Cycle 2 [00]: No-op  -> ARS [0000 0011 0]
Cycle 3 [10]: A=A-M  -> ARS [1110 1001 1]
Cycle 4 [11]: No-op  -> ARS [1111 0100 1]

Multiplication: 3 * -4 = -12
✓ Accepted | 0.04s | 1.8 MB`,
  },
  python: {
    lang: 'Python 3.11',
    title: 'Perceptron Binary Classifier (ML Lab)',
    code: `import numpy as np

# Training AND Gate
X = np.array([[0,0], [0,1], [1,0], [1,1]])
y = np.array([0, 0, 0, 1])

weights = np.zeros(2)
bias = 0.0
lr = 0.1

for epoch in range(10):
    for xi, target in zip(X, y):
        linear_output = np.dot(xi, weights) + bias
        pred = 1 if linear_output >= 0 else 0
        update = lr * (target - pred)
        weights += update * xi
        bias += update

print(f"Learned Weights: {weights}, Bias: {bias:.2f}")
print("Perceptron Convergence: PASS")`,
    output: `C:\\BPUT\\LAB\\PYTHON> run perceptron.py
Epoch 1-10 complete.
Weights: [0.2  0.1], Bias: -0.20
Predictions:
[0, 0] -> 0 (True)
[0, 1] -> 0 (True)
[1, 0] -> 0 (True)
[1, 1] -> 1 (True)
Perceptron Convergence: PASS
✓ Accepted | 0.18s | 8.4 MB`,
  },
  java: {
    lang: 'Java 17',
    title: 'Producer-Consumer Thread Sync (OOP Lab)',
    code: `class SharedBuffer {
    private int data;
    private boolean hasData = false;

    public synchronized void produce(int val) throws InterruptedException {
        while (hasData) wait();
        data = val;
        hasData = true;
        System.out.println("Produced: " + val);
        notify();
    }

    public synchronized int consume() throws InterruptedException {
        while (!hasData) wait();
        hasData = false;
        System.out.println("Consumed: " + data);
        notify();
        return data;
    }
}`,
    output: `C:\\BPUT\\LAB\\JAVA> run BufferSync.java
[Thread-1] Produced: 42
[Thread-2] Consumed: 42
[Thread-1] Produced: 88
[Thread-2] Consumed: 88
State: Synchronized Monitor Satisfied
✓ Accepted | 0.32s | 12.1 MB`,
  },
}

export default function LandingPage({ user, faculty }) {
  const navigate = useNavigate()
  const [selectedSem, setSelectedSem] = useState(4)
  const [activeCodeTab, setActiveCodeTab] = useState('c')
  const [activeFaq, setActiveFaq] = useState(null)

  const handleCtaClick = () => {
    if (user) {
      navigate('/dashboard')
    } else {
      navigate('/login')
    }
  }

  return (
    <div className="min-h-screen bg-surface-900 text-slate-100 selection:bg-primary-500 selection:text-white relative overflow-x-hidden">
      {/* Background Glows & Mesh Gradients */}
      <div className="fixed inset-0 pointer-events-none z-0">
        <div className="absolute top-[-10%] left-[20%] w-[650px] h-[650px] bg-primary-600/12 rounded-full blur-[140px]" />
        <div className="absolute top-[35%] right-[-10%] w-[550px] h-[550px] bg-accent-600/10 rounded-full blur-[150px]" />
        <div className="absolute bottom-[10%] left-[-10%] w-[600px] h-[600px] bg-blue-700/8 rounded-full blur-[160px]" />
        <div className="absolute inset-0 bg-mesh opacity-80" />
      </div>

      {/* ===== NAVIGATION BAR ===== */}
      <nav className="relative z-20 border-b border-white/5 bg-surface-900/75 backdrop-blur-md sticky top-0">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between">
          {/* Brand */}
          <div className="flex items-center gap-3.5 cursor-pointer" onClick={() => navigate('/')}>
            <div className="w-11 h-11 rounded-2xl bg-gradient-to-br from-primary-500 via-primary-600 to-accent-600 flex items-center justify-center shadow-lg shadow-primary-500/25 ring-1 ring-white/20">
              <HiAcademicCap className="w-6 h-6 text-white" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="text-base font-extrabold tracking-tight text-white">PPD Lab Platform</span>
                <span className="text-[10px] font-mono px-2 py-0.5 rounded-full bg-primary-500/15 text-primary-300 border border-primary-500/30">
                  BPUT Rourkela
                </span>
              </div>
              <p className="text-xs text-slate-400 font-medium">Department of Computer Science &amp; Engineering</p>
            </div>
          </div>

          {/* Quick links */}
          <div className="hidden md:flex items-center gap-8 text-sm font-medium text-slate-300">
            <a href="#features" className="hover:text-primary-400 transition-colors">Features</a>
            <a href="#curriculum" className="hover:text-primary-400 transition-colors">Curriculum</a>
            <a href="#demo" className="hover:text-primary-400 transition-colors">Interactive IDE</a>
            <a href="#faq" className="hover:text-primary-400 transition-colors">FAQ</a>
          </div>

          {/* Action Button */}
          <div className="flex items-center gap-3">
            {faculty ? (
              <button
                onClick={() => navigate('/faculty')}
                className="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl text-sm font-semibold text-accent-300 hover:text-white hover:bg-accent-600/20 transition-all border border-accent-500/30 bg-accent-500/10 shadow-sm"
              >
                <HiShieldCheck className="w-4 h-4 text-accent-400" />
                <span>Faculty: {faculty.name?.split(' ')[1] || 'Dashboard'}</span>
              </button>
            ) : (
              <button
                onClick={() => navigate('/faculty/login')}
                className="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl text-sm font-semibold text-accent-300 hover:text-white hover:bg-accent-600/20 transition-all border border-accent-500/30 bg-accent-500/10 shadow-sm"
              >
                <HiShieldCheck className="w-4 h-4 text-accent-400" />
                <span>Faculty Portal</span>
              </button>
            )}

            {user ? (
              <button
                onClick={() => navigate('/dashboard')}
                className="btn-primary !py-2.5 !px-5 !text-sm group shadow-lg shadow-primary-600/20"
              >
                <span>Dashboard ({user.name?.split(' ')[0] || 'Student'})</span>
                <HiArrowRight className="w-4 h-4 group-hover:translate-x-0.5 transition-transform" />
              </button>
            ) : (
              <button
                onClick={() => navigate('/login')}
                className="btn-primary !py-2.5 !px-5 !text-sm group shadow-lg shadow-primary-600/20"
              >
                <span>Student Portal</span>
                <HiArrowRight className="w-4 h-4 group-hover:translate-x-0.5 transition-transform" />
              </button>
            )}
          </div>
        </div>
      </nav>

      {/* ===== HERO SECTION ===== */}
      <section className="relative z-10 pt-16 pb-24 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto">
        <div className="text-center max-w-4xl mx-auto space-y-6">
          {/* Badge */}
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-gradient-to-r from-primary-500/10 via-accent-500/10 to-primary-500/10 border border-primary-500/20 text-primary-300 text-xs font-medium backdrop-blur-sm shadow-inner">
            <HiSparkles className="w-4 h-4 text-accent-400 animate-pulse" />
            <span>Official Computer Science Lab Environment • BPUT Syllabus Aligned</span>
          </div>

          {/* Headline */}
          <h1 className="text-4xl sm:text-6xl lg:text-7xl font-extrabold tracking-tight text-white leading-[1.12]">
            Online Lab Platform for{' '}
            <span className="gradient-text">BPUT CSE Engineers</span>
          </h1>

          {/* Subhead */}
          <p className="text-base sm:text-xl text-slate-300 max-w-2xl mx-auto leading-relaxed">
            Write, compile, and submit semester lab experiments straight from your browser.
            Equipped with Monaco code editor, interactive CLI input streams, and verified BPUT lab manuals.
          </p>

          {/* CTA Buttons */}
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-4">
            <button
              onClick={handleCtaClick}
              className="w-full sm:w-auto btn-primary !py-3.5 !px-8 !text-base group shadow-xl shadow-primary-600/30"
            >
              <span className="flex items-center gap-2">
                {user ? 'Open Your Lab Dashboard' : 'Access Student Environment'}
                <HiArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
              </span>
            </button>

            <a
              href="#curriculum"
              className="w-full sm:w-auto btn-secondary !py-3.5 !px-8 !text-base flex items-center justify-center gap-2 border border-white/10"
            >
              <HiBookOpen className="w-5 h-5 text-accent-400" />
              <span>Explore Lab Curriculum</span>
            </a>
          </div>

          {/* Credentials helper pill */}
          <div className="pt-2">
            <p className="text-xs text-slate-500 font-mono">
              ⚡ Pre-configured accounts for Semesters 3, 4, 5, and 6 • Instant cloud grading
            </p>
          </div>
        </div>

        {/* ===== HERO CODE LAB PREVIEW (Interactive Browser Mockup) ===== */}
        <div className="mt-14 relative max-w-5xl mx-auto">
          {/* Glowing backdrops */}
          <div className="absolute -inset-1 rounded-3xl bg-gradient-to-r from-primary-500 via-accent-500 to-primary-600 opacity-20 blur-xl transition-all" />

          {/* Mockup Container */}
          <div className="relative rounded-2xl bg-surface-800 border border-white/10 shadow-2xl overflow-hidden backdrop-blur-xl">
            {/* Window title bar */}
            <div className="flex items-center justify-between px-4 py-3 bg-[#0d121f] border-b border-white/10">
              <div className="flex items-center gap-2">
                <span className="w-3 h-3 rounded-full bg-rose-500/80 inline-block" />
                <span className="w-3 h-3 rounded-full bg-amber-500/80 inline-block" />
                <span className="w-3 h-3 rounded-full bg-emerald-500/80 inline-block" />
                <span className="ml-3 text-xs font-mono text-slate-400 flex items-center gap-2">
                  <span className="text-primary-400 font-semibold">CSPC2205</span>
                  <span>•</span>
                  <span>Experiment 01: Fast Multiplication &amp; Division (Booth's Algorithm)</span>
                </span>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-[11px] font-mono px-2 py-0.5 rounded bg-surface-700 text-accent-300 border border-white/5">
                  WEEK 1 (Q1/2) • WEDNESDAY
                </span>
              </div>
            </div>

            {/* Split layout: manual on left, editor & terminal on right */}
            <div className="grid grid-cols-1 md:grid-cols-12 min-h-[440px]">
              {/* Left Column: Lab Manual teaser */}
              <div className="md:col-span-5 p-5 bg-surface-900/60 border-r border-white/5 space-y-3.5 text-xs text-slate-300 overflow-hidden font-sans">
                <div className="flex items-center justify-between pb-2 border-b border-white/5">
                  <span className="font-semibold text-white flex items-center gap-1.5">
                    <HiBookOpen className="w-4 h-4 text-primary-400" />
                    Experiment Specification
                  </span>
                  <span className="text-[10px] text-primary-400 font-mono bg-primary-500/10 px-2 py-0.5 rounded border border-primary-500/20">
                    BPUT Syllabus
                  </span>
                </div>
                <div>
                  <h4 className="font-semibold text-slate-100 mb-1">Aim of Experiment</h4>
                  <p className="text-slate-400 text-[11px] leading-relaxed">
                    Simulate Booth's Multiplication Algorithm in C to understand binary 2's complement hardware arithmetic.
                  </p>
                </div>
                <div>
                  <h4 className="font-semibold text-slate-100 mb-1">Step Rules: (Q₀, Q₋₁)</h4>
                  <ul className="list-disc pl-4 space-y-1 text-slate-400 text-[11px]">
                    <li><code className="text-accent-300">10</code>: Subtract M from A (A = A - M), then ARS.</li>
                    <li><code className="text-accent-300">01</code>: Add M to A (A = A + M), then ARS.</li>
                    <li><code className="text-accent-300">00 / 11</code>: Arithmetic Right Shift only.</li>
                  </ul>
                </div>
                <div className="p-2.5 rounded-xl bg-surface-700/60 border border-white/5">
                  <div className="text-[10px] text-slate-400 uppercase font-mono mb-1">Sample Test Case</div>
                  <div className="text-slate-200 font-mono text-[11px]">M = 3 (0011), Q = -4 (1100)</div>
                  <div className="text-emerald-400 font-mono text-[11px] mt-0.5 font-semibold">→ Result = -12 (11110100)</div>
                </div>
              </div>

              {/* Right Column: Code & Terminal */}
              <div className="md:col-span-7 flex flex-col bg-black">
                {/* Code header bar */}
                <div className="flex items-center justify-between px-3 py-1.5 bg-[#0e1320] border-b border-white/5 text-[11px] font-mono text-slate-400">
                  <span className="text-accent-300 font-semibold">booth_multiplier.c</span>
                  <div className="flex items-center gap-2">
                    <span className="inline-flex items-center gap-1 text-emerald-400">
                      <HiCheckCircle className="w-3.5 h-3.5" />
                      Syntax Validated
                    </span>
                  </div>
                </div>

                {/* Code text preview */}
                <div className="p-4 font-mono text-[11px] text-slate-200 space-y-1 leading-relaxed overflow-hidden bg-black/90 flex-1">
                  <div><span className="text-rose-400">#include</span> <span className="text-emerald-400">&lt;stdio.h&gt;</span></div>
                  <div><span className="text-blue-400">int</span> <span className="text-amber-300">main</span>() &#123;</div>
                  <div className="pl-4 text-slate-400">// Booth's 2's Complement Multiplier</div>
                  <div className="pl-4"><span className="text-blue-400">int</span> n = 4, m = 3, q = -4;</div>
                  <div className="pl-4"><span className="text-blue-400">int</span> mask = (1 &lt;&lt; n) - 1;</div>
                  <div className="pl-4"><span className="text-blue-400">int</span> Q = q &amp; mask, A = 0, q_minus_1 = 0;</div>
                  <div className="pl-4"><span className="text-purple-400">for</span> (<span className="text-blue-400">int</span> i = 0; i &lt; n; i++) &#123; ... &#125;</div>
                  <div className="pl-4"><span className="text-amber-300">printf</span>(<span className="text-emerald-300">"Multiplication = %d * %d = %d\\n"</span>, m, q, res);</div>
                  <div>&#125;</div>
                </div>

                {/* Integrated Terminal Preview */}
                <div className="border-t border-white/10 bg-black p-3.5 font-mono text-[11px] space-y-1">
                  <div className="flex items-center justify-between text-blue-300 font-semibold bg-[#1e40af]/60 px-2.5 py-1 rounded">
                    <span>C:\BPUT\LAB&gt; C Program Output</span>
                    <span className="text-[10px] text-blue-200">✓ Accepted | 0.04s | 1.8MB</span>
                  </div>
                  <div className="text-emerald-400 font-semibold pt-1">$ run booth.c</div>
                  <div className="text-slate-300">Enter number of bits: <span className="text-amber-300">4</span></div>
                  <div className="text-slate-300">Enter Multiplicand (M): <span className="text-amber-300">3</span></div>
                  <div className="text-slate-300">Enter Multiplier (Q): <span className="text-amber-300">-4</span></div>
                  <div className="text-slate-400 text-[10px]">Initial: A=0000, Q=1100, Q-1=0 • 4 Cycles complete</div>
                  <div className="text-emerald-400 font-bold pt-1">
                    Final Result = -12 | Multiplication = 3 * -4 = -12
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* ===== STATS STRIP ===== */}
        <div className="mt-16 grid grid-cols-2 md:grid-cols-4 gap-4 max-w-5xl mx-auto">
          {[
            { value: '40+', label: 'Curated Experiments', sub: 'Semesters 3 through 6' },
            { value: '11', label: 'Lab Disciplines', sub: 'DS, Java, DAA, OS, ML, CN...' },
            { value: '0', label: 'Local Setup Needed', sub: 'Runs on any modern browser' },
            { value: '100%', label: 'BPUT Syllabus Aligned', sub: 'Theory, test vectors, viva' },
          ].map((stat, i) => (
            <div key={i} className="glass-card p-5 text-center">
              <div className="text-3xl font-extrabold text-white tracking-tight gradient-text">
                {stat.value}
              </div>
              <div className="text-sm font-semibold text-slate-200 mt-1">{stat.label}</div>
              <div className="text-[11px] text-slate-500 mt-0.5">{stat.sub}</div>
            </div>
          ))}
        </div>
      </section>

      {/* ===== FEATURES SECTION ===== */}
      <section id="features" className="relative z-10 py-24 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto border-t border-white/5">
        <div className="text-center max-w-3xl mx-auto mb-16 space-y-3">
          <span className="text-xs font-semibold tracking-wider text-primary-400 uppercase font-mono">
            Platform Capabilities
          </span>
          <h2 className="text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
            Built Specifically for University Labs
          </h2>
          <p className="text-slate-400 text-sm sm:text-base">
            Everything an engineering student and lab instructor needs for seamless weekly practical courses.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-6xl mx-auto">
          {[
            {
              icon: HiCommandLine,
              title: 'Interactive CLI & Stdin Stream',
              desc: 'Sequential prompts for interactive programs like scanf(), cin, and input(). No hardcoded inputs required.',
              color: 'from-blue-500 to-primary-600',
            },
            {
              icon: HiCodeBracket,
              title: 'Multi-Language Cloud Execution',
              desc: 'High-performance cloud compilers for C99, C++17, Java 17, Python 3.11, and SQL with sub-second execution.',
              color: 'from-accent-500 to-purple-600',
            },
            {
              icon: HiBookOpen,
              title: 'Comprehensive Lab Manuals',
              desc: 'Every experiment comes loaded with theoretical background, sample inputs/outputs, complexity analysis, and viva questions.',
              color: 'from-emerald-500 to-teal-600',
            },
            {
              icon: HiCalendarDays,
              title: 'Weekly Academic Schedule',
              desc: 'Organized with a strict 2 questions per week timetable matching BPUT semester schedules and non-overlapping lab rooms.',
              color: 'from-amber-500 to-orange-600',
            },
            {
              icon: HiCheckCircle,
              title: 'Instant Evaluation & Submission',
              desc: 'One-click code submission with real-time feedback, runtime tracking, memory stats, and evaluation history.',
              color: 'from-primary-500 to-cyan-500',
            },
            {
              icon: HiShieldCheck,
              title: 'Zero Local Toolchain Headaches',
              desc: 'Forget GCC paths, JDK environment variables, or Python venvs. Open the portal and start programming instantly.',
              color: 'from-rose-500 to-pink-600',
            },
          ].map((feature, i) => (
            <div
              key={i}
              className="glass-card p-6 flex flex-col justify-between hover:border-primary-500/40 transition-all hover:-translate-y-1 group"
            >
              <div>
                <div className={`w-12 h-12 rounded-2xl bg-gradient-to-br ${feature.color} flex items-center justify-center mb-5 text-white shadow-lg`}>
                  <feature.icon className="w-6 h-6" />
                </div>
                <h3 className="text-lg font-bold text-white mb-2 group-hover:text-primary-300 transition-colors">
                  {feature.title}
                </h3>
                <p className="text-sm text-slate-400 leading-relaxed">
                  {feature.desc}
                </p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* ===== INTERACTIVE DEMO CODE LAB SECTION ===== */}
      <section id="demo" className="relative z-10 py-24 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto border-t border-white/5">
        <div className="text-center max-w-3xl mx-auto mb-12 space-y-3">
          <span className="text-xs font-semibold tracking-wider text-accent-400 uppercase font-mono">
            Live IDE Simulation
          </span>
          <h2 className="text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
            See How the Cloud Lab Operates
          </h2>
          <p className="text-slate-400 text-sm sm:text-base">
            Switch between languages to preview how actual BPUT experiments run inside the integrated compiler and terminal.
          </p>
        </div>

        <div className="max-w-4xl mx-auto glass-card overflow-hidden">
          {/* Tab switches */}
          <div className="flex items-center justify-between px-4 py-2.5 bg-surface-800 border-b border-white/10">
            <div className="flex items-center gap-2">
              {Object.entries(DEMO_SNIPPETS).map(([key, data]) => (
                <button
                  key={key}
                  onClick={() => setActiveCodeTab(key)}
                  className={`px-3.5 py-1.5 rounded-lg text-xs font-semibold font-mono transition-all ${
                    activeCodeTab === key
                      ? 'bg-primary-600 text-white shadow-md shadow-primary-600/30'
                      : 'text-slate-400 hover:text-white hover:bg-surface-700'
                  }`}
                >
                  {data.lang}
                </button>
              ))}
            </div>
            <span className="text-xs font-mono text-slate-400 hidden sm:inline-block">
              {DEMO_SNIPPETS[activeCodeTab].title}
            </span>
          </div>

          {/* Code display */}
          <div className="p-5 font-mono text-xs text-slate-200 bg-[#070a13] overflow-x-auto leading-relaxed border-b border-white/10">
            <pre><code>{DEMO_SNIPPETS[activeCodeTab].code}</code></pre>
          </div>

          {/* Terminal output */}
          <div className="p-4 bg-black font-mono text-xs text-slate-300 space-y-1">
            <div className="flex items-center justify-between text-slate-500 pb-1 mb-1 border-b border-white/5 text-[11px]">
              <span>TERMINAL OUTPUT</span>
              <span className="text-emerald-400 font-semibold">● 0 errors</span>
            </div>
            <pre className="text-slate-200 whitespace-pre-wrap leading-relaxed">
              {DEMO_SNIPPETS[activeCodeTab].output}
            </pre>
          </div>
        </div>
      </section>

      {/* ===== CURRICULUM EXPLORER ===== */}
      <section id="curriculum" className="relative z-10 py-24 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto border-t border-white/5">
        <div className="text-center max-w-3xl mx-auto mb-14 space-y-3">
          <span className="text-xs font-semibold tracking-wider text-primary-400 uppercase font-mono">
            BPUT CSE Syllabus Explorer
          </span>
          <h2 className="text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
            Complete Lab Syllabus by Semester
          </h2>
          <p className="text-slate-400 text-sm sm:text-base">
            Select a semester to review the practical subjects, scheduled lab rooms, and experiment lists.
          </p>
        </div>

        {/* Semester Buttons */}
        <div className="flex items-center justify-center gap-3 mb-10 flex-wrap">
          {[3, 4, 5, 6].map((sem) => (
            <button
              key={sem}
              onClick={() => setSelectedSem(sem)}
              className={`px-5 py-2.5 rounded-xl text-sm font-bold transition-all ${
                selectedSem === sem
                  ? 'bg-gradient-to-r from-primary-600 to-accent-600 text-white shadow-lg shadow-primary-600/30'
                  : 'bg-surface-800 text-slate-400 hover:text-white border border-white/5'
              }`}
            >
              Semester {sem}
            </button>
          ))}
        </div>

        {/* Semester Details */}
        <div className="max-w-5xl mx-auto space-y-6">
          <div className="flex items-center justify-between px-2">
            <div>
              <h3 className="text-2xl font-bold text-white">{SEMESTERS_DATA[selectedSem].title}</h3>
              <p className="text-xs text-slate-400 mt-0.5">{SEMESTERS_DATA[selectedSem].description}</p>
            </div>
            <span className="px-3 py-1 rounded-full bg-primary-500/10 text-primary-300 text-xs font-mono border border-primary-500/20 font-semibold">
              {SEMESTERS_DATA[selectedSem].tag}
            </span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {SEMESTERS_DATA[selectedSem].subjects.map((sub, idx) => (
              <div key={idx} className="glass-card p-6 flex flex-col justify-between hover:border-primary-500/40 transition-all">
                <div>
                  <div className="flex items-center justify-between mb-3">
                    <span className="text-xs font-mono font-bold px-2 py-0.5 rounded bg-surface-700 text-primary-300 border border-white/5">
                      {sub.code}
                    </span>
                    <span className="text-xs font-mono text-accent-400 font-semibold bg-accent-500/10 px-2 py-0.5 rounded">
                      {sub.lang}
                    </span>
                  </div>

                  <h4 className="text-lg font-bold text-white mb-2">{sub.name}</h4>

                  <div className="space-y-1 mb-4 text-xs text-slate-400">
                    <div className="flex items-center gap-1.5">
                      <HiClock className="w-3.5 h-3.5 text-primary-400" />
                      <span>Every {sub.day} • {sub.room}</span>
                    </div>
                    <div className="flex items-center gap-1.5">
                      <HiBeaker className="w-3.5 h-3.5 text-emerald-400" />
                      <span>{sub.exps} Prescribed University Experiments</span>
                    </div>
                  </div>

                  <div className="pt-3 border-t border-white/5">
                    <p className="text-[11px] uppercase tracking-wider text-slate-500 font-semibold mb-2">Key Topics</p>
                    <div className="flex flex-wrap gap-1.5">
                      {sub.highlights.map((h, hi) => (
                        <span key={hi} className="text-[11px] font-mono px-2 py-0.5 rounded bg-surface-700/80 text-slate-300 border border-white/5">
                          {h}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>

                <div className="mt-6 pt-3 border-t border-white/5 flex items-center justify-between">
                  <span className="text-xs text-slate-500">2 questions / week</span>
                  <button
                    onClick={handleCtaClick}
                    className="text-xs font-semibold text-primary-400 hover:text-primary-300 flex items-center gap-1 group"
                  >
                    <span>Launch in Lab</span>
                    <HiArrowRight className="w-3 h-3 group-hover:translate-x-0.5 transition-transform" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===== FREQUENTLY ASKED QUESTIONS ===== */}
      <section id="faq" className="relative z-10 py-24 px-4 sm:px-6 lg:px-8 max-w-4xl mx-auto border-t border-white/5">
        <div className="text-center mb-14 space-y-3">
          <span className="text-xs font-semibold tracking-wider text-accent-400 uppercase font-mono">
            Student Support
          </span>
          <h2 className="text-3xl sm:text-5xl font-extrabold text-white tracking-tight">
            Frequently Asked Questions
          </h2>
          <p className="text-slate-400 text-sm sm:text-base">
            Quick answers about access, account credentials, and experiment submissions.
          </p>
        </div>

        <div className="space-y-3">
          {[
            {
              q: 'How do students log into the platform?',
              a: 'Every BPUT CSE student has a pre-provisioned username matching their official registration format (e.g. `pallavi.mishra` or `aarav.sharma`). Passwords follow the university standard `Lab@{year}cs{reg_no}`. Contact your lab instructor if you need a password reset.',
            },
            {
              q: 'Do I need to install GCC, Java, or Python on my laptop?',
              a: 'No. The platform compiles and executes your code remotely in isolated cloud sandboxes. You only need a web browser (Chrome, Edge, Firefox, or Safari).',
            },
            {
              q: 'Can programs with interactive user input (scanf / cin / input) be tested?',
              a: 'Yes! The integrated terminal detects input commands in your code and presents sequential input prompts (e.g., asking for bit size, multiplicand, and multiplier) before running your program with the full stdin stream.',
            },
            {
              q: 'How does code submission and evaluation work?',
              a: 'Once your program runs successfully in the Code Lab, click the green "Submit" button in the top toolbar. Your code, terminal output, and execution metrics will be recorded into the central database for faculty review.',
            },
            {
              q: 'Can I practice lab experiments outside scheduled lab hours?',
              a: 'Yes. The portal is accessible 24/7. You can revisit previous weeks, practice algorithms, test edge cases, and study the included viva-voce questions at your own pace.',
            },
          ].map((faq, i) => (
            <div
              key={i}
              className="glass-card overflow-hidden transition-all"
            >
              <button
                onClick={() => setActiveFaq(activeFaq === i ? null : i)}
                className="w-full p-5 text-left flex items-center justify-between text-sm sm:text-base font-semibold text-white hover:text-primary-300 transition-colors"
              >
                <span>{faq.q}</span>
                <HiChevronRight className={`w-5 h-5 text-slate-400 transition-transform ${activeFaq === i ? 'rotate-90 text-primary-400' : ''}`} />
              </button>
              {activeFaq === i && (
                <div className="px-5 pb-5 text-xs sm:text-sm text-slate-300 leading-relaxed border-t border-white/5 pt-3">
                  {faq.a}
                </div>
              )}
            </div>
          ))}
        </div>
      </section>

      {/* ===== FINAL CTA BANNER ===== */}
      <section className="relative z-10 py-20 px-4 sm:px-6 lg:px-8 max-w-5xl mx-auto">
        <div className="glass-card p-10 sm:p-14 text-center relative overflow-hidden border border-primary-500/30">
          <div className="absolute -top-24 -right-24 w-72 h-72 bg-primary-600/20 rounded-full blur-3xl pointer-events-none" />
          <div className="absolute -bottom-24 -left-24 w-72 h-72 bg-accent-600/20 rounded-full blur-3xl pointer-events-none" />

          <div className="relative z-10 space-y-5 max-w-2xl mx-auto">
            <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-primary-500 to-accent-600 mx-auto flex items-center justify-center shadow-lg shadow-primary-500/30">
              <HiAcademicCap className="w-8 h-8 text-white" />
            </div>

            <h2 className="text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
              Ready to Start Your Lab Session?
            </h2>

            <p className="text-slate-300 text-sm sm:text-base leading-relaxed">
              Log in with your BPUT CSE credentials and access your experiments, Monaco code editor, and lab guides immediately.
            </p>

            <div className="pt-2">
              <button
                onClick={handleCtaClick}
                className="btn-primary !py-3.5 !px-8 !text-base group shadow-xl shadow-primary-600/30"
              >
                <span className="flex items-center gap-2">
                  {user ? 'Go to My Lab Dashboard' : 'Sign In to Student Portal'}
                  <HiArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </span>
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* ===== FOOTER ===== */}
      <footer className="relative z-10 border-t border-white/5 bg-surface-900/90 py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6 text-xs text-slate-500">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-primary-500 to-accent-600 flex items-center justify-center text-white font-bold text-xs">
              <HiAcademicCap className="w-4 h-4" />
            </div>
            <div>
              <p className="font-semibold text-slate-300 text-sm">PPD Lab Platform</p>
              <p>Biju Patnaik University of Technology (BPUT), Rourkela • CSE Dept</p>
            </div>
          </div>

          <div className="flex items-center gap-6 text-slate-400">
            <a href="#features" className="hover:text-white transition-colors">Features</a>
            <a href="#curriculum" className="hover:text-white transition-colors">Curriculum</a>
            <a href="#demo" className="hover:text-white transition-colors">IDE Simulation</a>
            <a href="#faq" className="hover:text-white transition-colors">FAQ</a>
            <button onClick={() => navigate('/faculty')} className="text-accent-400 hover:text-white transition-colors font-medium">Faculty Portal</button>
            <button onClick={() => navigate('/login')} className="hover:text-white transition-colors">Student Login</button>
          </div>

          <div>
            <p>&copy; {new Date().getFullYear()} BPUT CSE Department. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}

