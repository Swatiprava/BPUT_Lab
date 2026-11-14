-- ============================================================
-- PPD Lab Platform — Seed Data
-- All subjects and enriched experiments from BPUT CSE Syllabus
-- ============================================================
-- Run this in Supabase SQL Editor AFTER running migration.sql
-- ============================================================

-- ============================================================
-- SUBJECTS
-- ============================================================

INSERT INTO subjects (code, name, semester, language) VALUES
('CSPC2202', 'Data Structures Lab', 3, 'c'),
('CSPC2203', 'Object Oriented Programming Lab', 3, 'java'),
('CSPC2204', 'Database Engineering Lab', 4, 'mysql'),
('CSPC2205', 'Computer Organization & Architecture Lab', 4, 'c'),
('CSPC2206', 'Design & Analysis of Algorithms Lab', 4, 'c'),
('CSPC2207', 'Computer Networks Lab', 4, 'c'),
('CSPC3201', 'Theory of Computation Laboratory', 5, 'c'),
('CSPC3202', 'Operating Systems Laboratory', 5, 'c'),
('CSPC3203', 'Machine Learning Laboratory', 5, 'python'),
('CSPC3204', 'Compiler Design Laboratory', 6, 'c'),
('CSPC3205', 'Software Engineering Laboratory', 6, 'python')
ON CONFLICT (code) DO UPDATE SET
  name = EXCLUDED.name,
  semester = EXCLUDED.semester,
  language = EXCLUDED.language;


-- ============================================================
-- CSPC2202: Data Structures Lab (Sem 3, C)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC2202'), 1, 'Sparse Matrix Implementation', '# Experiment 01: Sparse Matrix Implementation

## 🎯 Aim of the Experiment
To write, execute, and verify a C program that reads a two-dimensional matrix from standard input, identifies non-zero elements, and constructs an efficient sparse matrix representation using a 3-tuple (triplet) array format.

## 💻 Apparatus & Environment
- **Compiler:** GCC (GNU Compiler Collection) 9.0+ / Clang
- **Operating System:** Ubuntu Linux / Windows 10/11
- **Language Standard:** C99 / C11
- **Memory Profiler:** Valgrind (Optional)

## 📖 Theoretical Background & Core Principles
A **sparse matrix** is a mathematical matrix wherein the overwhelming majority of the elements have a numerical value of zero. In conventional two-dimensional matrix allocation ($m \times n$), memory is allocated contiguously for all $m \times n$ positions. If only $k$ entries ($k \ll m \times n$) are non-zero, this wastes massive memory and computational cycles.

```
Conventional 4x4 Matrix:
[0  0  3  0]
[0  0  0  0]   --> 16 integers allocated (64 bytes)
[5  0  0  0]       Only 3 useful values!
[0  2  0  0]
```

### Triplet Representation (3-Tuple)
In triplet representation, an array of dimensions $(k + 1) \times 3$ is created:
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
3. Read the $r \times c$ matrix elements into a 2D array `matrix[r][c]`.
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
- First line: Two integers $r$ and $c$ representing dimensions ($1 \le r, c \le 50$).
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
- Final non-zero count is 3. Triplet dimensions are $4 \times 3$.

## ⏱️ Complexity Analysis
- **Time Complexity:** $O(r \times c)$ to inspect all elements of the input matrix.
- **Auxiliary Space Complexity:** $O(k)$ where $k$ is the number of non-zero entries.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the threshold sparsity ratio for a matrix?**
   *Answer:* A matrix is considered sparse when non-zero elements constitute less than 20% to 30% of total elements ($k \le 0.2 \times M \times N$).
2. **What are the key representations of a sparse matrix?**
   *Answer:* Array of triplets (3-tuple), Linked List representation (sparse multi-list with row/col headers), and Compressed Sparse Row/Column (CSR/CSC).
3. **What is the Fast Transpose algorithm for sparse matrices?**
   *Answer:* An algorithm that transposes a triplet sparse matrix in $O(k + c)$ time by computing frequency of non-zero elements per column and pre-calculating starting indices.', '#include <stdio.h>

#define MAX 100

int main() {
    int matrix[MAX][MAX];
    int rows, cols;

    printf("Enter number of rows and columns: ");
    scanf("%d %d", &rows, &cols);

    // TODO: Read the matrix
    // TODO: Count non-zero elements
    // TODO: Create and display sparse matrix representation

    return 0;
}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 2, 'Stack using Array', '# Experiment 02: Stack Implementation using Array

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
   *Answer:* Static stack uses a fixed-size array with fixed capacity; dynamic stack uses a linked list or dynamically reallocated memory (`realloc`) allowing growth at runtime.', '#include <stdio.h>
#define MAX 100

int stack[MAX];
int top = -1;

void push(int val) {
    // TODO: Implement push operation
}

int pop() {
    // TODO: Implement pop operation
    return -1;
}

void display() {
    // TODO: Display all elements
}

int main() {
    int choice, value;

    do {
        printf("\n--- Stack Operations ---\n");
        printf("1. PUSH\n2. POP\n3. Display\n4. Exit\n");
        printf("Enter choice: ");
        scanf("%d", &choice);

        switch(choice) {
            case 1:
                printf("Enter value: ");
                scanf("%d", &value);
                push(value);
                break;
            case 2:
                pop();
                break;
            case 3:
                display();
                break;
        }
    } while(choice != 4);

    return 0;
}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 3, 'Queue using Array', '# Experiment 03: Queue Implementation using Array

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
- Constraints: $1 \le MAX \le 100$.

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
   *Answer:* A generalized queue supporting insertions and deletions at both the front and rear ends.', '#include <stdio.h>
#define MAX 100

int queue[MAX];
int front = -1, rear = -1;

void enqueue(int val) {
    // TODO: Implement enqueue
}

int dequeue() {
    // TODO: Implement dequeue
    return -1;
}

void display() {
    // TODO: Display queue elements
}

int main() {
    // TODO: Menu-driven program
    return 0;
}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 4, 'Single Linked List Operations', '# Experiment 04: Single Linked List Operations

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
   - Locate target node, update previous node''s `next` pointer to bypass it, and call `free(target)`.

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
   *Answer:* A pointer that continues to reference memory that has already been deallocated using `free()`.', '#include <stdio.h>
#include <stdlib.h>

struct Node {
    int data;
    struct Node* next;
};

struct Node* head = NULL;

void insertAtEnd(int val) {
    // TODO: Insert node at the end
}

void deleteNode(int val) {
    // TODO: Delete a node by value
}

void display() {
    // TODO: Traverse and display
}

int main() {
    // TODO: Menu-driven program
    return 0;
}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 5, 'Double Linked List Operations', '# Experiment 05: Double Linked List Operations

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
- Space Overhead: 2 pointers per node ($2 \times 8$ bytes on 64-bit systems)

## ❓ Viva-Voce Questions with Model Answers
1. **What is the main advantage of DLL over SLL?**
   *Answer:* Bidirectional traversal and $O(1)$ deletion of a given node without needing a reference to its predecessor.
2. **What is a Circular Doubly Linked List?**
   *Answer:* A DLL where the tail''s `next` points to head and head''s `prev` points to tail.', '#include <stdio.h>
#include <stdlib.h>

struct Node {
    int data;
    struct Node* prev;
    struct Node* next;
};

struct Node* head = NULL;

// TODO: Implement all operations

int main() {
    // TODO: Menu-driven program
    return 0;
}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 6, 'Binary Tree Operations', '# Experiment 06: Binary Tree Operations

## 🎯 Aim of the Experiment
To create a **Binary Tree** in C and implement depth-first tree traversals: **Inorder (LDR)**, **Preorder (DLR)**, and **Postorder (LRD)** using recursion.

## 💻 Apparatus & Environment
- **Compiler:** GCC 9.0+ / Clang
- **Language:** C99

## 📖 Theoretical Background & Core Principles
A Binary Tree is a hierarchical non-linear data structure where each node has at most two children: `left` and `right`.

```
        1 (Root)
       / \
      2   3
     / \
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
- **Space Complexity:** $O(H)$ recursion stack frames where $H$ is the tree height ($O(\log N)$ balanced, $O(N)$ skewed).

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Full Binary Tree vs Complete Binary Tree?**
   *Answer:* Full has 0 or 2 children per node. Complete is completely filled at all levels except possibly the last, which is filled from left to right.
2. **What traversal uniquely reconstructs a binary tree?**
   *Answer:* Inorder combined with either Preorder or Postorder traversal.', '#include <stdio.h>
#include <stdlib.h>

struct Node {
    int data;
    struct Node* left;
    struct Node* right;
};

struct Node* createNode(int val) {
    // TODO: Create a new node
    return NULL;
}

void inorder(struct Node* root) {
    // TODO: Inorder traversal
}

int main() {
    // TODO: Build and manipulate binary tree
    return 0;
}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 7, 'Bubble Sort', '# Experiment 07: Bubble Sort

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
   *Answer:* $N(N-1)/2$.', '#include <stdio.h>

void bubbleSort(int arr[], int n) {
    // TODO: Implement bubble sort
}

void printArray(int arr[], int n) {
    for(int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    printf("\n");
}

int main() {
    int arr[] = {64, 34, 25, 12, 22, 11, 90};
    int n = sizeof(arr)/sizeof(arr[0]);

    printf("Unsorted array: ");
    printArray(arr, n);

    bubbleSort(arr, n);

    printf("Sorted array: ");
    printArray(arr, n);

    return 0;
}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 8, 'Insertion Sort', '# Experiment 08: Insertion Sort

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
   *Answer:* It has minimal overhead, low constant factors, and achieves near-linear $O(N)$ performance on nearly sorted inputs.', '#include <stdio.h>\n\nvoid insertionSort(int arr[], int n) {\n    // TODO: Implement insertion sort\n}\n\nint main() {\n    int arr[] = {12, 11, 13, 5, 6};\n    int n = sizeof(arr)/sizeof(arr[0]);\n    \n    insertionSort(arr, n);\n    \n    printf("Sorted array: ");\n    for(int i = 0; i < n; i++)\n        printf("%d ", arr[i]);\n    \n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 9, 'Selection Sort', '# Experiment 09: Selection Sort

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
   *Answer:* In environments where memory writes are extremely expensive (e.g. Flash EEPROM) because it performs at most $O(N)$ writes.', '#include <stdio.h>\n\nvoid selectionSort(int arr[], int n) {\n    // TODO: Implement selection sort\n}\n\nint main() {\n    int arr[] = {64, 25, 12, 22, 11};\n    int n = sizeof(arr)/sizeof(arr[0]);\n    \n    selectionSort(arr, n);\n    \n    printf("Sorted array: ");\n    for(int i = 0; i < n; i++)\n        printf("%d ", arr[i]);\n    \n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 10, 'Quick Sort', '# Experiment 10: Quick Sort

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
- Best/Average Case Time: $O(N \log N)$
- Worst Case Time: $O(N^2)$ (when already sorted and extreme pivot selected)
- Space: $O(\log N)$ recursion stack

## ❓ Viva-Voce Questions with Model Answers
1. **How can worst-case behavior in Quick Sort be prevented?**
   *Answer:* Using Randomized Quick Sort (selecting pivot at random) or Median-of-Three pivot selection.', '#include <stdio.h>\n\nvoid swap(int* a, int* b) {\n    int t = *a;\n    *a = *b;\n    *b = t;\n}\n\nint partition(int arr[], int low, int high) {\n    // TODO: Implement partition\n    return 0;\n}\n\nvoid quickSort(int arr[], int low, int high) {\n    // TODO: Implement quick sort\n}\n\nint main() {\n    int arr[] = {10, 7, 8, 9, 1, 5};\n    int n = sizeof(arr)/sizeof(arr[0]);\n    \n    quickSort(arr, 0, n-1);\n    \n    printf("Sorted array: ");\n    for(int i = 0; i < n; i++)\n        printf("%d ", arr[i]);\n    \n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 11, 'Merge Sort', '# Experiment 11: Merge Sort

## 🎯 Aim of the Experiment
To implement **Merge Sort** in C using recursive divide-and-conquer and evaluate its stable $O(N \log N)$ performance.

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
- Time Complexity: $O(N \log N)$ in Best, Average, and Worst cases.
- Auxiliary Space: $O(N)$ for temporary merge arrays.

## ❓ Viva-Voce Questions with Model Answers
1. **Is Merge Sort an in-place sort?**
   *Answer:* No, standard Merge Sort requires $O(N)$ auxiliary storage to merge sorted subarrays.', '#include <stdio.h>\n\nvoid merge(int arr[], int l, int m, int r) {\n    // TODO: Implement merge\n}\n\nvoid mergeSort(int arr[], int l, int r) {\n    // TODO: Implement merge sort\n}\n\nint main() {\n    int arr[] = {38, 27, 43, 3, 9, 82, 10};\n    int n = sizeof(arr)/sizeof(arr[0]);\n    \n    mergeSort(arr, 0, n-1);\n    \n    printf("Sorted array: ");\n    for(int i = 0; i < n; i++)\n        printf("%d ", arr[i]);\n    \n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 12, 'Linear Search', '# Experiment 12: Linear Search

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
   *Answer:* When the array is unsorted and only a single query is performed, avoiding sorting overhead.', '#include <stdio.h>\n\nint linearSearch(int arr[], int n, int key) {\n    // TODO: Implement linear search\n    return -1;\n}\n\nint main() {\n    int arr[] = {2, 3, 4, 10, 40};\n    int n = sizeof(arr)/sizeof(arr[0]);\n    int key = 10;\n    \n    int result = linearSearch(arr, n, key);\n    \n    if(result == -1)\n        printf("Element not found");\n    else\n        printf("Element found at index %d", result);\n    \n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2202'), 13, 'Binary Search', '# Experiment 13: Binary Search

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
- Worst Case: $O(\log_2 N)$
- Auxiliary Space: $O(1)$ iterative, $O(\log N)$ recursive

## ❓ Viva-Voce Questions with Model Answers
1. **Why use `low + (high - low)/2` instead of `(low + high)/2`?**
   *Answer:* To avoid potential integer arithmetic overflow when `low + high` exceeds maximum signed 32-bit integer (`2,147,483,647`).', '#include <stdio.h>\n\nint binarySearch(int arr[], int l, int r, int key) {\n    // TODO: Implement binary search\n    return -1;\n}\n\nint main() {\n    int arr[] = {2, 3, 4, 10, 40};\n    int n = sizeof(arr)/sizeof(arr[0]);\n    int key = 10;\n    \n    int result = binarySearch(arr, 0, n-1, key);\n    \n    if(result == -1)\n        printf("Element not found");\n    else\n        printf("Element found at index %d", result);\n    \n    return 0;\n}')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC2203: Object Oriented Programming Lab (Sem 3, JAVA)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC2203'), 1, 'Hello World in Java', '# Experiment 01: Hello World in Java & JVM Architecture

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
   *Answer:* JDK contains development tools + JRE; JRE contains standard class libraries + JVM; JVM executes bytecode.', 'public class Main {\n    public static void main(String[] args) {\n        // TODO: Print "Hello World!"\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 2, 'Data Types, Variables & Control Structures', '# Experiment 02: Data Types, Variables & Control Structures

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
Primitive values: Int=100, Double=99.99, Char=''A''
Explicit Cast (double to int): 99
Loop counter from 1 to 5: 1 2 3 4 5
```

## ⏱️ Complexity Analysis
- Time & Space Complexity: $O(N)$ proportional to input loops.

## ❓ Viva-Voce Questions with Model Answers
1. **Why does Java not support pointers like C?**
   *Answer:* For security, memory safety, and preventing unauthorized direct memory manipulation; references are managed by the JVM Garbage Collector.', 'public class Main {\n    public static void main(String[] args) {\n        // TODO: Demonstrate data types, variables, operators\n        // TODO: Create and use arrays\n        // TODO: Use control structures\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 3, 'Classes and Constructors', '# Experiment 03: Classes and Constructors

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
   *Answer:* Yes, used in Singleton design patterns to restrict instantiation from outside the class.', 'class Student {\n    String name;\n    int rollNo;\n\n    // TODO: Default constructor\n    // TODO: Parameterized constructor\n    // TODO: Copy constructor\n\n    void display() {\n        System.out.println("Name: " + name + ", Roll No: " + rollNo);\n    }\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        // TODO: Create objects using different constructors\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 4, 'Method Overloading', '# Experiment 04: Method Overloading

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
1. **Why can''t method overloading be accomplished solely by changing the return type?**
   *Answer:* Because the compiler cannot unambiguously determine which method to invoke when called without assignment (e.g. `calc.add(2, 3)`).', 'class Calculator {\n    // TODO: Implement overloaded add methods\n    // add(int, int)\n    // add(int, int, int)\n    // add(double, double)\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        // TODO: Test method overloading\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 5, 'Inheritance and Method Overriding', '# Experiment 05: Inheritance and Method Overriding

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
   *Answer:* No, static methods are bonded at compile time; re-declaring them in a subclass causes method hiding, not overriding.', 'class Animal {\n    void sound() {\n        System.out.println("Animal makes a sound");\n    }\n}\n\nclass Dog extends Animal {\n    // TODO: Override sound() method\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        // TODO: Demonstrate inheritance and method overriding\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 6, 'Packages', '# Experiment 06: Packages

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
Greeting from custom package ''mypackage.Helper''!
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the default access level if no specifier is provided?**
   *Answer:* Package-private (default): accessible only within classes belonging to the identical package.', 'package mypackage;\n\npublic class MyClass {\n    public void greet() {\n        System.out.println("Hello from mypackage!");\n    }\n}\n\n// In Main.java:\n// import mypackage.MyClass;\n\npublic class Main {\n    public static void main(String[] args) {\n        // TODO: Use the package class\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 7, 'Exception Handling', '# Experiment 07: Exception Handling

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
   *Answer:* Only if `System.exit(0)` is invoked or if the JVM crashes due to fatal hardware/OS failure.', 'public class Main {\n    public static void main(String[] args) {\n        // TODO: Demonstrate try-catch-finally\n        // TODO: Handle ArithmeticException, ArrayIndexOutOfBoundsException\n        // TODO: Create and throw custom exception\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 8, 'Multithreading', '# Experiment 08: Multithreading

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
   *Answer:* `start()` creates a new OS thread call stack and invokes `run()` asynchronously, whereas calling `run()` directly executes it sequentially on the current thread.', 'class MyThread extends Thread {\n    public void run() {\n        // TODO: Thread logic\n    }\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        // TODO: Create and start threads\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 9, 'Applet Structure and Event Handling', '# Experiment 09: Applet Structure and Event Handling

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
   *Answer:* An abstract class providing empty default implementations for listener interfaces with multiple methods, allowing subclasses to override only required events.', 'import java.awt.*;\nimport java.awt.event.*;\nimport javax.swing.*;\n\npublic class Main extends JFrame implements ActionListener {\n    JButton btn;\n\n    Main() {\n        btn = new JButton("Click Me");\n        btn.addActionListener(this);\n        add(btn);\n        setSize(400, 300);\n        setVisible(true);\n    }\n\n    public void actionPerformed(ActionEvent e) {\n        // TODO: Handle button click\n    }\n\n    public static void main(String[] args) {\n        new Main();\n    }\n}'),
((SELECT id FROM subjects WHERE code='CSPC2203'), 10, 'Layout Managers', '# Experiment 10: Layout Managers

## 🎯 Aim of the Experiment
To design graphical interfaces in Java demonstrating layout managers: `FlowLayout`, `BorderLayout`, and `GridLayout`.

## 📖 Theoretical Background & Core Principles
Layout managers determine the sizing and geometric positioning of GUI components within a container, adapting dynamically to window resizing.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Create a `JFrame`.
2. Demonstrate `BorderLayout`: Add buttons to `NORTH`, `SOUTH`, `EAST`, `WEST`, and `CENTER`.
3. Demonstrate `GridLayout`: Arrange buttons in a $3 \times 3$ grid (e.g. numeric keypad).
4. Set window dimensions and make visible.

## 💡 Sample Output
```text
Layout manager applied: 3x3 Grid Keypad rendered cleanly.
BorderLayout regions allocated across 5 compass regions.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the default layout manager for `JFrame` content pane?**
   *Answer:* `BorderLayout` is the default layout manager for `JFrame`, while `FlowLayout` is default for `JPanel`.', 'import javax.swing.*;\nimport java.awt.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        // TODO: Create frames with different layout managers\n        // FlowLayout, BorderLayout, GridLayout\n    }\n}')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC2204: Database Engineering Lab (Sem 4, SQL)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC2204'), 1, 'Library Database', '# Experiment 01: Library Database Schema & DDL/DML Queries

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
   *Answer:* When the parent record is deleted, foreign keys in child records are automatically updated to `NULL`.', '-- Create tables\nCREATE TABLE PUBLISHER (\n    Name VARCHAR(100) PRIMARY KEY,\n    Address VARCHAR(200),\n    Phone VARCHAR(15)\n);\n\nCREATE TABLE BOOK (\n    Book_id INT PRIMARY KEY,\n    Title VARCHAR(200),\n    Publisher_Name VARCHAR(100) REFERENCES PUBLISHER(Name),\n    Pub_Year INT\n);\n\n-- TODO: Create remaining tables\n-- TODO: Insert sample data\n-- TODO: Write the required queries'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 2, 'College Database', '# Experiment 02: College Database & Aggregate Functions

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
   *Answer:* `WHERE` filters rows before grouping occurs; `HAVING` filters aggregated groups after the `GROUP BY` clause is evaluated.', '-- TODO: Create schema and implement queries'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 3, 'Order Database', '# Experiment 03: Order Database & Subqueries

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
   *Answer:* `UNION` eliminates duplicate records and performs an internal sort, whereas `UNION ALL` retains all duplicates and executes faster.', '-- TODO: Create schema and implement queries'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 4, 'DCL Commands - GRANT & REVOKE', '# Experiment 04: DCL Commands - GRANT & REVOKE

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
INSERT INTO EMPLOYEES VALUES (101, ''Anil'', 55000, 10);
ROLLBACK TO sp1;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between `COMMIT` and `ROLLBACK`?**
   *Answer:* `COMMIT` permanently saves transaction changes to disk; `ROLLBACK` undoes all uncommitted changes back to transaction start or savepoint.', '-- TODO: Create schema and demonstrate DCL commands'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 5, 'JOIN Operations', '# Experiment 05: JOIN Operations

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
   *Answer:* A `CROSS JOIN` that pairs every row of the first table with every row of the second table, resulting in $M \times N$ rows.', '-- TODO: Create tables and demonstrate JOINs'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 6, 'Election Commission Database', '# Experiment 06: Election Commission Database & Triggers

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
        RAISE_APPLICATION_ERROR(-20001, ''Underage voter registration denied.'');
    END IF;
END;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Statement-level and Row-level triggers?**
   *Answer:* Statement-level executes once for the entire SQL statement; Row-level (`FOR EACH ROW`) executes once for every individual row modified.', '-- TODO: Create schema, stored procedures, and triggers'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 7, 'Airline Database - Relational Algebra', '# Experiment 07: Airline Database - Relational Algebra

## 🎯 Aim of the Experiment
To express complex database queries on an **Airline Flight Database** using relational algebra expressions and SQL set operations.

## 📖 Theoretical Background & Core Principles
Relational algebra is a procedural query language consisting of operations: Selection ($\sigma$), Projection ($\pi$), Cartesian Product ($\times$), Union ($\cup$), Set Difference ($-$), and Join ($\bowtie$).

## ⚙️ Step-by-Step Algorithm & Procedure
1. Express query: "Find pilots certified for Boeing aircraft whose cruising range exceeds 3000 miles".
2. Convert relational algebraic expression $\pi_{ename}(\sigma_{aname=''Boeing'' \land cruisingrange > 3000}(AIRCRAFT \bowtie CERTIFIED \bowtie EMPLOYEES))$ to SQL.

## 💡 Sample Query
```sql
SELECT DISTINCT e.ename
FROM EMPLOYEES e
JOIN CERTIFIED c ON e.eid = c.eid
JOIN AIRCRAFT a ON c.aid = a.aid
WHERE a.aname LIKE ''%Boeing%'' AND a.cruisingrange > 3000;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is Relational Completeness?**
   *Answer:* A query language is relationally complete if it is at least as expressive as first-order relational calculus.', '-- TODO: Create schema and implement queries'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 8, 'Cursors', '# Experiment 08: Cursors in PL/SQL

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
        DBMS_OUTPUT.PUT_LINE(''Employee: '' || v_name || '' | Salary: '' || v_salary);
    END LOOP;
    CLOSE cur_emp;
END;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Cursor FOR Loop?**
   *Answer:* A simplified PL/SQL syntax that automatically opens, fetches, checks termination, and closes the cursor without explicit statements.', '-- TODO: Implement cursor operations'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 9, 'Stored Procedures - Student Grading', '# Experiment 09: Stored Procedures - Student Grading

## 🎯 Aim of the Experiment
To write a PL/SQL stored procedure that accepts student roll number, calculates aggregate percentages, and assigns academic class grades.

## 📖 Theoretical Background & Core Principles
A stored procedure is a named precompiled PL/SQL block stored inside the database catalog, reducing network round-trips and enforcing standardized business logic.

### Grading Criteria:
- Score $\ge 75\%$: Distinction
- Score $\ge 60\%$ and $< 75\%$: First Class
- Score $\ge 50\%$ and $< 60\%$: Second Class
- Score $< 50\%$: Fail

## 💡 Sample Procedure Definition
```sql
CREATE OR REPLACE PROCEDURE calculate_grade(p_roll IN INT, p_class OUT VARCHAR2) AS
    v_marks NUMBER;
BEGIN
    SELECT total_marks INTO v_marks FROM Stud_Marks WHERE roll = p_roll;
    IF v_marks >= 900 THEN
        p_class := ''Distinction'';
    ELSIF v_marks >= 720 THEN
        p_class := ''First Class'';
    ELSE
        p_class := ''Second Class'';
    END IF;
END;
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between a Stored Procedure and a Function?**
   *Answer:* A Function must return a value using the `RETURN` keyword and can be called inside SQL statements; a Procedure cannot be called directly within a `SELECT` statement.', '-- TODO: Create schema and stored procedure'),
((SELECT id FROM subjects WHERE code='CSPC2204'), 10, 'PL/SQL - Library Fine System', '# Experiment 10: PL/SQL - Library Fine System

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
3. If `days_overdue > 30`, calculate fine and set status `''SUSPENDED''`.
4. Insert fine receipt into `FINE` table.

## 💡 Sample Output
```text
Borrower Roll 102 checked in book ''Operating Systems''
Days Overdue: 35 days
Fine Calculated: Rs 550
Membership status updated to SUSPENDED.
```

## ❓ Viva-Voce Questions with Model Answers
1. **How do ACID properties apply to this transaction?**
   *Answer:* Atomicity ensures either both the fine record insertion and book status update occur together or neither occurs.', '-- TODO: Implement PL/SQL block with exception handling')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC2205: Computer Organization & Architecture Lab (Sem 4, C)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC2205'), 1, 'Fast Multiplication & Division', '# Experiment 01: Fast Multiplication & Division (Booth''s Algorithm)

## 🎯 Aim of the Experiment
To simulate **Booth''s Multiplication Algorithm** and **Restoring/Non-Restoring Division** in C to understand binary signed-2''s complement hardware arithmetic.

## 💻 Apparatus & Environment
- **Compiler:** GCC 9.0+
- **Language:** C99

## 📖 Theoretical Background & Core Principles
Booth''s algorithm accelerates multiplication of two signed binary integers in 2''s complement by scanning adjacent bit pairs ($Q_0, Q_{-1}$):
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
1. **Why is Booth''s Algorithm faster than repeated addition?**
   *Answer:* It skips blocks of consecutive 1s or 0s with simple shifts, significantly reducing the number of costly additions/subtractions.', '#include <stdio.h>\n\n// Booth''s Multiplication Algorithm\nvoid boothMultiply(int multiplicand, int multiplier) {\n    // TODO: Implement\n}\n\nint main() {\n    // TODO: Test multiplication and division\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2205'), 2, 'Hardware Training Kits', '# Experiment 02: Microprocessor Hardware Training Kits (8085/8086)

## 🎯 Aim of the Experiment
To familiarize with microprocessor hardware training kits (Intel 8085/8086), inspect internal register architectures (A, B, C, D, E, H, L), flag registers, and execute basic machine code.

## 📖 Theoretical Background & Core Principles
The 8085 is an 8-bit NMOS microprocessor operating at 3 MHz with a 16-bit address bus ($64 \text{ KB}$ addressable memory).
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
   *Answer:* AD0-AD7 lines carry both 8-bit memory address and data multiplexed in time, separated using the `ALE` (Address Latch Enable) signal.', '# Hardware Training Kit Experiments\n\n# Equipment Used:\n# TODO: Document hardware components\n\n# Observations:\n# TODO: Record observations'),
((SELECT id FROM subjects WHERE code='CSPC2205'), 3, 'PC Assembly & Block Diagram', '# Experiment 03: PC Assembly & Architectural Block Diagram

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
   *Answer:* Historically, Northbridge handled high-speed components (RAM, PCIe graphics); Southbridge handled slower peripheral I/O (USB, SATA, BIOS, Audio). Modern CPUs integrate Northbridge directly onto the CPU die.', '# PC Assembly & Block Diagram\n\n# Components Identified:\n# TODO: List all components\n\n# Motherboard Block Diagram:\n# TODO: Describe the layout\n\n# SMPS Specifications:\n# TODO: Document power supply details'),
((SELECT id FROM subjects WHERE code='CSPC2205'), 4, 'Hardware Technology Study Project', '# Experiment 04: Hardware Technology Study Project

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
   *Answer:* Structural hazards (hardware resource conflicts), Data hazards (RAW, WAR, WAW dependencies), and Control hazards (branch/jump instructions).', '# Hardware Technology Study Project\n\n# Topic: [Choose a topic]\n\n# 1. Introduction:\n# TODO\n\n# 2. Architecture/Design:\n# TODO\n\n# 3. Working Principle:\n# TODO\n\n# 4. Applications:\n# TODO\n\n# 5. Conclusion:\n# TODO')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC2206: Design & Analysis of Algorithms Lab (Sem 4, C)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC2206'), 1, 'Selection Sort with Time Complexity', '# Experiment 01: Selection Sort with Empirical Time Complexity

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
- Theoretical Time: $\Theta(N^2)$ in all cases.
- Empirical Verification: Doubling $N$ quadruples runtime.

## ❓ Viva-Voce Questions with Model Answers
1. **Why does $T(2N)/T(N) \approx 4$ confirm quadratic complexity?**
   *Answer:* Because for $T(N) = cN^2$, $T(2N) = c(2N)^2 = 4cN^2 = 4 T(N)$.', '#include <stdio.h>\n#include <time.h>\n#include <stdlib.h>\n\nvoid selectionSort(int arr[], int n) {\n    // TODO: Implement selection sort\n}\n\nint main() {\n    // TODO: Generate random array, sort, measure time\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 2, 'Quick Sort with Time Complexity', '# Experiment 02: Quick Sort with Time Complexity Analysis

## 🎯 Aim of the Experiment
To implement **Quick Sort** in C and analyze its average-case $O(N \log N)$ vs worst-case $O(N^2)$ time complexity across randomized vs presorted arrays.

## 📖 Theoretical Background & Core Principles
Quick Sort recurrence:
- Average Case: $T(N) = 2T(N/2) + O(N) \implies O(N \log N)$.
- Worst Case: $T(N) = T(N-1) + O(N) \implies O(N^2)$.

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
   *Answer:* By choosing a pivot at random with uniform distribution, the expected balance of the partition remains near $50:50$ with high probability.', '#include <stdio.h>\n#include <time.h>\n#include <stdlib.h>\n\n// TODO: Implement Quick Sort with timing analysis\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 3, 'Merge Sort with Time Complexity', '# Experiment 03: Merge Sort with Time Complexity

## 🎯 Aim of the Experiment
To implement **Merge Sort** in C and empirically verify its guaranteed $O(N \log N)$ time complexity irrespective of input data distribution.

## 📖 Theoretical Background & Core Principles
By the Master Theorem, $T(N) = 2T(N/2) + O(N) \implies a=2, b=2, d=1$. Since $a = b^d$, $T(N) = \Theta(N \log N)$ across best, average, and worst scenarios.

## 💡 Sample Test Case
```text
Sorted 50,000 random elements in 0.009 seconds.
Sorted 50,000 reverse elements in 0.009 seconds.
(Guaranteed uniform asymptotic performance!)
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why is Merge Sort preferred for Linked Lists over Quick Sort?**
   *Answer:* Linked lists allow $O(1)$ element insertion/splicing without requiring random-access indexing or extra array copying.', '#include <stdio.h>\n#include <time.h>\n#include <stdlib.h>\n\n// TODO: Implement Merge Sort with timing analysis\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 4, 'Knapsack - Greedy Method', '# Experiment 04: Fractional Knapsack - Greedy Method

## 🎯 Aim of the Experiment
To implement the **Fractional Knapsack Problem** using the Greedy algorithmic strategy and achieve optimal item value accumulation.

## 📖 Theoretical Background & Core Principles
In Fractional Knapsack, items can be broken into arbitrary fractions. The greedy choice property states that sorting items in descending order of value-to-weight ratio ($v_i / w_i$) yields the globally optimal solution.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Compute ratio $r_i = \text{value}_i / \text{weight}_i$ for all $n$ items.
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
- Time Complexity: $O(N \log N)$ dominated by sorting.
- Space Complexity: $O(1)$ auxiliary.

## ❓ Viva-Voce Questions with Model Answers
1. **Why does the Greedy method fail for the 0/1 Knapsack problem?**
   *Answer:* Because fractions are disallowed; leaving empty knapsack capacity cannot be compensated for without backtracking or dynamic programming.', '#include <stdio.h>\n\n// TODO: Implement Greedy Knapsack\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 5, 'Dijkstra''s Shortest Path', '# Experiment 05: Dijkstra''s Shortest Path Algorithm

## 🎯 Aim of the Experiment
To find the shortest path from a single source vertex to all other vertices in a weighted graph with non-negative edge weights using **Dijkstra''s Algorithm**.

## 📖 Theoretical Background & Core Principles
Dijkstra''s algorithm maintains a set of visited vertices and repeatedly selects the unvisited vertex with minimum tentative distance from source, applying edge relaxation:
$$\text{dist}[v] = \min(\text{dist}[v], \text{dist}[u] + \text{weight}(u, v))$$

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
- Time Complexity: $O(V^2)$ with adjacency matrix, $O((V + E) \log V)$ with min-priority heap.

## ❓ Viva-Voce Questions with Model Answers
1. **Can Dijkstra''s algorithm handle negative edge weights?**
   *Answer:* No, negative edges violate the greedy assumption that visited nodes have finalized minimum distances, leading to incorrect paths. Bellman-Ford must be used instead.', '#include <stdio.h>\n#include <limits.h>\n\n#define V 9\n\n// TODO: Implement Dijkstra''s Algorithm\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 6, 'Kruskal''s MST', '# Experiment 06: Kruskal''s Minimum Spanning Tree (MST)

## 🎯 Aim of the Experiment
To compute the **Minimum Spanning Tree (MST)** of a connected weighted graph using **Kruskal''s Algorithm** and the Disjoint Set Union (Union-Find) data structure.

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
- Time Complexity: $O(E \log E) = O(E \log V)$ for edge sorting.
- Space Complexity: $O(V + E)$.

## ❓ Viva-Voce Questions with Model Answers
1. **What is path compression in Union-Find?**
   *Answer:* A flattening optimization during `find()` that points every visited node directly to the set root, reducing future find operations to nearly $O(1)$.', '#include <stdio.h>\n#include <stdlib.h>\n\n// TODO: Implement Kruskal with Union-Find\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 7, 'Prim''s MST', '# Experiment 07: Prim''s Minimum Spanning Tree (MST)

## 🎯 Aim of the Experiment
To construct the MST of a graph starting from an arbitrary root vertex using **Prim''s Greedy Algorithm**.

## 📖 Theoretical Background & Core Principles
Prim''s algorithm grows a single tree component starting from an initial vertex, greedily adding the cheapest edge that connects a tree vertex to an external vertex outside the tree (Cut Property).

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
- Adjacency List + Min-Heap: $O(E \log V)$

## ❓ Viva-Voce Questions with Model Answers
1. **When should Kruskal''s be chosen over Prim''s?**
   *Answer:* Kruskal''s is better for sparse graphs ($E \ll V^2$); Prim''s with adjacency matrix is faster on dense graphs ($E \approx V^2$).', '#include <stdio.h>\n#include <limits.h>\n\n// TODO: Implement Prim''s Algorithm\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 8, 'Floyd''s Algorithm & TSP & 0/1 Knapsack', '# Experiment 08: Floyd''s Algorithm, TSP & 0/1 Knapsack (DP)

## 🎯 Aim of the Experiment
To solve **All-Pairs Shortest Paths (Floyd-Warshall)**, **0/1 Knapsack**, and the **Travelling Salesman Problem** using Dynamic Programming.

## 📖 Theoretical Background & Core Principles
Dynamic programming solves complex problems by breaking them down into overlapping subproblems and storing subproblem results in a memoization table.

### Floyd-Warshall Recurrence:
$$D^{(k)}[i][j] = \min(D^{(k-1)}[i][j], D^{(k-1)}[i][k] + D^{(k-1)}[k][j])$$

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
   *Answer:* Yes, if any diagonal element $D[i][i] < 0$ after $V$ iterations, a negative weight cycle exists.', '#include <stdio.h>\n\n// TODO: Implement Floyd-Warshall, TSP, and 0/1 Knapsack\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 9, 'Subset Sum Problem', '# Experiment 09: Subset Sum Problem (Backtracking)

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
   *Answer:* A conditional test that prunes search branches when subproblem invariants or feasibility conditions are violated.', '#include <stdio.h>\n\n// TODO: Implement Subset Sum using backtracking\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2206'), 10, 'Hamiltonian Cycles', '# Experiment 10: Hamiltonian Cycles (Backtracking)

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
   *Answer:* Eulerian path visits every edge exactly once; Hamiltonian path visits every vertex exactly once. Eulerian paths can be found in $O(E)$ time, whereas Hamiltonian is NP-Complete.', '#include <stdio.h>\n\n// TODO: Implement Hamiltonian Cycle using backtracking\n\nint main() {\n    return 0;\n}')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC2207: Computer Networks Lab (Sem 4, C)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC2207'), 1, 'Data Link Layer Framing', '# Experiment 01: Data Link Layer Framing (Character & Bit Stuffing)

## 🎯 Aim of the Experiment
To implement data link layer framing techniques: **Character/Byte Stuffing** (with DLE STX/ETX) and **Bit Stuffing** (Flag `01111110`) in C to achieve frame synchronization.

## 📖 Theoretical Background & Core Principles
- **Bit Stuffing:** Whenever five consecutive `1`s appear in the data stream, the sender automatically injects an extra `0` bit to prevent confusion with the frame delimiter flag `01111110` (6 ones).
- **Byte Stuffing:** Whenever a flag byte or escape byte appears in data, an escape character (`DLE`) is prepended.

## ⚙️ Step-by-Step Procedure
1. **Bit Stuffing:**
   - Initialize counter `ones = 0`.
   - Iterate through data bits: emit bit. If bit is `1`, increment `ones`.
   - When `ones == 5`, emit stuffed `''0''`, reset `ones = 0`.
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
   *Answer:* When the receiver sees five consecutive `1`s followed by a `0`, it discards the `0` bit. If followed by a `1`, it is a frame delimiter or error.', '#include <stdio.h>\n#include <string.h>\n\n// TODO: Implement character stuffing and bit stuffing\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 2, 'CRC Code Computation', '# Experiment 02: Cyclic Redundancy Check (CRC)

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
- Time Complexity: $O(N \times K)$ where $N$ is message length and $K$ is polynomial length.

## ❓ Viva-Voce Questions with Model Answers
1. **What types of errors does CRC guarantee to detect?**
   *Answer:* All single-bit errors, all double errors (with proper polynomial), any odd number of errors, and burst errors of length up to the polynomial degree.', '#include <stdio.h>\n\n// TODO: Implement CRC computation\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 3, 'Sliding Window Protocol - Go-Back-N', '# Experiment 03: Sliding Window Protocol (Go-Back-N)

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
   *Answer:* $2^m - 1$ to prevent overlapping ambiguity between old and new sequence number spaces.', '#include <stdio.h>\n\n// TODO: Implement Sliding Window with Go-Back-N\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 4, 'Broadcast Tree', '# Experiment 04: Broadcast Tree Generation

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
   *Answer:* A router accepts a broadcast packet only if it arrived on the interface normally used for sending packets toward the source, preventing forwarding loops.', '#include <stdio.h>\n\n// TODO: Implement broadcast tree generation\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 5, 'Distance Vector Routing', '# Experiment 05: Distance Vector Routing Algorithm

## 🎯 Aim of the Experiment
To simulate the distributed **Distance Vector Routing** algorithm in C using the **Bellman-Ford equation**.

## 📖 Theoretical Background & Core Principles
Each router maintains a vector containing the shortest known distance to every destination. Periodically, routers exchange vectors with immediate neighbors:
$$D_x(y) = \min_v \{ c(x, v) + D_v(y) \}$$

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
   *Answer:* In distance vector routing, routing loops cause metric distances to increment endlessly when a link breaks, mitigated by Split Horizon and Poisoned Reverse.', '#include <stdio.h>\n\n// TODO: Implement Distance Vector Routing\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 6, 'Data Encryption & Decryption', '# Experiment 06: Data Encryption & Decryption (Ciphers)

## 🎯 Aim of the Experiment
To implement symmetric data encryption and decryption using the **Caesar Cipher** and **Substitution Cipher** in C.

## 📖 Theoretical Background & Core Principles
Cryptography ensures data confidentiality over untrusted channels. Caesar cipher shifts each letter by a key $k$:
$$C = (P + k) \bmod 26, \quad P = (C - k) \bmod 26$$

## 💡 Sample Output
```text
Plaintext:  ATTACKATDAWN
Key:        3
Ciphertext: DWWDFNDWGDZQ
Decrypted:  ATTACKATDAWN
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why is Caesar Cipher vulnerable to cryptanalysis?**
   *Answer:* It has only 26 possible keys (trivial brute-force) and preserves the natural letter frequency distribution of the English language.', '#include <stdio.h>\n#include <string.h>\n\n// TODO: Implement encryption and decryption\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 7, 'Leaky Bucket Algorithm', '# Experiment 07: Leaky Bucket Traffic Shaping

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
   *Answer:* Leaky bucket enforces a rigid constant output rate; token bucket allows idle tokens to accumulate, supporting controlled bursts.', '#include <stdio.h>\n\n// TODO: Implement Leaky Bucket Algorithm\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 8, 'Frame Sorting', '# Experiment 08: Frame Sorting at Transport Buffers

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
   *Answer:* The 32-bit Sequence Number field tracks byte offsets in the TCP stream.', '#include <stdio.h>\n\n// TODO: Implement frame sorting\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 9, 'Wireshark Packet Analysis', '# Experiment 09: Wireshark Packet Analysis

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
   *Answer:* A network card mode where all passing packets on the broadcast domain are captured and passed to the OS, rather than just packets addressed to its MAC address.', '# Wireshark Packet Analysis Report\n# Document your findings below\n\n# 1. Packets captured:\n# 2. Protocols observed:\n# 3. Filter expressions used:\n# 4. Statistics summary:'),
((SELECT id FROM subjects WHERE code='CSPC2207'), 10, 'NS2 Network Simulation', '# Experiment 10: NS2 Network Simulation

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
   *Answer:* DropTail discards newly arriving packets when queue is full; RED (Random Early Detection) drops packets probabilistically before full buffer to signal congestion.', '# NS2 Simulation Script\n# Document your TCL scripts and results\n\n# TODO: Write NS2 simulation scenarios')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC3201: Theory of Computation Laboratory (Sem 5, C)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC3201'), 1, 'Introduction to Automata Simulation', '# Experiment 01: Introduction to Automata Simulation

## 🎯 Aim of the Experiment
To understand formal language theory, familiarize with automata simulation tools (Python / JFLAP), and construct a basic Finite Automaton simulation engine.

## 💻 Apparatus & Environment
- **Environment:** Python 3.8+ / JFLAP 7.1
- **Tools:** Graphviz (optional for state diagram rendering)

## 📖 Theoretical Background & Core Principles
A **Deterministic Finite Automaton (DFA)** is a 5-tuple:
$$M = (Q, \Sigma, \delta, q_0, F)$$
- $Q$: Finite set of states.
- $\Sigma$: Finite input alphabet.
- $\delta: Q \times \Sigma \to Q$: Transition function.
- $q_0 \in Q$: Initial start state.
- $F \subseteq Q$: Set of accept/final states.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Represent the transition function as a Python nested dictionary: `delta[current_state][symbol] = next_state`.
2. Initialize `current_state = q0`.
3. For each symbol in input string $w$:
   - If symbol not in $\Sigma$, reject.
   - Update `current_state = delta[current_state][symbol]`.
4. If `current_state in F`, accept; else reject.

## 💡 Sample Test Case
```python
# Language: Strings containing substring ''ab''
states = {''q0'', ''q1'', ''q2''}
alphabet = {''a'', ''b''}
transition = {
    ''q0'': {''a'': ''q1'', ''b'': ''q0''},
    ''q1'': {''a'': ''q1'', ''b'': ''q2''},
    ''q2'': {''a'': ''q2'', ''b'': ''q2''}
}
# String ''aab'' -> Ends in q2 (Accepted)
# String ''ba''  -> Ends in q1 (Rejected)
```

## ⏱️ Complexity Analysis
- Time Complexity: $O(|w|)$ linear in string length.
- Space Complexity: $O(|Q| \times |\Sigma|)$ to store state transition table.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between a DFA and an NFA?**
   *Answer:* In a DFA, each state has exactly one transition for every symbol in $\Sigma$. In an NFA, a state can have zero, one, or multiple transitions per symbol, as well as $\epsilon$-transitions.
2. **What is an Alphabet in formal language theory?**
   *Answer:* A non-empty, finite set of symbols denoted by $\Sigma$ (e.g. $\{0, 1\}$).', '# Automata Simulation using Python\n\nclass FiniteAutomaton:\n    def __init__(self, states, alphabet, transition, start, accept):\n        self.states = states\n        self.alphabet = alphabet\n        self.transition = transition\n        self.start = start\n        self.accept = accept\n\n    def accepts(self, string):\n        # TODO: Simulate the FA on the input string\n        pass\n\n# TODO: Create a simple FA and test it'),
((SELECT id FROM subjects WHERE code='CSPC3201'), 2, 'DFA Design and Simulation', '# Experiment 02: DFA Design and Simulation

## 🎯 Aim of the Experiment
To design and simulate DFAs recognizing specific regular languages (e.g., strings ending in `01`, strings with even number of `0`s, binary multiples of 3).

## 📖 Theoretical Background & Core Principles
Designing a minimal DFA requires identifying the minimal equivalence classes of the language using the Myhill-Nerode theorem.

### Example: Strings ending in `01` over $\Sigma = \{0, 1\}$:
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
DFA: Ends in ''01''
Input ''1001'' -> Accepted
Input ''1010'' -> Rejected
Input ''01''   -> Accepted
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Dead State (Trap State)?**
   *Answer:* A non-accepting state from which there is no escape path to any accepting state regardless of subsequent input symbols.', '# DFA Simulation\n\ndef simulate_dfa(dfa, input_string):\n    """Simulate a DFA on an input string."""\n    # TODO: Implement DFA simulation\n    pass\n\n# TODO: Define and test DFAs'),
((SELECT id FROM subjects WHERE code='CSPC3201'), 3, 'NFA Design and Conversion', '# Experiment 03: NFA Design and Conversion to DFA

## 🎯 Aim of the Experiment
To construct a Non-Deterministic Finite Automaton (NFA) and implement the **Subset Construction Algorithm (Powerset Construction)** to convert it into an equivalent minimal DFA.

## 📖 Theoretical Background & Core Principles
Every NFA with $n$ states can be converted into an equivalent DFA having at most $2^n$ states. Each DFA state corresponds to a subset of NFA states reachable simultaneously.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Initial DFA state $S_0 = \{q_0\}$.
2. For each unmarked DFA state $T$:
   - Mark $T$.
   - For each input symbol $a \in \Sigma$:
     - Compute $U = \bigcup_{s \in T} \delta_{NFA}(s, a)$.
     - If $U$ is new, add $U$ as an unvisited DFA state.
     - Add transition $\delta_{DFA}(T, a) = U$.
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
   *Answer:* No, both DFAs and NFAs recognize exactly the identical class of Regular Languages (they are computationally equivalent in expressive power).', '# NFA to DFA Conversion\n\ndef nfa_to_dfa(nfa):\n    """Convert NFA to equivalent DFA using subset construction."""\n    # TODO: Implement subset construction algorithm\n    pass'),
((SELECT id FROM subjects WHERE code='CSPC3201'), 4, 'NFA with Epsilon Transitions', '# Experiment 04: NFA with Epsilon Transitions (ε-NFA)

## 🎯 Aim of the Experiment
To construct an $\epsilon$-NFA, implement the **$\epsilon$-closure** calculation, and eliminate $\epsilon$-transitions to produce an equivalent standard DFA.

## 📖 Theoretical Background & Core Principles
The $\epsilon$-closure of a state $q$, denoted $\epsilon\text{-closure}(q)$, is the set of all states reachable from $q$ by traversing zero or more $\epsilon$ (null) transitions without consuming any input symbol.

## ⚙️ Step-by-Step Algorithm & Procedure
1. Calculate $\epsilon\text{-closure}(S)$ using depth-first search (DFS) along $\epsilon$-edges.
2. Form equivalent DFA transitions:
   $$\delta''(T, a) = \epsilon\text{-closure}\left( \bigcup_{s \in T} \delta(s, a) \right)$$

## 💡 Sample Output
```text
Epsilon-closure(q0) = {q0, q1, q2}
Transition on ''a'' from closure = {q1}
DFA constructed successfully without epsilon hops.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the practical use of $\epsilon$-NFAs?**
   *Answer:* Thompson''s Construction algorithm converts Regular Expressions directly into $\epsilon$-NFAs as the first stage in lexical analyzers (like Lex/Flex).', '# Epsilon-NFA Implementation\n\ndef epsilon_closure(states, transitions):\n    """Compute epsilon closure of a set of states."""\n    # TODO: Implement epsilon closure\n    pass'),
((SELECT id FROM subjects WHERE code='CSPC3201'), 5, 'Moore and Mealy Machines', '# Experiment 05: Moore and Mealy Machines

## 🎯 Aim of the Experiment
To design and simulate Finite State Machines with output: **Moore Machine** (output depends on state) and **Mealy Machine** (output depends on state and current input), and convert between them.

## 📖 Theoretical Background & Core Principles
- **Moore Machine:** Output function $\lambda: Q \to \Delta$. Output is associated with states.
- **Mealy Machine:** Output function $\lambda: Q \times \Sigma \to \Delta$. Output is associated with transitions.
- A Mealy machine typically requires fewer states than an equivalent Moore machine.

## 💡 Sample Test Case
```text
Design: 2''s Complement Generator
Mealy Machine: 2 states (Outputs 0s until first 1, then inverts remaining bits)
Moore Machine: Requires 3 states to generate equivalent output sequence.
```

## ❓ Viva-Voce Questions with Model Answers
1. **Can a Moore machine respond immediately to input changes?**
   *Answer:* No, a Moore machine changes its output only on clock edge state transitions, whereas a Mealy machine can change output immediately when input changes asynchronously.', '# Moore and Mealy Machine Simulation\n\nclass MooreMachine:\n    # TODO: Implement Moore Machine\n    pass\n\nclass MealyMachine:\n    # TODO: Implement Mealy Machine\n    pass'),
((SELECT id FROM subjects WHERE code='CSPC3201'), 6, 'Context-Free Grammar', '# Experiment 06: Context-Free Grammar (CFG) Design

## 🎯 Aim of the Experiment
To design **Context-Free Grammars (CFGs)** for formal languages, eliminate ambiguities, and generate derivation parse trees.

## 📖 Theoretical Background & Core Principles
A CFG is a 4-tuple $G = (V, \Sigma, R, S)$:
- $V$: Non-terminals (variables).
- $\Sigma$: Terminals.
- $R$: Production rules ($A \to \alpha$ where $A \in V, \alpha \in (V \cup \Sigma)^*$).
- $S$: Start symbol.

### Example: Balanced Parentheses:
$$S \to (S) \mid SS \mid \epsilon$$

## 💡 Sample Output
```text
Input: "(())()"
Leftmost Derivation:
S => (S) => ((S)) => (())
Parse Tree generated with height 3.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is an ambiguous grammar?**
   *Answer:* A grammar that produces two or more distinct leftmost derivations (or parse trees) for the same valid string.', '# Context-Free Grammar\n\nclass CFG:\n    def __init__(self, variables, terminals, productions, start):\n        # TODO: Initialize CFG\n        pass\n\n    def parse(self, string):\n        # TODO: Parse string using CFG\n        pass'),
((SELECT id FROM subjects WHERE code='CSPC3201'), 7, 'Pushdown Automata Simulation', '# Experiment 07: Pushdown Automata Simulation (PDA)

## 🎯 Aim of the Experiment
To design and simulate a **Pushdown Automaton (PDA)** in Python that accepts non-regular context-free languages (e.g. $L = \{a^n b^n \mid n \ge 1\}$) using a stack.

## 📖 Theoretical Background & Core Principles
A PDA augments a finite state automaton with an unbounded LIFO stack memory:
$$M = (Q, \Sigma, \Gamma, \delta, q_0, Z_0, F)$$
Transitions depend on current state, input symbol, and top-of-stack symbol: $\delta(q, a, X) \to (p, \gamma)$.

## 💡 Sample Output
```text
Input: "aaabbb"
Action: Pushed 3 ''a''s onto stack with Z0.
Action: Popped ''a'' for each ''b'' encountered.
Stack top: Z0, Input exhausted.
Accepted by Final State & Empty Stack!
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between DPDA and NPDA?**
   *Answer:* Unlike finite automata, Deterministic PDAs are strictly less expressive than Non-deterministic PDAs. NPDAs recognize all Context-Free Languages, whereas DPDAs recognize only Deterministic CFLs.', '# Pushdown Automata Simulation\n\nclass PDA:\n    def __init__(self, states, input_alphabet, stack_alphabet, transitions, start, accept):\n        # TODO: Initialize PDA\n        pass\n\n    def accepts(self, string):\n        # TODO: Simulate PDA\n        pass'),
((SELECT id FROM subjects WHERE code='CSPC3201'), 8, 'Turing Machine Design', '# Experiment 08: Turing Machine Simulation

## 🎯 Aim of the Experiment
To design and execute a **Turing Machine (TM)** simulation in Python performing unary addition or binary palindrome verification.

## 📖 Theoretical Background & Core Principles
A Turing Machine is the fundamental mathematical model of modern universal computation, consisting of an infinite two-way tape, a read/write head, and a state register:
$$\delta: Q \times \Gamma \to Q \times \Gamma \times \{L, R\}$$

## 💡 Sample Output
```text
Unary Addition: Tape "111+11" -> Head scans, replaces ''+'' with ''1'', erases trailing ''1''
Final Tape: "11111" (3 + 2 = 5)
State: q_halt (Computation finished)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the Church-Turing Thesis?**
   *Answer:* The hypothesis that any algorithm that can be computed by any physical computer or human can also be computed by a Turing Machine.
2. **What is the Halting Problem?**
   *Answer:* The undecidable problem of determining whether an arbitrary program and input will eventually finish running or run forever (proven undecidable by Alan Turing in 1936).', '# Turing Machine Simulation\n\nclass TuringMachine:\n    def __init__(self, states, alphabet, tape_alphabet, transitions, start, accept, reject):\n        # TODO: Initialize Turing Machine\n        pass\n\n    def run(self, input_string):\n        # TODO: Simulate Turing Machine\n        pass')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC3202: Operating Systems Laboratory (Sem 5, C)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC3202'), 1, 'OS Installation', '# Experiment 01: OS Installation & Virtualization

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
   *Answer:* A dedicated disk region used by the kernel memory manager as virtual memory when physical RAM is exhausted.', '# OS Installation Report\n# Document your installation steps\n\n# 1. OS Selected:\n# 2. Partitioning scheme:\n# 3. Installation steps:\n# 4. Post-installation configuration:'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 2, 'Linux Administrative Commands', '# Experiment 02: Linux Administrative Commands

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
   *Answer:* `SIGTERM` requests graceful shutdown allowing processes to clean up resources; `SIGKILL` immediately terminates the process at kernel level without handler execution.', '#!/bin/bash\n# Linux Administrative Commands Practice\n\n# File Management\necho "--- File Management ---"\n# TODO: Demonstrate file commands\n\n# Process Management\necho "--- Process Management ---"\n# TODO: Demonstrate process commands'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 3, 'Shell Programming', '# Experiment 03: UNIX Shell Programming

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
   *Answer:* It directs the program loader to use `/bin/bash` as the interpreter to parse and execute the script contents.', '#!/bin/bash\n# Shell Programming Examples\n\n# TODO: Variables and arithmetic\n# TODO: Conditional statements\n# TODO: Loops\n# TODO: Functions'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 4, 'Process Management System Calls', '# Experiment 04: Process Management System Calls (fork, exec, wait)

## 🎯 Aim of the Experiment
To write C programs demonstrating process creation, parent-child process synchronization, and program replacement using UNIX system calls: `fork()`, `execvp()`, and `wait()`.

## 📖 Theoretical Background & Core Principles
- `fork()` clones the calling process: returns `0` to the child and child''s PID to parent.
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
        printf("Child Process: PID=%d, Parent PID=%d\n", getpid(), getppid());
    } else {
        wait(NULL);
        printf("Parent Process: PID=%d, Child finished.\n", getpid());
    }
    return 0;
}
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Zombie process vs Orphan process?**
   *Answer:* An orphan''s parent died before it; it is adopted by `systemd` (PID 1). A zombie has finished execution but remains in the process table because its parent hasn''t yet called `wait()`.', '#include <stdio.h>\n#include <unistd.h>\n#include <sys/wait.h>\n\nint main() {\n    pid_t pid = fork();\n    \n    if (pid < 0) {\n        printf("Fork failed\\n");\n    } else if (pid == 0) {\n        // Child process\n        printf("Child PID: %d\\n", getpid());\n    } else {\n        // Parent process\n        wait(NULL);\n        printf("Parent PID: %d\\n", getpid());\n    }\n    \n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 5, 'Dining Philosophers Problem', '# Experiment 05: Dining Philosophers Synchronization Problem

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
   *Answer:* Mutual Exclusion, Hold and Wait, No Preemption, and Circular Wait.', '#include <stdio.h>\n#include <pthread.h>\n#include <semaphore.h>\n\n#define N 5\n\n// TODO: Implement Dining Philosophers\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 6, 'CPU Scheduling Algorithms', '# Experiment 06: CPU Scheduling Algorithms (FCFS, SJF, RR)

## 🎯 Aim of the Experiment
To simulate CPU scheduling algorithms in C: **First-Come First-Served (FCFS)**, **Shortest Job First (SJF)**, and **Round Robin (RR)**, and compute average Waiting Time (WT) and Turnaround Time (TAT).

## 📖 Theoretical Background & Core Principles
- **Turnaround Time (TAT):** $\text{Completion Time} - \text{Arrival Time}$.
- **Waiting Time (WT):** $\text{Turnaround Time} - \text{Burst Time}$.
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
   *Answer:* When short CPU-burst processes queue up behind a long CPU-burst process, dramatically increasing average waiting time.', '#include <stdio.h>\n\n// TODO: Implement FCFS, RR, SJF scheduling\n\nvoid fcfs(int processes[], int n, int burst[]) {\n    // TODO\n}\n\nvoid roundRobin(int processes[], int n, int burst[], int quantum) {\n    // TODO\n}\n\nvoid sjf(int processes[], int n, int burst[]) {\n    // TODO\n}\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 7, 'Banker''s Algorithm', '# Experiment 07: Banker''s Deadlock Avoidance Algorithm

## 🎯 Aim of the Experiment
To implement **Banker''s Algorithm** for deadlock avoidance, evaluating the safety state of the system and calculating a valid safe execution sequence.

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
- Time Complexity: $O(R \times P^2)$ where $P$ is process count and $R$ is resource types.

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Deadlock Prevention and Deadlock Avoidance?**
   *Answer:* Prevention eliminates one of Coffman''s conditions statically; Avoidance dynamically inspects resource allocation requests to ensure the system never enters an unsafe state.', '#include <stdio.h>\n\n#define P 5\n#define R 3\n\n// TODO: Implement Banker''s Algorithm\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 8, 'Page Replacement Algorithms', '# Experiment 08: Page Replacement Algorithms (FIFO, LRU, Optimal)

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
1. **What is Belady''s Anomaly?**
   *Answer:* The counter-intuitive phenomenon where increasing the number of physical frames increases the total number of page faults (occurs in FIFO, but never in stack-based algorithms like LRU).', '#include <stdio.h>\n\n// TODO: Implement FIFO, LRU, Optimal page replacement\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 9, 'Threading', '# Experiment 09: POSIX Threading (Pthreads)

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
   *Answer:* An undesirable situation where multiple threads read and write shared data concurrently, and the final outcome depends on uncontrollable thread scheduling order.', '#include <stdio.h>\n#include <pthread.h>\n\nvoid* threadFunc(void* arg) {\n    // TODO: Thread function\n    return NULL;\n}\n\nint main() {\n    pthread_t threads[5];\n    // TODO: Create and join threads\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 10, 'Paging Scheme', '# Experiment 10: Paging Memory Management Scheme

## 🎯 Aim of the Experiment
To simulate the hardware Paging scheme in C, translating logical addresses (Page Number + Page Offset) to physical addresses (Frame Number + Frame Offset) via a simulated Page Table.

## 📖 Theoretical Background & Core Principles
- Logical Address size = $m$ bits; Page Size = $2^p$ bytes.
- Page Number $p = \text{address} / \text{PageSize}$.
- Offset $d = \text{address} \bmod \text{PageSize}$.
- Physical Address = $(\text{FrameNumber} \times \text{PageSize}) + d$.

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
   *Answer:* A high-speed associative hardware cache that stores recent page-to-frame mappings to avoid two memory lookups per memory access.', '#include <stdio.h>\n\n// TODO: Implement paging scheme\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 11, 'Memory Allocation Methods', '# Experiment 11: Contiguous Memory Allocation (First, Best, Worst Fit)

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
   *Answer:* Internal is wasted space inside an allocated block (fixed partitioning); External is free space scattered across memory in blocks too small to satisfy requests.', '#include <stdio.h>\n\n// TODO: Implement First Fit, Worst Fit, Best Fit\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3202'), 12, 'Android Mobile Application', '# Experiment 12: Android Mobile Application Architecture

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
   *Answer:* An asynchronous messaging object used to request an action from another app component (Explicit Intent specifies target class; Implicit Intent specifies action filter).', '// Android Activity Example\nimport android.os.Bundle;\nimport android.app.Activity;\n\npublic class MainActivity extends Activity {\n    @Override\n    protected void onCreate(Bundle savedInstanceState) {\n        super.onCreate(savedInstanceState);\n        // TODO: Set up UI\n    }\n}')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC3203: Machine Learning Laboratory (Sem 5, PYTHON)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC3203'), 1, 'Python Setup and Basics', '# Experiment 01: Python Scientific Environment Setup

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
   *Answer:* Clean readable syntax, rich scientific ecosystem (NumPy, Scikit-Learn, PyTorch), and seamless C/C++ backend bindings for high-performance tensor computing.', '# Python Basics\n\n# Loops\nfor i in range(10):\n    print(i)\n\n# Functions\ndef factorial(n):\n    # TODO: Implement factorial\n    pass\n\n# TODO: More exercises'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 2, 'ML Libraries Introduction', '# Experiment 02: Introduction to ML Libraries (NumPy, Pandas, Matplotlib)

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
    ''Feature_A'': np.random.normal(0, 1, 100),
    ''Feature_B'': np.random.normal(5, 2, 100)
})
print(df.describe())
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is broadcasting in NumPy?**
   *Answer:* The mechanism that allows arithmetic operations between arrays of differing shapes by virtually stretching the smaller array to match the larger dimensions.', 'import numpy as np\nimport matplotlib.pyplot as plt\nimport pandas as pd\n\n# NumPy\narr = np.array([1, 2, 3, 4, 5])\nprint("Array:", arr)\n\n# TODO: Matrix operations\n# TODO: Create plots\n# TODO: Load a dataset'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 3, 'NumPy Operations', '# Experiment 03: NumPy Linear Algebra & Matrix Operations

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
print("Eigenvectors:\n", eigenvectors)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is an eigenvector?**
   *Answer:* A non-zero vector whose direction does not change when a linear transformation is applied, scaling only by a scalar factor known as the eigenvalue ($A v = \lambda v$).', 'import numpy as np\n\n# TODO: Create matrices\n# TODO: Matrix operations\n# TODO: Advanced NumPy operations'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 4, 'Statistical Measures', '# Experiment 04: Statistical Measures (Mean, Median, Mode, Variance, StdDev)

## 🎯 Aim of the Experiment
To compute descriptive statistical measures (Central Tendency and Dispersion) manually from mathematical formulas and compare them with `scipy.stats`.

## 📖 Theoretical Background & Core Principles
- **Mean:** $\bar{x} = \frac{1}{n} \sum x_i$
- **Variance:** $\sigma^2 = \frac{1}{n-1} \sum (x_i - \bar{x})^2$
- **Standard Deviation:** $\sigma = \sqrt{\sigma^2}$

## 💡 Sample Output
```text
Dataset: [12, 15, 18, 22, 25, 30, 35, 18, 22, 22]
Mean: 21.90 | Median: 22.00 | Mode: 22
Variance: 48.77 | Standard Deviation: 6.98
```

## ❓ Viva-Voce Questions with Model Answers
1. **When is Median preferred over Mean?**
   *Answer:* When the dataset contains extreme outliers or is heavily skewed, as the median is a robust statistic unaffected by extreme values.', 'import numpy as np\nfrom scipy import stats\n\ndata = [12, 15, 18, 22, 25, 30, 35, 18, 22, 22]\n\n# TODO: Calculate mean, median, mode, variance, std deviation'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 5, 'ML Libraries Overview', '# Experiment 05: Machine Learning Frameworks Overview (Scikit-Learn)

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
    (''scaler'', StandardScaler()),
    (''clf'', LogisticRegression())
])
# pipe.fit(X_train, y_train)
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why must data be split into training and test sets?**
   *Answer:* To evaluate model generalization on unseen data and prevent overfitting.', 'from sklearn import datasets\nfrom sklearn.model_selection import train_test_split\n\n# Load dataset\niris = datasets.load_iris()\nX, y = iris.data, iris.target\n\n# TODO: Split data, train model, evaluate'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 6, 'Linear Regression', '# Experiment 06: Linear Regression

## 🎯 Aim of the Experiment
To implement **Simple and Multiple Linear Regression**, derive the Ordinary Least Squares (OLS) normal equation, train using gradient descent, and evaluate with $R^2$ score and RMSE.

## 📖 Theoretical Background & Core Principles
Linear regression models linear relationship between input $X$ and continuous target $y$:
$$\hat{y} = w^T X + b$$
Cost Function: Mean Squared Error (MSE):
$$J(w) = \frac{1}{2m} \sum_{i=1}^m (\hat{y}^{(i)} - y^{(i)})^2$$

## 💡 Sample Benchmark
```text
Trained Model: y = 2.45 * x + 5.12
Mean Squared Error (MSE): 0.842
R-squared (R2) Score: 0.941 (94.1% variance explained)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is multicollinearity in multiple regression?**
   *Answer:* When two or more predictor features are highly correlated, leading to unstable coefficient estimates and inflated standard errors.', 'from sklearn.linear_model import LinearRegression\nfrom sklearn.model_selection import train_test_split\nimport numpy as np\nimport matplotlib.pyplot as plt\n\n# TODO: Implement Linear Regression'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 7, 'Logistic Regression', '# Experiment 07: Logistic Regression for Binary Classification

## 🎯 Aim of the Experiment
To implement **Logistic Regression** using the Sigmoid activation function, cross-entropy loss, and evaluate performance using Confusion Matrix, Accuracy, Precision, Recall, and ROC-AUC.

## 📖 Theoretical Background & Core Principles
Logistic regression maps continuous linear combination to probability space $[0, 1]$ via the Sigmoid function:
$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

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
   *Answer:* Because plugging the non-linear Sigmoid into MSE yields a non-convex function with numerous local minima, preventing guaranteed gradient descent convergence.', 'from sklearn.linear_model import LogisticRegression\nfrom sklearn.metrics import classification_report\n\n# TODO: Implement Logistic Regression'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 8, 'K-Nearest Neighbours', '# Experiment 08: K-Nearest Neighbours (KNN)

## 🎯 Aim of the Experiment
To implement the **K-Nearest Neighbours (KNN)** non-parametric classification algorithm using Euclidean distance and study the impact of hyperparameter $k$.

## 📖 Theoretical Background & Core Principles
KNN is a lazy learning instance-based algorithm that assigns the class dominating the $k$ closest training points in feature space:
$$d(x, y) = \sqrt{\sum_{i=1}^n (x_i - y_i)^2}$$

## 💡 Sample Test Case
```text
Iris Dataset (k=3):
Testing Sample [5.1, 3.5, 1.4, 0.2]
Nearest Neighbours: 3 Setosa samples
Predicted Class: Iris-Setosa (Confidence: 100%)
```

## ⏱️ Complexity Analysis
- Training Time: $O(1)$
- Prediction Time: $O(N \times D)$ per query (high inference cost).

## ❓ Viva-Voce Questions with Model Answers
1. **Why is feature scaling essential before applying KNN?**
   *Answer:* Because features with larger numeric magnitudes will disproportionately dominate distance calculations, distorting neighbor selection.', 'from sklearn.neighbors import KNeighborsClassifier\n\n# TODO: Implement KNN'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 9, 'Decision Tree', '# Experiment 09: Decision Tree Classifier

## 🎯 Aim of the Experiment
To implement the **Decision Tree Classifier** (CART algorithm) using **Gini Impurity** and **Information Gain (Entropy)**, and prune tree depth to avoid overfitting.

## 📖 Theoretical Background & Core Principles
A decision tree recursively splits feature space to maximize purity.
- **Gini Impurity:** $I_G(p) = 1 - \sum_{i=1}^C p_i^2$
- **Information Gain:** $IG(T, a) = H(T) - H(T \mid a)$

## 💡 Sample Output
```text
Decision Tree generated with max_depth=3.
Root Split: petal_length <= 2.45 (Gini = 0.66)
Training Accuracy: 98.2%, Test Accuracy: 96.0%
```

## ❓ Viva-Voce Questions with Model Answers
1. **How does pre-pruning differ from post-pruning?**
   *Answer:* Pre-pruning stops tree growth early based on criteria like `max_depth` or `min_samples_split`; post-pruning builds a full tree and trims branches based on validation error.', 'from sklearn.tree import DecisionTreeClassifier\n\n# TODO: Implement Decision Tree'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 10, 'Random Forest', '# Experiment 10: Random Forest Ensemble

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
   *Answer:* The validation error calculated on samples left out of the bootstrap sample (~36.8% of data per tree), providing an unbiased performance metric without cross-validation.', 'from sklearn.ensemble import RandomForestClassifier\n\n# TODO: Implement Random Forest'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 11, 'Support Vector Machine', '# Experiment 11: Support Vector Machine (SVM)

## 🎯 Aim of the Experiment
To implement **Support Vector Machines (SVM)** for linear and non-linear classification using kernel functions (Linear, RBF, Polynomial).

## 📖 Theoretical Background & Core Principles
SVM finds the maximum-margin hyperplane separating two classes:
$$\max \frac{2}{\|w\|} \quad \text{subject to } y_i(w^T x_i + b) \ge 1$$
The **Kernel Trick** maps inputs into high-dimensional Hilbert spaces without explicitly computing high-dimensional coordinates.

## 💡 Sample Output
```text
SVM with RBF Kernel (C=1.0, gamma=''scale'')
Number of Support Vectors: 42
Test Classification Accuracy: 97.5%
```

## ❓ Viva-Voce Questions with Model Answers
1. **What role do support vectors play in the final model?**
   *Answer:* Only the data points that lie directly on or inside the margin boundaries (support vectors) determine the orientation and position of the separating hyperplane.', 'from sklearn.svm import SVC\n\n# TODO: Implement SVM'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 12, 'Principal Component Analysis', '# Experiment 12: Principal Component Analysis (PCA)

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
   *Answer:* Because PCA seeks eigenvectors of the covariance matrix; without mean-centering, the first component would point toward the mean of the data rather than maximum variance.', 'from sklearn.decomposition import PCA\nimport matplotlib.pyplot as plt\n\n# TODO: Implement PCA'),
((SELECT id FROM subjects WHERE code='CSPC3203'), 13, 'K-Means Clustering', '# Experiment 13: K-Means Clustering

## 🎯 Aim of the Experiment
To implement the **K-Means Clustering** unsupervised algorithm, evaluate cluster centroids, and determine the optimal cluster count $k$ using the **Elbow Method** and **Silhouette Score**.

## 📖 Theoretical Background & Core Principles
K-Means partitions $n$ observations into $k$ clusters by minimizing the Within-Cluster Sum of Squares (WCSS / Inertia):
$$J = \sum_{i=1}^k \sum_{x \in S_i} \|x - \mu_i\|^2$$

## 💡 Sample Output
```text
Elbow analysis evaluated for k=1 to 8:
Optimal elbow point detected at k = 3.
Silhouette Score at k=3: 0.552 (Strong cluster cohesion)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between K-Means and K-Means++?**
   *Answer:* Standard K-Means picks initial centroids randomly (vulnerable to poor local minima); K-Means++ selects initial centroids with probability proportional to squared distance from existing centroids, ensuring well-dispersed starts.', 'from sklearn.cluster import KMeans\nimport matplotlib.pyplot as plt\n\n# TODO: Implement K-Means Clustering')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC3204: Compiler Design Laboratory (Sem 6, C)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC3204'), 1, 'Lexical Analyzer using LEX', '# Experiment 01: Lexical Analyzer using LEX / C

## 🎯 Aim of the Experiment
To design and implement a **Lexical Analyzer (Scanner)** using **LEX** (or in C) to tokenize source programs into streams of tokens, identifying keywords, identifiers, constants, and operators while eliminating comments and whitespace.

## 💻 Apparatus & Environment
- **Tools:** Flex / Lex, GCC Compiler
- **Language:** C / Lex specification (`.l`)

## 📖 Theoretical Background & Core Principles
Lexical Analysis is Phase 1 of compiler construction. It transforms an input character stream into a sequence of meaningful lexical tokens: `<token_name, attribute_value>`.

```
Source Code Stream ---> [ Lexical Analyzer (LEX) ] ---> Token Stream ---> Syntax Analyzer
                             |
                             v
                       Symbol Table
```

## ⚙️ Step-by-Step Procedure
1. Define token regular expressions in LEX format:
   - Identifiers: `[a-zA-Z_][a-zA-Z0-9_]*`
   - Numbers: `[0-9]+(\.[0-9]+)?`
   - Operators: `[+\-*/=<>]`
2. Define actions: insert identifiers into the symbol table, ignore comments (`/\* ... \*/`).
3. Compile with `lex lexer.l`, then `gcc lex.yy.c -o lexer -lfl`.

## 💡 Sample Test Case
```text
Input Code:
int total = count + 45;

Output Tokens:
<KEYWORD, "int">
<IDENTIFIER, "total">
<ASSIGN_OP, "=">
<IDENTIFIER, "count">
<ARITH_OP, "+">
<INTEGER_CONST, 45>
<SEMICOLON, ";">
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between a Token, Lexeme, and Pattern?**
   *Answer:* A Pattern is the description rule (regular expression); a Lexeme is the actual character sequence in the source code (e.g. `total`); a Token is the abstract category classification (e.g. `IDENTIFIER`).', '#include <stdio.h>\n#include <string.h>\n#include <ctype.h>\n\n// Simple Lexical Analyzer in C\nchar *keywords[] = {"int", "float", "char", "if", "else", "while", "for", "return"};\nint numKeywords = 8;\n\nint isKeyword(char *word) {\n    for(int i = 0; i < numKeywords; i++)\n        if(strcmp(word, keywords[i]) == 0)\n            return 1;\n    return 0;\n}\n\n// TODO: Complete the lexical analyzer\n\nint main() {\n    // TODO: Read input and tokenize\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 2, 'Syntax Analyzer using YACC', '# Experiment 02: Syntax Analyzer using YACC

## 🎯 Aim of the Experiment
To construct a **Syntax Analyzer (Parser)** using **YACC (Yet Another Compiler-Compiler)** to validate arithmetic expressions and control structures according to a Context-Free Grammar.

## 📖 Theoretical Background & Core Principles
Syntax analysis checks whether the token stream generated by the lexical analyzer conforms to the grammatical rules of the programming language, constructing a parse tree or abstract syntax tree (AST).

## ⚙️ Step-by-Step Procedure
1. Specify grammar rules in YACC file `parser.y`.
2. Define operator precedence and associativity: `%left ''+'' ''-''`, `%left ''*'' ''/''`.
3. Link LEX scanner (`yylex()`) with YACC parser (`yyparse()`).
4. Handle syntax errors using `yyerror()`.

## 💡 Sample Output
```text
Expression: 3 + 5 * (10 - 2)
Result: Valid Syntax! Arithmetic Expression recognized successfully.

Expression: 3 + * 5
Result: Syntax Error: Unexpected operator ''*'' at line 1.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between top-down and bottom-up parsing?**
   *Answer:* Top-down starts at the start symbol and tries to derive the string; bottom-up starts with the input string and reduces it back to the start symbol using handles.', '#include <stdio.h>\n#include <stdlib.h>\n#include <ctype.h>\n\n// Recursive Descent Parser for arithmetic expressions\n// Grammar: E -> T ((+|-) T)*\n//          T -> F ((*|/) F)*\n//          F -> (E) | number\n\nchar *input;\nint pos = 0;\n\n// TODO: Implement parser functions\n\nint main() {\n    // TODO: Read and parse expression\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 3, 'Left Recursion and Left Factoring', '# Experiment 03: Elimination of Left Recursion and Left Factoring

## 🎯 Aim of the Experiment
To transform context-free grammars by eliminating **Immediate Left Recursion** and applying **Left Factoring** to make them suitable for top-down predictive parsers.

## 📖 Theoretical Background & Core Principles
- **Left Recursion:** Productions of form $A \to A\alpha \mid \beta$ cause top-down recursive descent parsers to loop infinitely.
  - Transformation: $A \to \beta A''$, $A'' \to \alpha A'' \mid \epsilon$.
- **Left Factoring:** Productions with shared prefix $A \to \alpha\beta_1 \mid \alpha\beta_2$.
  - Transformation: $A \to \alpha A''$, $A'' \to \beta_1 \mid \beta_2$.

## 💡 Sample Test Case
```text
Original Grammar:
E -> E + T | T

Transformed Grammar (Left Recursion Eliminated):
E  -> T E''
E'' -> + T E'' | epsilon
```

## ❓ Viva-Voce Questions with Model Answers
1. **Why can''t an LL(1) parser handle left-recursive grammars?**
   *Answer:* Because the parser looks at the current non-terminal and expands it into the same non-terminal repeatedly without consuming any input symbol, resulting in an infinite recursion stack overflow.', '#include <stdio.h>\n#include <string.h>\n\n// TODO: Implement left recursion removal\n// TODO: Implement left factoring\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 4, 'Predictive Parser (LL(1))', '# Experiment 04: Predictive Parser (LL(1) Parser Table)

## 🎯 Aim of the Experiment
To compute the **FIRST** and **FOLLOW** sets for a grammar, construct an **LL(1) Parsing Table**, and simulate string parsing using a parser stack.

## 📖 Theoretical Background & Core Principles
- **FIRST($\alpha$):** Set of terminals that begin strings derived from $\alpha$.
- **FOLLOW($A$):** Set of terminals that can appear immediately to the right of non-terminal $A$ in some sentential form.
- A grammar is LL(1) if and only if no cell in its parsing table contains multiple entries.

## 💡 Sample Parsing Table Entry
```text
FIRST(E)  = { (, id }
FOLLOW(E) = { $, ) }

Parsing Table M[E, id]: E -> T E''
Parsing Table M[E, ( ]:  E -> T E''
No conflicting entries -> Grammar is verified LL(1)!
```

## ❓ Viva-Voce Questions with Model Answers
1. **What does LL(1) stand for?**
   *Answer:* Left-to-right scanning, Leftmost derivation, with 1 lookahead token.', '#include <stdio.h>\n\n// TODO: Implement LL(1) parser\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 5, 'Shift-Reduce Parser', '# Experiment 05: Shift-Reduce Bottom-Up Parser

## 🎯 Aim of the Experiment
To simulate a **Shift-Reduce Parser** in C, maintaining an operator stack and input buffer while demonstrating shift actions, reduce actions, handle identification, and accept states.

## 📖 Theoretical Background & Core Principles
Shift-reduce parsing operates by:
1. **Shift:** Push the current input symbol onto the parser stack.
2. **Reduce:** Replace a substring matching a production right-hand side (a handle) with the corresponding non-terminal.
3. **Accept:** Stack contains only start symbol and input is empty.

## 💡 Sample Parse Trace
```text
Stack          | Input Buffer | Action
---------------+--------------+-------
$              | id + id $    | Shift
$ id           | + id $       | Reduce by E -> id
$ E            | + id $       | Shift
$ E +          | id $         | Shift
$ E + id       | $            | Reduce by E -> id
$ E + E        | $            | Reduce by E -> E + E
$ E            | $            | ACCEPT
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Shift/Reduce conflict?**
   *Answer:* A situation in bottom-up parsing where the parser cannot decide whether to shift the next input symbol or reduce the current handle on the stack (e.g. the "dangling else" ambiguity).', '#include <stdio.h>\n#include <string.h>\n\n// TODO: Implement Shift-Reduce Parser\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 6, 'Syntax Directed Translation & AST', '# Experiment 06: Syntax Directed Translation (SDT) & AST Construction

## 🎯 Aim of the Experiment
To implement **Syntax Directed Translation (SDT)** with semantic actions and construct an **Abstract Syntax Tree (AST)** for expressions.

## 📖 Theoretical Background & Core Principles
SDT augments context-free grammar productions with semantic rules and attribute evaluations:
- **Synthesized Attributes:** Computed from children nodes in the parse tree.
- **Inherited Attributes:** Computed from parent or sibling nodes.

## 💡 Sample AST Output
```text
Input: a * (b + c)
AST Hierarchy:
      [*]
     /   \
   [a]   [+]
        /   \
      [b]   [c]
```

## ❓ Viva-Voce Questions with Model Answers
1. **How does an Abstract Syntax Tree (AST) differ from a Parse Tree?**
   *Answer:* A Parse Tree contains all grammatical details (including punctuation, parentheses, and intermediate non-terminals); an AST abstracts away non-essential syntax and retains only computational operators and operands.', '#include <stdio.h>\n#include <stdlib.h>\n\n// AST Node\ntypedef struct ASTNode {\n    char op;\n    int value;\n    struct ASTNode *left, *right;\n} ASTNode;\n\n// TODO: Build and traverse AST\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 7, 'Intermediate Code Generation', '# Experiment 07: Intermediate Code Generation (Three-Address Code)

## 🎯 Aim of the Experiment
To implement an **Intermediate Code Generator** producing **Three-Address Code (TAC)** representations (Quadruples, Triples, and Indirect Triples).

## 📖 Theoretical Background & Core Principles
Three-Address Code is an intermediate representation where each instruction has at most one operator on the right-hand side, decomposing complex expressions into atomic assignments:
$$x = y \text{ op } z$$

## 💡 Sample Generated Code
```text
Expression: x = -a * (b + c) - d
Three-Address Code (TAC):
t1 = -a
t2 = b + c
t3 = t1 * t2
t4 = t3 - d
x = t4
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Quadruple in compiler intermediate code?**
   *Answer:* A record structure with four fields: `op`, `arg1`, `arg2`, and `result`.', '#include <stdio.h>\n\n// TODO: Implement three-address code generation\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 8, 'Symbol Table', '# Experiment 08: Symbol Table Management

## 🎯 Aim of the Experiment
To design and implement a **Symbol Table** data structure using a Hash Table with chaining to support fast variable insertions, attribute lookups, and block scope management.

## 📖 Theoretical Background & Core Principles
The Symbol Table stores identifier metadata throughout all compilation phases: identifier name, data type, storage size, scope level, memory offset, and line number.

## 💡 Sample Interactive Session
```text
Action: Insert ''count'' (type: int, scope: 0, addr: 0x1000) -> Added
Action: Insert ''factor'' (type: float, scope: 1, addr: 0x1004) -> Added
Action: Lookup ''count'' -> Found: Type=int, Scope=0
Action: Exit Scope 1 -> Purged symbols at scope level 1.
```

## ⏱️ Complexity Analysis
- Average Insertion/Lookup: $O(1)$ with hash table.

## ❓ Viva-Voce Questions with Model Answers
1. **How does a compiler handle nested lexical scopes in the symbol table?**
   *Answer:* Using a stack of symbol tables or a tree of hashtables where lookups search from the current innermost scope outward to the global scope.', '#include <stdio.h>\n#include <string.h>\n\n#define MAX 100\n\ntypedef struct {\n    char name[50];\n    char type[20];\n    int scope;\n} Symbol;\n\nSymbol symbolTable[MAX];\nint count = 0;\n\n// TODO: Implement insert, lookup, display\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 9, 'Type Checking and Conversion', '# Experiment 09: Type Checking and Semantic Analysis

## 🎯 Aim of the Experiment
To implement a **Type Checker** in C that enforces static typing rules, checks operand compatibility, performs implicit type coercion, and detects semantic type errors.

## 📖 Theoretical Background & Core Principles
Semantic analysis ensures programs conform to language semantics that cannot be verified by context-free syntax alone. Type systems define rules for valid operations (e.g., cannot index an integer or add string to float without coercion).

## 💡 Sample Output
```text
Statement: int a = 10; float b = a + 3.14;
Action: Implicit coercion applied: int ''a'' widened to float. Type match: OK.

Statement: int *p; a = p + 5;
Error: Type mismatch: Cannot assign pointer arithmetic result to integer variable ''a''.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Static and Dynamic Type Checking?**
   *Answer:* Static checking occurs at compile time before execution (C, Java); Dynamic checking occurs at runtime during program execution (Python, JavaScript).', '#include <stdio.h>\n\n// TODO: Implement type checking and conversion\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 10, 'Code Optimization', '# Experiment 10: Machine-Independent Code Optimization

## 🎯 Aim of the Experiment
To implement basic code optimization techniques: **Constant Folding**, **Constant Propagation**, **Dead Code Elimination**, and **Common Subexpression Elimination (CSE)**.

## 📖 Theoretical Background & Core Principles
Optimizations transform code to execute faster or consume less memory while preserving semantics.
- Constant Folding: Evaluate compile-time constant operations ($x = 2 \times 3.1415 \to x = 6.283$).
- Dead Code Elimination: Remove statements whose computed values are never read.

## 💡 Sample Code Transformation
```text
Before Optimization:
x = 3 + 5;
y = x * 2;
if (0) { z = 100; }  // Dead code

After Optimization:
x = 8;
y = 16;
// Dead block eliminated!
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is Common Subexpression Elimination (CSE)?**
   *Answer:* An optimization that identifies expressions that were previously evaluated and replaces redundant recomputations with the saved prior result.', '#include <stdio.h>\n\n// TODO: Implement code optimization techniques\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 11, 'Runtime Environment Simulation', '# Experiment 11: Runtime Environment & Activation Records

## 🎯 Aim of the Experiment
To simulate a procedural **Runtime Stack** and **Activation Record (Stack Frame)** managing local variables, parameters, return addresses, control links, and access links.

## 📖 Theoretical Background & Core Principles
An activation record represents execution context for a function call:
- **Return Value / Return Address**
- **Control Link (Dynamic Link):** Points to caller''s stack frame.
- **Access Link (Static Link):** Points to enclosing lexical scope.
- **Local Data & Saved Machine Registers**

## 💡 Sample Stack Trace
```text
Function main() invoked -> Frame allocated [SP: 0x7FFF00]
main() calls factorial(3) -> Frame allocated [SP: 0x7FFE80]
factorial(3) calls factorial(2) -> Frame allocated [SP: 0x7FFE00]
Return: Stack frames popped in LIFO sequence.
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between the runtime Stack and Heap?**
   *Answer:* Stack allocates activation records automatically with function call/return in LIFO order; Heap allocates dynamically requested memory (`malloc`/`new`) with arbitrary lifetimes.', '#include <stdio.h>\n\n// TODO: Simulate runtime environment\n\nint main() {\n    return 0;\n}'),
((SELECT id FROM subjects WHERE code='CSPC3204'), 12, 'Mini Compiler Project', '# Experiment 12: Mini Compiler Pipeline Integration

## 🎯 Aim of the Experiment
To integrate all phases of a compiler (Lexer, Parser, AST, Intermediate Code Generator) for a simple expression-based mini language into an end-to-end executable pipeline.

## 📖 Theoretical Background & Core Principles
The compiler front-end pipeline connects lexical analysis, syntax parsing, semantic verification, and intermediate three-address code synthesis into a unified system.

## 💡 Sample Execution
```text
Input Mini-Program:
let radius = 5;
let area = 3.14 * radius * radius;

Generated Assembly / TAC:
MOV R1, 5
STORE radius, R1
MOV R2, 3.14
MUL R3, R2, radius
MUL R4, R3, radius
STORE area, R4
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between a Compiler and an Interpreter?**
   *Answer:* A compiler translates the entire source program into target machine code prior to execution; an interpreter translates and executes instructions line-by-line at runtime.', '#include <stdio.h>\n\n// Mini Compiler - Integration of all phases\n// TODO: Implement a complete simple compiler\n\nint main() {\n    return 0;\n}')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;

-- ============================================================
-- CSPC3205: Software Engineering Laboratory (Sem 6, PYTHON)
-- ============================================================
INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES
((SELECT id FROM subjects WHERE code='CSPC3205'), 1, 'Process Model Analysis', '# Experiment 01: Software Process Model Analysis

## 🎯 Aim of the Experiment
To analyze and compare Software Development Life Cycle (SDLC) process models: **Waterfall**, **Prototyping**, **Spiral**, **Agile/Scrum**, and **V-Model**, and select the optimal model for a given software scenario.

## 📖 Theoretical Background & Core Principles
A software process model is a structured framework of development stages: Requirements, Design, Implementation, Testing, Deployment, and Maintenance.

### Model Comparison Matrix:
| Model | Flexibility | Risk Management | Client Involvement | Best Suited For |
|---|---|---|---|---|
| **Waterfall** | Low | Low | At start only | Stable, well-defined requirements |
| **Spiral** | Medium | Very High | Milestone reviews | High-risk, complex projects |
| **Agile/Scrum**| Very High| High | Continuous per sprint | Dynamic, evolving market products |
| **V-Model** | Low | High | Verification focused | Mission-critical safety systems |

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Scrum Sprint?**
   *Answer:* A timeboxed iteration (typically 1 to 4 weeks) during which a development team creates a potentially releasable product increment.', '# Software Process Model Analysis\n\n# Project: [Describe your project]\n\n# 1. Waterfall Model\n# Applicability:\n# Pros:\n# Cons:\n\n# 2. Agile Model\n# Applicability:\n# Pros:\n# Cons:\n\n# Recommendation: [Your choice and justification]'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 2, 'Work Breakdown Structure', '# Experiment 02: Work Breakdown Structure (WBS) & Effort Estimation

## 🎯 Aim of the Experiment
To develop a **Work Breakdown Structure (WBS)** for a software engineering project and estimate project effort and duration using the **COCOMO (Constructive Cost Model)**.

## 📖 Theoretical Background & Core Principles
- **WBS:** Hierarchical decomposition of the total project scope into manageable deliverables and work packages.
- **Basic COCOMO Formula:**
  $$\text{Effort} = a \times (\text{KLOC})^b \quad \text{[Person-Months]}$$
  $$\text{Duration} = c \times (\text{Effort})^d \quad \text{[Months]}$$

## 💡 Sample Estimation
```text
Project: E-Commerce Web Portal
Estimated Code Size: 32 KLOC (Semi-detached mode)
Effort = 3.0 * (32)^1.12 = 146.5 Person-Months
Development Time = 2.5 * (146.5)^0.35 = 14.3 Months
Recommended Team Size = 146.5 / 14.3 ~ 10 Engineers
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Organic, Semi-detached, and Embedded projects in COCOMO?**
   *Answer:* Organic: small teams in familiar environments; Semi-detached: medium teams with mixed experience; Embedded: tight constraints coupled with complex hardware/software rules.', '# Work Breakdown Structure\n\n# Project: [Describe your project]\n\n# Process-Based WBS:\n# TODO: Define process breakdown\n\n# Product-Based WBS:\n# TODO: Define product breakdown\n\n# Estimation:\n# TODO: Effort and cost estimation'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 3, 'ER Diagram', '# Experiment 03: Entity-Relationship (ER) Diagram Modeling

## 🎯 Aim of the Experiment
To design a conceptual **Entity-Relationship (ER) Diagram** for a software application (e.g. Hospital Management System), identifying entities, attributes, relationships, and cardinalities (1:1, 1:N, M:N).

## 📖 Theoretical Background & Core Principles
ER modeling is a high-level conceptual data model.
- **Entities:** Rectangles.
- **Attributes:** Ellipses (Underlined for Primary Key).
- **Relationships:** Diamonds with participation constraints.

## 💡 Sample Modeling
```text
[DOCTOR] <---(Treats)---> [PATIENT]
Doctor (Doc_ID, Name, Specialty)
Patient (Patient_ID, Name, Disease)
Relationship: Treats (1:N or M:N with timestamp)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Weak Entity?**
   *Answer:* An entity that cannot be identified by its own attributes alone and depends on the existence of a parent identifying entity (indicated by a double rectangle).', '# ER Diagram Design\n\n# System: [Describe the system]\n\n# Entities:\n# TODO: List entities and their attributes\n\n# Relationships:\n# TODO: Define relationships and cardinality'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 4, 'DFD - Data Flow Diagram', '# Experiment 04: Data Flow Diagram (DFD) Modeling

## 🎯 Aim of the Experiment
To construct functional data models using **Data Flow Diagrams (DFD)**: Level 0 (Context Diagram), Level 1 DFD, and Level 2 DFD for critical sub-processes.

## 📖 Theoretical Background & Core Principles
DFD illustrates how data moves through an information system.
- **External Entity:** Square/Rectangle.
- **Process:** Circle or Rounded Rectangle.
- **Data Store:** Open-ended rectangle.
- **Data Flow:** Labeled arrow.

## 💡 Sample Context Diagram (Level 0)
```text
[Customer] ---> (Place Order) ---> (1.0 E-Commerce System) ---> [Billing Gateway]
[Customer] <--- (Order Confirmation) <--- (1.0 E-Commerce System)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is DFD Balancing?**
   *Answer:* The rule requiring that all input and output data flows in a parent diagram must be preserved when decomposing a process into lower-level child diagrams.', '# Data Flow Diagram Design\n\n# System: [Describe the system]\n\n# Level 0 (Context Diagram):\n# TODO: Define external entities and data flows\n\n# Level 1 DFD:\n# TODO: Decompose into sub-processes'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 5, 'State Transition Diagram', '# Experiment 05: State Transition Diagram (STD) Modeling

## 🎯 Aim of the Experiment
To model the dynamic, event-driven behavior of a software component (e.g. ATM Transaction or Order Lifecycle) using **State Transition Diagrams (STD)**.

## 📖 Theoretical Background & Core Principles
An STD models the finite states an object passes through during its lifetime in response to external events, conditions (guards), and actions:
$$\text{Current State} + \text{Event [Guard]} / \text{Action} \to \text{Next State}$$

## 💡 Sample State Lifecycle
```text
[IDLE] -- Card Inserted --> [PIN_ENTRY]
[PIN_ENTRY] -- Valid PIN --> [TRANSACTION_SELECT]
[TRANSACTION_SELECT] -- Withdraw [Balance >= Amount] / Dispense Cash --> [COMPLETED]
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is an active state vs passive state?**
   *Answer:* An active state represents ongoing internal processing; a passive state waits for an external event trigger.', '# State Transition Diagram\n\n# System: [Describe the system]\n\n# States:\n# TODO: List all states\n\n# Transitions:\n# TODO: Define transitions with events and actions'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 6, 'Use Case & Class Diagrams', '# Experiment 06: UML Use Case & Class Diagrams

## 🎯 Aim of the Experiment
To design UML **Use Case Diagrams** (identifying actors, system boundaries, `<<include>>`, and `<<extend>>` relationships) and static **Class Diagrams** (with attributes, methods, and visibility).

## 📖 Theoretical Background & Core Principles
- **Use Case:** Captures system functional requirements from the perspective of external actors.
- **Class Diagram:** Static structure of classes, interfaces, attributes (`+` public, `-` private, `#` protected), and associations.

## 💡 Sample Relationship
```text
Use Case: (Book Flight) <<include>> (Process Payment)
Use Case: (Book Flight) <<extend>> (Apply Discount Coupon)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between `<<include>>` and `<<extend>>`?**
   *Answer:* `<<include>>` is mandatory and always executed as part of the base use case; `<<extend>>` is optional and executed only when specific conditions are met.', '# OO Design - Use Case & Class Model\n\n# System: [Describe the system]\n\n# Actors:\n# TODO: List actors\n\n# Use Cases:\n# TODO: Define use cases\n\n# Classes:\n# TODO: Define classes with attributes and methods'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 7, 'Interaction Diagrams', '# Experiment 07: UML Interaction Diagrams (Sequence & Collaboration)

## 🎯 Aim of the Experiment
To design dynamic UML **Sequence Diagrams** (showing message chronological sequencing across lifelines) and equivalent **Collaboration / Communication Diagrams**.

## 📖 Theoretical Background & Core Principles
Sequence diagrams emphasize time ordering of messages exchanged between collaborating objects. Elements include Lifelines, Activation Bars, Synchronous calls (solid arrow), and Return messages (dashed arrow).

## 💡 Sample Sequence Flow
```text
User            UI Controller            Database
 |                    |                      |
 |-- 1: login(u, p) ->|                      |
 |                    |-- 2: queryUser() --->|
 |                    |<-- 3: userRecord ----|
 |<-- 4: success -----|                      |
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between a Sequence Diagram and Communication Diagram?**
   *Answer:* Sequence diagrams emphasize time order chronologically top-to-bottom; Communication diagrams emphasize spatial object relationships and architectural links with numbered messages.', '# Interaction Diagrams\n\n# Scenario: [Describe the interaction scenario]\n\n# Sequence Diagram:\n# TODO: Define objects and message sequence\n\n# Collaboration Diagram:\n# TODO: Define object collaboration'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 8, 'Package & Deployment Diagrams', '# Experiment 08: UML Package, Component & Deployment Diagrams

## 🎯 Aim of the Experiment
To model software architectures using **Package Diagrams** (subsystem organization), **Component Diagrams** (modular software artifacts and interfaces), and **Deployment Diagrams** (physical hardware execution nodes).

## 📖 Theoretical Background & Core Principles
- **Component Diagram:** Illustrates replaceable modular units with provided/required interfaces (lollipop and socket notation).
- **Deployment Diagram:** Shows physical computational nodes (servers, devices) and artifact deployments.

## 💡 Sample Deployment Nodes
```text
<<node>> [Client Browser]
   | (HTTPS / REST)
   v
<<node>> [Web Application Server (Node/Django)]
   | (TCP / Port 5432)
   v
<<node>> [Database Cluster (PostgreSQL)]
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is a Node in a UML deployment diagram?**
   *Answer:* A 3D box representing a physical computational device (hardware server) or execution environment (virtual machine/container) on which software artifacts execute.', '# Architecture Diagrams\n\n# System: [Describe the system]\n\n# Package Diagram:\n# TODO: Define packages and dependencies\n\n# Component Diagram:\n# TODO: Define components and interfaces\n\n# Deployment Diagram:\n# TODO: Define nodes and artifacts'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 9, 'Test Case Design', '# Experiment 09: Test Case Design (ECP, BVA & Testing Suites)

## 🎯 Aim of the Experiment
To design, write, and execute systematic software test cases using **Equivalence Class Partitioning (ECP)**, **Boundary Value Analysis (BVA)**, and categorize unit, integration, and system tests.

## 📖 Theoretical Background & Core Principles
- **Equivalence Class Partitioning:** Divides input domain into valid and invalid partitions where one test representative represents the entire class.
- **Boundary Value Analysis:** Focuses testing on boundaries of input domains (min, min+1, nominal, max-1, max) where software defects concentrate.

## 💡 Sample Test Case Specification
```text
Feature: Age Validation (Valid range: 18 to 60)
Test Cases by BVA:
TC-01: Age = 17 -> Expected: Invalid Error message (Boundary: min-1)
TC-02: Age = 18 -> Expected: Accepted (Boundary: min)
TC-03: Age = 19 -> Expected: Accepted (Boundary: min+1)
TC-04: Age = 60 -> Expected: Accepted (Boundary: max)
TC-05: Age = 61 -> Expected: Invalid Error message (Boundary: max+1)
```

## ❓ Viva-Voce Questions with Model Answers
1. **What is the difference between Black-box and White-box testing?**
   *Answer:* Black-box tests functionality against specifications without knowledge of internal code structure; White-box tests internal control structures, branches, and statements with knowledge of source code.', '# Test Case Design\n\n# System Under Test: [Describe]\n\n# Functional Test Cases:\n# TC-01:\n#   Description:\n#   Steps:\n#   Expected Result:\n#   Actual Result:\n\n# Non-Functional Test Cases:\n# TODO: Performance, usability tests'),
((SELECT id FROM subjects WHERE code='CSPC3205'), 10, 'UI Design & Storyboarding', '# Experiment 10: UI Design, Storyboarding & Usability Heuristics

## 🎯 Aim of the Experiment
To design a user interface storyboard wireframe and evaluate compliance with **Jakob Nielsen''s 10 Usability Heuristics** and accessibility guidelines (WCAG 2.1).

## 📖 Theoretical Background & Core Principles
Usability engineering ensures systems are intuitive, accessible, and error-tolerant.
- **Visibility of System Status:** Inform user about current operations with progress bars and spinners.
- **Error Prevention & Recovery:** Clear error messages with corrective actions.
- **Consistency & Standards:** Uniform UI components and vocabulary.

## ❓ Viva-Voce Questions with Model Answers
1. **What is Fitts''s Law in UI/UX design?**
   *Answer:* A model predicting that the time required to rapidly move to a target area is a function of the ratio between distance to target and width of target ($T = a + b \log_2(2D/W)$).', '# UI Design & Storyboarding\n\n# Application: [Describe]\n\n# User Stories:\n# TODO: Define user stories\n\n# Wireframes:\n# TODO: Describe screen layouts\n\n# Storyboard:\n# TODO: Define user flow sequence')
ON CONFLICT (subject_id, experiment_number) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  boilerplate_code = EXCLUDED.boilerplate_code;
