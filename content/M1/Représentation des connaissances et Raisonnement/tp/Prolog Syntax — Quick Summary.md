## 1. Program Structure
A Prolog program has **three parts**:

| Element | Purpose | Example |
|---------|---------|---------|
| **Facts** | Things that are true | `pair(2).` |
| **Rules** | Conclusions based on conditions | `pair(N) :- N mod 2 =:= 0.` |
| **Queries** | Questions you ask | `?- pair(4).` → `true.` |

---

## 2. Variables vs Atoms

| Syntax | Meaning | Example |
|--------|---------|---------|
| `N`, `X`, `Result` | **Variable** (uppercase or `_`) | `pair(N).` |
| `salade`, `pair` | **Atom** (lowercase) | `entree(salade).` |
| `42`, `3` | **Number** | `somme(3, X).` |
| `_` | **Anonymous variable** | `entree(_).` |

> Variables are capitalized. Atoms are lowercase.

---

## 3. Rule Syntax

```
head :- condition1, condition2.
```

Read as: **head is true IF all conditions are true.**

| Operator | Meaning |
|----------|---------|
| `:-` | IF |
| `,` | AND |
| `;` | OR (in rules) / next solution (in CLI) |
| `.` | End of statement |

---

## 4. Arithmetic Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `is` | Evaluate expression | `X is 2 + 3.` → `X = 5` |
| `=:=` | Compare values | `5 =:= 2 + 3.` → `true` |
| `=\=` | Not equal (numeric) | `5 =\= 2 + 4.` |
| `<`, `>`, `=<`, `>=` | Comparisons | `3 < 5.` |
| `mod` | Remainder | `7 mod 2` |

⚠️ `X = 3 + 4` gives `X = 3+4` (no calculation). Use `is` to compute.

---

## 5. Unification (`=`)

`=` means **matching**, not assignment.

```
?- X = 5.        → X = 5.
?- 5 = 6.        → false.
```

Bindings are undone on **backtracking**.

---

## 6. Recursion

Needs **two parts**:
- **Base case** — stops recursion
- **Recursive case** — reduces the problem

```prolog
somme(0, 0).
somme(N, X) :-
    N > 0,
    N1 is N - 1,
    somme(N1, X1),
    X is X1 + N.
```

`?- somme(3, X).` → `X = 6`

---

## 7. The Cut `!`

Commits to choices made — **prevents backtracking** within the current predicate.

```prolog
p(1).
p(2) :- !.
p(3).
```

`?- p(X).` → `X = 1 ; X = 2.` (never returns `X = 3`)

---

## 8. File (`.pl`) vs CLI

| File (`tp2.pl`) | CLI |
|-----------------|-----|
| Contains **facts & rules** | Ask **queries** |
| Load with `?- [tp2].` | Type `?- query.` |

---

## 9. Key Things to Master for the TP

✅ `:-` (IF)
✅ Variables (uppercase) vs atoms (lowercase)
✅ `,` (AND)
✅ `is` (evaluate) vs `=:=` (compare)
✅ Recursive rules
✅ `!` (cut)