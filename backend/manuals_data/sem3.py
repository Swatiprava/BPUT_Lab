"""
Comprehensive University-Grade Lab Manuals for Semester 3 BPUT CSE:
- CSPC2202: Data Structures Lab (13 Experiments)
- CSPC2203: Object Oriented Programming Lab (10 Experiments)
"""

SEM3_MANUALS = {
    # =========================================================================
    # CSPC2202: Data Structures Lab (C)
    # =========================================================================
    ("CSPC2202", 1): """# Experiment 01: Sparse Matrix Implementation

## 🎯 Aim of the Experiment
To write, execute, and verify a C program that reads a two-dimensional matrix from standard input, identifies non-zero elements, and constructs an efficient sparse matrix representation using a 3-tuple (triplet) array format.

## 💻 Apparatus & Environment
- **Compiler:** GCC (GNU Compiler Collection) 9.0+ / Clang
- **Operating System:** Ubuntu Linux / Windows 10/11
- **Language Standard:** C99 / C11
- **Memory Profiler:** Valgrind (Optional)

## 📖 Theoretical Background & Core Principles
A **sparse matrix** is a mathematical matrix wherein the overwhelming majority of the elements have a numerical value of zero. In conventional two-dimensional matrix allocation ($m \\times n$), memory is allocated contiguously for all $m \\times n$ positions. If only $k$ entries ($k \\ll m \\times n$) are non-zero, this wastes massive memory and computational cycles.

```
Conventional 4x4 Matrix:
[0  0  3  0]
[0  0  0  0]   --> 16 integers allocated (64 bytes)
[5  0  0  0]       Only 3 useful values!
[0  2  0  0]
```

### Triplet Representation (3-Tuple)
In triplet representation, an array of dimensions $(k + 1) \\times 3$ is created:
- **Header Row (Index 0):**
  - `sparse[0][0]` = Total Rows in original matrix ($M$)
  - `sparse[0][1]` = Total Columns in original matrix ($N$)
  - `sparse[0][2]` = Total Non-Zero elements ($k$)
- **Data Rows (Indices 1 to $k$):**
  - `sparse[i][0]` = Row index of $i$-th non-zero element (0-indexed)
  - `sparse[i][1]` = Column index of $i$-th non-zero element (0-indexed)
  - `sparse[i][2]` = Numerical value of the non-zero element

## ⚙️ Step-by-Step Algorithm & Procedure
1. **Start** program execution.
2. Read dimensions $r$ (rows) and $c$ (columns) from user input.
3. Read the $r \\times c$ matrix elements into a 2D array `matrix[r][c]`.
4. Initialize non-zero counter `k = 0`.
5. Traverse the matrix row-wise using nested loops `i` from $0$ to $r-1$ and `j` from $0$ to $c-1$:
   - If `matrix[i][j] != 0`:
     - Increment `k = k + 1`.
     - Assign `sparse[k][0] = i`.
     - Assign `sparse[k][1] = j`.
     - Assign `sparse[k][2] = matrix[i][j]`.
6. Set metadata: `sparse[0][0] = r`, `sparse[0][1] = c`, `sparse[0][2] = k`.
7. Output the original matrix and the resulting triplet table.
8. **Stop**.

## 📥 Input Specifications & Constraints
- First line: Two integers $r$ and $c$ representing dimensions ($1 \\le r, c \\le 50$).
- Next $r$ lines: Each containing $c$ integers representing matrix values.

## 📤 Output Format
- Display the original matrix in rectangular grid format.
- Display the sparse matrix triplet table with column headers: `Row`, `Col`, `Val`.

## 💡 Sample Test Case & Dry Run Trace

### Sample Input:
```text
4 4
0 0 3 0
0 0 0 0
5 0 0 0
0 2 0 0
```

### Expected Output:
```text
Original Matrix:
0 0 3 0
0 0 0 0
5 0 0 0
0 2 0 0

Sparse Matrix Triplet Representation:
Row  Col  Val
4    4    3
0    2    3
2    0    5
3    1    2
```

### Dry Run Walkthrough:
- Scanned (0,2): value is 3 -> Added triplet (0, 2, 3) at row 1.
- Scanned (2,0): value is 5 -> Added triplet (2, 0, 5) at row 2.
- Scanned (3,1): value is 2 -> Added triplet (3, 1, 2) at row 3.
- Final non-zero count is 3. Triplet dimensions are $4 \\times 3$.

## ⏱️ Complexity Analysis
- **Time Complexity:** $O(r \\times c)$ to inspect all elements of the input matrix.
- **Auxiliary Space Complexity:** $O(k)$ where $k$ is the number of non-zero entries.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the threshold sparsity ratio for a matrix?**
   *Answer:* A matrix is considered sparse when non-zero elements constitute less than 20% to 30% of total elements ($k \\le 0.2 \\times M \\times N$).
2. **What are the key representations of a sparse matrix?**
   *Answer:* Array of triplets (3-tuple), Linked List representation (sparse multi-list with row/col headers), and Compressed Sparse Row/Column (CSR/CSC).
3. **What is the Fast Transpose algorithm for sparse matrices?**
   *Answer:* An algorithm that transposes a triplet sparse matrix in $O(k + c)$ time by computing frequency of non-zero elements per column and pre-calculating starting indices.
""",

    ("CSPC2202", 2): """# Experiment 02: Stack Implementation using Array

## 🎯 Aim of the Experiment
To design and implement a menu-driven C program for a **Stack** data structure using a static contiguous array, providing `PUSH`, `POP`, `PEEK`, and `DISPLAY` operations with boundary checks for Overflow and Underflow.

## 💻 Apparatus & Environment
- **Compiler:** GCC 9.0+ / Clang
- **Operating System:** Linux / Windows
- **Language Standard:** C99

## 📖 Theoretical Background & Core Principles
A **Stack** is a linear data structure following the **LIFO (Last In, First Out)** principle. The insertion and deletion of elements happen exclusively at one end termed the `TOP`.

```
        +-------+
TOP ->  |  30   |  <-- PUSH / POP end
        +-------+
        |  20   |
        +-------+
        |  10   |
        +-------+ (Base / Index 0)
```

### Boundary Conditions:
- **Stack Underflow:** Attempting to `POP` when `TOP == -1`.
- **Stack Overflow:** Attempting to `PUSH` when `TOP == MAX - 1`.

## ⚙️ Step-by-Step Algorithm & Procedure
### Push Operation:
1. Check if `TOP == MAX - 1`. If true, print `"Stack Overflow"` and abort.
2. Increment `TOP = TOP + 1`.
3. Assign `stack[TOP] = item`.
4. Return success.

### Pop Operation:
1. Check if `TOP == -1`. If true, print `"Stack Underflow"` and return error code.
2. Retrieve `item = stack[TOP]`.
3. Decrement `TOP = TOP - 1`.
4. Return `item`.

### Display Operation:
1. If `TOP == -1`, print `"Stack is Empty"`.
2. Loop `i` from `TOP` down to `0` and print `stack[i]`.

## 📥 Input Specifications & Constraints
- Menu choice: `1` (Push), `2` (Pop), `3` (Display), `4` (Exit).
- Array maximum capacity: $MAX = 100$.
- Element values: standard 32-bit signed integers.

## 📤 Output Format
- Success/error messages for Push and Pop operations.
- Formatted list of current stack elements displayed top-to-bottom.

## 💡 Sample Test Case & Dry Run Trace

### Sample Interactive Session:
```text
1. Push 15 -> TOP=0, stack=[15]
2. Push 25 -> TOP=1, stack=[15, 25]
3. Push 35 -> TOP=2, stack=[15, 25, 35]
4. Display -> 35 -> 25 -> 15
5. Pop     -> Popped: 35 (TOP becomes 1)
6. Display -> 25 -> 15
```

## ⏱️ Complexity Analysis
- **Time Complexity:**
  - `PUSH`: $O(1)$ constant time.
  - `POP`: $O(1)$ constant time.
  - `PEEK`: $O(1)$ constant time.
  - `DISPLAY`: $O(N)$ linear time.
- **Space Complexity:** $O(MAX)$ contiguous memory allocated for array.

## ❓ Viva-Voce Questions with Model Answers
1. **Name real-world applications of Stacks in Computer Science.**
   *Answer:* Function call call-stack (activation records), parsing expressions (Infix to Postfix conversion), browser history back/forward navigation, and syntax parenthesis matching.
2. **What is Stack Overflow in memory architecture?**
   *Answer:* It occurs when the call stack pointer exceeds the allocated stack memory segment, often caused by infinite recursion or excessively large local stack variables.
3. **What is the difference between static and dynamic stack?**
   *Answer:* Static stack uses a fixed-size array with fixed capacity; dynamic stack uses a linked list or dynamically reallocated memory (`realloc`) allowing growth at runtime.
""",

    ("CSPC2202", 3): """# Experiment 03: Queue Implementation using Array

## 🎯 Aim of the Experiment
To design and implement a **Linear Queue** data structure in C using an array, supporting `ENQUEUE`, `DEQUEUE`, and `DISPLAY` operations with boundary checks for Queue Full and Queue Empty.

## 💻 Apparatus & Environment
- **Compiler:** GCC 9.0+ / Clang
- **Operating System:** Linux / Windows
- **Standard:** C99

## 📖 Theoretical Background & Core Principles
A **Queue** is a linear data structure that adheres to the **FIFO (First In, First Out)** protocol. Elements are inserted at the `REAR` end and removed from the `FRONT` end.

```
 FRONT                                  REAR
   |                                     |
   v                                     v
+------+------+------+------+------+------+
|  10  |  20  |  30  |  40  |      |      |
+------+------+------+------+------+------+
 Dequeue End                         Enqueue End
```

### Pointers & Conditions:
- Initially: `FRONT = -1`, `REAR = -1`.
- `ENQUEUE`: Increments `REAR` and places new element. (Sets `FRONT = 0` if first insertion).
- `DEQUEUE`: Removes element at `FRONT` and increments `FRONT`.
- **Queue Underflow:** `FRONT == -1` or `FRONT > REAR`.
- **Queue Overflow (Linear):** `REAR == MAX - 1`.

## ⚙️ Step-by-Step Algorithm & Procedure
### Enqueue(val):
1. If `REAR == MAX - 1`, print `"Queue Overflow"` and return.
2. If `FRONT == -1`, set `FRONT = 0`.
3. Set `REAR = REAR + 1`.
4. Set `queue[REAR] = val`.

### Dequeue():
1. If `FRONT == -1` or `FRONT > REAR`, print `"Queue Underflow"` and return error.
2. Store `val = queue[FRONT]`.
3. Set `FRONT = FRONT + 1`.
4. If `FRONT > REAR`, reset `FRONT = -1, REAR = -1`.
5. Return `val`.

## 📥 Input Specifications & Constraints
- Options: `1` (Enqueue), `2` (Dequeue), `3` (Display), `4` (Exit).
- Constraints: $1 \\le MAX \\le 100$.

## 📤 Output Format
- Status messages for operations and horizontal list of active queue elements.

## 💡 Sample Test Case & Dry Run Trace
```text
Enqueue: 10, 20, 30 -> Queue: [10, 20, 30] (Front: 0, Rear: 2)
Dequeue            -> Removed 10 (Front: 1, Rear: 2)
Display            -> Queue contents: 20  30
```

## ⏱️ Complexity Analysis
- `ENQUEUE`: $O(1)$
- `DEQUEUE`: $O(1)$
- `DISPLAY`: $O(N)$
- `Space`: $O(MAX)$

## ❓ Viva-Voce Questions with Model Answers
1. **What is false overflow in a linear queue?**
   *Answer:* When `REAR` reaches `MAX - 1`, new elements cannot be enqueued even if vacant slots exist at the front due to prior dequeues.
2. **How does a Circular Queue solve false overflow?**
   *Answer:* By wrapping pointers around using modulo arithmetic: `REAR = (REAR + 1) % MAX`.
3. **What is a Double-Ended Queue (Deque)?**
   *Answer:* A generalized queue supporting insertions and deletions at both the front and rear ends.
""",

    ("CSPC2202", 4): """# Experiment 04: Single Linked List Operations

## 🎯 Aim of the Experiment
To construct a dynamically allocated **Singly Linked List (SLL)** in C and implement basic operations: Insertion (at beginning, at end, at given position), Deletion (from beginning, end, and by value), and Traversal.

## 💻 Apparatus & Environment
- **Compiler:** GCC / Clang
- **Operating System:** Linux / Windows

## 📖 Theoretical Background & Core Principles
A Singly Linked List is a linear dynamic data structure composed of self-referential structures (nodes). Each node stores data and a pointer to the next consecutive node in heap memory.

```
+--------+------+     +--------+------+     +--------+------+
| Data 1 | Next |---> | Data 2 | Next |---> | Data 3 | NULL |
+--------+------+     +--------+------+     +--------+------+
  ^
 HEAD
```

## ⚙️ Step-by-Step Algorithm & Procedure
1. Define `struct Node { int data; struct Node* next; };`.
2. **Insert at Beginning:**
   - Allocate node: `newNode = (struct Node*)malloc(sizeof(struct Node))`.
   - `newNode->data = val; newNode->next = head; head = newNode;`.
3. **Insert at End:**
   - Allocate node and set `newNode->next = NULL`.
   - If `head == NULL`, `head = newNode`.
   - Else traverse `temp` to last node (`temp->next == NULL`) and set `temp->next = newNode`.
4. **Delete Node:**
   - Locate target node, update previous node's `next` pointer to bypass it, and call `free(target)`.

## 📥 Input Specifications & Constraints
- Menu choice: `1` Insert Beg, `2` Insert End, `3` Delete, `4` Display, `5` Exit.

## 📤 Output Format
- Linked list nodes displayed with `->` arrows terminating in `NULL`.

## 💡 Sample Test Case & Dry Run Trace
```text
Insert Beg(20) -> 20 -> NULL
Insert Beg(10) -> 10 -> 20 -> NULL
Insert End(30) -> 10 -> 20 -> 30 -> NULL
Delete(20)     -> 10 -> 30 -> NULL
```

## ⏱️ Complexity Analysis
- Insertion at Head: $O(1)$
- Insertion at Tail: $O(N)$ (without tail pointer) / $O(1)$ (with tail pointer)
- Deletion: $O(N)$ search time
- Auxiliary Space: $O(N)$ for node pointer storage

## ❓ Viva-Voce Questions with Model Answers
1. **Why is a linked list preferred over an array?**
   *Answer:* Dynamic resizing at runtime without reallocation/copying overhead, and $O(1)$ insertions/deletions when node references are known.
2. **What is a dangling pointer?**
   *Answer:* A pointer that continues to reference memory that has already been deallocated using `free()`.
""",

    ("CSPC2202", 5): """# Experiment 05: Double Linked List Operations

## 🎯 Aim of the Experiment
To design, implement, and verify a **Doubly Linked List (DLL)** in C supporting bidirectional traversal, node insertion, and node deletion.

## 💻 Apparatus & Environment
- **Compiler:** GCC 9.0+ / Clang
- **Standard:** C99

## 📖 Theoretical Background & Core Principles
A Doubly Linked List node contains two pointers: `prev` pointing to the predecessor node and `next` pointing to the successor node.

```
       +------+--------+------+      +------+--------+------+
NULL <-| prev |  Data  | next |<---->| prev |  Data  | next |-> NULL
       +------+--------+------+      +------+--------+------+
```

## ⚙️ Step-by-Step Algorithm & Procedure
1. Declare node: `struct Node { int data; struct Node *prev, *next; };`.
2. **Insert at Beginning:**
   - Allocate `newNode`. Set `newNode->prev = NULL`, `newNode->next = head`.
   - If `head != NULL`, set `head->prev = newNode`. Update `head = newNode`.
3. **Delete Node:**
   - Relink `node->prev->next = node->next` and `node->next->prev = node->prev`.
   - Call `free(node)`.

## 💡 Sample Test Case
```text
Insert 10, 20, 30 -> Forward: 10 <-> 20 <-> 30
Backward Traversal -> 30 <-> 20 <-> 10
```

## ⏱️ Complexity Analysis
- Insertion at Head/Tail: $O(1)$ (with tail pointer)
- Deletion of given node pointer: $O(1)$
- Traversal: $O(N)$
- Space Overhead: 2 pointers per node ($2 \\times 8$ bytes on 64-bit systems)

## ❓ Viva-Voce Questions with Model Answers
1. **What is the main advantage of DLL over SLL?**
   *Answer:* Bidirectional traversal and $O(1)$ deletion of a given node without needing a reference to its predecessor.
2. **What is a Circular Doubly Linked List?**
   *Answer:* A DLL where the tail's `next` points to head and head's `prev` points to tail.
""",

    ("CSPC2202", 6): """# Experiment 06: Binary Tree Operations

## 🎯 Aim of the Experiment
To create a **Binary Tree** in C and implement depth-first tree traversals: **Inorder (LDR)**, **Preorder (DLR)**, and **Postorder (LRD)** using recursion.

## 💻 Apparatus & Environment
- **Compiler:** GCC 9.0+ / Clang
- **Language:** C99

## 📖 Theoretical Background & Core Principles
A Binary Tree is a hierarchical non-linear data structure where each node has at most two children: `left` and `right`.

```
        1 (Root)
       / \\
      2   3
     / \\
    4   5
```

### Traversal Conventions:
- **Preorder (DLR):** Visit Node -> Left Subtree -> Right Subtree.
- **Inorder (LDR):** Left Subtree -> Visit Node -> Right Subtree (Yields sorted order in BST).
- **Postorder (LRD):** Left Subtree -> Right Subtree -> Visit Node.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create node with `data`, `left = NULL`, `right = NULL`.
2. `inorder(root)`: If `root != NULL`: `inorder(root->left); print(root->data); inorder(root->right);`.
3. `preorder(root)`: If `root != NULL`: `print(root->data); preorder(root->left); preorder(root->right);`.
4. `postorder(root)`: If `root != NULL`: `postorder(root->left); postorder(root->right); print(root->data);`.

## 💡 Sample Test Case
```text
Tree: Root=1, Left=2, Right=3, 2->Left=4, 2->Right=5
Preorder:   1  2  4  5  3
Inorder:    4  2  5  1  3
Postorder:  4  5  2  3  1
```

## ⏱️ Complexity Analysis
- **Time Complexity:** $O(N)$ as every node is visited exactly once.
- **Space Complexity:** $O(H)$ recursion stack frames where $H$ is the tree height ($O(\\log N)$ balanced, $O(N)$ skewed).

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Full Binary Tree vs Complete Binary Tree?**
   *Answer:* Full has 0 or 2 children per node. Complete is completely filled at all levels except possibly the last, which is filled from left to right.
2. **What traversal uniquely reconstructs a binary tree?**
   *Answer:* Inorder combined with either Preorder or Postorder traversal.
""",

    ("CSPC2202", 7): """# Experiment 07: Bubble Sort

## 🎯 Aim of the Experiment
To implement the **Bubble Sort** algorithm in C, trace pass-by-pass bubbling of maximum elements, and optimize it using an early termination swap flag.

## 💻 Apparatus & Environment
- **Compiler:** GCC 9.0+
- **Language:** C99

## 📖 Theoretical Background & Core Principles
Bubble Sort repeatedly steps through the list, compares adjacent pairs, and swaps them if they are in the wrong order. In pass $i$, the $i$-th largest element bubbles up to its correct terminal index.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Loop `i` from $0$ to $n-2$:
   - Set `swapped = 0`.
   - Loop `j` from $0$ to $n-i-2$:
     - If `arr[j] > arr[j+1]`, swap `arr[j]` and `arr[j+1]`, set `swapped = 1`.
   - If `swapped == 0`, break early (array is sorted).
2. End.

## 💡 Sample Test Case
```text
Input:  [64, 34, 25, 12, 22, 11, 90]
Pass 1: [34, 25, 12, 22, 11, 64, 90] (90 in place)
Output: [11, 12, 22, 25, 34, 64, 90]
```

## ⏱️ Complexity Analysis
- Best Case Time: $O(N)$ (already sorted with optimization flag)
- Worst/Average Time: $O(N^2)$
- Space Complexity: $O(1)$ (in-place)

## ❓ Viva-Voce Questions with Model Answers
1. **Is Bubble Sort stable?**
   *Answer:* Yes, because identical elements maintain their relative order as swaps only occur for strictly greater elements (`arr[j] > arr[j+1]`).
2. **What is the maximum number of comparisons in Bubble Sort?**
   *Answer:* $N(N-1)/2$.
""",

    ("CSPC2202", 8): """# Experiment 08: Insertion Sort

## 🎯 Aim of the Experiment
To write and verify a C program implementing the **Insertion Sort** algorithm, simulating how playing cards are ordered in hand.

## 📖 Theoretical Background & Core Principles
Insertion sort maintains two virtual partitions in the array: sorted on the left and unsorted on the right. In each pass, the first unsorted element (`key`) is shifted backward into its correct sorted slot.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Loop `i` from $1$ to $n-1$:
   - Set `key = arr[i]`, `j = i - 1`.
   - While `j >= 0` and `arr[j] > key`:
     - Shift `arr[j+1] = arr[j]`.
     - Decrement `j = j - 1`.
   - Place `arr[j+1] = key`.

## 💡 Sample Test Case
```text
Input:  [12, 11, 13, 5, 6]
Pass 1 (key=11): [11, 12, 13, 5, 6]
Pass 3 (key=5):  [5, 11, 12, 13, 6]
Output: [5, 6, 11, 12, 13]
```

## ⏱️ Complexity Analysis
- Best Case: $O(N)$ comparisons when array is already sorted.
- Worst Case: $O(N^2)$ when array is reversely sorted.
- Space: $O(1)$ auxiliary.

## ❓ Viva-Voce Questions with Model Answers
1. **Why is Insertion Sort preferred for small datasets or nearly sorted arrays?**
   *Answer:* It has minimal overhead, low constant factors, and achieves near-linear $O(N)$ performance on nearly sorted inputs.
""",

    ("CSPC2202", 9): """# Experiment 09: Selection Sort

## 🎯 Aim of the Experiment
To design and implement **Selection Sort** in C, minimizing memory write operations by selecting the smallest remaining element per pass.

## 📖 Theoretical Background & Core Principles
Selection sort partitions the list into sorted and unsorted regions. It repeatedly locates the index of the minimum element from the unsorted region and swaps it with the leftmost unsorted position.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Loop `i` from $0$ to $n-2$:
   - Set `min_idx = i`.
   - Loop `j` from `i+1` to $n-1$:
     - If `arr[j] < arr[min_idx]`, update `min_idx = j`.
   - If `min_idx != i`, swap `arr[i]` and `arr[min_idx]`.

## 💡 Sample Test Case
```text
Input:  [64, 25, 12, 22, 11]
Pass 1: Min=11 -> Swap with 64 -> [11, 25, 12, 22, 64]
Output: [11, 12, 22, 25, 64]
```

## ⏱️ Complexity Analysis
- Comparisons: Exactly $N(N-1)/2 = O(N^2)$ in all cases.
- Swaps: At most $N - 1 = O(N)$ swaps.
- Space: $O(1)$.

## ❓ Viva-Voce Questions with Model Answers
1. **When is Selection Sort advantageous?**
   *Answer:* In environments where memory writes are extremely expensive (e.g. Flash EEPROM) because it performs at most $O(N)$ writes.
""",

    ("CSPC2202", 10): """# Experiment 10: Quick Sort

## 🎯 Aim of the Experiment
To implement the **Quick Sort** algorithm in C using the Divide-and-Conquer paradigm with the Lomuto/Hoare partitioning scheme.

## 📖 Theoretical Background & Core Principles
Quick Sort selects a `pivot` element, partitions the array such that all elements smaller than the pivot are placed to its left and larger ones to its right, then recursively sorts both subarrays.

## ⚙️ Step-by-Step Algorithm & Procedure
1. `partition(arr, low, high)`:
   - Choose `pivot = arr[high]`.
   - Set `i = low - 1`.
   - For `j = low` to `high - 1`:
     - If `arr[j] < pivot`, increment `i` and swap `arr[i]` with `arr[j]`.
   - Swap `arr[i+1]` with `arr[high]`. Return `i+1`.
2. `quickSort(arr, low, high)`:
   - If `low < high`:
     - `p = partition(arr, low, high)`.
     - `quickSort(arr, low, p - 1)`.
     - `quickSort(arr, p + 1, high)`.

## 💡 Sample Test Case
```text
Input:  [10, 7, 8, 9, 1, 5]
Pivot:  5 -> Partition: [1] 5 [7, 8, 9, 10]
Output: [1, 5, 7, 8, 9, 10]
```

## ⏱️ Complexity Analysis
- Best/Average Case Time: $O(N \\log N)$
- Worst Case Time: $O(N^2)$ (when already sorted and extreme pivot selected)
- Space: $O(\\log N)$ recursion stack

## ❓ Viva-Voce Questions with Model Answers
1. **How can worst-case behavior in Quick Sort be prevented?**
   *Answer:* Using Randomized Quick Sort (selecting pivot at random) or Median-of-Three pivot selection.
""",

    ("CSPC2202", 11): """# Experiment 11: Merge Sort

## 🎯 Aim of the Experiment
To implement **Merge Sort** in C using recursive divide-and-conquer and evaluate its stable $O(N \\log N)$ performance.

## 📖 Theoretical Background & Core Principles
Merge Sort recursively halves the array until base subarrays of size 1 are reached, then merges two sorted subarrays into a single sorted array using two pointers.

## ⚙️ Step-by-Step Algorithm & Procedure
1. If `left < right`:
   - Compute `mid = left + (right - left) / 2`.
   - Call `mergeSort(arr, left, mid)`.
   - Call `mergeSort(arr, mid + 1, right)`.
   - Call `merge(arr, left, mid, right)` to combine.

## 💡 Sample Test Case
```text
Input:  [38, 27, 43, 3, 9, 82, 10]
Divide: [38, 27, 43] and [3, 9, 82, 10]
Output: [3, 9, 10, 27, 38, 43, 82]
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(N \\log N)$ in Best, Average, and Worst cases.
- Auxiliary Space: $O(N)$ for temporary merge arrays.

## ❓ Viva-Voce Questions with Model Answers
1. **Is Merge Sort an in-place sort?**
   *Answer:* No, standard Merge Sort requires $O(N)$ auxiliary storage to merge sorted subarrays.
""",

    ("CSPC2202", 12): """# Experiment 12: Linear Search

## 🎯 Aim of the Experiment
To implement **Linear Search** in C to find a key element in an unordered array sequentially.

## 📖 Theoretical Background & Core Principles
Linear search traverses the array element-by-element from index $0$ to $n-1$, checking if `arr[i] == key`. It requires no prior sorting of data.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Loop `i` from $0$ to $n-1$:
   - If `arr[i] == key`, return index `i`.
2. If loop terminates without match, return `-1`.

## 💡 Sample Test Case
```text
Array: [2, 3, 4, 10, 40], Key: 10 -> Found at index 3
Key: 99 -> Element not found (-1)
```

## ⏱️ Complexity Analysis
- Best Case Time: $O(1)$ (element at index 0)
- Worst Case Time: $O(N)$ (element at end or absent)
- Space Complexity: $O(1)$

## ❓ Viva-Voce Questions with Model Answers
1. **When is Linear Search preferred over Binary Search?**
   *Answer:* When the array is unsorted and only a single query is performed, avoiding sorting overhead.
""",

    ("CSPC2202", 13): """# Experiment 13: Binary Search

## 🎯 Aim of the Experiment
To implement **Binary Search** in C on a sorted array and verify its logarithmic time complexity.

## 📖 Theoretical Background & Core Principles
Binary search operates on sorted arrays by repeatedly comparing the target key with the middle element `arr[mid]`. If the key matches, search succeeds; otherwise, the search space is halved.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Set `low = 0`, `high = n - 1`.
2. While `low <= high`:
   - Compute `mid = low + (high - low) / 2`.
   - If `arr[mid] == key`, return `mid`.
   - If `arr[mid] < key`, set `low = mid + 1`.
   - Else set `high = mid - 1`.
3. Return `-1` if not found.

## 💡 Sample Test Case
```text
Sorted Array: [2, 3, 4, 10, 40], Target: 10
Mid index 2 (val=4): 10 > 4 -> low=3
Mid index 3 (val=10): Match! -> Return index 3
```

## ⏱️ Complexity Analysis
- Best Case: $O(1)$
- Worst Case: $O(\\log_2 N)$
- Auxiliary Space: $O(1)$ iterative, $O(\\log N)$ recursive

## ❓ Viva-Voce Questions with Model Answers
1. **Why use `low + (high - low)/2` instead of `(low + high)/2`?**
   *Answer:* To avoid potential integer arithmetic overflow when `low + high` exceeds maximum signed 32-bit integer (`2,147,483,647`).
""",

    # =========================================================================
    # CSPC2203: Object Oriented Programming Lab (Java)
    # =========================================================================
    ("CSPC2203", 1): """# Experiment 01: Hello World in Java & JVM Architecture

## 🎯 Aim of the Experiment
To understand the Java compilation and execution model, write a standard Java class, and execute the `main` method emitting formatted output.

## 💻 Apparatus & Environment
- **JDK:** OpenJDK 17 / Oracle JDK 21
- **Platform:** Windows / Linux
- **Tools:** `javac`, `java`

## 📖 Theoretical Background & Core Principles
Java achieves "Write Once, Run Anywhere" (WORA) via intermediate bytecode (`.class`) executed by the **Java Virtual Machine (JVM)**.

```
Source (.java) ---> javac Compiler ---> Bytecode (.class) ---> JVM (JIT Interpreter) ---> Machine Code
```

### Breakdown of `public static void main(String[] args)`:
- `public`: JVM calls it from outside the package.
- `static`: Can be invoked without creating an instance of the class.
- `void`: Returns no value.
- `String[] args`: Captures command-line arguments.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create file `Main.java`.
2. Declare `public class Main`.
3. Define `public static void main(String[] args)`.
4. Add `System.out.println("Hello World!");`.
5. Compile via `javac Main.java` and run via `java Main`.

## 💡 Sample Output
```text
Hello World!
Welcome to BPUT CSE Java Lab.
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(1)$
- Space Complexity: $O(1)$

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between JDK, JRE, and JVM?**
   *Answer:* JDK contains development tools + JRE; JRE contains standard class libraries + JVM; JVM executes bytecode.
""",

    ("CSPC2203", 2): """# Experiment 02: Data Types, Variables & Control Structures

## 🎯 Aim of the Experiment
To demonstrate primitive data types, type casting, arithmetic/relational operators, and control structures (if-else, switch-case, for, while, do-while) in Java.

## 📖 Theoretical Background & Core Principles
Java defines 8 primitive types: `byte`, `short`, `int`, `long`, `float`, `double`, `char`, and `boolean`. Strongly typed rules enforce explicit casting for narrowing conversions.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Declare primitive variables of diverse types.
2. Demonstrate type casting: implicit widening (`int` to `double`) and explicit narrowing (`double` to `int`).
3. Implement a menu using `switch` and iterate over array elements with `for-each` loop.

## 💡 Sample Test Case
```text
Primitive values: Int=100, Double=99.99, Char='A'
Explicit Cast (double to int): 99
Loop counter from 1 to 5: 1 2 3 4 5
```

## ⏱️ Complexity Analysis
- Time & Space Complexity: $O(N)$ proportional to input loops.

## ❓ Viva-Voce Questions with Model Answers
1. **Why does Java not support pointers like C?**
   *Answer:* For security, memory safety, and preventing unauthorized direct memory manipulation; references are managed by the JVM Garbage Collector.
""",

    ("CSPC2203", 3): """# Experiment 03: Classes and Constructors

## 🎯 Aim of the Experiment
To design an object-oriented class in Java demonstrating default constructors, parameterized constructors, copy constructors, and constructor overloading.

## 📖 Theoretical Background & Core Principles
A constructor is a special member function having the same name as the class and no return type. It initializes state upon `new` instantiation.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Define class `Student` with fields `name`, `rollNo`, `cgpa`.
2. Implement Default Constructor: initializes default values.
3. Implement Parameterized Constructor: initializes fields using `this` keyword.
4. Implement Copy Constructor: creates duplicate object from existing reference.
5. Create instances in `main` and invoke display methods.

## 💡 Sample Test Case
```text
Default Student: Name: null, Roll: 0
Parameterized:  Name: Ayush, Roll: 101, CGPA: 9.2
Copy Student:   Name: Ayush, Roll: 101, CGPA: 9.2
```

## ⏱️ Complexity Analysis
- Object creation: $O(1)$ time and heap space.

## ❓ Viva-Voce Questions with Model Answers
1. **Can a constructor be declared private?**
   *Answer:* Yes, used in Singleton design patterns to restrict instantiation from outside the class.
""",

    ("CSPC2203", 4): """# Experiment 04: Method Overloading

## 🎯 Aim of the Experiment
To demonstrate compile-time polymorphism in Java using **Method Overloading** with differing parameter counts, types, and sequences.

## 📖 Theoretical Background & Core Principles
Method overloading occurs when multiple methods in the same class share the identical name but differ in their method signature (parameter list). Return type alone is insufficient to overload methods.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Define class `Calculator`.
2. Implement `add(int a, int b)`.
3. Implement `add(int a, int b, int c)`.
4. Implement `add(double a, double b)`.
5. Call each variant from `main()` and observe static binding.

## 💡 Sample Output
```text
add(10, 20)        = 30
add(10, 20, 30)    = 60
add(12.5, 7.5)     = 20.0
```

## ⏱️ Complexity Analysis
- Binding Resolution: $O(1)$ compile-time resolution.

## ❓ Viva-Voce Questions with Model Answers
1. **Why can't method overloading be accomplished solely by changing the return type?**
   *Answer:* Because the compiler cannot unambiguously determine which method to invoke when called without assignment (e.g. `calc.add(2, 3)`).
""",

    ("CSPC2203", 5): """# Experiment 05: Inheritance and Method Overriding

## 🎯 Aim of the Experiment
To implement single and multilevel inheritance, demonstrate **Method Overriding**, dynamic method dispatch (runtime polymorphism), and the `super` keyword.

## 📖 Theoretical Background & Core Principles
Inheritance (`extends`) allows a subclass to inherit attributes and methods of a superclass. Method overriding occurs when a subclass provides a specific implementation of a method already declared in its parent.

```
Class Animal { void sound() }
      ^
      | extends
Class Dog    { void sound() -> "Barks" }
```

## ⚙️ Step-by-Step Algorithm & Procedure
1. Define base class `Animal` with method `sound()`.
2. Define derived class `Dog extends Animal` and override `sound()`.
3. Use `super.sound()` to invoke parent behavior.
4. Demonstrate Dynamic Method Dispatch: `Animal a = new Dog(); a.sound();`.

## 💡 Sample Output
```text
Animal makes a sound
Dog barks loudly (super called successfully)
```

## ⏱️ Complexity Analysis
- Dynamic Dispatch: $O(1)$ via JVM virtual method table (vtable).

## ❓ Viva-Voce Questions with Model Answers
1. **Can static methods be overridden in Java?**
   *Answer:* No, static methods are bonded at compile time; re-declaring them in a subclass causes method hiding, not overriding.
""",

    ("CSPC2203", 6): """# Experiment 06: Packages

## 🎯 Aim of the Experiment
To organize Java code into user-defined packages, demonstrate the `import` statement, and analyze the four access specifiers (`public`, `protected`, `default`, `private`).

## 📖 Theoretical Background & Core Principles
Packages provide namespace segregation, avoid naming collisions, and control class visibility across architectural boundaries.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create directory `mypackage`.
2. Define `package mypackage;` in `Helper.java` with a public method.
3. In parent directory, create `Main.java` and write `import mypackage.Helper;`.
4. Compile with `javac -d . Helper.java` and run `Main.java`.

## 💡 Sample Output
```text
Greeting from custom package 'mypackage.Helper'!
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the default access level if no specifier is provided?**
   *Answer:* Package-private (default): accessible only within classes belonging to the identical package.
""",

    ("CSPC2203", 7): """# Experiment 07: Exception Handling

## 🎯 Aim of the Experiment
To handle runtime errors robustly in Java using `try`, `catch`, `finally`, `throw`, `throws`, and creating a custom user-defined Exception class.

## 📖 Theoretical Background & Core Principles
Exceptions are abnormal runtime conditions. Checked exceptions (`IOException`, `SQLException`) must be handled or declared. Unchecked exceptions (`ArithmeticException`, `NullPointerException`) derive from `RuntimeException`.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Wrap hazardous arithmetic division in a `try` block.
2. Catch `ArithmeticException` with a diagnostic message.
3. Create custom exception: `class InvalidAgeException extends Exception`.
4. Validate input with `throw new InvalidAgeException("Age < 18")`.
5. Execute cleanup actions inside `finally`.

## 💡 Sample Output
```text
Caught Exception: Division by zero is undefined!
Finally block executed: Resources released.
```

## ❓ Viva-Voce Questions with Model Answers
1. **Can a finally block be bypassed?**
   *Answer:* Only if `System.exit(0)` is invoked or if the JVM crashes due to fatal hardware/OS failure.
""",

    ("CSPC2203", 8): """# Experiment 08: Multithreading

## 🎯 Aim of the Experiment
To implement multithreading in Java by extending the `Thread` class and implementing the `Runnable` interface, and demonstrating thread synchronization.

## 📖 Theoretical Background & Core Principles
Threads are lightweight units of execution sharing a common memory heap. Concurrency issues like race conditions require `synchronized` blocks or methods to preserve atomicity.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Define `class WorkerThread extends Thread` with `run()` loop.
2. Define `class Task implements Runnable` with `run()`.
3. In `Main`, create thread instances and trigger them with `start()`.
4. Join threads using `thread.join()` to synchronize main termination.

## 💡 Sample Output
```text
Thread-1: Iteration 1
Thread-2: Iteration 1
Thread-1: Iteration 2
All threads completed execution.
```

## ⏱️ Complexity Analysis
- Concurrency overhead: Context switching cost per OS schedule.

## ❓ Viva-Voce Questions with Model Answers
1. **Why call `start()` instead of `run()` directly?**
   *Answer:* `start()` creates a new OS thread call stack and invokes `run()` asynchronously, whereas calling `run()` directly executes it sequentially on the current thread.
""",

    ("CSPC2203", 9): """# Experiment 09: Applet Structure and Event Handling

## 🎯 Aim of the Experiment
To understand the graphical GUI architecture in Java, analyze the life cycle of applets/Swing frames, and implement event handling using the Delegation Event Model.

## 📖 Theoretical Background & Core Principles
Java Event Handling follows the **Delegation Event Model**:
1. **Event Source:** UI component generating events (e.g. `JButton`).
2. **Event Object:** Encapsulates state change (e.g. `ActionEvent`).
3. **Event Listener:** Interface with callback methods (`ActionListener`).

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create a `JFrame` window.
2. Add a `JButton` and `JLabel`.
3. Register listener: `btn.addActionListener(e -> label.setText("Button Clicked!"));`.
4. Display frame with `setVisible(true)`.

## 💡 Sample Output
```text
GUI Frame launched.
[Click Me] Button triggered -> Text updated: "Action Event Fired!"
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is an Adapter class in Java AWT/Swing?**
   *Answer:* An abstract class providing empty default implementations for listener interfaces with multiple methods, allowing subclasses to override only required events.
""",

    ("CSPC2203", 10): """# Experiment 10: Layout Managers

## 🎯 Aim of the Experiment
To design graphical interfaces in Java demonstrating layout managers: `FlowLayout`, `BorderLayout`, and `GridLayout`.

## 📖 Theoretical Background & Core Principles
Layout managers determine the sizing and geometric positioning of GUI components within a container, adapting dynamically to window resizing.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create a `JFrame`.
2. Demonstrate `BorderLayout`: Add buttons to `NORTH`, `SOUTH`, `EAST`, `WEST`, and `CENTER`.
3. Demonstrate `GridLayout`: Arrange buttons in a $3 \\times 3$ grid (e.g. numeric keypad).
4. Set window dimensions and make visible.

## 💡 Sample Output
```text
Layout manager applied: 3x3 Grid Keypad rendered cleanly.
BorderLayout regions allocated across 5 compass regions.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the default layout manager for `JFrame` content pane?**
   *Answer:* `BorderLayout` is the default layout manager for `JFrame`, while `FlowLayout` is default for `JPanel`.
"""
}
