"""
Comprehensive University-Grade Lab Manuals for Semester 5 BPUT CSE:
- CSPC3201: Theory of Computation Laboratory (8 Experiments)
- CSPC3202: Operating Systems Laboratory (12 Experiments)
- CSPC3203: Machine Learning Laboratory (13 Experiments)
"""

SEM5_MANUALS = {
    # =========================================================================
    # CSPC3201: Theory of Computation Laboratory (Python/JFLAP)
    # =========================================================================
    ("CSPC3201", 1): """# Experiment 01: Introduction to Automata Simulation

## 🎯 Aim of the Experiment
To understand formal language theory, familiarize with automata simulation tools (Python / JFLAP), and construct a basic Finite Automaton simulation engine.

## 💻 Apparatus & Environment
- **Environment:** Python 3.8+ / JFLAP 7.1
- **Tools:** Graphviz (optional for state diagram rendering)

## 📖 Theoretical Background & Core Principles
A **Deterministic Finite Automaton (DFA)** is a 5-tuple:
$$M = (Q, \\Sigma, \\delta, q_0, F)$$
- $Q$: Finite set of states.
- $\\Sigma$: Finite input alphabet.
- $\\delta: Q \\times \\Sigma \\to Q$: Transition function.
- $q_0 \\in Q$: Initial start state.
- $F \\subseteq Q$: Set of accept/final states.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Represent the transition function as a Python nested dictionary: `delta[current_state][symbol] = next_state`.
2. Initialize `current_state = q0`.
3. For each symbol in input string $w$:
   - If symbol not in $\\Sigma$, reject.
   - Update `current_state = delta[current_state][symbol]`.
4. If `current_state in F`, accept; else reject.

## 💡 Sample Test Case
```python
# Language: Strings containing substring 'ab'
states = {'q0', 'q1', 'q2'}
alphabet = {'a', 'b'}
transition = {
    'q0': {'a': 'q1', 'b': 'q0'},
    'q1': {'a': 'q1', 'b': 'q2'},
    'q2': {'a': 'q2', 'b': 'q2'}
}
# String 'aab' -> Ends in q2 (Accepted)
# String 'ba'  -> Ends in q1 (Rejected)
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(|w|)$ linear in string length.
- Space Complexity: $O(|Q| \\times |\\Sigma|)$ to store state transition table.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between a DFA and an NFA?**
   *Answer:* In a DFA, each state has exactly one transition for every symbol in $\\Sigma$. In an NFA, a state can have zero, one, or multiple transitions per symbol, as well as $\\epsilon$-transitions.
2. **What is an Alphabet in formal language theory?**
   *Answer:* A non-empty, finite set of symbols denoted by $\\Sigma$ (e.g. $\\{0, 1\\}$).
""",

    ("CSPC3201", 2): """# Experiment 02: DFA Design and Simulation

## 🎯 Aim of the Experiment
To design and simulate DFAs recognizing specific regular languages (e.g., strings ending in `01`, strings with even number of `0`s, binary multiples of 3).

## 📖 Theoretical Background & Core Principles
Designing a minimal DFA requires identifying the minimal equivalence classes of the language using the Myhill-Nerode theorem.

### Example: Strings ending in `01` over $\\Sigma = \\{0, 1\\}$:
- State $q_0$: Base state / last symbol was `1` or start.
- State $q_1$: Last symbol was `0`.
- State $q_2$: Last two symbols were `01` (Accept state).

```
          1          0
       +----+     +----+
       v    |     v    |
----->(q0)----0--->(q1)----1--->((q2))
        ^                          |
        |------------0-------------|
```

## 💡 Sample Test Case
```text
DFA: Ends in '01'
Input '1001' -> Accepted
Input '1010' -> Rejected
Input '01'   -> Accepted
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Dead State (Trap State)?**
   *Answer:* A non-accepting state from which there is no escape path to any accepting state regardless of subsequent input symbols.
""",

    ("CSPC3201", 3): """# Experiment 03: NFA Design and Conversion to DFA

## 🎯 Aim of the Experiment
To construct a Non-Deterministic Finite Automaton (NFA) and implement the **Subset Construction Algorithm (Powerset Construction)** to convert it into an equivalent minimal DFA.

## 📖 Theoretical Background & Core Principles
Every NFA with $n$ states can be converted into an equivalent DFA having at most $2^n$ states. Each DFA state corresponds to a subset of NFA states reachable simultaneously.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Initial DFA state $S_0 = \\{q_0\\}$.
2. For each unmarked DFA state $T$:
   - Mark $T$.
   - For each input symbol $a \\in \\Sigma$:
     - Compute $U = \\bigcup_{s \\in T} \\delta_{NFA}(s, a)$.
     - If $U$ is new, add $U$ as an unvisited DFA state.
     - Add transition $\\delta_{DFA}(T, a) = U$.
3. Any DFA state containing at least one NFA accept state becomes a DFA accept state.

## 💡 Sample Output
```text
NFA States: {q0, q1, q2}
DFA States Created: {q0}, {q0, q1}, {q0, q2}
Language equivalence verified on 100 random strings.
```

## ⏱️ Complexity Analysis
- Time/Space Complexity: $O(2^{|Q|})$ in the theoretical worst case, though typically much smaller in practical grammars.

## ❓ Viva-Voce Questions with Model Answers
1. **Does an NFA recognize more languages than a DFA?**
   *Answer:* No, both DFAs and NFAs recognize exactly the identical class of Regular Languages (they are computationally equivalent in expressive power).
""",

    ("CSPC3201", 4): """# Experiment 04: NFA with Epsilon Transitions (ε-NFA)

## 🎯 Aim of the Experiment
To construct an $\\epsilon$-NFA, implement the **$\\epsilon$-closure** calculation, and eliminate $\\epsilon$-transitions to produce an equivalent standard DFA.

## 📖 Theoretical Background & Core Principles
The $\\epsilon$-closure of a state $q$, denoted $\\epsilon\\text{-closure}(q)$, is the set of all states reachable from $q$ by traversing zero or more $\\epsilon$ (null) transitions without consuming any input symbol.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Calculate $\\epsilon\\text{-closure}(S)$ using depth-first search (DFS) along $\\epsilon$-edges.
2. Form equivalent DFA transitions:
   $$\\delta'(T, a) = \\epsilon\\text{-closure}\\left( \\bigcup_{s \\in T} \\delta(s, a) \\right)$$

## 💡 Sample Output
```text
Epsilon-closure(q0) = {q0, q1, q2}
Transition on 'a' from closure = {q1}
DFA constructed successfully without epsilon hops.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the practical use of $\\epsilon$-NFAs?**
   *Answer:* Thompson's Construction algorithm converts Regular Expressions directly into $\\epsilon$-NFAs as the first stage in lexical analyzers (like Lex/Flex).
""",

    ("CSPC3201", 5): """# Experiment 05: Moore and Mealy Machines

## 🎯 Aim of the Experiment
To design and simulate Finite State Machines with output: **Moore Machine** (output depends on state) and **Mealy Machine** (output depends on state and current input), and convert between them.

## 📖 Theoretical Background & Core Principles
- **Moore Machine:** Output function $\\lambda: Q \\to \\Delta$. Output is associated with states.
- **Mealy Machine:** Output function $\\lambda: Q \\times \\Sigma \\to \\Delta$. Output is associated with transitions.
- A Mealy machine typically requires fewer states than an equivalent Moore machine.

## 💡 Sample Test Case
```text
Design: 2's Complement Generator
Mealy Machine: 2 states (Outputs 0s until first 1, then inverts remaining bits)
Moore Machine: Requires 3 states to generate equivalent output sequence.
```

## ❓ Viva-Voce Questions with Model Answers
1. **Can a Moore machine respond immediately to input changes?**
   *Answer:* No, a Moore machine changes its output only on clock edge state transitions, whereas a Mealy machine can change output immediately when input changes asynchronously.
""",

    ("CSPC3201", 6): """# Experiment 06: Context-Free Grammar (CFG) Design

## 🎯 Aim of the Experiment
To design **Context-Free Grammars (CFGs)** for formal languages, eliminate ambiguities, and generate derivation parse trees.

## 📖 Theoretical Background & Core Principles
A CFG is a 4-tuple $G = (V, \\Sigma, R, S)$:
- $V$: Non-terminals (variables).
- $\\Sigma$: Terminals.
- $R$: Production rules ($A \\to \\alpha$ where $A \\in V, \\alpha \\in (V \\cup \\Sigma)^*$).
- $S$: Start symbol.

### Example: Balanced Parentheses:
$$S \\to (S) \\mid SS \\mid \\epsilon$$

## 💡 Sample Output
```text
Input: "(())()"
Leftmost Derivation:
S => (S) => ((S)) => (())
Parse Tree generated with height 3.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is an ambiguous grammar?**
   *Answer:* A grammar that produces two or more distinct leftmost derivations (or parse trees) for the same valid string.
""",

    ("CSPC3201", 7): """# Experiment 07: Pushdown Automata Simulation (PDA)

## 🎯 Aim of the Experiment
To design and simulate a **Pushdown Automaton (PDA)** in Python that accepts non-regular context-free languages (e.g. $L = \\{a^n b^n \\mid n \\ge 1\\}$) using a stack.

## 📖 Theoretical Background & Core Principles
A PDA augments a finite state automaton with an unbounded LIFO stack memory:
$$M = (Q, \\Sigma, \\Gamma, \\delta, q_0, Z_0, F)$$
Transitions depend on current state, input symbol, and top-of-stack symbol: $\\delta(q, a, X) \\to (p, \\gamma)$.

## 💡 Sample Output
```text
Input: "aaabbb"
Action: Pushed 3 'a's onto stack with Z0.
Action: Popped 'a' for each 'b' encountered.
Stack top: Z0, Input exhausted.
Accepted by Final State & Empty Stack!
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between DPDA and NPDA?**
   *Answer:* Unlike finite automata, Deterministic PDAs are strictly less expressive than Non-deterministic PDAs. NPDAs recognize all Context-Free Languages, whereas DPDAs recognize only Deterministic CFLs.
""",

    ("CSPC3201", 8): """# Experiment 08: Turing Machine Simulation

## 🎯 Aim of the Experiment
To design and execute a **Turing Machine (TM)** simulation in Python performing unary addition or binary palindrome verification.

## 📖 Theoretical Background & Core Principles
A Turing Machine is the fundamental mathematical model of modern universal computation, consisting of an infinite two-way tape, a read/write head, and a state register:
$$\\delta: Q \\times \\Gamma \\to Q \\times \\Gamma \\times \\{L, R\\}$$

## 💡 Sample Output
```text
Unary Addition: Tape "111+11" -> Head scans, replaces '+' with '1', erases trailing '1'
Final Tape: "11111" (3 + 2 = 5)
State: q_halt (Computation finished)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the Church-Turing Thesis?**
   *Answer:* The hypothesis that any algorithm that can be computed by any physical computer or human can also be computed by a Turing Machine.
2. **What is the Halting Problem?**
   *Answer:* The undecidable problem of determining whether an arbitrary program and input will eventually finish running or run forever (proven undecidable by Alan Turing in 1936).
""",

    # =========================================================================
    # CSPC3202: Operating Systems Laboratory (C)
    # =========================================================================
    ("CSPC3202", 1): """# Experiment 01: OS Installation & Virtualization

## 🎯 Aim of the Experiment
To install a modern Linux distribution (Ubuntu 22.04 LTS / Fedora) in a dual-boot or virtualized environment (VirtualBox / KVM), configure disk partitions (GPT/EFI), and initialize system services.

## 📖 Theoretical Background & Core Principles
- **Partitioning Schemes:** MBR (Legacy, max 4 primary partitions, 2 TB limit) vs GPT (GUID Partition Table, 128 partitions, 18 EB).
- **Filesystem Hierarchy Standard (FHS):** `/bin` (binaries), `/etc` (configurations), `/home` (user data), `/var` (variable logs), `/proc` (virtual kernel process filesystem).

## ⚙️ Step-by-Step Procedure
1. Create a VM with 2 vCPUs, 4 GB RAM, and 25 GB VDI disk.
2. Configure mount points: `/boot/efi` (512 MB FAT32), `swap` (4 GB), `/` (root ext4 remainder).
3. Complete installation and verify GRUB bootloader.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the purpose of swap space?**
   *Answer:* A dedicated disk region used by the kernel memory manager as virtual memory when physical RAM is exhausted.
""",

    ("CSPC3202", 2): """# Experiment 02: Linux Administrative Commands

## 🎯 Aim of the Experiment
To practice core Linux administrative commands for process management, file permissions, user groups, and disk storage inspection.

## 📖 Theoretical Background & Core Principles
Unix follows "Everything is a file". Permissions consist of Read (4), Write (2), and Execute (1) across User, Group, and Others.

## 💡 Essential Command Reference
```bash
# File permissions
chmod 755 script.sh      # rwxr-xr-x
chown root:developer file.txt

# Process monitoring
ps aux | grep nginx      # View process tree
top                      # Live system resource usage
kill -9 <PID>            # Send SIGKILL

# Disk and memory
df -h                    # Disk free human-readable
free -m                  # Physical RAM & Swap metrics
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between `kill -15` (SIGTERM) and `kill -9` (SIGKILL)?**
   *Answer:* `SIGTERM` requests graceful shutdown allowing processes to clean up resources; `SIGKILL` immediately terminates the process at kernel level without handler execution.
""",

    ("CSPC3202", 3): """# Experiment 03: UNIX Shell Programming

## 🎯 Aim of the Experiment
To write automated Bash shell scripts demonstrating variables, positional parameters, arithmetic expansions, conditionals, loops, and user-defined functions.

## 📖 Theoretical Background & Core Principles
Bash (Bourne Again Shell) is the primary command-line interpreter in Unix-like systems, enabling administrative automation and task pipelining.

## 💡 Sample Script
```bash
#!/bin/bash
echo "=== Prime Number Checker ==="
read -p "Enter integer: " n
if [ $n -le 1 ]; then
    echo "$n is NOT prime"
    exit 0
fi
for (( i=2; i*i<=n; i++ )); do
    if [ $((n % i)) -eq 0 ]; then
        echo "$n is NOT prime"
        exit 0
    fi
done
echo "$n is a PRIME number"
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the significance of the first line `#!/bin/bash` (Shebang)?**
   *Answer:* It directs the program loader to use `/bin/bash` as the interpreter to parse and execute the script contents.
""",

    ("CSPC3202", 4): """# Experiment 04: Process Management System Calls (fork, exec, wait)

## 🎯 Aim of the Experiment
To write C programs demonstrating process creation, parent-child process synchronization, and program replacement using UNIX system calls: `fork()`, `execvp()`, and `wait()`.

## 📖 Theoretical Background & Core Principles
- `fork()` clones the calling process: returns `0` to the child and child's PID to parent.
- `wait()` halts parent until child completes, reaping the process table entry.
- `execvp()` overwrites the calling process image with a new executable binary.

```
Parent Process (PID 1000)
       |
    fork() -------------------+
       |                      |
   wait(NULL)         Child Process (PID 1001)
       |                      |
       |                   execvp()
       |                      |
       v                      v
Parent Resumes <------- Child Terminates (Exit 0)
```

## 💡 Sample Code
```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();
    if (pid < 0) {
        perror("Fork failed");
        return 1;
    } else if (pid == 0) {
        printf("Child Process: PID=%d, Parent PID=%d\\n", getpid(), getppid());
    } else {
        wait(NULL);
        printf("Parent Process: PID=%d, Child finished.\\n", getpid());
    }
    return 0;
}
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Zombie process vs Orphan process?**
   *Answer:* An orphan's parent died before it; it is adopted by `systemd` (PID 1). A zombie has finished execution but remains in the process table because its parent hasn't yet called `wait()`.
""",

    ("CSPC3202", 5): """# Experiment 05: Dining Philosophers Synchronization Problem

## 🎯 Aim of the Experiment
To simulate the classic **Dining Philosophers Problem** in C using POSIX mutex locks and semaphores to prevent deadlocks and starvation.

## 📖 Theoretical Background & Core Principles
Five philosophers sit at a circular table with 5 chopsticks. A philosopher needs both adjacent chopsticks to eat. If all philosophers pick their right chopstick simultaneously, a circular wait deadlock occurs.

### Deadlock Solutions:
1. Resource hierarchy: Pick lower-numbered chopstick first.
2. Allow at most 4 philosophers to sit at the table simultaneously using a counting semaphore.

## 💡 Sample Output
```text
Philosopher 0 is THINKING
Philosopher 1 is EATING (Holding chopsticks 1 & 2)
Philosopher 2 is HUNGRY (Waiting for chopstick 2)
Philosopher 1 finished EATING, released chopsticks.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What are the four Coffman conditions for deadlock?**
   *Answer:* Mutual Exclusion, Hold and Wait, No Preemption, and Circular Wait.
""",

    ("CSPC3202", 6): """# Experiment 06: CPU Scheduling Algorithms (FCFS, SJF, RR)

## 🎯 Aim of the Experiment
To simulate CPU scheduling algorithms in C: **First-Come First-Served (FCFS)**, **Shortest Job First (SJF)**, and **Round Robin (RR)**, and compute average Waiting Time (WT) and Turnaround Time (TAT).

## 📖 Theoretical Background & Core Principles
- **Turnaround Time (TAT):** $\\text{Completion Time} - \\text{Arrival Time}$.
- **Waiting Time (WT):** $\\text{Turnaround Time} - \\text{Burst Time}$.
- Round Robin assigns fixed time quantum $q$, preempting processes into a circular ready queue.

## 💡 Sample Comparison Table
```text
Algorithm   | Avg Waiting Time | Avg Turnaround Time | Preemptive?
------------+------------------+---------------------+------------
FCFS        | 17.0 ms          | 27.0 ms             | No
SJF (NP)    | 7.33 ms          | 17.33 ms            | No
Round Robin | 10.67 ms         | 20.67 ms            | Yes (q=2)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the Convoy Effect in FCFS?**
   *Answer:* When short CPU-burst processes queue up behind a long CPU-burst process, dramatically increasing average waiting time.
""",

    ("CSPC3202", 7): """# Experiment 07: Banker's Deadlock Avoidance Algorithm

## 🎯 Aim of the Experiment
To implement **Banker's Algorithm** for deadlock avoidance, evaluating the safety state of the system and calculating a valid safe execution sequence.

## 📖 Theoretical Background & Core Principles
The system tracks matrices:
- `Allocation[P][R]`: Resources currently allocated.
- `Max[P][R]`: Maximum resource demand.
- `Need[P][R] = Max[P][R] - Allocation[P][R]`.
- `Available[R]`: Free resources in system.

## 💡 Sample Output
```text
System is in a SAFE state!
Safe Execution Sequence: P1 -> P3 -> P4 -> P0 -> P2
New resource request for P1 [1, 0, 2] approved immediately.
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(R \\times P^2)$ where $P$ is process count and $R$ is resource types.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Deadlock Prevention and Deadlock Avoidance?**
   *Answer:* Prevention eliminates one of Coffman's conditions statically; Avoidance dynamically inspects resource allocation requests to ensure the system never enters an unsafe state.
""",

    ("CSPC3202", 8): """# Experiment 08: Page Replacement Algorithms (FIFO, LRU, Optimal)

## 🎯 Aim of the Experiment
To simulate virtual memory page replacement algorithms: **FIFO**, **Least Recently Used (LRU)**, and **Optimal (OPT)**, and count page faults for a reference string.

## 📖 Theoretical Background & Core Principles
When a process references a logical memory page not present in physical RAM frames, a **Page Fault** occurs, requiring a victim frame replacement.

## 💡 Sample Benchmark
```text
Reference String: 7, 0, 1, 2, 0, 3, 0, 4, 2, 3, 0, 3, 2 (Frames = 3)
FIFO Total Page Faults:    10
LRU Total Page Faults:     8
Optimal Page Faults:       6 (Theoretical Minimum)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is Belady's Anomaly?**
   *Answer:* The counter-intuitive phenomenon where increasing the number of physical frames increases the total number of page faults (occurs in FIFO, but never in stack-based algorithms like LRU).
""",

    ("CSPC3202", 9): """# Experiment 09: POSIX Threading (Pthreads)

## 🎯 Aim of the Experiment
To implement multithreaded programming in C using POSIX Threads (`pthread_create`, `pthread_join`, `pthread_mutex_t`), demonstrating parallel computation and mutex locking.

## 💡 Sample Code
```c
#include <pthread.h>
#include <stdio.h>

int counter = 0;
pthread_mutex_t lock;

void* worker(void* arg) {
    pthread_mutex_lock(&lock);
    counter++;
    pthread_mutex_unlock(&lock);
    return NULL;
}
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a race condition?**
   *Answer:* An undesirable situation where multiple threads read and write shared data concurrently, and the final outcome depends on uncontrollable thread scheduling order.
""",

    ("CSPC3202", 10): """# Experiment 10: Paging Memory Management Scheme

## 🎯 Aim of the Experiment
To simulate the hardware Paging scheme in C, translating logical addresses (Page Number + Page Offset) to physical addresses (Frame Number + Frame Offset) via a simulated Page Table.

## 📖 Theoretical Background & Core Principles
- Logical Address size = $m$ bits; Page Size = $2^p$ bytes.
- Page Number $p = \\text{address} / \\text{PageSize}$.
- Offset $d = \\text{address} \\bmod \\text{PageSize}$.
- Physical Address = $(\\text{FrameNumber} \\times \\text{PageSize}) + d$.

## 💡 Sample Translation
```text
Page Size: 1024 bytes (1 KB)
Logical Address: 3500
Page Number: 3500 / 1024 = 3, Offset: 428
Page Table: Page 3 maps to Frame 7
Physical Address: (7 * 1024) + 428 = 7596
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Translation Lookaside Buffer (TLB)?**
   *Answer:* A high-speed associative hardware cache that stores recent page-to-frame mappings to avoid two memory lookups per memory access.
""",

    ("CSPC3202", 11): """# Experiment 11: Contiguous Memory Allocation (First, Best, Worst Fit)

## 🎯 Aim of the Experiment
To simulate dynamic variable-partition memory allocation strategies: **First Fit**, **Best Fit**, and **Worst Fit**, and compare external fragmentation.

## 📖 Theoretical Background & Core Principles
- **First Fit:** Allocates the first hole that is big enough (Fastest).
- **Best Fit:** Allocates the smallest hole that is big enough (Leaves tiny residual fragments).
- **Worst Fit:** Allocates the largest available hole (Leaves large reusable fragments).

## 💡 Sample Comparison
```text
Memory Blocks: [100K, 500K, 200K, 300K, 600K]
Processes: P1=212K, P2=417K, P3=112K, P4=426K
First Fit successfully allocated all 4 processes.
Best Fit allocated all 4 processes with smallest leftover holes.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Internal and External Fragmentation?**
   *Answer:* Internal is wasted space inside an allocated block (fixed partitioning); External is free space scattered across memory in blocks too small to satisfy requests.
""",

    ("CSPC3202", 12): """# Experiment 12: Android Mobile Application Architecture

## 🎯 Aim of the Experiment
To explore the Android OS architecture (Linux kernel, HAL, ART runtime, Application Framework), Activity lifecycle, and event-driven mobile application development.

## 📖 Theoretical Background & Core Principles
Android sits on top of a modified Linux kernel. Apps run inside individual sandboxed processes utilizing the Android Runtime (ART) with Ahead-of-Time (AOT) and JIT compilation.

### Activity Lifecycle States:
`onCreate()` -> `onStart()` -> `onResume()` -> `onPause()` -> `onStop()` -> `onDestroy()`.

## 💡 Sample Activity Method
```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    Button btn = findViewById(R.id.myButton);
    btn.setOnClickListener(v -> Toast.makeText(this, "Android OS Lab Active", Toast.LENGTH_SHORT).show());
}
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is an Intent in Android?**
   *Answer:* An asynchronous messaging object used to request an action from another app component (Explicit Intent specifies target class; Implicit Intent specifies action filter).
""",

    # =========================================================================
    # CSPC3203: Machine Learning Laboratory (Python)
    # =========================================================================
    ("CSPC3203", 1): """# Experiment 01: Python Scientific Environment Setup

## 🎯 Aim of the Experiment
To configure a modern scientific Python environment (Anaconda, Jupyter, Virtual Environments), understand vectorization, and implement core Python idioms (list comprehensions, generators, lambda functions).

## 💻 Apparatus & Environment
- **Runtime:** Python 3.9+ / Anaconda / Miniconda
- **Packages:** NumPy, Pandas, Scipy, Matplotlib

## 💡 Sample Code
```python
# List comprehension vs Vectorized operation
data = [i for i in range(1000)]
squares = [x**2 for x in data if x % 2 == 0]
print(f"Computed {len(squares)} even squares.")
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why is Python the preferred language for Machine Learning?**
   *Answer:* Clean readable syntax, rich scientific ecosystem (NumPy, Scikit-Learn, PyTorch), and seamless C/C++ backend bindings for high-performance tensor computing.
""",

    ("CSPC3203", 2): """# Experiment 02: Introduction to ML Libraries (NumPy, Pandas, Matplotlib)

## 🎯 Aim of the Experiment
To manipulate tabular data with **Pandas**, perform matrix operations in **NumPy**, and visualize data distributions using **Matplotlib** and **Seaborn**.

## 📖 Theoretical Background & Core Principles
- **NumPy:** $N$-dimensional arrays (`ndarray`) with contiguous memory and SIMD vectorization.
- **Pandas:** `DataFrame` for labeled tabular data manipulation.
- **Matplotlib:** 2D plotting library for publication-quality charts.

## 💡 Sample Script
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.DataFrame({
    'Feature_A': np.random.normal(0, 1, 100),
    'Feature_B': np.random.normal(5, 2, 100)
})
print(df.describe())
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is broadcasting in NumPy?**
   *Answer:* The mechanism that allows arithmetic operations between arrays of differing shapes by virtually stretching the smaller array to match the larger dimensions.
""",

    ("CSPC3203", 3): """# Experiment 03: NumPy Linear Algebra & Matrix Operations

## 🎯 Aim of the Experiment
To implement matrix arithmetic, dot products, eigenvalues/eigenvectors, and matrix inversion using `numpy.linalg`.

## 📖 Theoretical Background & Core Principles
Linear transformations and matrix algebra underpin machine learning algorithms (covariance matrices, projection matrices, neural network layer weights).

## 💡 Sample Execution
```python
import numpy as np

A = np.array([[4, 2], [1, 3]])
eigenvalues, eigenvectors = np.linalg.eig(A)
print("Eigenvalues:", eigenvalues)
print("Eigenvectors:\\n", eigenvectors)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is an eigenvector?**
   *Answer:* A non-zero vector whose direction does not change when a linear transformation is applied, scaling only by a scalar factor known as the eigenvalue ($A v = \\lambda v$).
""",

    ("CSPC3203", 4): """# Experiment 04: Statistical Measures (Mean, Median, Mode, Variance, StdDev)

## 🎯 Aim of the Experiment
To compute descriptive statistical measures (Central Tendency and Dispersion) manually from mathematical formulas and compare them with `scipy.stats`.

## 📖 Theoretical Background & Core Principles
- **Mean:** $\\bar{x} = \\frac{1}{n} \\sum x_i$
- **Variance:** $\\sigma^2 = \\frac{1}{n-1} \\sum (x_i - \\bar{x})^2$
- **Standard Deviation:** $\\sigma = \\sqrt{\\sigma^2}$

## 💡 Sample Output
```text
Dataset: [12, 15, 18, 22, 25, 30, 35, 18, 22, 22]
Mean: 21.90 | Median: 22.00 | Mode: 22
Variance: 48.77 | Standard Deviation: 6.98
```

## ❓ Viva-Voce Questions with Model Answers
1. **When is Median preferred over Mean?**
   *Answer:* When the dataset contains extreme outliers or is heavily skewed, as the median is a robust statistic unaffected by extreme values.
""",

    ("CSPC3203", 5): """# Experiment 05: Machine Learning Frameworks Overview (Scikit-Learn)

## 🎯 Aim of the Experiment
To explore the Scikit-Learn API design (`fit`, `transform`, `predict`), train-test splitting, data standardization, and pipeline construction.

## 📖 Theoretical Background & Core Principles
Data leakage occurs if test sets influence training preprocessing. Scikit-Learn `Pipeline` chains transformers (`StandardScaler`) and estimators cleanly.

## 💡 Sample Code
```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('clf', LogisticRegression())
])
# pipe.fit(X_train, y_train)
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why must data be split into training and test sets?**
   *Answer:* To evaluate model generalization on unseen data and prevent overfitting.
""",

    ("CSPC3203", 6): """# Experiment 06: Linear Regression

## 🎯 Aim of the Experiment
To implement **Simple and Multiple Linear Regression**, derive the Ordinary Least Squares (OLS) normal equation, train using gradient descent, and evaluate with $R^2$ score and RMSE.

## 📖 Theoretical Background & Core Principles
Linear regression models linear relationship between input $X$ and continuous target $y$:
$$\\hat{y} = w^T X + b$$
Cost Function: Mean Squared Error (MSE):
$$J(w) = \\frac{1}{2m} \\sum_{i=1}^m (\\hat{y}^{(i)} - y^{(i)})^2$$

## 💡 Sample Benchmark
```text
Trained Model: y = 2.45 * x + 5.12
Mean Squared Error (MSE): 0.842
R-squared (R2) Score: 0.941 (94.1% variance explained)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is multicollinearity in multiple regression?**
   *Answer:* When two or more predictor features are highly correlated, leading to unstable coefficient estimates and inflated standard errors.
""",

    ("CSPC3203", 7): """# Experiment 07: Logistic Regression for Binary Classification

## 🎯 Aim of the Experiment
To implement **Logistic Regression** using the Sigmoid activation function, cross-entropy loss, and evaluate performance using Confusion Matrix, Accuracy, Precision, Recall, and ROC-AUC.

## 📖 Theoretical Background & Core Principles
Logistic regression maps continuous linear combination to probability space $[0, 1]$ via the Sigmoid function:
$$\\sigma(z) = \\frac{1}{1 + e^{-z}}$$

## 💡 Sample Metrics Output
```text
Confusion Matrix:
[[50   3]
 [ 2  45]]
Accuracy:  95.0%
Precision: 93.8%
Recall:    95.7%
F1-Score:  94.7%
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why is MSE not suitable for Logistic Regression cost function?**
   *Answer:* Because plugging the non-linear Sigmoid into MSE yields a non-convex function with numerous local minima, preventing guaranteed gradient descent convergence.
""",

    ("CSPC3203", 8): """# Experiment 08: K-Nearest Neighbours (KNN)

## 🎯 Aim of the Experiment
To implement the **K-Nearest Neighbours (KNN)** non-parametric classification algorithm using Euclidean distance and study the impact of hyperparameter $k$.

## 📖 Theoretical Background & Core Principles
KNN is a lazy learning instance-based algorithm that assigns the class dominating the $k$ closest training points in feature space:
$$d(x, y) = \\sqrt{\\sum_{i=1}^n (x_i - y_i)^2}$$

## 💡 Sample Test Case
```text
Iris Dataset (k=3):
Testing Sample [5.1, 3.5, 1.4, 0.2]
Nearest Neighbours: 3 Setosa samples
Predicted Class: Iris-Setosa (Confidence: 100%)
```

## ⏱️ Complexity Analysis
- Training Time: $O(1)$
- Prediction Time: $O(N \\times D)$ per query (high inference cost).

## ❓ Viva-Voce Questions with Model Answers
1. **Why is feature scaling essential before applying KNN?**
   *Answer:* Because features with larger numeric magnitudes will disproportionately dominate distance calculations, distorting neighbor selection.
""",

    ("CSPC3203", 9): """# Experiment 09: Decision Tree Classifier

## 🎯 Aim of the Experiment
To implement the **Decision Tree Classifier** (CART algorithm) using **Gini Impurity** and **Information Gain (Entropy)**, and prune tree depth to avoid overfitting.

## 📖 Theoretical Background & Core Principles
A decision tree recursively splits feature space to maximize purity.
- **Gini Impurity:** $I_G(p) = 1 - \\sum_{i=1}^C p_i^2$
- **Information Gain:** $IG(T, a) = H(T) - H(T \\mid a)$

## 💡 Sample Output
```text
Decision Tree generated with max_depth=3.
Root Split: petal_length <= 2.45 (Gini = 0.66)
Training Accuracy: 98.2%, Test Accuracy: 96.0%
```

## ❓ Viva-Voce Questions with Model Answers
1. **How does pre-pruning differ from post-pruning?**
   *Answer:* Pre-pruning stops tree growth early based on criteria like `max_depth` or `min_samples_split`; post-pruning builds a full tree and trims branches based on validation error.
""",

    ("CSPC3203", 10): """# Experiment 10: Random Forest Ensemble

## 🎯 Aim of the Experiment
To construct a **Random Forest Ensemble** using Bootstrap Aggregating (Bagging) and Random Subspace method, and evaluate feature importances.

## 📖 Theoretical Background & Core Principles
Random Forest builds $B$ decorrelated decision trees on bootstrap resamples of training data, averaging their outputs (or voting) to significantly reduce model variance.

## 💡 Sample Output
```text
Number of Trees: 100
Out-of-Bag (OOB) Score: 0.965
Top Feature Importance:
1. Petal Length: 0.45
2. Petal Width:  0.42
3. Sepal Length: 0.09
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is Out-of-Bag (OOB) error?**
   *Answer:* The validation error calculated on samples left out of the bootstrap sample (~36.8% of data per tree), providing an unbiased performance metric without cross-validation.
""",

    ("CSPC3203", 11): """# Experiment 11: Support Vector Machine (SVM)

## 🎯 Aim of the Experiment
To implement **Support Vector Machines (SVM)** for linear and non-linear classification using kernel functions (Linear, RBF, Polynomial).

## 📖 Theoretical Background & Core Principles
SVM finds the maximum-margin hyperplane separating two classes:
$$\\max \\frac{2}{\\|w\\|} \\quad \\text{subject to } y_i(w^T x_i + b) \\ge 1$$
The **Kernel Trick** maps inputs into high-dimensional Hilbert spaces without explicitly computing high-dimensional coordinates.

## 💡 Sample Output
```text
SVM with RBF Kernel (C=1.0, gamma='scale')
Number of Support Vectors: 42
Test Classification Accuracy: 97.5%
```

## ❓ Viva-Voce Questions with Model Answers
1. **What role do support vectors play in the final model?**
   *Answer:* Only the data points that lie directly on or inside the margin boundaries (support vectors) determine the orientation and position of the separating hyperplane.
""",

    ("CSPC3203", 12): """# Experiment 12: Principal Component Analysis (PCA)

## 🎯 Aim of the Experiment
To implement **Principal Component Analysis (PCA)** for unsupervised dimensionality reduction, compute the covariance matrix, and plot explained variance ratios.

## 📖 Theoretical Background & Core Principles
PCA orthogonally transforms correlated features into a smaller set of linearly uncorrelated variables (Principal Components) that maximize variance along orthogonal axes.

## 💡 Sample Output
```text
Original Dimensions: 4 features
Reduced Dimensions:  2 Principal Components
Explained Variance Ratio: PC1 = 72.8%, PC2 = 23.0% (Cumulative: 95.8%)
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why must data be mean-centered before PCA?**
   *Answer:* Because PCA seeks eigenvectors of the covariance matrix; without mean-centering, the first component would point toward the mean of the data rather than maximum variance.
""",

    ("CSPC3203", 13): """# Experiment 13: K-Means Clustering

## 🎯 Aim of the Experiment
To implement the **K-Means Clustering** unsupervised algorithm, evaluate cluster centroids, and determine the optimal cluster count $k$ using the **Elbow Method** and **Silhouette Score**.

## 📖 Theoretical Background & Core Principles
K-Means partitions $n$ observations into $k$ clusters by minimizing the Within-Cluster Sum of Squares (WCSS / Inertia):
$$J = \\sum_{i=1}^k \\sum_{x \\in S_i} \\|x - \\mu_i\\|^2$$

## 💡 Sample Output
```text
Elbow analysis evaluated for k=1 to 8:
Optimal elbow point detected at k = 3.
Silhouette Score at k=3: 0.552 (Strong cluster cohesion)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between K-Means and K-Means++?**
   *Answer:* Standard K-Means picks initial centroids randomly (vulnerable to poor local minima); K-Means++ selects initial centroids with probability proportional to squared distance from existing centroids, ensuring well-dispersed starts.
"""
}
