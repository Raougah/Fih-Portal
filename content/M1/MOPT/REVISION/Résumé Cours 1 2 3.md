## Choosing the Right Method

> [!question] **What type of exercise do you have?**
> Identify the structure of the problem first to pick the exact analytical tool immediately.

> [!tip] **Case 1: A function of one variable (unconstrained)**
> - **Example:** $f(x) = x^2 - 4x + 5$
> - **Method:** Use **derivatives** (1st and 2nd order tests)
> - The first derivative tells us the slope of the curve (x ta3 القيمة الحدية).
> - The second derivative tell us: How do we know whether it is a maximum or minimum?
> $$
> f'(x) = 0, \quad f''(x)
> $$

> [!info] **Case 2: A function of two variables (no constraint)**
> - **Example:** $f(x, y) = x^2 + y^2$
> - **Method:** Use the **gradient** and **Hessian matrix**
> $$
> \nabla f = 0, \quad H_f
> $$

> [!important] **Case 3: A function with a constraint**
> - **Example:** Maximize area with a fixed perimeter.
> - **Method:** Use **Lagrange multipliers** or **variable elimination**
> $$
> \nabla f = \lambda \nabla h
> $$

---
## Aide-Mémoire : Méthodes d'Optimisation

## 1. Optimisation sans contrainte

| Sujet | Formule |
| :--- | :--- |
| **Point critique** | $\nabla f = 0$ |
| **Gradient** | $\nabla f = (f_x, f_y)^T$ |
| **Hessienne** | $H = \begin{pmatrix} f_{xx} & f_{xy} \\ f_{yx} & f_{yy} \end{pmatrix}$ |
| **Déterminant Hessien** | $D = f_{xx}f_{yy} - f_{xy}^2$ |
| **Minimum local** | $D > 0,\ f_{xx} > 0$ |
| **Maximum local** | $D > 0,\ f_{xx} < 0$ |
| **Point selle** | $D < 0$ |
| **Test inconclusif** | $D = 0$ |

---

## 2. Méthodes d'optimisation

| Sujet | Formule |
| :--- | :--- |
| **Surface rectangle** | $S = xy$ |
| **Gradient Descent** | $X_{k+1} = X_k - \alpha \nabla f(X_k)$ |
| **Newton** | $X_{k+1} = X_k - H^{-1} \nabla f(X_k)$ |
| **Line Search** | $\alpha^* = \arg\min_\alpha f(x_k + \alpha d)$ |

---

## 3. Multiplicateurs de Lagrange

| Sujet | Formule |
| :--- | :--- |
| **Contrainte égalité** | $h(x,y) = 0$ |
| **Lagrangien** | $L = f + \lambda h$ |
| **Stationnarité** | $\nabla_{x,y} L = 0$ |
| **Dérivée de $\lambda$** | $\frac{\partial L}{\partial \lambda} = h(x,y) = 0$ |
| **Solution** | Résoudre $\nabla L = 0$ |

---

## 4. Conditions KKT

> [!info] Domaine d'application
> Pour les contraintes d'inégalité de la forme $g_i(x) \leq 0$.

| Sujet | Formule |
| :--- | :--- |
| **Lagrangien** | $L = f + \sum_i \lambda_i g_i$ |
| **Stationnarité** | $\nabla_x L = 0$ |
| **Primal feasibility** | $g_i(x) \leq 0$ |
| **Dual feasibility** | $\lambda_i \geq 0$ |
| **Complementary slackness** | $\lambda_i g_i(x) = 0$ |
| **Contrainte active** | $g_i(x) = 0$ |
| **Contrainte inactive** | $g_i(x) < 0 \Rightarrow \lambda_i = 0$ |

> [!warning] Important
> Pour une contrainte d'inégalité, on ne rajoute pas une dérivée par rapport à $\lambda$ comme cinquième condition. La contrainte apparaît dans la faisabilité et la complémentarité.

---

## 5. Méthode de pénalisation

| Sujet | Formule |
| :--- | :--- |
| **Pénalité égalité** | $P = f + \rho h(x)^2$ |
| **Pénalité inégalité** | $P = f + \rho \max(0, g(x))^2$ |
| **Dérivée seconde** | $P''$ |
| **Paramètre** | $\rho \to +\infty$ |
| **Violation** | $g(x^*) > 0$ |
| **Estimation multiplicateur** | $\lambda \approx 2\rho g(x^*)$ |
| **Limite** | $x^*(\rho) \to x^*$ |

---

## 6. Méthode de barrière logarithmique

| Sujet | Formule |
| :--- | :--- |
| **Barrière** | $B = f - \mu \sum_i \ln(-g_i(x))$ |
| **Domaine** | $g_i(x) < 0$ |
| **Minimum** | $\nabla B = 0$ |
| **Paramètre** | $\mu \to 0^+$ |
| **Marge** | $-g_i(x^*)$ |
| **Estimation multiplicateur** | $\lambda_i \approx \frac{\mu}{-g_i(x^*)}$ |
| **Limite** | $x^*(\mu) \to x^*$ |

---

## 7. Comparaison des méthodes

| Sujet | Pénalisation | Barrière |
| :--- | :--- | :--- |
| **Paramètre** | $\rho$ | $\mu$ |
| **Évolution** | $\rho \to \infty$ | $\mu \to 0$ |
| **Position** | Peut être infaisable | Strictement faisable |
| **Objectif** | Pénaliser les violations | Éviter les frontières |
| **Multiplicateur** | $2\rho g(x^*)$ | $\frac{\mu}{-g(x^*)}$ |

---

## 8. Les limites à retenir

> [!tip] Synthèse des convergences asymptotiques

| Sujet | Limite |
| :--- | :--- |
| **Pénalité** | $\rho \to +\infty$ |
| **Barrière** | $\mu \to 0^+$ |
| **Pénalité violation** | $g(x^*) \to 0$ |
| **Barrière marge** | $-g(x^*) \to 0^+$ |
| **Multiplicateur pénalité** | $\lambda^*$ |
| **Multiplicateur barrière** | $\lambda^*$ |