## **1. Complexity table**

|Data structure|Access|Search|Insertion|Deletion|
|---|---|---|---|---|
|Unsorted array|Θ(1)|Θ(n)|Θ(1)*|Θ(n)|
|Sorted array|Θ(1)|Θ(log n)|Θ(n)|Θ(n)|
|Linked list|Θ(n)|Θ(n)|Θ(1)**|Θ(n)**|
|Balanced BST|N/A|Θ(log n)|Θ(log n)|Θ(log n)|
|Unbalanced BST|N/A|Θ(n) worst|Θ(n) worst|Θ(n) worst|
|Binary heap|N/A|Θ(n)|Θ(log n)|Θ(log n)***|
|Hash table|N/A|Θ(1) expected|Θ(1) expected|Θ(1) expected|

>`*`At the end, if capacity is available.
>`**`At a known position or node, depending on the list type. Finding the position may cost Θ(n).
>`***`For deleting the minimum or an element at a known position.

|Structure|Implementation Effort|Time Guarantee|Memory Overhead|Locality|
|---|---|---|---|---|
|Array / dynamic array|Very low|Θ(1) access; Θ(n) search, insertion, deletion|Very low|Excellent|
|Linked list|Low|Θ(1) relinking; Θ(n) search|High|Poor|
|Plain BST|Low|None — Θ(n) worst case|Medium|Poor|
|AVL / red-black tree|High|Θ(log n) worst case|Medium|Poor|
|Binary heap|Low to medium|Θ(log n) worst case; Θ(1) find-min|Very low|Good|
|Hash table|Medium (hash function, resizing)|Θ(1) expected; Θ(n) worst case|Medium to low|Good (open addressing)|

## **2. Important concepts**

- Array: elements are contiguous in memory. Index access is Θ(1).
    
- Linked list: elements are connected using pointers. Access requires traversal.
    
- Stack: LIFO, Last In First Out.
    
- Queue: FIFO, First In First Out.
    
- BST: left child values are smaller, right child values are larger.
    
- AVL: balanced BST. Height is Θ(log n).
    
- Red-black tree: balanced BST with logarithmic height.
    
- Heap: complete binary tree satisfying the heap property.
    
- Hash table: uses a hash function to calculate where a key should be stored.
## 3. **BST height**

This is an important exam question.

The cost of BST operations depends on height h.

$$T(n)=\Theta(h)$$

**Two possibilities:**

- Balanced BST: \(h=\Theta(\log n)\).
    
- Unbalanced BST: \(h=\Theta(n)\).
    

>Example: inserting 1, 2, 3, 4, 5 in order can create a chain (twali 3adna linked list).

## **4. Hash tables**

Load factor: is used to decide when to resize and rehash the table to keep lookups and insertions fast at O(1) time.

$$\alpha=\frac{n}{m}$$

Where:

- n = number of stored elements.
    
- m = number of table slots (buckets).
    

Collisions happen when different keys produce the same hash index.

**Two common collision strategies (Methods to reduce this shit):**

- **Chaining**: store colliding elements in a linked list or another collection.
    
- **Open addressing**: search for another free position.
    

**Remember**:

- Expected search: Θ(1), under suitable hashing and load-factor assumptions.
    
- Worst-case search: Θ(n).
    
- A poor hash function increases collisions.

## **5. Amortized complexity**

- **Average-Case:** "On a _typical_ input, how fast is one operation?" (Relies on luck/probability).
- **Amortized:** "On the _worst possible_ sequence of inputs, what is the average cost per operation?" (A strict mathematical guarantee).

**Example: Dynamic array with doubling**

- Normal append: Θ(1).
    
- Append that triggers resizing: Θ(n).
    
- Amortized append: Θ(1).

## **6. Rotations**

![[AAC_Rotation.png]]

| Case | Imbalance         | Rotation     |
| ---- | ----------------- | ------------ |
| LL   | Left, then left   | Right        |
| RR   | Right, then right | Left         |
| LR   | Left, then right  | Left + Right |
| RL   | Right, then left  | Right + Left |

## **7. AVL**

> Bach évito nti7o fi unbalanced BST

For every node:

$$BF = Height(Left)-Height(Right)$$

An AVL tree requires:

$$BF \in \{-1,0,+1\}$$

- BF = +1: left subtree is higher.
    
- BF = 0: both subtrees have equal height.
    
- BF = -1: right subtree is higher.
    
- BF = +2 or -2: imbalance. You must rotate !!!

## **8. Black-Red**

> Bach évito nti7o fi unbalanced BST
> chouf video: https://www.youtube.com/watch?v=UFrg_XKFZ7M

**Two cases**
- Parent and Uncle -> RED, and new child -> red:
Recolor P, UN -> Black
GP (Grand Parent), Child -> Red

- Parent without Uncle -> RED, and new child -> red:
Rotation.
P -> Black