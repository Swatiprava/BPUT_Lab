"""
Comprehensive University-Grade Lab Manuals for Semester 4 BPUT CSE:
- CSPC2204: Database Engineering Lab (10 Experiments)
- CSPC2205: Computer Organization & Architecture Lab (4 Experiments)
- CSPC2206: Design & Analysis of Algorithms Lab (10 Experiments)
- CSPC2207: Computer Networks Lab (10 Experiments)
"""

SEM4_MANUALS = {
    # =========================================================================
    # CSPC2204: Database Engineering Lab (SQL)
    # =========================================================================
    ("CSPC2204", 1): """# Experiment 01: Library Database Schema & DDL/DML Queries

## 🎯 Aim of the Experiment
To design and implement a relational database schema for a **Library Management System**, enforce primary and foreign key integrity constraints, insert sample data, and write relational SQL queries to retrieve lending records.

## 💻 Apparatus & Environment
- **RDBMS:** PostgreSQL 14+ / MySQL 8.0+ / SQLite 3
- **Tools:** pgAdmin / psql CLI / DBeaver

## 📖 Theoretical Background & Core Principles
A Relational Database Management System (RDBMS) represents data as relations (tables) conforming to relational calculus and integrity constraints:
- **Entity Integrity:** Primary Key must be unique and non-null.
- **Referential Integrity:** Foreign keys must reference valid existing primary keys in parent tables.
- **Cascading Rules:** `ON DELETE CASCADE` propagates deletions from parent to child records.

### Schema Entities:
1. `PUBLISHER (Name, Address, Phone)`
2. `BOOK (Book_id, Title, Publisher_Name, Pub_Year)`
3. `BOOK_AUTHORS (Book_id, Author_Name)`
4. `BOOK_COPIES (Book_id, Programme_id, No_of_Copies)`
5. `BOOK_LENDING (Book_id, Programme_id, Card_No, Date_Out, Due_Date)`

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create tables with proper data types and primary/foreign key relationships.
2. Insert consistent sample data across all tables.
3. Write queries:
   - Retrieve all book titles with author and publisher names.
   - Find borrowers who checked out more than 3 books between specific dates.
   - Delete a book and observe foreign key behavior.

## 💡 Sample Test Case & Queries
```sql
CREATE TABLE PUBLISHER (
    Name VARCHAR(100) PRIMARY KEY,
    Address VARCHAR(200),
    Phone VARCHAR(15)
);

CREATE TABLE BOOK (
    Book_id INT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Publisher_Name VARCHAR(100) REFERENCES PUBLISHER(Name) ON DELETE CASCADE,
    Pub_Year INT
);

SELECT b.Title, b.Publisher_Name, p.Phone
FROM BOOK b
JOIN PUBLISHER p ON b.Publisher_Name = p.Name;
```

## ⏱️ Complexity Analysis
- Query Execution: $O(1)$ with B-Tree indexes on Primary/Foreign Keys.
- Table Scan: $O(N)$ where $N$ is total records.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between DDL and DML?**
   *Answer:* DDL defines schema structure (`CREATE`, `ALTER`, `DROP`); DML manipulates row contents (`SELECT`, `INSERT`, `UPDATE`, `DELETE`).
2. **What does `ON DELETE SET NULL` do?**
   *Answer:* When the parent record is deleted, foreign keys in child records are automatically updated to `NULL`.
""",

    ("CSPC2204", 2): """# Experiment 02: College Database & Aggregate Functions

## 🎯 Aim of the Experiment
To create a **College Student Information Database** schema, populate student academic records, and execute analytical SQL queries using aggregate functions (`COUNT`, `AVG`, `MAX`), `GROUP BY`, and `HAVING` clauses.

## 📖 Theoretical Background & Core Principles
Aggregations collapse multiple tuples into summary values. `GROUP BY` partitions records into equivalence classes based on matching column values, while `HAVING` filters aggregated groups (unlike `WHERE` which filters individual tuples before grouping).

### Schema Entities:
- `STUDENT (REGNO, SName, Address, Phone, Gender)`
- `SEMSEC (SSID, Sem, Sec)`
- `CLASS (REGNO, SSID)`
- `COURSE (Subcode, Title, Sem, Credits)`
- `IAMARKS (REGNO, Subcode, SSID, Test1, Test2, Test3, FinalIA)`

## ⚙️ Step-by-Step Algorithm & Procedure
1. Define schema and insert student records across semesters 3, 4, 5, and 6.
2. Compute `FinalIA` as the average of the two highest test scores:
   `FinalIA = (Test1 + Test2 + Test3 - LEAST(Test1, Test2, Test3)) / 2.0`.
3. Query distribution of male vs female students per section using `GROUP BY Sem, Sec, Gender`.

## 💡 Sample Output
```text
Sem | Sec | Gender | Student_Count
----+-----+--------+--------------
4   | A   | Male   | 28
4   | A   | Female | 22
4   | B   | Male   | 25
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between `WHERE` and `HAVING`?**
   *Answer:* `WHERE` filters rows before grouping occurs; `HAVING` filters aggregated groups after the `GROUP BY` clause is evaluated.
""",

    ("CSPC2204", 3): """# Experiment 03: Order Database & Subqueries

## 🎯 Aim of the Experiment
To implement an **Order Processing Database**, model salesman-customer-order relationships, and construct nested subqueries, correlated subqueries, and set operations (`UNION`, `INTERSECT`).

## 📖 Theoretical Background & Core Principles
Subqueries are queries nested inside another SQL statement. Correlated subqueries reference columns from the outer query, executing once per candidate row of the outer table.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create `SALESMAN`, `CUSTOMER`, and `ORDERS` tables with appropriate constraints.
2. Write query to find salesmen who have multiple customers assigned.
3. Write query to retrieve all customers who placed an order above the city average using a correlated subquery.

## 💡 Sample Output
```text
Salesman_id | Name     | Customer_Count
------------+----------+---------------
1001        | Rajesh   | 4
1002        | Priya    | 3
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between `UNION` and `UNION ALL`?**
   *Answer:* `UNION` eliminates duplicate records and performs an internal sort, whereas `UNION ALL` retains all duplicates and executes faster.
""",

    ("CSPC2204", 4): """# Experiment 04: DCL Commands - GRANT & REVOKE

## 🎯 Aim of the Experiment
To demonstrate Data Control Language (DCL) commands (`GRANT` and `REVOKE`) and transaction savepoints (`SAVEPOINT`, `ROLLBACK TO SAVEPOINT`) for database security and access control.

## 📖 Theoretical Background & Core Principles
DCL manages user privileges on database objects to ensure least-privilege security policies. Savepoints divide large transactions into smaller verifiable recovery units.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create user role `lab_student`.
2. Grant `SELECT` and `INSERT` on `EMPLOYEES` table to `lab_student`.
3. Connect as `lab_student` and verify permissions.
4. Revoke `INSERT` permission using `REVOKE INSERT ON EMPLOYEES FROM lab_student;`.
5. Demonstrate partial rollback using a named `SAVEPOINT`.

## 💡 Sample SQL
```sql
GRANT SELECT, INSERT ON EMPLOYEES TO lab_student;
SAVEPOINT sp1;
INSERT INTO EMPLOYEES VALUES (101, 'Anil', 55000, 10);
ROLLBACK TO sp1;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between `COMMIT` and `ROLLBACK`?**
   *Answer:* `COMMIT` permanently saves transaction changes to disk; `ROLLBACK` undoes all uncommitted changes back to transaction start or savepoint.
""",

    ("CSPC2204", 5): """# Experiment 05: JOIN Operations

## 🎯 Aim of the Experiment
To construct and compare all SQL JOIN operations: `INNER JOIN`, `LEFT OUTER JOIN`, `RIGHT OUTER JOIN`, `FULL OUTER JOIN`, and `CROSS JOIN`.

## 📖 Theoretical Background & Core Principles
A `JOIN` operation merges columns from two or more tables based on a related column between them:
- **Inner Join:** Tuples matching condition in both tables.
- **Left Outer Join:** All rows from left table + matched rows from right (unmatched right columns set to `NULL`).
- **Right Outer Join:** All rows from right table + matched rows from left.
- **Full Outer Join:** All rows when there is a match in either table.

## 💡 Sample Query
```sql
SELECT e.emp_name, d.dept_name
FROM EMPLOYEES e
FULL OUTER JOIN DEPARTMENTS d ON e.dept_no = d.dept_no;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Cartesian product in SQL?**
   *Answer:* A `CROSS JOIN` that pairs every row of the first table with every row of the second table, resulting in $M \\times N$ rows.
""",

    ("CSPC2204", 6): """# Experiment 06: Election Commission Database & Triggers

## 🎯 Aim of the Experiment
To design an **Election Commission Database** with stored procedures and automated database triggers to ensure voting validity and auto-increment ballot counts.

## 📖 Theoretical Background & Core Principles
A **Trigger** is a procedural code block automatically invoked by the RDBMS engine in response to specific DML events (`BEFORE` or `AFTER` `INSERT`, `UPDATE`, `DELETE`) on a designated table.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create `CONSTITUENCY`, `CANDIDATES`, and `VOTER` tables.
2. Write a trigger `check_voter_age` executing `BEFORE INSERT ON VOTER`:
   - If `vage < 18`, raise exception `"Voter must be at least 18 years old"`.
3. Create stored procedure `cast_vote(vid, cand_id)`.

## 💡 Sample SQL
```sql
CREATE OR REPLACE TRIGGER check_voter_age
BEFORE INSERT ON VOTER
FOR EACH ROW
BEGIN
    IF :NEW.vage < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Underage voter registration denied.');
    END IF;
END;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Statement-level and Row-level triggers?**
   *Answer:* Statement-level executes once for the entire SQL statement; Row-level (`FOR EACH ROW`) executes once for every individual row modified.
""",

    ("CSPC2204", 7): """# Experiment 07: Airline Database - Relational Algebra

## 🎯 Aim of the Experiment
To express complex database queries on an **Airline Flight Database** using relational algebra expressions and SQL set operations.

## 📖 Theoretical Background & Core Principles
Relational algebra is a procedural query language consisting of operations: Selection ($\\sigma$), Projection ($\\pi$), Cartesian Product ($\\times$), Union ($\\cup$), Set Difference ($-$), and Join ($\\bowtie$).

## ⚙️ Step-by-Step Algorithm & Procedure
1. Express query: "Find pilots certified for Boeing aircraft whose cruising range exceeds 3000 miles".
2. Convert relational algebraic expression $\\pi_{ename}(\\sigma_{aname='Boeing' \\land cruisingrange > 3000}(AIRCRAFT \\bowtie CERTIFIED \\bowtie EMPLOYEES))$ to SQL.

## 💡 Sample Query
```sql
SELECT DISTINCT e.ename
FROM EMPLOYEES e
JOIN CERTIFIED c ON e.eid = c.eid
JOIN AIRCRAFT a ON c.aid = a.aid
WHERE a.aname LIKE '%Boeing%' AND a.cruisingrange > 3000;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is Relational Completeness?**
   *Answer:* A query language is relationally complete if it is at least as expressive as first-order relational calculus.
""",

    ("CSPC2204", 8): """# Experiment 08: Cursors in PL/SQL

## 🎯 Aim of the Experiment
To implement explicit and implicit cursors in PL/SQL to process multi-row query result sets tuple-by-tuple.

## 📖 Theoretical Background & Core Principles
A **Cursor** is a pointer to the private memory work area allocated by the database to process SQL results.
- **Explicit Cursor Lifecycle:** `DECLARE` -> `OPEN` -> `FETCH` -> `CLOSE`.
- **Attributes:** `%FOUND`, `%NOTFOUND`, `%ROWCOUNT`, `%ISOPEN`.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Declare cursor `emp_cursor FOR SELECT emp_id, emp_salary FROM EMPLOYEES;`.
2. Open cursor and initiate a `LOOP`.
3. Fetch row into local record variables.
4. Exit when `emp_cursor%NOTFOUND`.
5. Close cursor.

## 💡 Sample PL/SQL Block
```sql
DECLARE
    CURSOR cur_emp IS SELECT emp_name, emp_salary FROM EMPLOYEES WHERE dept_no = 10;
    v_name EMPLOYEES.emp_name%TYPE;
    v_salary EMPLOYEES.emp_salary%TYPE;
BEGIN
    OPEN cur_emp;
    LOOP
        FETCH cur_emp INTO v_name, v_salary;
        EXIT WHEN cur_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee: ' || v_name || ' | Salary: ' || v_salary);
    END LOOP;
    CLOSE cur_emp;
END;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Cursor FOR Loop?**
   *Answer:* A simplified PL/SQL syntax that automatically opens, fetches, checks termination, and closes the cursor without explicit statements.
""",

    ("CSPC2204", 9): """# Experiment 09: Stored Procedures - Student Grading

## 🎯 Aim of the Experiment
To write a PL/SQL stored procedure that accepts student roll number, calculates aggregate percentages, and assigns academic class grades.

## 📖 Theoretical Background & Core Principles
A stored procedure is a named precompiled PL/SQL block stored inside the database catalog, reducing network round-trips and enforcing standardized business logic.

### Grading Criteria:
- Score $\\ge 75\\%$: Distinction
- Score $\\ge 60\\%$ and $< 75\\%$: First Class
- Score $\\ge 50\\%$ and $< 60\\%$: Second Class
- Score $< 50\\%$: Fail

## 💡 Sample Procedure Definition
```sql
CREATE OR REPLACE PROCEDURE calculate_grade(p_roll IN INT, p_class OUT VARCHAR2) AS
    v_marks NUMBER;
BEGIN
    SELECT total_marks INTO v_marks FROM Stud_Marks WHERE roll = p_roll;
    IF v_marks >= 900 THEN
        p_class := 'Distinction';
    ELSIF v_marks >= 720 THEN
        p_class := 'First Class';
    ELSE
        p_class := 'Second Class';
    END IF;
END;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between a Stored Procedure and a Function?**
   *Answer:* A Function must return a value using the `RETURN` keyword and can be called inside SQL statements; a Procedure cannot be called directly within a `SELECT` statement.
""",

    ("CSPC2204", 10): """# Experiment 10: PL/SQL - Library Fine System

## 🎯 Aim of the Experiment
To develop a PL/SQL block that calculates overdue fines on returned library books and updates borrower membership status.

## 📖 Theoretical Background & Core Principles
Tiered business logic calculations in database systems are handled by transactional PL/SQL blocks guarding against inconsistent intermediate states.

### Fine Tier Structure:
- 1 to 15 days overdue: No fine (Grace period).
- 16 to 30 days: ₹5 per overdue day.
- $>30$ days: ₹50 per day + account freeze.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Accept `roll_no` and `book_id`.
2. Compute `days_overdue = TRUNC(SYSDATE - due_date)`.
3. If `days_overdue > 30`, calculate fine and set status `'SUSPENDED'`.
4. Insert fine receipt into `FINE` table.

## 💡 Sample Output
```text
Borrower Roll 102 checked in book 'Operating Systems'
Days Overdue: 35 days
Fine Calculated: Rs 550
Membership status updated to SUSPENDED.
```

## ❓ Viva-Voce Questions with Model Answers
1. **How do ACID properties apply to this transaction?**
   *Answer:* Atomicity ensures either both the fine record insertion and book status update occur together or neither occurs.
""",

    # =========================================================================
    # CSPC2205: Computer Organization & Architecture Lab (C)
    # =========================================================================
    ("CSPC2205", 1): """# Experiment 01: Fast Multiplication & Division (Booth's Algorithm)

## 🎯 Aim of the Experiment
To simulate **Booth's Multiplication Algorithm** and **Restoring/Non-Restoring Division** in C to understand binary signed-2's complement hardware arithmetic.

## 💻 Apparatus & Environment
- **Compiler:** GCC 9.0+
- **Language:** C99

## 📖 Theoretical Background & Core Principles
Booth's algorithm accelerates multiplication of two signed binary integers in 2's complement by scanning adjacent bit pairs ($Q_0, Q_{-1}$):
- `00` or `11`: No arithmetic operation, Arithmetic Right Shift (ARS) only.
- `10`: Subtract Multiplicand from Accumulator ($A = A - M$), then ARS.
- `01`: Add Multiplicand to Accumulator ($A = A + M$), then ARS.

```
Registers: [  Accumulator (A)  ][  Multiplier (Q)  ][ Q_-1 ]
Shift:     Arithmetic Right Shift preserving sign bit of A
```

## ⚙️ Step-by-Step Algorithm & Procedure
1. Initialize $A = 0$, $Q_{-1} = 0$, $count = n$ (word size in bits).
2. For each step while $count > 0$:
   - Inspect $(Q_0, Q_{-1})$.
   - Perform addition, subtraction, or pass based on bit pair.
   - Perform Arithmetic Right Shift on $(A, Q, Q_{-1})$.
   - Decrement $count$.
3. Result is stored in combined register $[A, Q]$.

## 💡 Sample Test Case
```text
Multiplicand M = 3 (0011), Multiplier Q = -4 (1100)
Initial: A=0000, Q=1100, Q_-1=0, count=4
After 4 Cycles: Result = 11110100 (which is -12 in decimal)
```

## ⏱️ Complexity Analysis
- Cycle count: Exactly $n$ clock cycles for $n$-bit integers.
- Space Complexity: $O(1)$ registers.

## ❓ Viva-Voce Questions with Model Answers
1. **Why is Booth's Algorithm faster than repeated addition?**
   *Answer:* It skips blocks of consecutive 1s or 0s with simple shifts, significantly reducing the number of costly additions/subtractions.
""",

    ("CSPC2205", 2): """# Experiment 02: Microprocessor Hardware Training Kits (8085/8086)

## 🎯 Aim of the Experiment
To familiarize with microprocessor hardware training kits (Intel 8085/8086), inspect internal register architectures (A, B, C, D, E, H, L), flag registers, and execute basic machine code.

## 📖 Theoretical Background & Core Principles
The 8085 is an 8-bit NMOS microprocessor operating at 3 MHz with a 16-bit address bus ($64 \\text{ KB}$ addressable memory).
- **Registers:** Accumulator (A), Flag Register (S, Z, AC, P, CY), General-purpose registers (B, C, D, E, H, L), Stack Pointer (SP), Program Counter (PC).

## ⚙️ Step-by-Step Procedure
1. Power up the 8085 training kit.
2. Enter memory address (e.g. `2000H`).
3. Key in hex opcodes for 8-bit addition:
   - `MVI A, 05H` -> `3E 05`
   - `ADI 03H`    -> `C6 03`
   - `STA 2050H`  -> `32 50 20`
   - `HLT`        -> `76`
4. Execute with `GO 2000H` and inspect memory at `2050H`.

## 💡 Sample Output
```text
Memory at 2050H: 08H
Flags: Carry=0, Zero=0, Sign=0, Parity=1
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is multiplexed bus in 8085?**
   *Answer:* AD0-AD7 lines carry both 8-bit memory address and data multiplexed in time, separated using the `ALE` (Address Latch Enable) signal.
""",

    ("CSPC2205", 3): """# Experiment 03: PC Assembly & Architectural Block Diagram

## 🎯 Aim of the Experiment
To dissect and identify computer motherboard subsystems: CPU Socket, Chipset (Northbridge/Southbridge), RAM slots (DIMM), Expansion buses (PCIe), Storage interfaces (SATA/NVMe), and Power Supply Unit (PSU).

## 📖 Theoretical Background & Core Principles
Von Neumann architecture defines the fundamental computer structure: CPU (Control Unit + ALU), Memory subsystem, and I/O devices communicating over shared system buses.

```
+------------+       +--------------+       +-------------+
|    CPU     |<=====>| System Bus   |<=====>| Main Memory |
| (CU + ALU) |       | Addr/Data/Ctl|       |   (RAM)     |
+------------+       +--------------+       +-------------+
                            ^
                            |
                     +--------------+
                     |  I/O Bridge  |
                     +--------------+
```

## ⚙️ Step-by-Step Procedure
1. Identify CPU socket pins and thermal heatsink mounting.
2. Inspect dual-channel DDR4/DDR5 DIMM slots and latch mechanisms.
3. Trace PCIe x16 lanes routed directly to CPU for GPU communication.
4. Document the power delivery stages: ATX 24-pin and 8-pin EPS connectors.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Northbridge and Southbridge?**
   *Answer:* Historically, Northbridge handled high-speed components (RAM, PCIe graphics); Southbridge handled slower peripheral I/O (USB, SATA, BIOS, Audio). Modern CPUs integrate Northbridge directly onto the CPU die.
""",

    ("CSPC2205", 4): """# Experiment 04: Hardware Technology Study Project

## 🎯 Aim of the Experiment
To conduct an architectural study on modern multi-core processors, analyzing cache hierarchies (L1, L2, L3), instruction pipelining, and branch prediction.

## 📖 Theoretical Background & Core Principles
- **Cache Hierarchy:**
  - L1 Cache: Split L1-Instruction and L1-Data (32-64 KB per core, 4-5 cycle latency).
  - L2 Cache: Unified dedicated cache (512 KB - 1 MB per core, 12-14 cycles).
  - L3 Cache: Shared LLC (Last Level Cache) across all cores (16-64 MB, 40-50 cycles).
- **Pipelining Stages:** IF (Fetch), ID (Decode), EX (Execute), MEM (Memory Access), WB (Write-back).

## ❓ Viva-Voce Questions with Model Answers
1. **What is a pipeline hazard?**
   *Answer:* Structural hazards (hardware resource conflicts), Data hazards (RAW, WAR, WAW dependencies), and Control hazards (branch/jump instructions).
""",

    # =========================================================================
    # CSPC2206: Design & Analysis of Algorithms Lab (C)
    # =========================================================================
    ("CSPC2206", 1): """# Experiment 01: Selection Sort with Empirical Time Complexity

## 🎯 Aim of the Experiment
To implement **Selection Sort** in C and measure its actual execution runtimes using `clock()` across varying input sizes ($N = 5000, 10000, 20000, 40000$) to verify quadratic time complexity $O(N^2)$.

## 📖 Theoretical Background & Core Principles
Selection sort always performs $N(N-1)/2$ comparisons regardless of whether input is sorted, reversed, or random. Plotting time $T(N)$ vs $N^2$ yields a straight line confirming theoretical derivation.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Allocate dynamic arrays of size $N$.
2. Populate with pseudo-random integers using `rand()`.
3. Capture start time: `t1 = clock()`.
4. Perform Selection Sort.
5. Capture end time: `t2 = clock()`.
6. Compute elapsed time: `(double)(t2 - t1) / CLOCKS_PER_SEC`.
7. Repeat for $N = 5000, 10000, 20000$.

## 💡 Sample Benchmark Table
```text
N Elements | Time Taken (Seconds) | Ratio T(2N)/T(N)
-----------+----------------------+-----------------
5000       | 0.045 s              | -
10000      | 0.182 s              | ~4.04 (Quadratic!)
20000      | 0.731 s              | ~4.01 (Quadratic!)
```

## ⏱️ Complexity Analysis
- Theoretical Time: $\\Theta(N^2)$ in all cases.
- Empirical Verification: Doubling $N$ quadruples runtime.

## ❓ Viva-Voce Questions with Model Answers
1. **Why does $T(2N)/T(N) \\approx 4$ confirm quadratic complexity?**
   *Answer:* Because for $T(N) = cN^2$, $T(2N) = c(2N)^2 = 4cN^2 = 4 T(N)$.
""",

    ("CSPC2206", 2): """# Experiment 02: Quick Sort with Time Complexity Analysis

## 🎯 Aim of the Experiment
To implement **Quick Sort** in C and analyze its average-case $O(N \\log N)$ vs worst-case $O(N^2)$ time complexity across randomized vs presorted arrays.

## 📖 Theoretical Background & Core Principles
Quick Sort recurrence:
- Average Case: $T(N) = 2T(N/2) + O(N) \\implies O(N \\log N)$.
- Worst Case: $T(N) = T(N-1) + O(N) \\implies O(N^2)$.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Implement `partition()` using middle or randomized pivot.
2. Measure time on random arrays ($N = 10000$ to $100000$).
3. Measure time on already sorted arrays to observe degradation.

## 💡 Benchmark Results
```text
Array Size | Random Array (Avg Case) | Presorted Array (Worst Case)
-----------+-------------------------+-----------------------------
10,000     | 0.002 s                 | 0.085 s
50,000     | 0.012 s                 | 2.120 s
```

## ❓ Viva-Voce Questions with Model Answers
1. **How does randomized pivot prevent worst-case performance?**
   *Answer:* By choosing a pivot at random with uniform distribution, the expected balance of the partition remains near $50:50$ with high probability.
""",

    ("CSPC2206", 3): """# Experiment 03: Merge Sort with Time Complexity

## 🎯 Aim of the Experiment
To implement **Merge Sort** in C and empirically verify its guaranteed $O(N \\log N)$ time complexity irrespective of input data distribution.

## 📖 Theoretical Background & Core Principles
By the Master Theorem, $T(N) = 2T(N/2) + O(N) \\implies a=2, b=2, d=1$. Since $a = b^d$, $T(N) = \\Theta(N \\log N)$ across best, average, and worst scenarios.

## 💡 Sample Test Case
```text
Sorted 50,000 random elements in 0.009 seconds.
Sorted 50,000 reverse elements in 0.009 seconds.
(Guaranteed uniform asymptotic performance!)
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why is Merge Sort preferred for Linked Lists over Quick Sort?**
   *Answer:* Linked lists allow $O(1)$ element insertion/splicing without requiring random-access indexing or extra array copying.
""",

    ("CSPC2206", 4): """# Experiment 04: Fractional Knapsack - Greedy Method

## 🎯 Aim of the Experiment
To implement the **Fractional Knapsack Problem** using the Greedy algorithmic strategy and achieve optimal item value accumulation.

## 📖 Theoretical Background & Core Principles
In Fractional Knapsack, items can be broken into arbitrary fractions. The greedy choice property states that sorting items in descending order of value-to-weight ratio ($v_i / w_i$) yields the globally optimal solution.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Compute ratio $r_i = \\text{value}_i / \\text{weight}_i$ for all $n$ items.
2. Sort items descending by $r_i$.
3. Initialize `cur_weight = 0`, `total_val = 0.0`.
4. Loop through sorted items:
   - If item fits fully: take all, update capacity.
   - Else take fraction: `total_val += val * (rem_capacity / weight); break;`.

## 💡 Sample Test Case
```text
Capacity: 50
Items (Val, Wt): (60, 10), (100, 20), (120, 30)
Ratios: 6.0, 5.0, 4.0
Take item 1 (wt 10, val 60) -> rem cap = 40
Take item 2 (wt 20, val 100) -> rem cap = 20
Take 2/3 of item 3 (wt 20/30, val 80)
Max Total Value = 240.0
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(N \\log N)$ dominated by sorting.
- Space Complexity: $O(1)$ auxiliary.

## ❓ Viva-Voce Questions with Model Answers
1. **Why does the Greedy method fail for the 0/1 Knapsack problem?**
   *Answer:* Because fractions are disallowed; leaving empty knapsack capacity cannot be compensated for without backtracking or dynamic programming.
""",

    ("CSPC2206", 5): """# Experiment 05: Dijkstra's Shortest Path Algorithm

## 🎯 Aim of the Experiment
To find the shortest path from a single source vertex to all other vertices in a weighted graph with non-negative edge weights using **Dijkstra's Algorithm**.

## 📖 Theoretical Background & Core Principles
Dijkstra's algorithm maintains a set of visited vertices and repeatedly selects the unvisited vertex with minimum tentative distance from source, applying edge relaxation:
$$\\text{dist}[v] = \\min(\\text{dist}[v], \\text{dist}[u] + \\text{weight}(u, v))$$

## ⚙️ Step-by-Step Algorithm & Procedure
1. Initialize `dist[source] = 0` and all other `dist[v] = INFINITY`.
2. For $i = 0$ to $V-1$:
   - Pick vertex $u$ with minimum tentative distance not yet visited.
   - Mark $u$ as visited.
   - For every neighbor $v$ of $u$: relax edge $(u, v)$.

## 💡 Sample Test Case
```text
Graph: Source = 0
Edge (0->1, wt 4), Edge (0->2, wt 1), Edge (2->1, wt 2)
Shortest Distances: Node 0: 0 | Node 1: 3 (via 2) | Node 2: 1
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(V^2)$ with adjacency matrix, $O((V + E) \\log V)$ with min-priority heap.

## ❓ Viva-Voce Questions with Model Answers
1. **Can Dijkstra's algorithm handle negative edge weights?**
   *Answer:* No, negative edges violate the greedy assumption that visited nodes have finalized minimum distances, leading to incorrect paths. Bellman-Ford must be used instead.
""",

    ("CSPC2206", 6): """# Experiment 06: Kruskal's Minimum Spanning Tree (MST)

## 🎯 Aim of the Experiment
To compute the **Minimum Spanning Tree (MST)** of a connected weighted graph using **Kruskal's Algorithm** and the Disjoint Set Union (Union-Find) data structure.

## 📖 Theoretical Background & Core Principles
An MST is a tree connecting all $V$ vertices with exactly $V - 1$ edges that minimizes the total edge weight sum without creating cycles.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Sort all edges in non-decreasing order of weights.
2. Initialize Disjoint Set Union with $V$ sets.
3. For each sorted edge $(u, v)$ with weight $w$:
   - If `find(u) != find(v)`:
     - Add edge $(u, v)$ to MST.
     - Call `union(u, v)`.
4. Stop when MST contains $V - 1$ edges.

## 💡 Sample Test Case
```text
Edges: (1-2: 1), (2-3: 2), (1-3: 4)
Sorted: (1-2: 1) added, (2-3: 2) added. (1-3: 4) discarded (creates cycle).
MST Total Weight = 3
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(E \\log E) = O(E \\log V)$ for edge sorting.
- Space Complexity: $O(V + E)$.

## ❓ Viva-Voce Questions with Model Answers
1. **What is path compression in Union-Find?**
   *Answer:* A flattening optimization during `find()` that points every visited node directly to the set root, reducing future find operations to nearly $O(1)$.
""",

    ("CSPC2206", 7): """# Experiment 07: Prim's Minimum Spanning Tree (MST)

## 🎯 Aim of the Experiment
To construct the MST of a graph starting from an arbitrary root vertex using **Prim's Greedy Algorithm**.

## 📖 Theoretical Background & Core Principles
Prim's algorithm grows a single tree component starting from an initial vertex, greedily adding the cheapest edge that connects a tree vertex to an external vertex outside the tree (Cut Property).

## 💡 Sample Output
```text
Edge   Weight
0 - 1    2
1 - 2    3
0 - 3    6
Total MST Weight = 11
```

## ⏱️ Complexity Analysis
- Adjacency Matrix: $O(V^2)$
- Adjacency List + Min-Heap: $O(E \\log V)$

## ❓ Viva-Voce Questions with Model Answers
1. **When should Kruskal's be chosen over Prim's?**
   *Answer:* Kruskal's is better for sparse graphs ($E \\ll V^2$); Prim's with adjacency matrix is faster on dense graphs ($E \\approx V^2$).
""",

    ("CSPC2206", 8): """# Experiment 08: Floyd's Algorithm, TSP & 0/1 Knapsack (DP)

## 🎯 Aim of the Experiment
To solve **All-Pairs Shortest Paths (Floyd-Warshall)**, **0/1 Knapsack**, and the **Travelling Salesman Problem** using Dynamic Programming.

## 📖 Theoretical Background & Core Principles
Dynamic programming solves complex problems by breaking them down into overlapping subproblems and storing subproblem results in a memoization table.

### Floyd-Warshall Recurrence:
$$D^{(k)}[i][j] = \\min(D^{(k-1)}[i][j], D^{(k-1)}[i][k] + D^{(k-1)}[k][j])$$

## 💡 Sample Output
```text
All-Pairs Shortest Distance Matrix:
    0    3    8  INF
  INF    0  INF    1
  INF    4    0  INF
    2  INF    5    0
```

## ⏱️ Complexity Analysis
- Floyd-Warshall Time: $O(V^3)$
- Space Complexity: $O(V^2)$

## ❓ Viva-Voce Questions with Model Answers
1. **Can Floyd-Warshall detect negative weight cycles?**
   *Answer:* Yes, if any diagonal element $D[i][i] < 0$ after $V$ iterations, a negative weight cycle exists.
""",

    ("CSPC2206", 9): """# Experiment 09: Subset Sum Problem (Backtracking)

## 🎯 Aim of the Experiment
To find all subsets of a given integer set $S$ whose sum equals target $d$ using the **Backtracking** state-space tree traversal with pruning.

## 📖 Theoretical Background & Core Principles
Backtracking systematically constructs candidate solutions in a depth-first manner, abandoning (pruning) branches as soon as the partial sum exceeds $d$ or the remaining elements cannot possibly achieve $d$.

## 💡 Sample Test Case
```text
Set S = {1, 2, 5, 6, 8}, Target d = 9
Solutions Found:
Subset 1: {1, 2, 6} -> Sum = 9
Subset 2: {1, 8}    -> Sum = 9
```

## ⏱️ Complexity Analysis
- Worst Case Time: $O(2^N)$ pruned substantially in practice.
- Space Complexity: $O(N)$ recursion depth.

## ❓ Viva-Voce Questions with Model Answers
1. **What is a bounding function in backtracking?**
   *Answer:* A conditional test that prunes search branches when subproblem invariants or feasibility conditions are violated.
""",

    ("CSPC2206", 10): """# Experiment 10: Hamiltonian Cycles (Backtracking)

## 🎯 Aim of the Experiment
To find all **Hamiltonian Cycles** (closed loop visiting every vertex exactly once and returning to start) in an undirected graph using backtracking.

## 📖 Theoretical Background & Core Principles
A Hamiltonian cycle in an $n$-vertex graph is a simple cycle containing all $n$ vertices. The backtracking approach explores candidate vertices in order, verifying adjacency and uniqueness.

## 💡 Sample Test Case
```text
Graph: 5 vertices
Hamiltonian Cycle 1: 0 -> 1 -> 2 -> 4 -> 3 -> 0
Hamiltonian Cycle 2: 0 -> 3 -> 4 -> 2 -> 1 -> 0
```

## ⏱️ Complexity Analysis
- Worst Case Time: $O(N!)$
- Space Complexity: $O(N)$ path vector

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Eulerian path and Hamiltonian path?**
   *Answer:* Eulerian path visits every edge exactly once; Hamiltonian path visits every vertex exactly once. Eulerian paths can be found in $O(E)$ time, whereas Hamiltonian is NP-Complete.
""",

    # =========================================================================
    # CSPC2207: Computer Networks Lab (C)
    # =========================================================================
    ("CSPC2207", 1): """# Experiment 01: Data Link Layer Framing (Character & Bit Stuffing)

## 🎯 Aim of the Experiment
To implement data link layer framing techniques: **Character/Byte Stuffing** (with DLE STX/ETX) and **Bit Stuffing** (Flag `01111110`) in C to achieve frame synchronization.

## 📖 Theoretical Background & Core Principles
- **Bit Stuffing:** Whenever five consecutive `1`s appear in the data stream, the sender automatically injects an extra `0` bit to prevent confusion with the frame delimiter flag `01111110` (6 ones).
- **Byte Stuffing:** Whenever a flag byte or escape byte appears in data, an escape character (`DLE`) is prepended.

## ⚙️ Step-by-Step Procedure
1. **Bit Stuffing:**
   - Initialize counter `ones = 0`.
   - Iterate through data bits: emit bit. If bit is `1`, increment `ones`.
   - When `ones == 5`, emit stuffed `'0'`, reset `ones = 0`.
2. Append flag `01111110` at start and end.

## 💡 Sample Test Case
```text
Input Data:   01111110111110
Bit Stuffed:  0111110101111100
(Flag: 01111110 attached at boundaries)
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(N)$ where $N$ is bitstream length.
- Space Complexity: $O(N)$.

## ❓ Viva-Voce Questions with Model Answers
1. **How does the receiver unstuff bits?**
   *Answer:* When the receiver sees five consecutive `1`s followed by a `0`, it discards the `0` bit. If followed by a `1`, it is a frame delimiter or error.
""",

    ("CSPC2207", 2): """# Experiment 02: Cyclic Redundancy Check (CRC)

## 🎯 Aim of the Experiment
To implement error detection using **Cyclic Redundancy Check (CRC)** in C with standard generator polynomials (CRC-12, CRC-16, CRC-CCITT).

## 📖 Theoretical Background & Core Principles
CRC treats binary bitstrings as polynomials with coefficients in GF(2) (modulo-2 arithmetic using XOR without carries).

## ⚙️ Step-by-Step Algorithm & Procedure
1. Append $k - 1$ zeros to message $M$, where $k$ is generator polynomial bit-length.
2. Divide augmented message by generator polynomial using modulo-2 division (XOR).
3. The remainder is the CRC checksum. Append remainder to original message and transmit.

## 💡 Sample Test Case
```text
Data: 1101011011, Generator: 10011
Remainder Checksum: 1110
Transmitted Codeword: 11010110111110
Receiver verification: Remainder is 0000 -> No transmission error detected!
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(N \\times K)$ where $N$ is message length and $K$ is polynomial length.

## ❓ Viva-Voce Questions with Model Answers
1. **What types of errors does CRC guarantee to detect?**
   *Answer:* All single-bit errors, all double errors (with proper polynomial), any odd number of errors, and burst errors of length up to the polynomial degree.
""",

    ("CSPC2207", 3): """# Experiment 03: Sliding Window Protocol (Go-Back-N)

## 🎯 Aim of the Experiment
To simulate the **Go-Back-N ARQ Sliding Window Protocol** in C, modeling sender window buffers, sequence numbers, timeouts, and loss recovery.

## 📖 Theoretical Background & Core Principles
Go-Back-N allows sending up to $N$ frames before blocking for acknowledgments (cumulative ACKs). If a frame timeout fires, all unacknowledged frames from the lost frame onward are retransmitted.

## 💡 Sample Output
```text
Sender: Transmitted Frames 0, 1, 2, 3 (Window Size = 4)
Receiver: ACK 0 received -> Window slides to [1, 2, 3, 4]
Simulated Loss: Frame 1 dropped!
Timeout: Frame 1 expired -> Retransmitting Frames 1, 2, 3, 4!
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the maximum window size in Go-Back-N with $m$-bit sequence numbers?**
   *Answer:* $2^m - 1$ to prevent overlapping ambiguity between old and new sequence number spaces.
""",

    ("CSPC2207", 4): """# Experiment 04: Broadcast Tree Generation

## 🎯 Aim of the Experiment
To generate a **Broadcast Tree** for a subnet of router nodes using minimum spanning tree principles or reverse path forwarding.

## 📖 Theoretical Background & Core Principles
A broadcast tree is a spanning tree rooted at the source node containing all nodes in the subnet, eliminating broadcast storm duplicate packets.

## 💡 Sample Output
```text
Source Node: 0
Broadcast Tree Links:
Node 0 -> Node 1 (Cost: 2)
Node 0 -> Node 2 (Cost: 3)
Node 1 -> Node 3 (Cost: 1)
Total Broadcast Tree Cost = 6
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is Reverse Path Forwarding (RPF)?**
   *Answer:* A router accepts a broadcast packet only if it arrived on the interface normally used for sending packets toward the source, preventing forwarding loops.
""",

    ("CSPC2207", 5): """# Experiment 05: Distance Vector Routing Algorithm

## 🎯 Aim of the Experiment
To simulate the distributed **Distance Vector Routing** algorithm in C using the **Bellman-Ford equation**.

## 📖 Theoretical Background & Core Principles
Each router maintains a vector containing the shortest known distance to every destination. Periodically, routers exchange vectors with immediate neighbors:
$$D_x(y) = \\min_v \\{ c(x, v) + D_v(y) \\}$$

## 💡 Sample Output
```text
Routing Table for Node A:
Dest | Next Hop | Distance
-----+----------+---------
B    | B        | 2
C    | B        | 5
D    | D        | 1
Routing tables converged in 3 exchange rounds.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the Count-to-Infinity problem?**
   *Answer:* In distance vector routing, routing loops cause metric distances to increment endlessly when a link breaks, mitigated by Split Horizon and Poisoned Reverse.
""",

    ("CSPC2207", 6): """# Experiment 06: Data Encryption & Decryption (Ciphers)

## 🎯 Aim of the Experiment
To implement symmetric data encryption and decryption using the **Caesar Cipher** and **Substitution Cipher** in C.

## 📖 Theoretical Background & Core Principles
Cryptography ensures data confidentiality over untrusted channels. Caesar cipher shifts each letter by a key $k$:
$$C = (P + k) \\bmod 26, \\quad P = (C - k) \\bmod 26$$

## 💡 Sample Output
```text
Plaintext:  ATTACKATDAWN
Key:        3
Ciphertext: DWWDFNDWGDZQ
Decrypted:  ATTACKATDAWN
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why is Caesar Cipher vulnerable to cryptanalysis?**
   *Answer:* It has only 26 possible keys (trivial brute-force) and preserves the natural letter frequency distribution of the English language.
""",

    ("CSPC2207", 7): """# Experiment 07: Leaky Bucket Traffic Shaping

## 🎯 Aim of the Experiment
To implement the **Leaky Bucket Algorithm** in C for network traffic shaping and congestion control.

## 📖 Theoretical Background & Core Principles
The leaky bucket turns bursty traffic into a smooth, steady stream of packets at a constant departure rate, dropping incoming packets if the buffer capacity is exceeded.

## 💡 Sample Output
```text
Time 1: Arrived 4 pkts -> Sent 2 pkts -> Bucket: 2 pkts
Time 2: Arrived 6 pkts -> Sent 2 pkts -> Bucket: 6 pkts
Time 3: Arrived 5 pkts -> Buffer Full! 3 pkts dropped -> Bucket: 8 pkts
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Leaky Bucket and Token Bucket?**
   *Answer:* Leaky bucket enforces a rigid constant output rate; token bucket allows idle tokens to accumulate, supporting controlled bursts.
""",

    ("CSPC2207", 8): """# Experiment 08: Frame Sorting at Transport Buffers

## 🎯 Aim of the Experiment
To implement a frame reassembly buffer in C that sorts out-of-order arriving frames into correct sequence numbers.

## 📖 Theoretical Background & Core Principles
Network packets can travel via diverse paths, arriving out-of-order at the destination. The transport layer reorders frames before delivery to the application layer.

## 💡 Sample Output
```text
Arrived Sequence: [3, 1, 4, 0, 2]
Reassembled Message: Frame 0 -> Frame 1 -> Frame 2 -> Frame 3 -> Frame 4
Payload delivered successfully in correct order.
```

## ❓ Viva-Voce Questions with Model Answers
1. **Which TCP header field enables frame reassembly?**
   *Answer:* The 32-bit Sequence Number field tracks byte offsets in the TCP stream.
""",

    ("CSPC2207", 9): """# Experiment 09: Wireshark Packet Analysis

## 🎯 Aim of the Experiment
To capture live network traffic using **Wireshark**, inspect protocol headers (Ethernet, IP, TCP, UDP, DNS, HTTP), and analyze flow statistics.

## 📖 Theoretical Background & Core Principles
Wireshark captures network packets by putting the network interface into promiscuous mode, decoding protocol stacks layer-by-layer.

## ⚙️ Step-by-Step Procedure
1. Open Wireshark and select active network interface.
2. Apply filter: `http` or `dns` or `tcp.port == 80`.
3. Generate traffic by visiting a website.
4. Inspect TCP 3-way handshake (`SYN`, `SYN-ACK`, `ACK`).

## 💡 Sample Analysis Findings
```text
Packet 1: Source IP: 192.168.1.5 -> Dest IP: 93.184.216.34 [SYN] Seq=0
Packet 2: Dest IP: 93.184.216.34 -> Source IP: 192.168.1.5 [SYN, ACK] Seq=0 Ack=1
Packet 3: Source IP: 192.168.1.5 -> Dest IP: 93.184.216.34 [ACK] Seq=1 Ack=1
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is promiscuous mode?**
   *Answer:* A network card mode where all passing packets on the broadcast domain are captured and passed to the OS, rather than just packets addressed to its MAC address.
""",

    ("CSPC2207", 10): """# Experiment 10: NS2 Network Simulation

## 🎯 Aim of the Experiment
To create a network topology in **NS2 (Network Simulator 2)** using OTcl, simulate TCP and UDP traffic flows, and visualize performance in NAM.

## 📖 Theoretical Background & Core Principles
NS2 uses a dual-language architecture: C++ for fast packet event scheduling and OTcl for scenario scripting and topology setup.

## 💡 Sample OTcl Script Snippet
```tcl
set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf
set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between DropTail and RED queueing?**
   *Answer:* DropTail discards newly arriving packets when queue is full; RED (Random Early Detection) drops packets probabilistically before full buffer to signal congestion.
"""
}
