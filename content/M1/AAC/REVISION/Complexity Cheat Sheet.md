# Algorithm Complexity Notes

**Growth order:**

$$ \boxed{ 1<\log n<n<n\log n<n^2<n^3<2^n<n! } $$

---

# Part A: Quick Reference

## 1. Summations

![[AAC_summations.png]]

- $\sum_{i=1}^{n} 1 = n = O(n)$
- $\sum_{i=1}^{n} i = \frac{n(n+1)}{2} = O(n^2)$
- $\sum_{i=1}^{n} i^2 = \frac{n(n+1)(2n+1)}{6} = O(n^3)$
- $\sum_{i=0}^{k} 2^i = 2^{k+1} - 1 = O(2^k)$
- $\sum_{i=1}^{n} \frac{1}{i} = O(\log n)$

## 2. Loop Patterns

![[AAC_Loop_Patterns.png]]

|Pattern|Complexity|
|:--|:--|
|`i = i + 1`|$O(n)$|
|`i = i + c`|$O(n)$|
|`i = 2 * i`|$O(\log n)$|
|`i = i / 2`|$O(\log n)$|
|`i = i * i`|$O(\log \log n)$|
|Nested independent loops|$O(nm)$|
|Inner loop 1 to i|$O(n^2)$|
|Inner loop 1 to i²|$O(n^3)$|
|Doubling outer, inner 1 to i|$O(n)$|

## 3. Recurrences

![[AAC_Recurrences.png]]

|Recurrence|Complexity|
|:--|:--|
|$T(n) = T(n-1) + 1$|$O(n)$|
|$T(n) = T(n-1) + n$|$O(n^2)$|
|$T(n) = T(n/2) + 1$|$O(\log n)$|
|$T(n) = T(n/2) + n$|$O(n)$|
|$T(n) = 2T(n/2) + 1$|$O(n)$|
|$T(n) = 2T(n/2) + n$|$O(n \log n)$|
|$T(n) = 4T(n/2) + n$|$O(n^2)$|
|$T(n) = 2T(n-1) + 1$|$O(2^n)$|
|$T(n) = T(n-1) + T(n-2) + 1$|$O(\varphi^n)$|

---

# Part B: Analyzing Loops

## 4. Simple loops

```
for i = 1 to n:
    operation
```

$$ \Theta(n) $$

Changing the step by a constant does not change the complexity.

```
for i = 1 to n step 3:
    operation
```

Approximately n/3 iterations.

$$ \Theta(n) $$

A fixed loop:

```
for i = 1 to 100:
    operation
```

$$ \Theta(1) $$

The number of iterations does not depend on n.

## 5. Independent nested loops

```
for i = 1 to n:
    for j = 1 to m:
        operation
```

$$ T(n,m)=n\times m $$

$$ \boxed{\Theta(nm)} $$

If n = m:

$$ \Theta(n^2) $$

Example: matrix multiplication.

Three independent loops:

```
for i = 1 to n:
    for j = 1 to n:
        for k = 1 to n:
            operation
```

$$ T(n)=n^3 $$

$$ \boxed{\Theta(n^3)} $$

## 6. Dependent nested loops

> [!important] Exam topic This is one of the most important exam topics. When the inner loop depends on the outer counter, you cannot automatically multiply the iteration counts. You must calculate a sum.

### Example 1

```
for i = 1 to n:
    for j = 1 to i:
        operation
```

For each i, the inner loop executes i times. Therefore:

$$ T(n)=1+2+3+\cdots+n $$

Using the arithmetic sum:

$$ T(n)=\frac{n(n+1)}{2} $$

$$ \boxed{\Theta(n^2)} $$

### Example 2

```
for i = 1 to n:
    for j = 1 to i*i:
        operation
```

$$ T(n)=\sum_{i=1}^{n}i^2 $$

$$ T(n)=\frac{n(n+1)(2n+1)}{6} $$

$$ \boxed{\Theta(n^3)} $$

### Example 3

```
for i = 1 to n:
    for j = 1 to n:
        for k = 1 to j:
            operation
```

For each j, the innermost loop executes j times.

$$ T(n)=\sum_{i=1}^{n}\sum_{j=1}^{n}j $$

$$ T(n)=n\sum_{j=1}^{n}j $$

$$ T(n)=n\frac{n(n+1)}{2} $$

$$ \boxed{\Theta(n^3)} $$

## 7. Logarithmic loops

When a counter doubles or halves, the number of iterations is logarithmic.

```
i = 1

while i <= n:
    operation
    i = 2 * i
```

After k iterations:

$$ i=2^k $$

The loop stops when:

$$ 2^k>n $$

Taking logarithms:

$$ k>\log_2 n $$

Therefore:

$$ \boxed{\Theta(\log n)} $$

If the counter is squared each iteration:

```
i = 2

while i <= n:
    operation
    i = i * i
```

After k iterations:

$$ i=2^{2^k} $$

Therefore:

$$ \boxed{\Theta(\log\log n)} $$

## 8. Dependent logarithmic loop (very important)

```
i = 1

while i <= n:
    for j = 1 to i:
        operation

    i = 2 * i
```

The outer loop executes approximately $\log_2 n$ times, but the inner loop does not execute n times in every iteration.

The actual total is:

$$ T(n)=1+2+4+8+\cdots+2^k $$

Using the geometric sum:

$$ T(n)=2^{k+1}-1 $$

Since the final power is proportional to n:

$$ \boxed{\Theta(n)} $$

> [!warning] Important Do not automatically multiply $\log n$ by $n$. That would only give an upper bound, not the tight complexity.