# Formules utilisées dans le TP 2 : ACP (convention dénominateur n)

Notation : $n = 6$ individus, $p = 2$ variables ($X$ = poids, $Y$ = taille).

---

## 1. Moyennes et centrage

**Moyennes**

$$\bar{X} = \frac{1}{n}\sum_{i=1}^{n} x_i \qquad \bar{Y} = \frac{1}{n}\sum_{i=1}^{n} y_i$$

Application : $\bar{X} = \dfrac{72}{6} = 12$ et $\bar{Y} = \dfrac{78}{6} = 13$

**Centrage**

$$x_i^c = x_i - \bar{X} \qquad y_i^c = y_i - \bar{Y}$$

Forme matricielle : $X_c = X - \mathbf{1}\,\bar{x}^{T}$

---

## 2. Matrice de covariance

**Variances**

$$V(X) = \frac{1}{n}\sum_{i=1}^{n} (x_i^c)^2 \qquad V(Y) = \frac{1}{n}\sum_{i=1}^{n} (y_i^c)^2$$

**Covariance**

$$\mathrm{Cov}(X,Y) = \frac{1}{n}\sum_{i=1}^{n} x_i^c \, y_i^c$$

**Matrice de covariance**

$$V = \begin{pmatrix} V(X) & \mathrm{Cov}(X,Y) \\ \mathrm{Cov}(X,Y) & V(Y) \end{pmatrix} = \frac{1}{n} X_c^{T} X_c$$

Application numérique :

$$V = \begin{pmatrix} 49 & 25{,}5 \\ 25{,}5 & 45{,}667 \end{pmatrix}$$

**Interprétation :**
- termes diagonaux = variances (dispersion de chaque variable) ;
- termes hors diagonale = covariances (liaison linéaire entre les variables).

---

## 3. Valeurs propres et vecteurs propres

**Équation caractéristique**

$$\det(V - \lambda I) = 0$$

Pour une matrice $2\times 2$ :

$$\lambda^2 - \mathrm{tr}(V)\,\lambda + \det(V) = 0$$

avec

$$\mathrm{tr}(V) = V(X) + V(Y) = 94{,}667 \qquad \det(V) = V(X)\,V(Y) - \mathrm{Cov}(X,Y)^2 = 1587{,}42$$

**Discriminant et racines**

$$\Delta = \mathrm{tr}(V)^2 - 4\det(V) \qquad \lambda_{1,2} = \frac{\mathrm{tr}(V) \pm \sqrt{\Delta}}{2}$$

Résultat : $\lambda_1 \approx 72{,}888 \ge \lambda_2 \approx 21{,}779$

**Vecteur propre associé à $\lambda_k$**

$$(V - \lambda_k I)\,u_k = 0 \quad\Longrightarrow\quad (V(X) - \lambda_k)\,u_{k1} + \mathrm{Cov}(X,Y)\,u_{k2} = 0$$

$$u_{k2} = \frac{\lambda_k - V(X)}{\mathrm{Cov}(X,Y)}\;u_{k1}$$

**Normalisation**

$$\hat{u}_k = \frac{u_k}{\lVert u_k \rVert} \qquad \lVert u_k \rVert = \sqrt{u_{k1}^2 + u_{k2}^2}$$

Résultat : $u_1 \approx (0{,}7298 \;;\; 0{,}6837)$ et $u_2 \approx (-0{,}6837 \;;\; 0{,}7298)$

**Orthogonalité**

$$u_1 \cdot u_2 = u_{11}u_{21} + u_{12}u_{22} = 0$$

---

## 4. Inertie expliquée

**Inertie totale**

$$I_{tot} = \lambda_1 + \lambda_2 = \mathrm{tr}(V) = V(X) + V(Y)$$

**Pourcentage d'inertie de l'axe $k$**

$$P_k = \frac{\lambda_k}{\lambda_1 + \lambda_2} \times 100$$

Résultat : $P_1 \approx 76{,}99\ \%$ et $P_2 \approx 23{,}01\ \%$

**Inertie cumulée**

$$P_1 + P_2 = 100\ \%$$

(Les deux axes portent toute l'inertie, car $p = 2$ variables donnent $2$ axes.)

---

## 5. Coordonnées factorielles (projection des individus)

$$c_{ik} = u_{k1}\,x_i^c + u_{k2}\,y_i^c = \langle \mathbf{x}_i^c , u_k \rangle$$

Forme matricielle :

$$C = X_c\,U \qquad U = [\,u_1 \;\; u_2\,]$$

**Propriétés de contrôle**

$$\sum_{i=1}^{n} c_{ik} = 0 \qquad \frac{1}{n}\sum_{i=1}^{n} c_{ik}^2 = \lambda_k$$

---

## 6. ACP normée (centrée-réduite)

**Écart-type (dénominateur $n$)**

$$s_j = \sqrt{\frac{1}{n}\sum_{i=1}^{n} (x_{ij} - \bar{x}_j)^2}$$

Application : $s_X = 7$ et $s_Y = \sqrt{45{,}667} \approx 6{,}758$

**Variables centrées-réduites**

$$z_{ij} = \frac{x_{ij} - \bar{x}_j}{s_j} \qquad Z = X_c\,D^{-1}, \quad D = \mathrm{diag}(s_1, s_2)$$

**Matrice de covariance des variables réduites = matrice de corrélation**

$$R = \frac{1}{n} Z^{T} Z = \begin{pmatrix} 1 & r \\ r & 1 \end{pmatrix}$$

**Coefficient de corrélation**

$$r = \frac{\mathrm{Cov}(X,Y)}{s_X\, s_Y} = \frac{25{,}5}{7 \times 6{,}758} \approx 0{,}539$$

**Valeurs propres de $R$ (cas $2\times 2$)**

$$\lambda_1 = 1 + r \approx 1{,}539 \qquad \lambda_2 = 1 - r \approx 0{,}461$$

**Vecteurs propres de $R$ (cas $2\times 2$, $r>0$)**

$$u_1 = \frac{1}{\sqrt{2}}(1,\,1) \qquad u_2 = \frac{1}{\sqrt{2}}(-1,\,1)$$

**Inertie totale**

$$I_{tot} = \mathrm{tr}(R) = p = 2$$

**Pourcentages d'inertie**

$$P_1 = \frac{1{,}539}{2} \times 100 \approx 76{,}96\ \% \qquad P_2 = \frac{0{,}461}{2} \times 100 \approx 23{,}04\ \%$$

**Coordonnées factorielles**

$$C = Z\,U$$

---

## 7. Comparaison des deux ACP

| | ACP non normée | ACP normée |
|---|---|---|
| Données utilisées | $X_c$ (centrées) | $Z$ (centrées-réduites) |
| Matrice diagonalisée | $V = \frac{1}{n}X_c^T X_c$ (covariance) | $R = \frac{1}{n}Z^T Z$ (corrélation) |
| Inertie totale | $\mathrm{tr}(V) = \sum_j V(X_j)$ | $\mathrm{tr}(R) = p$ |
| Dépend des unités | Oui | Non |
| Poids des variables | Proportionnel à leur variance | Égal pour toutes |

**Relation entre les deux matrices**

$$R = D^{-1}\,V\,D^{-1}$$

Les deux ACP donnent les mêmes axes seulement si les variables ont des variances égales (ou à un facteur d'échelle près).

---

## 8. Correspondance avec Python (NumPy)

| Formule | Code |
|---|---|
| $\bar{x}$ | `X.mean(axis=0)` |
| $X_c = X - \bar{x}$ | `Xc = X - moyennes` |
| $V = \frac{1}{n}X_c^T X_c$ | `V = (Xc.T @ Xc) / n` |
| $\lambda_k,\ u_k$ | `vals, vecs = np.linalg.eigh(V)` |
| Tri décroissant | `idx = np.argsort(vals)[::-1]` |
| $P_k = \lambda_k / \sum\lambda \times 100$ | `pct = vals / vals.sum() * 100` |
| $C = X_c U$ | `C = Xc @ vecs` |
| $s_j$ (dénominateur $n$) | `X.std(axis=0)` (par défaut `ddof=0`) |
| $Z = X_c / s$ | `Z = Xc / sigma` |

```python
import numpy as np
import matplotlib.pyplot as plt

X = np.array([[20, 15], [5, 2], [12, 21], [21, 13], [2, 7], [12, 20]], dtype=float)
noms = [f"I{i+1}" for i in range(len(X))]
n = X.shape[0]

def acp(Z, titre):
    V = (Z.T @ Z) / n                     
    vals, vecs = np.linalg.eigh(V)      
    idx = np.argsort(vals)[::-1] 
    vals, vecs = vals[idx], vecs[:, idx]

    pct = vals / vals.sum() * 100
    C = Z @ vecs                   

    print(f"\n===== {titre} =====")
    print("matrice de covariance :\n", np.round(V, 4))
    print("valeurs propres :", np.round(vals, 4))
    print("vecteurs propres :\n", np.round(vecs, 4))
    print("inertie:\n", np.round(pct, 2))
    print("coordonne factorielles :\n", np.round(C, 3))


    plt.figure(figsize=(6, 6))
    plt.scatter(C[:, 0], C[:, 1], color="tab:blue")
    for i, nom in enumerate(noms):
        plt.annotate(nom, (C[i, 0], C[i, 1]), textcoords="offset points", xytext=(5, 5))
    plt.axhline(0, color="k", lw=0.8)
    plt.axvline(0, color="k", lw=0.8)
    plt.xlabel(f"Axe 1 ({pct[0]:.2f} %)")
    plt.ylabel(f"Axe 2 ({pct[1]:.2f} %)")
    plt.title(titre)
    plt.grid(alpha=0.3)
    plt.axis("equal")
    plt.show()
    return vals, pct, C


moyennes= X.mean(axis=0)
print("moyennes :", moyennes)
Xc= X - moyennes
vals1,pct1,C1= acp(Xc, "ACP non norme")
sigma= X.std(axis=0)                
Z= Xc/sigma
vals2,pct2,C2= acp(Z, "ACP norme")

print("valeurs propres non norme :", np.round(vals1, 3), "| norme :", np.round(vals2, 3))
print("inertie non normée :", np.round(pct1, 2), "| norme :", np.round(pct2, 2))
```