> [!abstract] **The Golden Principle of the Module**
> **Optimization means finding the best possible solution while respecting the problem's restrictions.**

---

## Timeline of the Six Courses

1. **[[#Cours 1. Fundamentals of optimization|Cours 1: Introduction to optimization]]** — Understand optimization, variables, objective functions, constraints, classification, convexity, norms, and distances.
2. **[[#Cours 2. Unconstrained optimization|Cours 2: Unconstrained optimization]]** — Find minimums using derivatives, gradients, Hessians, Gradient Descent, Newton, and BFGS.
3. **[[#Cours 3. Constrained optimization|Cours 3: Constrained optimization]]** — Find the best solution while respecting restrictions using Lagrange, KKT, penalties, and barriers.
4. **[[#Cours 4. Convex optimization|Cours 4: Convex optimization]]** — Understand convex functions, convex sets, mathematical properties, optimality, and duality.
5. **[[#Cours 5. Mathematical programming|Cours 5: Mathematical programming]]** — Solve practical optimization problems using Linear Programming, Simplex, Interior-Point methods, and Quadratic Programming.
6. **[[#Cours 6. Stochastic optimization|Cours 6: Stochastic optimization]]** — Train machine learning models using SGD, Momentum, AdaGrad, RMSProp, and Adam.

---

# Cours 1. Fundamentals of optimization
*Chapter 1, Part 1*

## 1. What is optimization?

Optimization is the process of finding the **best possible configuration** of a system according to a specific objective.

There are two main possibilities:
- **Minimization:** find the smallest value.
- **Maximization:** find the largest value.

| Problem | Objective |
| :--- | :--- |
| Reduce production costs | **Minimize** |
| Increase company profit | **Maximize** |
| Reduce prediction error | **Minimize** |
| Increase network performance | **Maximize** |

### The Three Essential Elements

Every optimization problem has three main elements:

1. **Decision variables** — These are the values we can control.
   - *Example:* A factory produces two products: $x_1$ (quantity of product A) and $x_2$ (quantity of product B).
   - We represent them using a vector, where $n$ is the number of variables:
     $$x = (x_1, x_2, \ldots, x_n)^T$$
2. **Objective function** — Describes what we want to optimize.
   - *Example:* If A earns €40 and B earns €30, total profit is:
     $$J(x_1, x_2) = 40x_1 + 30x_2$$
3. **Constraints** — Restrictions that variables must respect.
   - *Example:* Production cannot exceed 100 available hours, and you cannot produce negative quantities:
     $$2x_1 + x_2 \leq 100, \qquad x_1 \geq 0, \quad x_2 \geq 0$$

> [!important] **General Mathematical Formulation**
> $$\boxed{\min_{x \in U} J(x)}$$
> - $x$: decision variables.
> - $J(x)$: objective function.
> - $U$: feasible set, containing all allowed solutions.
> - **Admissible solution:** $x \in U$.
> - **Optimal solution ($x^*$):** $J(x^*) \leq J(x), \quad \forall x \in U$.

---

## 2. Local Minimum vs Global Minimum

> [!tip] **High-Yield QCM Topic**
> - **Local minimum:** The lowest value in a **small neighborhood** around a point:
>   $$f(x^*) \leq f(x) \quad \text{for all } x \text{ sufficiently close to } x^*$$
> - **Global minimum:** The lowest value over the **entire feasible domain**:
>   $$f(x^*) \leq f(x), \quad \forall x \in U$$
> 
> **Key Rule:** A global minimum is also a local minimum if the domain contains a neighborhood around it. **The reverse is not necessarily true.** The same logic applies to maxima, with inequalities reversed.

---

## 3. Classification of Optimization Problems

Your first course classifies optimization problems using **seven criteria**:

### A. According to the presence of constraints
- **Unconstrained optimization:** No restrictions on the decision variables.
  $$\min f(x) = x^2 + 4x + 5$$
- **Constrained optimization:** Variables must respect equality or inequality conditions.
  $$\max 40x_1 + 30x_2 \quad \text{s.t.} \quad 2x_1 + x_2 \leq 100, \quad x_1 \leq 40, \quad x_1, x_2 \geq 0$$

### B. According to the nature of variables

| Type | Meaning | Mathematical Example | Practical Example |
| :--- | :--- | :--- | :--- |
| **Continuous** | Any real value | $x = 2.5$ | Vehicle speed |
| **Discrete** | Specific values, often integers | $x = 1, 2, 3$ | Number of machines |
| **Binary** | Only $0$ or $1$ | Select ($1$) or reject ($0$) | Whether to open a factory |
| **Mixed** | Continuous and discrete together | $(x_1 \in \mathbb{Z}, x_2 \in \mathbb{R})$ | Number of machines + continuous production quantities |

> [!warning] **QCM Trap**
> Binary variables are a **special case of discrete variables**.

### C. According to mathematical structure
- **Linear optimization (LP):** Objective function and constraints are linear.
  $$\max 3x_1 + 2x_2 \quad \text{s.t.} \quad x_1 + x_2 \leq 10$$
- **Nonlinear optimization (NLP):** At least one of the objective function or constraints is nonlinear.
  $$f(x) = \sin(x) + x^2$$
- **Quadratic optimization (QP):** Objective function contains quadratic terms, usually with linear constraints.
  $$f(x) = x^2 + 2y^2$$

### D. According to the nature of data
- **Deterministic optimization:** All data are known and fixed (e.g., transport problem with known distances and costs).
- **Stochastic optimization:** Some data are uncertain or random (e.g., stock management when customer demand changes randomly).

### E. According to the number of objectives
- **Mono-objective:** One objective function (e.g., minimize production cost).
- **Multi-objective:** Several objectives that may conflict (e.g., minimize cost, maximize quality, minimize delivery time). You search for a compromise.

### F. According to time dependence
- **Static optimization:** Objective and constraints do not change with time (e.g., choose production quantities for a fixed planning period).
- **Dynamic optimization:** Decisions and conditions evolve over time (e.g., manage a water reservoir over several days).

### G. According to geometry
- **Convex optimization** vs **Non-convex optimization** (studied below).

---

## 4. Convex Sets

An ensemble $C$ is **convex** if the line segment between any two points in the set remains completely inside the set:

$$\boxed{\lambda x + (1 - \lambda)y \in C} \quad \text{for } x, y \in C, \quad \lambda \in [0, 1]$$

- $x$ and $y$ are two points; $\lambda$ controls the position between them, and $1-\lambda$ controls the remaining proportion.
- **Convex set:** Every segment remains inside.
- **Non-convex set:** Some segments leave the set.

> [!note] **Important Property**
> The **intersection** of any number of convex sets is always **convex**.

---

## 5. Convex Functions

A function is convex when its graph has a **bowl-like shape**:

$$f(\lambda x + (1 - \lambda)y) \leq \lambda f(x) + (1 - \lambda)f(y) \quad \forall x, y \in \text{dom}(f), \quad \lambda \in [0, 1]$$

For a function of one variable, a useful test throughout its domain is:
$$\boxed{f''(x) \geq 0}$$

> [!example] **Example: $f(x) = x^2$**
> - First derivative: $f'(x) = 2x$
> - Second derivative: $f''(x) = 2$
> - Since $2 \geq 0$, the function is **convex**.

### Types of Convexity

| Type | Rule | Meaning |
| :--- | :--- | :--- |
| **Convex** | $\leq$ | Bowl shape |
| **Strictly convex** | $<$ for distinct points and interior $\lambda \in (0,1)$ | Strict bowl shape |
| **Strongly convex** | Convex with a positive curvature bound | Has guaranteed curvature |
| **Concave** | $-f$ is convex ($f''(x) \leq 0$ in 1D) | Upside-down bowl |

> [!important] **Fundamental Theorem of Convexity**
> For a **convex function** minimized over a **convex set**:
> **Every local minimum is also a global minimum.**
> *(This is one of the most important facts in the entire module.)*

---

## 6. Convex vs Non-Convex Optimization

| Feature | Convex Optimization | Non-Convex Optimization |
| :--- | :--- | :--- |
| **Optimum guarantee** | Global optimum guaranteed when it exists | Multiple local minima possible |
| **Behavior** | No bad local minima; predictable | Algorithms can get stuck; depends on initialization |
| **Course Examples** | Linear regression, SVM, Linear programming, Convex QP | Deep neural networks, Traveling Salesman Problem (TSP), Complex combinatorial optimization |
| **Typical Methods** | Gradient Descent, LP and QP solvers | Metaheuristics, simulated annealing, genetic algorithms |

---

## 7. Norms and Distances

A **norm** measures the size or length of a vector $x = (x_1, x_2, \ldots, x_n)$.

- **L1 norm (Manhattan):** Sums absolute values.
  $$\boxed{\|x\|_1 = \sum_{i=1}^{n} |x_i|} \quad \xrightarrow{x=(3,-4)} \quad \|x\|_1 = 3 + 4 = 7$$
- **L2 norm (Euclidean):** Euclidean length.
  $$\boxed{\|x\|_2 = \sqrt{\sum_{i=1}^{n} x_i^2}} \quad \xrightarrow{x=(3,-4)} \quad \|x\|_2 = \sqrt{3^2 + (-4)^2} = 5$$
- **L-infinity norm ($L_\infty$):** Maximum absolute component.
  $$\boxed{\|x\|_\infty = \max_i |x_i|} \quad \xrightarrow{x=(3,-4)} \quad \|x\|_\infty = \max(3, 4) = 4$$

### Distance Induced by a Norm
$$\boxed{d(x, y) = \|x - y\|} \qquad \text{Euclidean: } d(x, y) = \sqrt{\sum_i (x_i - y_i)^2}$$

### Why do we use norms?
- Measure distances between points and errors.
- Check algorithm convergence and measure the size of gradients.
- **Regularize ML models:** In **Ridge regression**, $L_2$ regularization penalizes large weights. In **Lasso**, $L_1$ regularization encourages sparse weights.

> [!warning] **Four Properties of a Valid Norm (QCM Trap: A norm is never negative)**
> 1. **Non-negativity:** $\|x\| \geq 0$
> 2. **Zero condition:** $\|x\| = 0 \iff x = 0$
> 3. **Homogeneity:** $\|\alpha x\| = |\alpha|\|x\|$
> 4. **Triangle inequality:** $\|x + y\| \leq \|x\| + \|y\|$

---

# Cours 2. Unconstrained optimization
*Chapter 1, Part 2*

> [!question] **Core Question**
> How can we find the minimum of a mathematical function **without constraints** using **Gradient Descent**, **Newton**, and **Quasi-Newton (BFGS)**?

## 1. Derivative (1D)

The derivative $f'(x)$ measures the slope of a function:

| Derivative | Meaning |
| :--- | :--- |
| $f'(x) > 0$ | Function is increasing |
| $f'(x) < 0$ | Function is decreasing |
| $f'(x) = 0$ | **Stationary point** |

- *Example:* $f(x) = x^2 \implies f'(x) = 2x$. At $x=3$, $f'(3)=6$ (increasing); at $x=-3$, $f'(-3)=-6$ (decreasing); at $x=0$, $f'(0)=0$ (minimum).
- **Important:** A zero derivative does **not** automatically mean a minimum; it can also be a maximum or saddle point.

### Essential Derivative Rules

| Function | Derivative |
| :--- | :--- |
| $x^n$ | $nx^{n-1}$ |
| $af(x)$ | $af'(x)$ |
| $f(x) + g(x)$ | $f'(x) + g'(x)$ |
| $f(x)g(x)$ | $f'(x)g(x) + f(x)g'(x)$ |
| $e^x$ | $e^x$ |
| $\sin x$ | $\cos x$ |
| $\cos x$ | $-\sin x$ |

---

## 2. Gradient (Multi-variable)

The **gradient** extends the derivative to multiple variables and points in the direction of **greatest increase**:

$$\boxed{\nabla f(x, y) = \begin{pmatrix} \frac{\partial f}{\partial x} \\ \frac{\partial f}{\partial y} \end{pmatrix}} \qquad \text{Direction of greatest local decrease: } \boxed{p = -\nabla f(x)}$$

> [!example] **Example**
> Let $f(x, y) = x^2 + y^2$. Then $\nabla f(x, y) = (2x, 2y)$.
> At point $(1, 2)$: $\nabla f(1, 2) = (2, 4)$, so the steepest descent direction is $p = (-2, -4)$.

> [!tip] **QCM Rules**
> - Gradient = greatest increase (vector).
> - Negative gradient = greatest local decrease (vector).
> - Derivative in one variable = scalar.

---

## 3. Hessian Matrix

The **Hessian** measures the **curvature** of a function (in 1D: $H = f''(x)$):

$$\boxed{H = \begin{pmatrix} f_{xx} & f_{xy} \\ f_{yx} & f_{yy} \end{pmatrix}}$$

- *Example:* For $f(x, y) = x^2 + 4y^2$, $f_x = 2x$, $f_y = 8y$, so:
  $$H = \begin{pmatrix} 2 & 0 \\ 0 & 8 \end{pmatrix}$$

### Identifying Stationary Points via the Hessian

For a twice-differentiable function at a stationary point ($\nabla f = 0$):

| Hessian at stationary point | Result |
| :--- | :--- |
| **Positive definite** | Strict local minimum |
| **Negative definite** | Strict local maximum |
| **Indefinite** | Saddle point |
| **Positive semidefinite** | Minimum test is inconclusive in general |
| **Negative semidefinite** | Maximum test is inconclusive in general |

> [!important] **2 × 2 Symmetric Hessian Determinant Test**
> Calculate $D = f_{xx}f_{yy} - (f_{xy})^2$ at a stationary point:
> - $D > 0$ and $f_{xx} > 0 \implies$ **Minimum**
> - $D > 0$ and $f_{xx} < 0 \implies$ **Maximum**
> - $D < 0 \implies$ **Saddle point**
> - $D = 0 \implies$ **Inconclusive**

---

## 4. The General Iterative Algorithm

All three descent methods follow the same iterative update:

$$\boxed{x_{k+1} = x_k + \alpha_k p_k}$$

- $x_k$: current point | $p_k$: search direction | $\alpha_k$: step size | $x_{k+1}$: next point.
- **Valid descent direction condition:** $\boxed{\nabla f(x_k)^T p_k < 0}$ (function decreases locally).
- **Stopping criterion:** Repeat until $\boxed{\|\nabla f(x_k)\| < \varepsilon}$ (or max iterations reached).

---

## 5. Line Search (*Recherche Linéaire*)

Line search determines **how far to move** (step size $\alpha$) along direction $p_k$:
- Very small step $\implies$ slow convergence.
- Very large step $\implies$ may overshoot the minimum and increase the function.

### A. Exact Line Search
Solves a 1D minimization problem: $\boxed{\min_{\alpha > 0} f(x + \alpha p)}$.
- *Example:* $f(x) = (x - 2)^2$, $x_0 = 0$, $p = 1 \implies f(\alpha) = (\alpha - 2)^2$. Setting $2(\alpha - 2) = 0 \implies \boxed{\alpha = 2}$, giving $x_1 = 0 + 2(1) = 2$.

### B. Inexact Line Search (Armijo & Wolfe)
Finds a step that decreases the function **sufficiently** (faster and more practical):
- **Armijo condition (sufficient decrease):**
  $$\boxed{f(x + \alpha p) \leq f(x) + c_1 \alpha \nabla f(x)^T p} \qquad (\text{typically } c_1 = 10^{-4})$$
- **Wolfe conditions:** Armijo sufficient decrease + a curvature condition.

#### Backtracking Line Search Algorithm
```text
alpha = 1
while Armijo condition is false:
    alpha = alpha / 2
return alpha
```

| Exact Line Search | Inexact Line Search |
| :--- | :--- |
| Finds optimal step | Finds sufficient step |
| More calculations (1D minimization) | Usually faster and practical (Armijo / Wolfe) |

---

## 6. Gradient Descent

Moves directly in the opposite direction of the gradient:

$$\boxed{x_{k+1} = x_k - \alpha \nabla f(x_k)}$$

> [!example] **Worked Example: $f(x) = x^2$, $x_0 = 4$, $\alpha = 0.25$**
> - Gradient: $f'(x) = 2x$. General step: $x_{k+1} = (1 - 2\alpha)x_k$.
> - Iteration 1: $x_1 = 4 - 0.25(8) = 2$
> - Iteration 2: $x_2 = 2 - 0.25(4) = 1$
> - Iteration 3: $x_3 = 1 - 0.25(2) = 0.5$
> 
> **Effect of learning rate $\alpha$:**
> - $\alpha = 0.25 \implies$ Converges gradually.
> - $\alpha = 0.5 \implies$ Reaches minimum in **one iteration**.
> - $\alpha = 1.1 \implies$ **Diverges**.

- **Advantages:** Simple, low computational cost ($O(n)$), requires only the gradient, suitable for high dimensions.
- **Disadvantages:** Can converge slowly, sensitive to learning rate, zigzags in narrow valleys.

---

## 7. Newton's Method

Uses both the **gradient** and the **Hessian** (curvature):

$$\boxed{x_{k+1} = x_k - H_k^{-1}\nabla f(x_k)} \quad \Longleftrightarrow \quad \text{Solve } H_k p_k = -\nabla f(x_k), \quad x_{k+1} = x_k + \alpha p_k$$
*(Usually $\alpha = 1$ near the minimum.)*

> [!example] **Worked Example: $f(x, y) = x^2 + 4y^2$, $x_0 = (4, 1)$**
> - Gradient: $g = (8, 8)$ | Hessian: $H = \begin{pmatrix} 2 & 0 \\ 0 & 8 \end{pmatrix}$
> - Solve $Hp = -g \implies 2p_1 = -8 \Rightarrow p_1 = -4$, and $8p_2 = -8 \Rightarrow p_2 = -1 \implies p = (-4, -1)$.
> - Update: $x_1 = (4, 1) + (-4, -1) = \boxed{(0, 0)}$ (**1 iteration** because the objective is quadratic with constant Hessian!).

- **Advantages:** Very fast near the minimum (**quadratic convergence**); minimizes a quadratic in 1 iteration.
- **Disadvantages:** Expensive ($O(n^3)$); requires exact Hessian; can behave badly far from solution; **finds a stationary point, not automatically a minimum** (if $H$ is not positive definite).

---

## 8. Quasi-Newton: BFGS

**BFGS** (*Broyden-Fletcher-Goldfarb-Shanno*) achieves Newton-like speed **without computing the exact Hessian**, by approximating the **inverse Hessian** $H_k$ from gradient differences:

$$\boxed{p_k = -H_k \nabla f(x_k)}$$

Using $s_k = x_{k+1} - x_k$, $y_k = \nabla f(x_{k+1}) - \nabla f(x_k)$, and $\rho_k = \frac{1}{y_k^T s_k}$:

$$H_{k+1} = (I - \rho_k s_k y_k^T) H_k (I - \rho_k y_k s_k^T) + \rho_k s_k s_k^T$$

- **Why use BFGS?** Avoids exact Hessian ($O(n^2)$ cost per iteration) and achieves **superlinear convergence** near a solution (converges in at most $n$ iterations on an $n$-dimensional quadratic with exact line search).

---

## 9. Comparison of the Three Methods

| Criterion | Gradient Descent | Newton | BFGS |
| :--- | :--- | :--- | :--- |
| **Uses gradient** | Yes | Yes | Yes |
| **Uses exact Hessian** | No | Yes | No |
| **Stores Hessian approx.** | No | No | Yes (inverse Hessian) |
| **Cost per iteration** | Low — $O(n)$ | High — $O(n^3)$ | Medium — $O(n^2)$ |
| **Convergence near optimum** | Linear | Quadratic | Superlinear |
| **Best use** | Very large problems | Small problems | Medium-sized problems |

---

## 10. Rate of Convergence & Condition Number

Let $e_k = \|x_k - x^*\|$ be the error at iteration $k$:

1. **Linear convergence (Gradient Descent):** $e_{k+1} \approx C e_k$ (e.g., $1, 0.5, 0.25, 0.125$).
2. **Superlinear convergence (BFGS):** $\frac{e_{k+1}}{e_k} \rightarrow 0$.
3. **Quadratic convergence (Newton):** $e_{k+1} \approx C e_k^2$ (e.g., $10^{-1}, 10^{-2}, 10^{-4}, 10^{-8}$).

$$\boxed{\text{Quadratic} > \text{Superlinear} > \text{Linear}}$$

### Condition Number ($\kappa$)
For a positive definite Hessian:
$$\boxed{\kappa = \frac{\lambda_{\max}}{\lambda_{\min}}}$$

- *Example:* For $H = \begin{pmatrix} 2 & 0 \\ 0 & 8 \end{pmatrix}$, eigenvalues are $2$ and $8$, so $\kappa = \frac{8}{2} = 4$.
- **Small $\kappa$:** Easy optimization.
- **Large $\kappa$:** Narrow valleys and slow convergence for Gradient Descent. On a positive definite quadratic with optimal fixed step, the objective error decreases by factor:
  $$\rho = \left(\frac{\kappa - 1}{\kappa + 1}\right)^2 \xrightarrow{\kappa \to \infty} 1$$

> [!warning] **Common Mistakes in Cours 2**
> - Using $+\nabla f$ instead of $-\nabla f$ for minimization.
> - Confusing gradient (1st derivatives, vector) with Hessian (2nd derivatives, matrix).
> - Assuming $\nabla f = 0$ always means a minimum, or that Newton always finds a minimum.
> - Thinking BFGS computes the exact Hessian.
> - Confusing **quadratic convergence** (speed) with a **quadratic objective function** (shape).

---

# Cours 3. Constrained optimization
*Chapter 1, Part 3*

## 1. General Formulation & Feasible Set

$$\boxed{\min f(x)} \quad \text{subject to} \quad h_j(x) = 0 \text{ (equality)}, \quad g_i(x) \leq 0 \text{ (inequality)}$$

- **Feasible set:** $U = \{x : g_i(x) \leq 0, \; h_j(x) = 0\}$.

### Active vs Inactive Inequality Constraints
For $g_i(x) \leq 0$:
- **Active constraint:** $\boxed{g_i(x) = 0}$ (at the boundary limit).
- **Inactive constraint:** $\boxed{g_i(x) < 0}$ (strictly inside; not limiting the current solution).
- *Example:* $x \leq 10 \iff g(x) = x - 10 \leq 0$. At $x=10$: **active**; at $x=5$: **inactive**; at $x=12$: **infeasible**.

---

## 2. Lagrange Multipliers (Equality Constraints)

For $\min f(x, y)$ subject to $h(x, y) = 0$, construct the **Lagrangian**:

$$\boxed{L(x, y, \lambda) = f(x, y) + \lambda h(x, y)}$$

Solve: $\frac{\partial L}{\partial x} = 0$, $\frac{\partial L}{\partial y} = 0$, $\frac{\partial L}{\partial \lambda} = 0$.

> [!example] **Worked Example: $\min f(x, y) = x^2 + y^2$ s.t. $x + y = 2$**
> - $L = x^2 + y^2 + \lambda(x + y - 2)$
> - Derivatives: $2x + \lambda = 0$, $2y + \lambda = 0$, $x + y - 2 = 0 \implies x = y \implies 2x = 2$.
> - Solution: $\boxed{x = 1, \quad y = 1}$, with $f(1, 1) = 2$.
> - *Note:* Lagrange gives **candidate points**; it does not automatically prove global optimality for non-convex problems.

---

## 3. KKT Conditions (Karush-Kuhn-Tucker)

Extends Lagrange to both **inequality** ($g_i(x) \leq 0$) and **equality** ($h_j(x) = 0$) constraints. Using the PDF's Lagrangian convention:

$$\boxed{L = f(x) + \sum_i \mu_i g_i(x) - \sum_j \lambda_j h_j(x)}$$

> [!important] **The Four KKT Conditions**
> 1. **Stationarity:** $\boxed{\nabla f + \sum_i \mu_i \nabla g_i - \sum_j \lambda_j \nabla h_j = 0}$ (gradients and constraint forces balance).
> 2. **Primal feasibility:** $\boxed{g_i(x) \leq 0, \quad h_j(x) = 0}$ (respects original constraints).
> 3. **Dual feasibility:** $\boxed{\mu_i \geq 0}$ (inequality multipliers must be non-negative).
> 4. **Complementary slackness:** $\boxed{\mu_i g_i(x) = 0}$
>    - If active ($g_i(x) = 0$), $\mu_i$ may be $> 0$.
>    - If inactive ($g_i(x) < 0$), $\mu_i$ **must** be $0$.

> [!example] **Worked Example: $\min f(x) = x^2$ s.t. $x \geq 2$**
> - Rewrite: $g(x) = 2 - x \leq 0$. Lagrangian: $L = x^2 + \mu(2 - x)$.
> - Conditions: $2x - \mu = 0$, $x \geq 2$, $\mu \geq 0$, $\mu(2 - x) = 0$.
> - Unconstrained minimum $x = 0$ is infeasible, so the optimum is on the boundary: $\boxed{x^* = 2}$, $\mu = 4$, $f(x^*) = 4$.

- **Sufficiency vs Necessity:** For a **convex** problem (with regularity assumptions), KKT conditions are **sufficient for global optimality**. For a **non-convex** problem, they are generally **necessary** (under constraint qualifications), **not sufficient**.

### Lagrange vs KKT

| Lagrange | KKT |
| :--- | :--- |
| Mainly equality constraints | Equality and inequality constraints |
| Stationarity equations | Four conditions |
| No inequality multiplier sign rule in basic equality case | Dual feasibility $\mu_i \geq 0$ + complementarity |
| Finds candidates | Finds candidates; sufficient in convex problems |

---

## 4. Penalty Methods vs Barrier Methods

### Penalty Methods
Adds a cost when constraints are violated ($r > 0$ is the penalty parameter):
- Equality $h(x) = 0$: $\boxed{F(x) = f(x) + r h(x)^2}$
- Inequality $g(x) \leq 0$: $F(x) = f(x) + r \max(0, g(x))^2$
- As $r$ increases, violations become more expensive (though very large $r$ causes numerical ill-conditioning).

### Barrier Methods
Prevents the algorithm from reaching the boundary ($g(x) < 0$, $\mu > 0$):
$$\boxed{F(x) = f(x) - \mu \log(-g(x))}$$
- As $g(x) \to 0^-$, $-\mu \log(-g(x)) \to +\infty$.

| Penalty Methods | Barrier Methods |
| :--- | :--- |
| Penalizes violations | Prevents reaching boundary |
| Can allow infeasible points | Requires a **strictly feasible** starting point |
| Penalty parameter $r$ often increases | Barrier parameter $\mu$ gradually decreases |

> [!warning] **QCM Trap**
> A logarithmic barrier is defined **strictly inside** the feasible region ($g(x) < 0$), never outside it.

---

# Cours 4. Convex optimization
*Chapter 2, Part 1*

## 1. Structure of a Convex Optimization Problem

$$\min f(x) \quad \text{subject to} \quad g_i(x) \leq 0, \quad Ax = b$$

1. **Objective function $f(x)$:** Must be **convex**.
2. **Inequality constraints $g_i(x)$:** Must be **convex functions**.
3. **Equality constraints $h(x) = Ax - b$:** Must be **affine** ($a^T x + b$; linear is a special case).

---

## 2. Verifying Convexity via the Hessian

Compute $H(x) = \nabla^2 f(x)$ and examine its eigenvalues:

| Eigenvalues | Hessian | Conclusion |
| :--- | :--- | :--- |
| **All positive** ($\lambda_i > 0$) | Positive definite | **Strictly convex** |
| **All non-negative** ($\lambda_i \geq 0$) | Positive semidefinite ($\succeq 0$) | **Convex** |
| **Mixed signs** ($>0$ and $<0$) | Indefinite | **Non-convex** |
| **All non-positive** ($\lambda_i \leq 0$) | Negative semidefinite | **Concave** |

> [!tip] **Quick 2 × 2 Symmetric Hessian Test**
> For $H = \begin{pmatrix} a & b \\ b & c \end{pmatrix}$:
> - **Positive definite (strictly convex):** $a > 0$ and $ac - b^2 > 0$.
> - **Positive semidefinite (convex):** $a \geq 0$, $c \geq 0$, and $ac - b^2 \geq 0$.
> 
> *Examples:*
> - $f(x, y) = x^2 + xy + y^2 \implies H = \begin{pmatrix} 2 & 1 \\ 1 & 2 \end{pmatrix}$ ($\lambda = 1, 3 > 0$) $\implies$ **Strictly convex**.
> - $f(x, y) = x^2 - y^2 \implies H = \begin{pmatrix} 2 & 0 \\ 0 & -2 \end{pmatrix}$ ($\lambda = 2, -2$) $\implies$ **Non-convex** (saddle).

---

## 3. Key Properties, Strong Convexity & Feasible Sets

- **Property 1 (Global Optimality):** Every local minimum of a convex function on a convex domain is a **global minimum** (unique if strictly convex).
- **Property 2 (First-Order Condition):** For differentiable convex $f$, the tangent lies below the graph:
  $$\boxed{f(y) \geq f(x) + \nabla f(x)^T(y - x)} \qquad \text{and} \qquad \boxed{\nabla f(x^*) = 0} \iff x^* \text{ is global min}$$
- **Property 3 (Second-Order Condition):** $\boxed{\nabla^2 f(x) \succeq 0}$.
- **Strong Convexity:** Guaranteed positive curvature $\alpha > 0$:
  $$f(ty + (1 - t)x) \leq tf(y) + (1 - t)f(x) - \alpha t(1 - t)\|y - x\|^2$$
  *(Guarantees a unique minimizer and faster convergence rates.)*

> [!warning] **Feasible Set QCM Trap**
> If $g$ is convex, its sublevel set $g(x) \leq 0$ is **convex** (e.g., $x^2 + y^2 \leq 4$, a filled disk).
> However, $x^2 + y^2 = 4$ (only the circumference) is **not a convex set**!

---

## 4. Duality & SVM Interpretation

From the Lagrangian $L(x, \mu) = f(x) + \sum_i \mu_i g_i(x)$ ($\mu \geq 0$), we define the **dual function** and **dual problem**:

$$\boxed{q(\mu) = \inf_x L(x, \mu)} \qquad \Longrightarrow \qquad \boxed{\max_{\mu \geq 0} q(\mu)}$$

- **Weak Duality (Always holds):** $\boxed{d^* \leq p^*}$ (dual optimum is a lower bound on primal optimum).
- **Strong Duality (Zero duality gap):** $\boxed{d^* = p^*}$. Holds for convex problems under **Slater's condition** (existence of a strictly feasible point where $g_i(x) < 0$ for all inequalities).

### Application to Support Vector Machines (SVM)
- **Primal:** $\min_{w, b} \frac{1}{2}\|w\|^2 \quad \text{s.t.} \quad y_i(w^T x_i + b) \geq 1$.
- **Dual:** $\max_\alpha \sum_i \alpha_i - \frac{1}{2}\sum_i \sum_j \alpha_i \alpha_j y_i y_j (x_i^T x_j) \quad \text{s.t.} \quad \alpha_i \geq 0, \; \sum_i \alpha_i y_i = 0$.
- **Why the dual is vital in AI:**
  1. Uses scalar products $(x_i^T x_j)$, enabling the **kernel trick** for nonlinear boundaries.
  2. Nonzero $\alpha_i > 0$ identify the **support vectors**.

---

# Cours 5. Mathematical programming
*Chapter 2, Part 2*

## 1. Three Main Families

| Type | Objective Function | Constraints |
| :--- | :--- | :--- |
| **Linear Programming (LP)** | Linear | Linear |
| **Quadratic Programming (QP)** | Quadratic | Generally linear |
| **Nonlinear Programming (NLP)** | Nonlinear | Linear or nonlinear |

---

## 2. Linear Programming (LP) & Graphical Resolution

$$\max Z = c_1 x_1 + c_2 x_2 + \cdots + c_n x_n \quad \text{s.t.} \quad Ax \leq b, \quad x \geq 0$$

> [!important] **Fundamental Theorem of LP**
> If an LP problem has a finite optimal solution, **at least one optimal solution occurs at a vertex** of the feasible region.

> [!example] **Graphical Example: $\max Z = 3x_1 + 5x_2$ s.t. $2x_1 + 2x_2 \leq 10$, $x_1 + 2x_2 \leq 8$, $x_1, x_2 \geq 0$**
> Candidate vertices:
> - $(0, 0) \implies Z = 0$
> - $(4, 0) \implies Z = 12$
> - $(0, 4) \implies Z = 20$
> - $(2, 3) \implies Z = 3(2) + 5(3) = \boxed{21}$ (Optimal: $x_1 = 2, x_2 = 3$)

---

## 3. The Simplex Method

Moves from vertex to neighboring improving vertices until no improvement is possible.

### Step-by-Step Walkthrough ($\max Z = 3x_1 + 2x_2$ s.t. $x_1 + x_2 \leq 4$, $x_1 + 3x_2 \leq 6$)

1. **Convert to standard form** using non-negative **slack variables** ($s_i \geq 0$, representing unused resources):
   $$x_1 + x_2 + s_1 = 4, \qquad x_1 + 3x_2 + s_2 = 6$$
2. **Initial Tableau** (starts at origin $x_1 = x_2 = 0, s_1 = 4, s_2 = 6, Z = 0$):

| Base | $x_1$ | $x_2$ | $s_1$ | $s_2$ | RHS |
| :--- | :---: | :---: | :---: | :---: | :---: |
| $s_1$ | **1** | 1 | 1 | 0 | 4 |
| $s_2$ | 1 | 3 | 0 | 1 | 6 |
| **Costs** | **3** | 2 | 0 | 0 | 0 |

3. **Entering variable:** Largest positive reduced cost ($3 > 2$) $\implies$ $\boxed{x_1 \text{ enters}}$.
4. **Leaving variable (Minimum Ratio Test):** $\boxed{\text{Ratio} = \frac{\text{RHS}}{\text{positive coefficient}}}$ (ignore $\leq 0$ coefficients):
   - Row $s_1$: $4 / 1 = 4$ (smallest) $\implies$ $\boxed{s_1 \text{ leaves}}$.
   - Row $s_2$: $6 / 1 = 6$.
5. **Pivot** on intersection (value = $1$) and update rows:

| Base | $x_1$ | $x_2$ | $s_1$ | $s_2$ | RHS |
| :--- | :---: | :---: | :---: | :---: | :---: |
| $x_1$ | 1 | 1 | 1 | 0 | 4 |
| $s_2$ | 0 | 2 | -1 | 1 | 2 |
| **Costs** | 0 | -1 | -3 | 0 | **12** |

6. **Optimality Check:** All reduced costs are $\leq 0$ ($0, -1, -3, 0$). Stop!
   $$\boxed{x_1 = 4, \quad x_2 = 0, \quad Z_{\max} = 12}$$

---

## 4. Interior-Point Methods

Moves through the **interior** of the feasible region using a logarithmic barrier $-\mu \log(s_i)$ on positive slacks $s_i$:
$$\phi(x; \mu) = -3x_1 - 2x_2 - \mu \sum_i \log(s_i) \qquad (\text{as } \mu \to 0, \text{ converges to optimum})$$

| Simplex | Interior-Point Methods |
| :--- | :--- |
| Moves along edges / visits vertices | Moves inside the feasible region |
| Uses pivots | Uses optimization directions and barriers |
| **Exponential** worst-case complexity | **Polynomial-time** complexity |

---

## 5. Quadratic Programming (QP) & Applications

$$\boxed{\min \frac{1}{2} x^T Q x + c^T x} \quad \text{subject to} \quad Ax \leq b$$

- **Convexity depends on $Q$:** $Q \succeq 0$ (PSD) $\implies$ Convex QP (KKT sufficient); $Q \succ 0$ (PD) $\implies$ Strictly convex QP (unique minimizer); negative eigenvalue $\implies$ Non-convex.
- *Example:* $\min \frac{1}{2}x^2 + y^2 - xy$ s.t. $x + y = 1$. Here $Q = \begin{pmatrix} 1 & -1 \\ -1 & 2 \end{pmatrix}$ ($\lambda \approx 0.38, 2.62 > 0$, strictly convex). Lagrange yields $\boxed{x = \frac{3}{5}, y = \frac{2}{5}, f = 0.10}$.

### Machine Learning Optimization Families

| Model | Optimization Family |
| :--- | :--- |
| **SVM** | QP |
| **Ridge regression ($L_2$)** | Convex quadratic optimization |
| **Lasso ($L_1$)** | Convex optimization (often reformulated as QP or LP) |
| **L1 regression** | LP reformulation |
| **Logistic regression** | Convex, generally not QP |
| **Deep neural networks** | Generally non-convex |

---

## 6. Transportation Problem (LP Application)

Two depots ($D_1 = 30$, $D_2 = 20$) supply two clients ($C_1 = 25$, $C_2 = 25$) with unit costs: $c_{11}=4, c_{12}=6, c_{21}=5, c_{22}=3$.
- $\min Z = 4x_{11} + 6x_{12} + 5x_{21} + 3x_{22}$ subject to supply/demand equations and $x_{ij} \geq 0$.
- Setting $x_{11} = a \implies x_{12} = 30-a, \; x_{21} = 25-a, \; x_{22} = a-5$ with $5 \leq a \leq 25$.
- Cost becomes $Z = 290 - 4a$. Maximizing $a \implies a = 25$:
  $$D_1 \to C_1: 25, \quad D_1 \to C_2: 5, \quad D_2 \to C_1: 0, \quad D_2 \to C_2: 20 \implies \boxed{Z_{\min} = 190}$$

---

# Cours 6. Stochastic optimization
*Chapter 3, Part 1*

## 1. GD vs SGD vs Mini-Batch GD

For $N$ training examples, minimizing average loss $f(w) = \frac{1}{N}\sum_{i=1}^{N} f_i(w)$:

- **Batch Gradient Descent:** Uses all $N$ examples per update: $\boxed{w_{k+1} = w_k - \alpha \nabla f(w_k)}$ (exact, stable, expensive for large $N$).
- **Stochastic Gradient Descent (SGD):** Uses **1 random example** $i_k$: $\boxed{w_{k+1} = w_k - \alpha \nabla f_{i_k}(w_k)}$ (very cheap, noisy updates, noise helps escape saddle points).
- **Mini-Batch Gradient Descent:** Uses a small batch $B_k$ of size $b$:
  $$\boxed{g_k = \frac{1}{b}\sum_{i \in B_k} \nabla f_i(w_k)}, \qquad w_{k+1} = w_k - \alpha g_k$$

### Key Vocabulary & Batch Size Trade-offs

| Term | Meaning |
| :--- | :--- |
| **Epoch** | **One complete pass** through the entire training dataset |
| **Batch size ($b$)** | Number of examples used for **one gradient update** |
| **Learning rate ($\alpha$)** | Step size used to update model parameters |

*(Example: $N = 10,000$ examples with $b = 100 \implies 100$ parameter updates per epoch.)*

| Batch Size | Gradient Estimate | Cost per Update | Updates per Epoch |
| :--- | :--- | :--- | :--- |
| $1$ (Pure SGD) | Very noisy | Very low | $N$ |
| $32$ to $256$ (Mini-batch) | More stable | Low | $N / b$ |
| $N$ (Full Batch GD) | Exact | High | $1$ |

---

## 2. SGD Regression Example & Robbins-Monro Conditions

Fit $\hat{y} = wx$ with loss $f_i(w) = (wx_i - y_i)^2 \implies \nabla f_i(w) = 2x_i(wx_i - y_i)$.
Data: $(1, 2.2), (2, 3.8), (3, 6.3)$, $w_0 = 0$, $\alpha = 0.05$:
1. Example 1: $g = 2(1)(0 - 2.2) = -4.4 \implies w_1 = 0 - 0.05(-4.4) = \boxed{0.22}$.
2. Example 2: $g = 2(2)(0.44 - 3.8) = -13.44 \implies w_2 = 0.22 - 0.05(-13.44) = \boxed{0.892}$.
3. Example 3: $g = 2(3)(2.676 - 6.3) = -21.744 \implies w_3 = 0.892 - 0.05(-21.744) = \boxed{1.9792}$.
*(Exact global minimum is $w^* = \frac{\sum x_i y_i}{\sum x_i^2} = \frac{28.7}{14} = \boxed{2.05}$.)*

### Why SGD Oscillates & Robbins-Monro Convergence Conditions
Each sample pulls $w$ toward its own optimum ($2.2, 1.9, 2.1$). Reduce oscillation via learning rate decay, larger mini-batches, or Momentum.
- **Robbins-Monro conditions** for diminishing step size $\alpha_k$ (e.g., $\alpha_k = \frac{\alpha_0}{k}$):
  $$\boxed{\sum_{k=1}^{\infty} \alpha_k = \infty} \quad \text{(keeps making progress)} \qquad \text{and} \qquad \boxed{\sum_{k=1}^{\infty} \alpha_k^2 < \infty} \quad \text{(dampens noise)}$$

---

## 3. Modern Optimizers (Momentum, AdaGrad, RMSProp, Adam)

### A. Momentum
Accumulates velocity from past gradients ($\beta \approx 0.9$) to accelerate consistent directions and dampen zigzagging:
$$\boxed{v_k = \beta v_{k-1} + g_k}, \qquad \boxed{w_{k+1} = w_k - \alpha v_k}$$

### B. AdaGrad
Adapts the learning rate per parameter by accumulating all past squared gradients (element-wise):
$$\boxed{G_k = G_{k-1} + g_k^2}, \qquad \boxed{w_{k+1} = w_k - \alpha \frac{g_k}{\sqrt{G_k} + \varepsilon}}$$
- **Disadvantage:** $G_k \to \infty$ monotonically, causing the learning rate to shrink to zero and stop training prematurely.

### C. RMSProp
Fixes AdaGrad by using an **exponential moving average** of squared gradients ($\rho \approx 0.9$):
$$\boxed{E_k = \rho E_{k-1} + (1 - \rho)g_k^2}, \qquad \boxed{w_{k+1} = w_k - \alpha \frac{g_k}{\sqrt{E_k} + \varepsilon}}$$

### D. Adam (Adaptive Moment Estimation)
Combines **Momentum** (1st moment) + **RMSProp** (2nd moment) + **Bias Correction**:
1. **First moment:** $\boxed{m_k = \beta_1 m_{k-1} + (1 - \beta_1)g_k}$
2. **Second moment:** $\boxed{v_k = \beta_2 v_{k-1} + (1 - \beta_2)g_k^2}$
3. **Bias correction:** $\boxed{\hat{m}_k = \frac{m_k}{1 - \beta_1^k}}, \qquad \boxed{\hat{v}_k = \frac{v_k}{1 - \beta_2^k}}$
4. **Parameter update:** $\boxed{w_{k+1} = w_k - \alpha \frac{\hat{m}_k}{\sqrt{\hat{v}_k} + \varepsilon}}$

*(Typical defaults: $\alpha = 0.001$, $\beta_1 = 0.9$, $\beta_2 = 0.999$, $\varepsilon = 10^{-8}$.)*

### Optimizer Comparison & Formula Recognition

| Optimizer | Main Idea | Formula Signature | Extra Memory (100M params @ 4B = 400 MB) |
| :--- | :--- | :--- | :--- |
| **SGD** | Stochastic gradient | $w - \alpha g$ | $0$ MB |
| **Momentum** | Remembers past gradients | $v = \beta v + g$ | $+400$ MB ($1$ vector) |
| **AdaGrad** | Accumulates squared gradients | $G = G + g^2$ | $+400$ MB ($1$ vector) |
| **RMSProp** | Moving average of squared gradients | $E = \rho E + (1-\rho)g^2$ | $+400$ MB ($1$ vector) |
| **Adam** | Momentum + RMSProp + bias correction | $m, v, \hat{m}, \hat{v}$ | $+800$ MB ($2$ vectors) |

> [!note] **Professor's Benchmark on $f(x, y) = x^2 + 4y^2$ from $(4, 1)$ (50 iterations)**
> Final gradient norms: GD ($< 10^{-9}$), Momentum ($< 10^{-9}$), AdaGrad ($0.0008$), RMSProp ($0.10$), Adam ($0.16$).
> *Lesson:* On a small, clean, deterministic quadratic, standard GD/Momentum excel; Adam and RMSProp shine on large, noisy, badly scaled deep learning landscapes.

---

## 4. Deep Learning Training, Backpropagation & Practical Rules

1. **Initialize weights** $\to$ 2. **Forward propagation** $\to$ 3. **Calculate loss** $L(w) = \frac{1}{N}\sum_{i=1}^N L_i(w)$ $\to$ 4. **Backpropagation** (computes gradients via chain rule) $\to$ 5. **Optimizer update** (updates weights) $\to$ 6. **Validation** (monitors overfitting).

> [!warning] **Crucial Distinction**
> **Backpropagation** calculates gradients; the **optimizer** uses those gradients to update weights. They are **not** the same thing!

### Why SGD/Adam instead of Newton/BFGS in Deep Learning?
1. **Computational cost:** Mini-batch processes $100$ samples instead of $1,000,000$.
2. **Memory:** For $10^6$ parameters, the Hessian has $10^{12}$ elements $\approx 4\text{ TB}$ of RAM!
3. **Non-convexity:** SGD noise helps escape saddle points.
4. **Generalization:** Prevents overfitting to training noise.

- **Gradient clipping:** Caps gradient norm when gradients explode to prevent unstable updates.

---

# Final QCM Revision Sheet

## 1. Master Comparison of Confusable Concepts

| Concept A | Concept B | Core Difference |
| :--- | :--- | :--- |
| **Local minimum** | **Global minimum** | Lowest nearby vs lowest over entire feasible domain $U$ |
| **Convex** | **Non-convex** | No bad local minima vs multiple local minima possible |
| **Derivative** | **Gradient** | Scalar (1D) vs Vector (multi-variable) |
| **Gradient** | **Hessian** | First derivatives vs Second derivatives (curvature) |
| **Exact line search** | **Inexact line search** | Exact 1D minimum vs sufficient decrease (Armijo/Wolfe) |
| **Gradient Descent** | **Newton** | Gradient only ($O(n)$) vs Gradient + Hessian ($O(n^3)$) |
| **Newton** | **BFGS** | Exact Hessian vs Inverse Hessian approximation ($O(n^2)$) |
| **Equality** | **Inequality** | $h(x) = 0$ vs $g(x) \leq 0$ |
| **Active constraint** | **Inactive constraint** | $g(x) = 0$ ($\mu \geq 0$) vs $g(x) < 0$ ($\mu = 0$) |
| **Lagrange** | **KKT** | Equality constraints vs Equality + Inequality constraints |
| **Penalty** | **Barrier** | Penalizes outside violations vs Prevents reaching boundary from inside |
| **Weak duality** | **Strong duality** | $d^* \leq p^*$ (always) vs $d^* = p^*$ (convex + Slater) |
| **Simplex** | **Interior-Point** | Moves along vertices vs Moves through interior |
| **LP** | **QP** | Linear objective vs Quadratic objective |
| **SGD** | **Mini-batch** | $1$ example vs Small group of $b$ examples |
| **AdaGrad** | **RMSProp** | Cumulative sum of $g^2$ vs Exponential moving average of $g^2$ |
| **RMSProp** | **Adam** | Moving avg of $g^2$ vs Moving avg of $g$ and $g^2$ + bias correction |

---

## 2. QCM Practice: 20 True / False Questions

Test yourself before checking the answer key below!

1. The gradient points toward the greatest increase. *(True / False)*
2. A zero gradient always means a global minimum. *(True / False)*
3. Every global minimum is also a local minimum. *(True / False)*
4. A convex function can have multiple distinct global minima. *(True / False)*
5. A positive definite Hessian at a stationary point indicates a strict local minimum. *(True / False)*
6. Newton requires only the gradient. *(True / False)*
7. BFGS calculates the exact Hessian at every iteration. *(True / False)*
8. A very large learning rate can cause divergence. *(True / False)*
9. An inactive inequality constraint has a zero KKT multiplier. *(True / False)*
10. KKT conditions are always sufficient for global optimality. *(True / False)*
11. Weak duality guarantees equality between primal and dual values. *(True / False)*
12. Simplex moves from vertex to vertex. *(True / False)*
13. The Simplex entering variable is chosen using the minimum ratio test. *(True / False)*
14. Interior-Point methods move through the interior of the feasible region. *(True / False)*
15. AdaGrad accumulates squared gradients. *(True / False)*
16. RMSProp uses a cumulative sum of all squared gradients. *(True / False)*
17. Adam combines Momentum and RMSProp. *(True / False)*
18. Backpropagation and the optimizer are the same thing. *(True / False)*
19. A larger batch size usually produces a less noisy gradient estimate. *(True / False)*
20. An epoch is one parameter update. *(True / False)*

> [!success]- **Click to Reveal Answers & Explanations**
> 1. **True** — $-\nabla f$ points toward greatest local decrease.
> 2. **False** — It can be a local maximum, saddle point, or non-global local minimum if non-convex.
> 3. **True** — Provided the domain contains a neighborhood around it.
> 4. **True** — A flat-bottomed convex function (not *strictly* convex) can have infinitely many global minima.
> 5. **True** — Sufficient second-order condition for a strict local minimum.
> 6. **False** — Newton requires both the gradient and the exact Hessian.
> 7. **False** — BFGS approximates the inverse Hessian using gradient differences.
> 8. **True** — Overshoots the minimum and diverges.
> 9. **True** — By complementary slackness ($\mu_i g_i(x) = 0$), if $g_i(x) < 0$, then $\mu_i = 0$.
> 10. **False** — Only sufficient for **convex** problems (under regularity conditions).
> 11. **False** — Weak duality gives $d^* \leq p^*$; equality requires **strong duality**.
> 12. **True** — Traverses adjacent vertices of the feasible polytope.
> 13. **False** — The **leaving** variable uses the minimum ratio test; the **entering** variable uses reduced costs.
> 14. **True** — Uses logarithmic barriers to stay strictly inside the feasible region.
> 15. **True** — $G_k = G_{k-1} + g_k^2$.
> 16. **False** — That is AdaGrad; RMSProp uses an exponential moving average.
> 17. **True** — Plus bias correction for first and second moments.
> 18. **False** — Backpropagation computes gradients; the optimizer updates parameters.
> 19. **True** — Lower variance gradient estimate.
> 20. **False** — An epoch is one full pass through the entire dataset ($N/b$ updates).

---

## 3. Revision Priority & Final Map

| Priority | Course | What to Master |
| :--- | :--- | :--- |
| 🔴 **Very High** | **Cours 2** | Derivatives, gradient, Hessian, Newton, BFGS, convergence rates |
| 🔴 **Very High** | **Cours 3** | Lagrange, four KKT conditions, active vs inactive constraints |
| 🔴 **Very High** | **Cours 4** | Convexity tests, eigenvalues, weak/strong duality, Slater |
| 🔴 **Very High** | **Cours 6** | SGD, Momentum, AdaGrad, RMSProp, Adam formulas & memory |
| 🟠 **High** | **Cours 5** | Simplex tableau, entering/leaving variables, LP vs QP |
| 🟠 **High** | **Cours 1** | Problem classification, norms ($L_1, L_2, L_\infty$), distances, convexity |

> [!tip] **Final Exam Strategy**
> Do not memorize formulas blindly without understanding what each variable represents. In a QCM, your professor can change numbers or notation while testing the exact same underlying principle. Focus on **recognizing which method a problem requires**.