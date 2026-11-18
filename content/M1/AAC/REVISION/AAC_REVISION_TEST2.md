---
title: "Mastery Guide: AVL Trees, Red-Black Trees, Hash Tables & Heaps"
course: Advanced Algorithms and Complexity (USTO-MB)
tags:
  - algorithms
  - data-structures
  - avl-tree
  - red-black-tree
  - hash-tables
  - binary-heaps
  - obsidian-notes
  - exam-prep
---

# Mastery Guide: Balanced Trees, Hash Tables & Binary Heaps

> [!info] Course Context & Golden Rule
> Based on **Lecture 4: Data Structures and Complexity** (Prof. A. Mebarki, USTO-MB).
> **Golden Rule:** Never just memorize a complexity table. Always be able to explain *where* the cost comes from (following a root-to-leaf path of length $h$, performing $\Theta(1)$ rotations, sifting along a complete tree of height $\lfloor \log_2 n \rfloor$, or probing a cluster of length proportional to $\alpha$).

---

## 1. AVL Trees

### Quick Study Guide

> [!abstract] Core Invariant
> An **AVL tree** is a Binary Search Tree (BST) where, for every node $x$, the heights of its left and right subtrees differ by at most $1$:
>
> $$
> \text{bf}(x) = \text{height}(\text{left}(x)) - \text{height}(\text{right}(x)) \in \{-1, 0, +1\}
> $$
>
> *(By convention, an empty subtree `NIL` has height $-1$, and a single leaf node has height $0$.)*

#### Why is the height strictly $\Theta(\log n)$?

* A minimal AVL tree of height $h$ has one subtree of height $h-1$ and one of height $h-2$:

  $$
  N(h) = N(h-1) + N(h-2) + 1 = F_{h+3} - 1
  $$

* Using the Fibonacci growth rate $\phi = \frac{1+\sqrt{5}}{2} \approx 1.618$, this guarantees:

  $$
  h \le \log_{\phi}(n+1) - 1 \approx 1.44 \log_2(n+1) - 1
  $$

* An AVL tree is **never more than $44\%$ deeper** than a perfect binary tree.

#### Rebalancing Rotations (When $|\text{bf}(z)| = 2$)

Walk upward from the inserted/deleted node to the first unbalanced ancestor $z$:

| Imbalance Case | Heavy Subtree Shape | Repair Operation | Rotations |
| :--- | :--- | :--- | :---: |
| **Left-Left (LL)** | Left child of left child of $z$ | `RIGHT-ROTATE(z)` | $1$ (single) |
| **Right-Right (RR)** | Right child of right child of $z$ | `LEFT-ROTATE(z)` | $1$ (single) |
| **Left-Right (LR)** | Right child of left child of $z$ | `LEFT-ROTATE(left(z))`, then `RIGHT-ROTATE(z)` | $2$ (double) |
| **Right-Left (RL)** | Left child of right child of $z$ | `RIGHT-ROTATE(right(z))`, then `LEFT-ROTATE(z)` | $2$ (double) |

#### Operation Complexities

* **Search:** $\Theta(\log n)$ — follows one downward path of length $h \le 1.44\log_2 n$.
* **Insertion:** $\Theta(\log n)$ — descent + upward walk; requires **at most $1$ rebalancing** (single or double rotation) because the rotation restores the subtree's original pre-insertion height.
* **Deletion:** $\Theta(\log n)$ — descent + upward walk; may require **up to $O(\log n)$ rotations** because repairing a subtree can decrease its height by $1$, propagating the imbalance upward.

---

### Exam-Style Exercise: AVL Trees (11 points, ~8 minutes)

> [!question] Exercise 1 — AVL Insertions, Deletion & Search
> An initially empty **AVL tree** receives the keys **`30, 15, 45, 10, 20, 5, 18, 25`** inserted in this exact order. We represent a subtree rooted at $k$ as `k(left, right)`, using `-` for an empty child.
>
> **(a) (3.5 pts)** Write the final AVL tree after all eight insertions and list every rotation performed.
> **(b) (0.5 pt)** What is the height $h$ of the tree, and what is the balance factor $\text{bf}$ of the root?
> **(c) (2 pts)** Delete the key **`45`** from the tree obtained in (a). Write the rebalanced AVL tree.
> **(d) (1.5 pts)** After this deletion, how many nodes are examined to search for **`18`** (the node where the key is found is counted)?
> **(e) (1.5 pts)** How many nodes are examined to search for **`22`**, which is absent (count every non-`NIL` node visited)?
> **(f) (2 pts)** Why can deletion in an AVL tree trigger up to $O(\log n)$ rotations, whereas insertion requires at most one rebalancing? Answer in one or two sentences.

> [!success]- Step-by-Step Solution (Click to Expand)
> **(a) Final AVL tree after the 8 insertions:**
>
> 1. Insert `30, 15, 45, 10, 20`: balanced tree `30(15(10, 20), 45)`.
> 2. Insert `5`: placed as left child of `10` $\rightarrow$ `30(15(10(5, -), 20), 45)`.
>    * Balance factors: $\text{bf}(10) = +1$, $\text{bf}(15) = +1$, $\text{bf}(30) = 2 - 0 = +2$ (**LL imbalance at `30`**).
>    * Repair: **`RIGHT-ROTATE(30)`** $\rightarrow$ `15` becomes the new root, `20` becomes the left child of `30`:
>      `15(10(5, -), 30(20, 45))`
> 3. Insert `18` (left of `20`) and `25` (right of `20`):
>    * Heights: `20` has $h=1$ ($\text{bf}=0$), `30` has $h=2$ ($\text{bf}=+1$), `15` has $h=3$ ($\text{bf} = 1 - 2 = -1$). All nodes remain balanced.
>
> **Final Tree:**
>
> ```text
>         15
>        /  \
>      10    30
>     /     /  \
>    5     20   45
>         /  \
>        18  25
> ```
>
> In parenthesized notation: **`15(10(5, -), 30(20(18, 25), 45))`** ($1$ single right rotation at `30`).
>
> **(b) Height and Root Balance Factor:**
>
> * Height: $h = 3$ (longest path `15 -> 30 -> 20 -> 18` has $3$ edges).
> * Root balance factor: $\text{bf}(15) = h(\text{left}) - h(\text{right}) = 1 - 2 = -1$.
>
> **(c) Tree after deleting `45`:**
>
> * Removing leaf `45` leaves `30` with left child `20` ($h=1$) and right child `-` ($h=-1$).
> * $\text{bf}(30) = 1 - (-1) = +2$ (**LL imbalance at `30`**, since $\text{bf}(20) = 0$).
> * Repair: **`RIGHT-ROTATE(30)`** $\rightarrow$ `20` becomes right child of `15`, and `25` becomes left child of `30`.
>
> **Final Tree after deletion:**
>
> ```text
>         15
>        /  \
>      10    20
>     /     /  \
>    5     18   30
>              /
>             25
> ```
>
> In parenthesized notation: **`15(10(5, -), 20(18, 30(25, -)))`**.
>
> **(d) Nodes examined to search for `18`:**
> **$3$ nodes**: `15` ($18 > 15$) $\rightarrow$ `20` ($18 < 20$) $\rightarrow$ `18` (found).
>
> **(e) Nodes examined to search for `22` (absent):**
> **$4$ nodes**: `15` ($22 > 15$) $\rightarrow$ `20` ($22 > 20$) $\rightarrow$ `30` ($22 < 30$) $\rightarrow$ `25` ($22 < 25 \rightarrow \text{NIL}$, stop).
>
> **(f) Why deletion can take $O(\log n)$ rotations while insertion takes at most $1$:**
> After an insertion, a single or double rotation restores the unbalanced subtree's height to its exact value prior to the insertion, so no ancestor's balance factor changes. After a deletion, rebalancing an unbalanced subtree can decrease its overall height by $1$, propagating the imbalance upward toward the root.

---

## 2. Red-Black Trees

### Quick Study Guide

> [!abstract] The 5 Red-Black Properties
> A **Red-Black tree** is a BST where every node carries $1$ color bit (`RED` or `BLACK`), empty pointers are treated as black `NIL` leaves, and:
>
> 1. Every node is either **red** or **black**.
> 2. The **root is black**.
> 3. Every **`NIL` leaf is black**.
> 4. **No two consecutive red nodes:** If a node is red, both its children are black.
> 5. **Equal black-height ($\text{bh}$):** For every node $x$, all downward paths from $x$ to a `NIL` leaf contain the exact same number of black nodes.

#### Why is the height $\Theta(\log n)$?

* By Property 4, at least half the nodes on any root-to-leaf path (excluding the root) are black, so $\text{bh} \ge h/2$.
* By induction on Property 5, a subtree with black-height $\text{bh}$ has at least $2^{\text{bh}} - 1$ internal nodes.
* Therefore, $n \ge 2^{h/2} - 1 \implies h \le 2\log_2(n+1)$.

#### Insertion Rebalancing (New node $z$ is always inserted as `RED`)

Inserting a `RED` node preserves Property 5 and can only violate Property 4 (if $z$'s parent is also `RED`). Let $u$ be $z$'s **uncle** (sibling of $z$'s parent):

| Case | Condition | Action | Next Step |
| :--- | :--- | :--- | :--- |
| **Case 1** | Uncle $u$ is **RED** | Recolor parent & uncle **BLACK**; recolor grandparent **RED** | Move $z$ up to grandparent and repeat ($O(\log n)$ max) |
| **Case 2** | Uncle $u$ is **BLACK**, $z$ is an **inner** grandchild (zig-zag) | Rotate at **parent** to align into a straight line | Falls directly into **Case 3** |
| **Case 3** | Uncle $u$ is **BLACK**, $z$ is an **outer** grandchild (straight line) | Rotate at **grandparent** + swap colors of parent & grandparent | **Done!** (At most $2$ rotations total) |

#### AVL vs. Red-Black Trees (Comparative Summary)

| Criterion | AVL Tree | Red-Black Tree |
| :--- | :--- | :--- |
| **Height Bound** | $h \le 1.44 \log_2(n+2)$ (stricter, shallower) | $h \le 2 \log_2(n+1)$ (looser, up to $\approx 1.4\times$ deeper) |
| **Search (worst case)** | $\Theta(\log n)$ — fewest comparisons | $\Theta(\log n)$ — slightly longer paths |
| **Rotations / Insertion** | At most $1$ (single or double) | At most $2$ |
| **Rotations / Deletion** | Up to $O(\log n)$ | At most $3$ |
| **Typical Use Case** | **Read-heavy** workloads (lookups dominate) | **Write-heavy** general-purpose maps/sets (`std::map`, `TreeMap`) |

---

### Exam-Style Exercise: Red-Black Trees (11 points, ~8 minutes)

> [!question] Exercise 2 — Red-Black Insertions, Black-Height & Properties
> An initially empty **Red-Black tree** receives the keys **`10, 20, 30, 15, 12`** inserted in this exact order. Denote each node as `key[R]` (Red) or `key[B]` (Black).
>
> **(a) (3.5 pts)** Write/draw the Red-Black tree after all five insertions and name the rebalancing cases (Case 1, 2, or 3) triggered.
> **(b) (0.5 pt)** What is the height $h$ of the tree, and what is the black-height $\text{bh}$ of the root (excluding the root and counting black `NIL` leaves)?
> **(c) (2 pts)** Insert the key **`5`** into the tree obtained in (a). Write/draw the updated Red-Black tree.
> **(d) (1.5 pts)** After this insertion, how many nodes are examined to search for **`15`** (the node where the key is found is counted)?
> **(e) (1.5 pts)** How many nodes are examined to search for **`14`**, which is absent (count every non-`NIL` node visited)?
> **(f) (2 pts)** What would go wrong if every newly inserted key were colored **Black** instead of **Red**? Answer in one or two sentences.

> [!success]- Step-by-Step Solution (Click to Expand)
> **(a) Red-Black tree after inserting `10, 20, 30, 15, 12`:**
>
> 1. Insert `10[R]` $\rightarrow$ recolored to **`10[B]`** (Property 2: root must be black).
> 2. Insert `20[R]` as right child of `10[B]` $\rightarrow$ valid: `10[B](-, 20[R])`.
> 3. Insert `30[R]` as right child of `20[R]` $\rightarrow$ Red-Red violation; uncle (`NIL`) is Black, outer grandchild (**Case 3**):
>    * Left-rotate at `10` and swap colors of `20` and `10` $\rightarrow$ **`20[B](10[R], 30[R])`**.
> 4. Insert `15[R]` as right child of `10[R]` $\rightarrow$ Red-Red violation; uncle `30[R]` is Red (**Case 1**):
>    * Recolor `10` and `30` to Black, grandparent `20` to Red, then restore root `20` to Black $\rightarrow$ **`20[B](10[B](-, 15[R]), 30[B])`**.
> 5. Insert `12[R]` as left child of `15[R]` $\rightarrow$ Red-Red violation; uncle (`NIL`) is Black, `12` is an inner grandchild (RL zig-zag):
>    * **Case 2:** Right-rotate at `15` $\rightarrow$ `10[B](-, 12[R](-, 15[R]))`.
>    * **Case 3:** Left-rotate at `10` and swap colors of `12` and `10` $\rightarrow$ `12[B](10[R], 15[R])`.
>
> **Final Red-Black Tree:**
>
> ```text
>         20[B]
>        /     \
>     12[B]    30[B]
>     /   \
>  10[R]  15[R]
> ```
>
> **(b) Height and Black-Height of the root:**
>
> * Height: $h = 2$ (edges along `20 -> 12 -> 10`).
> * Black-height of root `20`: $\text{bh}(20) = 2$ (every path from `20` to a `NIL` leaf crosses `12[B]` or `30[B]` plus the black `NIL` leaf).
>
> **(c) Tree after inserting `5`:**
>
> * `5[R]` is inserted as the left child of `10[R]` $\rightarrow$ Red-Red violation at `10[R]` and `5[R]`.
> * Uncle `15[R]` is **Red** (**Case 1**): recolor `10` to Black, `15` to Black, and grandparent `12` to Red. Since `12[R]`'s parent `20[B]` is Black, stop.
>
> **Updated Red-Black Tree:**
>
> ```text
>           20[B]
>          /     \
>       12[R]    30[B]
>       /   \
>    10[B]  15[B]
>    /
>  5[R]
> ```
>
> **(d) Nodes examined to search for `15`:**
> **$3$ nodes**: `20[B]` ($15 < 20$) $\rightarrow$ `12[R]` ($15 > 12$) $\rightarrow$ `15[B]` (found).
>
> **(e) Nodes examined to search for `14` (absent):**
> **$3$ nodes**: `20[B]` ($14 < 20$) $\rightarrow$ `12[R]` ($14 > 12$) $\rightarrow$ `15[B]` ($14 < 15 \rightarrow \text{NIL}$, stop).
>
> **(f) What goes wrong if new nodes are colored Black instead of Red:**
> Coloring a newly inserted leaf **Black** would immediately add $+1$ to the black-height of that single root-to-leaf path while leaving all other paths unchanged, violating **Property 5** (equal black-height) on every single insertion.

---

## 3. Hash Tables

### Quick Study Guide

> [!abstract] Core Principle & Load Factor
> A **hash table** maps keys from universe $U$ into an array of $m$ slots via a hash function $h(k) \in \{0, 1, \dots, m-1\}$.
>
> * **Load factor:** $\alpha = \frac{n}{m}$ (average number of elements per slot).
> * Because $|U| > m$ (and due to the birthday paradox), **collisions are unavoidable**; performance depends on how collisions are resolved and the quality of $h(k)$.

#### Hash Functions

* **Division method:** $h(k) = k \bmod m$ — choose $m$ to be a **prime** not close to a power of $2$.
* **Multiplication method:** $h(k) = \lfloor m \cdot (kA \bmod 1) \rfloor$ with $0 < A < 1$ (e.g., $A \approx 0.618$).
* **Strings (Polynomial):** $\Theta(\ell)$ for a string of length $\ell$ (not $\Theta(1)$!).

#### Collision Resolution Strategies

1. **Chaining:** Each slot points to a linked list of colliding keys.
   * Expected search cost: $\Theta(1 + \alpha)$ (unsuccessful: $\alpha$ comparisons; successful: $\approx 1 + \alpha/2$). Worst case: $\Theta(n)$.
2. **Open Addressing:** All elements reside inside the array itself ($\alpha < 1$).
   * **Linear Probing:** $h(k, i) = (h(k) + i) \bmod m$. Suffers from **primary clustering** (contiguous blocks of occupied cells grow and merge; expected unsuccessful probes $\approx \frac{1}{2}\left(1 + \frac{1}{(1-\alpha)^2}\right)$).
   * **Double Hashing:** $h(k, i) = (h_1(k) + i \cdot h_2(k)) \bmod m$, where $h_2(k)$ is relatively prime to $m$ (e.g., $h_2(k) = 1 + (k \bmod (m-2))$ when $m$ is prime). Eliminates primary clustering.
   * **Deletion Rule:** Never mark a deleted slot as `EMPTY`; mark it as a tombstone **`DEL`** so subsequent searches do not terminate prematurely.

> [!warning] Crucial Exam Traps (Prof. Mebarki's Checklist)
>
> * $\Theta(1)$ for hash tables is an **expected** (and amortized with resizing) bound—**never** a worst-case guarantee ($\Theta(n)$ worst case).
> * Hash tables **destroy key order**: finding `MIN`, `MAX`, `SUCCESSOR`, or answering a **range query** costs $\Theta(n + m)$, whereas a balanced tree does range queries in $\Theta(\log n + r)$.

---

### Exam-Style Exercise: Hash Tables (11 points, ~8 minutes)

> [!question] Exercise 3 — Open Addressing with Double Hashing
> A hash table has $m = 13$ slots (numbered $0$ to $12$) and uses **double hashing** with:
>
> $$
> h_1(k) = k \bmod 13, \qquad h_2(k) = 1 + (k \bmod 11)
> $$
>
> After a collision, the slots $(h_1(k) + i \cdot h_2(k)) \bmod 13$ for $i = 1, 2, \dots$ are tried in turn. A deleted slot is marked **`DEL`** (never `EMPTY`).
> The keys **`27, 40, 14, 53, 18, 31, 66, 44`** are inserted, in this order, into an initially empty table.
>
> **(a) (3.5 pts)** Write the table after the eight insertions (leave `EMPTY` slots blank).
>
> | Slot | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **Key** | | | | | | | | | | | | | |
>
> **(b) (0.5 pt)** Load factor $\alpha = \underline{\hspace{2cm}}$
> **(c) (1 pt)** Delete the key **`31`**. Write the table again.
>
> | Slot | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **Key** | | | | | | | | | | | | | |
>
> **(d) (2 pts)** After this deletion, how many slots are examined to search for **`66`** (the slot where the key is found is counted)? $\underline{\hspace{2cm}}$
> **(e) (2 pts)** How many slots are examined to search for **`92`**, which is absent (the `EMPTY` slot that stops the search is counted)? $\underline{\hspace{2cm}}$
> **(f) (2 pts)** Why does double hashing perform significantly better than linear probing when the load factor $\alpha$ is high (e.g., $\alpha = 0.75$)? Answer in one or two sentences.

> [!success]- Step-by-Step Solution (Click to Expand)
> **(a) Hash table after the 8 insertions:**
>
> * **`27`**: $h_1(27) = 27 \bmod 13 = 1 \rightarrow$ inserted in slot **1**.
> * **`40`**: $h_1(40) = 40 \bmod 13 = 1$ (collision); $h_2(40) = 1 + (40 \bmod 11) = 8$.
>   * $i=1$: $(1 + 8) \bmod 13 = 9 \rightarrow$ inserted in slot **9**.
> * **`14`**: $h_1(14) = 14 \bmod 13 = 1$ (collision); $h_2(14) = 1 + (14 \bmod 11) = 4$.
>   * $i=1$: $(1 + 4) \bmod 13 = 5 \rightarrow$ inserted in slot **5**.
> * **`53`**: $h_1(53) = 53 \bmod 13 = 1$ (collision); $h_2(53) = 1 + (53 \bmod 11) = 10$.
>   * $i=1$: $(1 + 10) \bmod 13 = 11 \rightarrow$ inserted in slot **11**.
> * **`18`**: $h_1(18) = 18 \bmod 13 = 5$ (collision); $h_2(18) = 1 + (18 \bmod 11) = 8$.
>   * $i=1$: $(5 + 8) \bmod 13 = 0 \rightarrow$ inserted in slot **0**.
> * **`31`**: $h_1(31) = 31 \bmod 13 = 5$ (collision); $h_2(31) = 1 + (31 \bmod 11) = 10$.
>   * $i=1$: $(5 + 10) \bmod 13 = 2 \rightarrow$ inserted in slot **2**.
> * **`66`**: $h_1(66) = 66 \bmod 13 = 1$ (collision); $h_2(66) = 1 + (66 \bmod 11) = 1$.
>   * $i=1$: $(1 + 1) \bmod 13 = 2$ (collision with `31`).
>   * $i=2$: $(1 + 2) \bmod 13 = 3 \rightarrow$ inserted in slot **3**.
> * **`44`**: $h_1(44) = 44 \bmod 13 = 5$ (collision); $h_2(44) = 1 + (44 \bmod 11) = 1$.
>   * $i=1$: $(5 + 1) \bmod 13 = 6 \rightarrow$ inserted in slot **6**.
>
> | Slot | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **Key** | **18** | **27** | **31** | **66** | | **14** | **44** | | | **40** | | **53** | |
>
> **(b) Load factor ($\alpha$):**
>
> $$
> \alpha = \frac{n}{m} = \frac{8}{13} \approx 0.62
> $$
>
> **(c) Table after deleting `31`:**
> Key **`31`** is at slot **2**, which is replaced by **`DEL`**:
>
> | Slot | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **Key** | **18** | **27** | **DEL** | **66** | | **14** | **44** | | | **40** | | **53** | |
>
> **(d) Slots examined to search for `66`:**
> **$3$ slots** ($h_1(66) = 1$, $h_2(66) = 1$):
>
> 1. **Slot 1**: contains `27` $\neq 66$ (continue).
> 2. **Slot 2**: contains `DEL` (continue).
> 3. **Slot 3**: contains **`66`** (found, stop).
>
> **(e) Slots examined to search for `92` (absent):**
> **$5$ slots** ($h_1(92) = 92 \bmod 13 = 1$, $h_2(92) = 1 + (92 \bmod 11) = 5$):
>
> 1. **Slot 1** ($i=0$): contains `27` $\neq 92$.
> 2. **Slot 6** ($i=1$, $(1+5)\bmod 13 = 6$): contains `44` $\neq 92$.
> 3. **Slot 11** ($i=2$, $(1+10)\bmod 13 = 11$): contains `53` $\neq 92$.
> 4. **Slot 3** ($i=3$, $(1+15)\bmod 13 = 3$): contains `66` $\neq 92$.
> 5. **Slot 8** ($i=4$, $(1+20)\bmod 13 = 8$): **`EMPTY`** (stops search).
>
> **(f) Why double hashing beats linear probing at high load factors:**
> Linear probing suffers from **primary clustering**, where contiguous runs of occupied slots grow and merge, causing probe lengths to degrade rapidly ($\approx \frac{1}{2}(1 + 1/(1-\alpha)^2)$). Double hashing uses a key-dependent step $h_2(k)$ so keys with the same initial hash follow different probe sequences, avoiding clusters.

---

## 4. Binary Heaps

### Quick Study Guide

> [!abstract] Core Properties & Zero-Pointer Array Layout
> A **binary heap** is a binary tree satisfying two properties:
>
> 1. **Shape property:** The tree is **complete** (all levels are completely filled except possibly the last, which is filled from left to right). Therefore, its height is strictly $h = \lfloor \log_2 n \rfloor$.
> 2. **Heap property (Min-Heap):** For every node $i$, $H[\text{parent}(i)] \le H[i]$, placing the minimum element at the root $H[0]$.
>
> Because the tree is complete, it is stored in a contiguous $0$-indexed array **without pointers**:
>
> $$
> \text{parent}(i) = \left\lfloor \frac{i - 1}{2} \right\rfloor, \qquad \text{left}(i) = 2i + 1, \qquad \text{right}(i) = 2i + 2
> $$

#### Fundamental Operations & Sifting

* **`FIND-MIN`:** $\Theta(1)$ — directly reads $H[0]$.
* **`INSERT(H, k)`:** $\Theta(\log n)$ worst case ($\Theta(1)$ expected for random keys) — places $k$ at $H[n]$, increments $n$, and runs `SIFT-UP` along at most $\lfloor \log_2 n \rfloor$ levels.
* **`EXTRACT-MIN(H)`:** $\Theta(\log n)$ — saves $H[0]$, moves $H[n-1]$ to $H[0]$, decrements $n$, and runs `SIFT-DOWN` along at most $\lfloor \log_2 n \rfloor$ levels.
* **`DECREASE-KEY(i)` / `DELETE(i)` (position $i$ known):** $\Theta(\log n)$ — updates or replaces $H[i]$ with $H[n-1]$, then sifts up or down.
* **`SEARCH` (arbitrary key):** $\Theta(n)$ — the heap property says nothing about the order between left and right subtrees.

#### Bottom-Up `BUILD-HEAP`: $\Theta(n)$, NOT $\Theta(n \log n)$

* Repeatedly calling `INSERT` $n$ times costs $\Theta(n \log n)$ in the worst case.
* Running `SIFT-DOWN(H, i, n)` from the last internal node $i = \lfloor n/2 \rfloor - 1$ down to $0$ runs in **$\Theta(n)$**:
  * Leaves (height $0$) need $0$ swaps.
  * At height $j$, there are at most $\lceil n / 2^{j+1} \rceil$ nodes, and `SIFT-DOWN` costs $O(j)$ per node:

  $$
  T(n) \le \sum_{j=0}^{\lfloor \log_2 n \rfloor} \left\lceil \frac{n}{2^{j+1}} \right\rceil c j \le c n \sum_{j \ge 0} \frac{j}{2^{j+1}} = c n \cdot 1 = \Theta(n)
  $$

* **Heapsort:** Builds a max-heap in $\Theta(n)$, then performs $n-1$ root swaps and `SIFT-DOWN` calls $\implies \Theta(n \log n)$ worst-case time and $\Theta(1)$ extra space (in-place).

> [!warning] Crucial Exam Traps (Prof. Mebarki's Checklist)
>
> * A heap is **not** a BST: searching for an arbitrary key takes $\Theta(n)$, not $\Theta(\log n)$.
> * Building a heap bottom-up via `BUILD-HEAP` is $\Theta(n)$ because most nodes sit near the bottom of the tree and sift down very few levels.

---

### Exam-Style Exercise: Binary Heaps (11 points, ~8 minutes)

> [!question] Exercise 4 — Bottom-Up `BUILD-HEAP`, `EXTRACT-MIN` & `INSERT`
> Consider the unsorted $0$-indexed array $H$ of $n = 9$ keys:
>
> | Index $i$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **$H[i]$** | **45** | **22** | **60** | **15** | **38** | **10** | **50** | **8** | **29** |
>
> **(a) (3.5 pts)** Apply the bottom-up **`BUILD-HEAP`** algorithm to transform $H$ into a **min-heap**. Write the resulting array (indices $0$ to $8$) and list the indices $i$ on which `SIFT-DOWN` is called.
>
> | Index $i$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **$H[i]$** | | | | | | | | | |
>
> **(b) (0.5 pt)** Height $h = \underline{\hspace{1.5cm}}$ and index of $\text{parent}(7) = \underline{\hspace{1.5cm}}$
> **(c) (2 pts)** Perform one **`EXTRACT-MIN`** followed by **`INSERT(12)`** on the min-heap from (a). Write the updated min-heap array (indices $0$ to $8$).
>
> | Index $i$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **$H[i]$** | | | | | | | | | |
>
> **(d) (1.5 pts)** After these operations, how many array cells must be examined in the worst case to search for the key **`45`**? $\underline{\hspace{2cm}}$
> **(e) (1.5 pts)** How many swaps are performed in the worst case during a single `EXTRACT-MIN` on a min-heap of $n = 1024$ elements? $\underline{\hspace{2cm}}$
> **(f) (2 pts)** Why does bottom-up `BUILD-HEAP` cost $\Theta(n)$ rather than $\Theta(n \log n)$, even though it invokes `SIFT-DOWN` roughly $n/2$ times? Answer in one or two sentences.

> [!success]- Step-by-Step Solution (Click to Expand)
> **(a) Min-heap after bottom-up `BUILD-HEAP`:**
>
> `SIFT-DOWN` is called from $i = \lfloor 9/2 \rfloor - 1 = 3$ down to $0$ (indices **$3, 2, 1, 0$**):
>
> 1. **$i = 3$** ($H[3] = 15$): children $H[7] = 8$ and $H[8] = 29$. Swap $H[3]$ with smaller child $H[7] = 8$:
>    `[45, 22, 60, 8, 38, 10, 50, 15, 29]`
> 2. **$i = 2$** ($H[2] = 60$): children $H[5] = 10$ and $H[6] = 50$. Swap $H[2]$ with smaller child $H[5] = 10$:
>    `[45, 22, 10, 8, 38, 60, 50, 15, 29]`
> 3. **$i = 1$** ($H[1] = 22$):
>    * Children $H[3] = 8$ and $H[4] = 38 \rightarrow$ swap $H[1]$ with $H[3] = 8$.
>    * At index $3$, children $H[7] = 15$ and $H[8] = 29 \rightarrow$ swap $H[3]$ with $H[7] = 15$.
>    * Array: `[45, 8, 10, 15, 38, 60, 50, 22, 29]`
> 4. **$i = 0$** ($H[0] = 45$):
>    * Children $H[1] = 8$ and $H[2] = 10 \rightarrow$ swap $H[0]$ with $H[1] = 8$.
>    * At index $1$, children $H[3] = 15$ and $H[4] = 38 \rightarrow$ swap $H[1]$ with $H[3] = 15$.
>    * At index $3$, children $H[7] = 22$ and $H[8] = 29 \rightarrow$ swap $H[3]$ with $H[7] = 22$.
>
> | Index $i$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **$H[i]$** | **8** | **15** | **10** | **22** | **38** | **60** | **50** | **45** | **29** |
>
> **(b) Height and Parent Index:**
>
> * Height: $h = \lfloor \log_2 9 \rfloor = 3$.
> * $\text{parent}(7) = \lfloor (7 - 1)/2 \rfloor = 3$ (which holds key `22`).
>
> **(c) Array after `EXTRACT-MIN` followed by `INSERT(12)`:**
>
> 1. **`EXTRACT-MIN`**:
>    * Remove root `8`, move last element $H[8] = 29$ to $H[0]$, shrink $n$ to $8$:
>      `[29, 15, 10, 22, 38, 60, 50, 45]`
>    * `SIFT-DOWN(H, 0, 8)`: compare $29$ with children $H[1] = 15$ and $H[2] = 10 \rightarrow$ swap with $H[2] = 10$:
>      `[10, 15, 29, 22, 38, 60, 50, 45]`
>    * At index $2$, children are $H[5] = 60$ and $H[6] = 50$; since $29 \le 50$, stop.
> 2. **`INSERT(12)`**:
>    * Place `12` at $H[8]$, restore $n = 9$:
>      `[10, 15, 29, 22, 38, 60, 50, 45, 12]`
>    * `SIFT-UP(H, 8)`:
>      * $\text{parent}(8) = 3$ ($H[3] = 22 > 12$) $\rightarrow$ swap indices $8$ and $3$.
>      * $\text{parent}(3) = 1$ ($H[1] = 15 > 12$) $\rightarrow$ swap indices $3$ and $1$.
>      * $\text{parent}(1) = 0$ ($H[0] = 10 < 12$) $\rightarrow$ stop.
>
> | Index $i$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
> | **$H[i]$** | **10** | **12** | **29** | **15** | **38** | **60** | **50** | **45** | **22** |
>
> **(d) Cells examined in the worst case to search for `45`:**
> **$9$ cells** ($n = 9$), because a heap maintains no order between left and right subtrees, so searching for an arbitrary key requires scanning the entire array in $\Theta(n)$ worst-case time.
>
> **(e) Worst-case swaps for `EXTRACT-MIN` with $n = 1024$:**
> **$10$ swaps**, because the height of a complete binary tree of $1024$ nodes is $h = \lfloor \log_2 1024 \rfloor = 10$, and `SIFT-DOWN` performs at most one swap per level along a single root-to-leaf path.
>
> **(f) Why `BUILD-HEAP` is $\Theta(n)$ rather than $\Theta(n \log n)$:**
> The cost of `SIFT-DOWN` on a node is proportional to that node's height $j$ rather than $\log n$, and the number of nodes decreases geometrically with height ($\lceil n / 2^{j+1} \rceil$ nodes at height $j$), so the total work sums to $\sum_{j \ge 0} \frac{n}{2^{j+1}} \cdot cj = \Theta(n)$.