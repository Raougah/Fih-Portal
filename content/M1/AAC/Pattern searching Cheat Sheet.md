## **Khasak ta3ref hado**

You have:

- T = Text, length n.
    
- P = Pattern, length m.
    
- σ = Alphabet size.
    
- occ = Number of occurrences.
    

Number of possible positions:

$$ n-m+1 $$

Example:

```
T = ABRACADABRA
P = ABRA
```

## **B. Naïve algorithm**

The algorithm checks every possible position and compares characters one by one.

Worst case:

$$ T(n,m)=(n-m+1)m $$

$$ \boxed{\Theta(nm)} $$

Best case: the first pattern character never appears in the text.

$$ \Theta(n) $$

Average case, under the independent uniform character assumption:

$$ \Theta(n) $$

Example of a worst-case input

```
T = AAAAAAAAAA
P = AAAAB
```

At each shift, four characters match and the last one fails. The algorithm repeats those comparisons.

## **C. Efficient pattern-matching algorithms**

Memorize this comparison:

|Algorithm|Main idea|Worst-case search|
|---|---|---|
|Naïve|Try every position|Θ(nm)|
|Rabin-Karp|Compare hashes|Θ(nm)|
|Finite automaton|Transition table|Θ(n)|
|KMP|Reuse previous matches|Θ(n)|
|Boyer-Moore-Horspool|Skip positions|Θ(nm)|
|Suffix tree|Index the text|Θ(m + occ)|

Important distinctions:

- Rabin-Karp uses hashing and rolling hashes.
    
- KMP uses a failure function.
    
- Boyer-Moore-Horspool compares from right to left.
    
- Finite automata use Θ(mσ) preprocessing and memory.
    
- Suffix trees require Θ(n) preprocessing.
    
## **D. KMP algorithm. Very important**

KMP avoids comparing characters that are already known to match.

The central concept is the failure function:

\[ \pi[i]=\text{length of longest proper border of }P[0..i] \]

A border is a string that is both:

- A proper prefix.
    
- A proper suffix.
    

Example:

```
String = ABABA

Prefixes: A, AB, ABA, ABAB
Suffixes: A, BA, ABA, BABA

Longest proper border = ABA
Length = 3
```

Therefore, its border length is 3.

### **Worked exercise: calculate π**

Given:

```
P = ABABAC
```

Calculate the longest proper border for every prefix.

|i|Prefix|π[i]|
|---|---|---|
|0|A|0|
|1|AB|0|
|2|ABA|1|
|3|ABAB|2|
|4|ABABA|3|
|5|ABABAC|0|

Final answer

\[ \boxed{\pi=[0,0,1,2,3,0]} \]

### **How to solve a KMP exercise**

1. Write the pattern.
    
2. Calculate the prefix function π.
    
3. Start comparing the pattern with the text.
    
4. When a mismatch occurs, use:
    

\[ k=\pi[k-1] \]

5. Continue without moving the text pointer backward.
    
6. When k = m, report the occurrence.
    

### **KMP complexity**

|Operation|Complexity|
|---|---|
|Compute π|Θ(m)|
|Search text|Θ(n)|
|Total|Θ(n + m)|
|Extra memory|Θ(m)|

QCM trap: KMP contains a nested while loop, but its complexity is not Θ(nm). It is amortized Θ(n) for matching.