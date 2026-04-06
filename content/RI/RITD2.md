## **Fiche:**

[[FICHERITD2.pdf]]

---
## **Solution:**
[[Loi de Zipf]]
### Exercice 1 — Loi de Zipf

##### **Liste des termes unique:**

| **#** | Terme        |
| ----- | ------------ |
| **1** | recherche    |
| **2** | informations |
| **3** | domaine      |
| **4** | algorithmes  |
| **5** | moteurs      |
| **6** | fondamental  |


**Total : 6 termes uniques**

---

##### **Fréquence d'apparition de chaque terme**

| Terme       | D1  | D2  | D3  | **Fréquence totale** |
| ----------- | :-: | :-: | :-: | :------------------: |
| recherche   |  1  |  1  |  1  |        **3**         |
| algorithme  |  0  |  1  |  1  |        **2**         |
| information |  2  |  0  |  0  |        **2**         |
| domaine     |  1  |  0  |  0  |        **1**         |
| fondamental |  1  |  0  |  0  |        **1**         |
| moteurs     |  0  |  1  |  0  |        **1**         |


---

##### **Vérification de la loi de Zipf**

| Rang (r) | Terme(s)    | fréquence | f Zipf = 3/r |
| :------: | ----------- | :-------: | :----------: |
|    1     | recherche   |     3     |     3.00     |
|    2     | algorithme  |     2     |     1.50     |
|    3     | information |     2     |     1.00     |
|    4     | domaine     |     1     |     0.75     |
|    5     | fondamental |     1     |     0.6      |
|    6     | moteurs     |     1     |     0.5      |

> [!check] Conclusion
> La loi de Zipf est **approximativement vérifiée** : la fréquence diminue bien lorsque le rang augmente. Cependant, sur un si petit corpus, la distribution reste grossière. La loi de Zipf se manifeste pleinement sur de **grands corpus**.

---

##### **Graphique fréquence vs rang**

![[RITD2EXO1.svg]]
> [!tip] Commentaire
> - La courbe suit globalement la décroissance **hyperbolique** de Zipf.

---

### Exercice 2 — Approche basée sur la discrimination
Vrai 3jezet mala 9olt el AI yektob el 7al kach makayen clicki [[RISOL1.pdf|hna]]
#### Données

Documents (fréquences des termes) :

$$
d_1 = [6, 2, 3, 6, 2], \quad
d_2 = [6, 1, 2, 0, 2], \quad
d_3 = [6, 5, 1, 0, 0]
$$

- Nombre de documents $N = 3$  
- Nombre de termes $M = 5$  
- Poids maximal $\max(d_{ij}) = 6$  
- Facteur de normalisation $\text{MaxS} = M \times (\max)^2 = 5 \times 36 = 180$

#### 1. Vecteur centroïde initial $V$

$$
v_j = \frac{1}{N} \sum_{i=1}^{N} d_{ij}
$$

$$
V = \left[6,\; \frac{8}{3},\; 2,\; 2,\; \frac{4}{3}\right]
$$

#### 2. Uniformité initiale $U_1$

Similarité d’un document $d_i$ avec le centroïde $V$ :

$$
\operatorname{Sim}(d_i, V) = 1 - \sqrt{\frac{\sum_{j=1}^{M} |d_{ij} - v_j|^2}{\text{MaxS}}}
$$

Sommes des carrés des différences :

- $d_1$ : $\displaystyle \sum = \frac{161}{9}$  
- $d_2$ : $\displaystyle \sum = \frac{65}{9}$  
- $d_3$ : $\displaystyle \sum = \frac{110}{9}$

D’où :

$$
\begin{aligned}
\operatorname{Sim}(d_1,V) &= 1 - \sqrt{\frac{161/9}{180}} \approx 0.6847 \\
\operatorname{Sim}(d_2,V) &= 1 - \sqrt{\frac{65/9}{180}} \approx 0.7997 \\
\operatorname{Sim}(d_3,V) &= 1 - \sqrt{\frac{110/9}{180}} \approx 0.7394
\end{aligned}
$$

Uniformité :

$$
U_1 = \frac{1}{N} \sum_{i=1}^{N} \operatorname{Sim}(d_i, V) \approx 0.7413
$$

#### 3. Suppression de chaque terme et calcul de $U_2$

Lorsqu’on annule le terme $k$ (mise à zéro dans tous les documents), le nouveau centroïde $V'$ a sa $k$-ième composante nulle, les autres inchangées.  
La nouvelle somme des carrés pour le document $i$ devient :

$$
\text{new\_sum}_i = \text{orig\_sum}_i - (d_{ik} - v_k)^2
$$

Les carrés des différences $(d_{ik} - v_k)^2$ sont :

| Terme $k$ | $d_1$     | $d_2$     | $d_3$     |
|-----------|-----------|-----------|-----------|
| 1         | 0         | 0         | 0         |
| 2         | $4/9$     | $25/9$    | $49/9$    |
| 3         | 1         | 0         | 1         |
| 4         | 16        | 4         | 4         |
| 5         | $4/9$     | $4/9$     | $16/9$    |

On calcule alors $\operatorname{Sim}(d_i', V') = 1 - \sqrt{\text{new\_sum}_i / 180}$ puis $U_2 = \frac{1}{3} \sum \operatorname{Sim}'$.

##### Résultats numériques

| Terme $k$ | $U_2$      | $v_k = U_2 - U_1$ |
|-----------|------------|-------------------|
| 1         | 0.7413     | 0                 |
| 2         | 0.7792     | 0.0379            |
| 3         | 0.7479     | 0.00663           |
| 4         | 0.8500     | 0.1088            |
| 5         | 0.7513     | 0.0100            |

#### 4. Interprétation

- $v_k > 0$ : le terme est **discriminant** (sa suppression uniformise le corpus).  
- Plus $v_k$ est grand, meilleur est le pouvoir discriminant.

**Classement des termes** :  
Terme 4 (0.1088) > Terme 2 (0.0379) > Terme 5 (0.0100) > Terme 3 (0.00663) > Terme 1 (0)

Le terme 4 est le plus utile pour distinguer les documents ; le terme 1 (constant) ne discrimine pas.

### Exercice 3 — IF/IDF
Vrai 3jezet mala 9olt el AI yektob el 7al kach makayen clicki [[RISOL2.pdf|hna]]
#### Tableau des fréquences

| Terme    | D1 | D2 | D3 | D4 | D5 |
|----------|----|----|----|----|----|
| Algo     | 0  | 1  | 0  | 0  | 1  |
| Informa  | 0  | 1  | 0  | 0  | 1  |
| Programm | 3  | 2  | 2  | 0  | 1  |
| lang     | 1  | 0  | 1  | 1  | 0  |
| fonct    | 0  | 0  | 1  | 1  | 1  |
| const    | 1  | 0  | 0  | 0  | 0  |

#### Formules utilisées

- **TF** (Term Frequency) :  
  $$ TF(t_i, d_j) = \frac{\text{freq}(t_i, d_j)}{\sum_{t' \in d_j} \text{freq}(t', d_j)} $$
  (fréquence normalisée par la longueur du document)

- **IDF** (Inverse Document Frequency) :  
  $$ IDF(t_i) = \log_{10}\left(\frac{N}{N_t}\right), \quad N=5 $$
  avec \(N_t\) = nombre de documents contenant \(t_i\).

- **Poids** :  
  $$ W(t_i, d_j) = TF(t_i, d_j) \times IDF(t_i) $$

#### Étape 1 : Somme des fréquences par document (dénominateur du TF)

On additionne toutes les fréquences de chaque document.

$$
\begin{array}{rcl}
S_{D1} &=& 0+0+3+1+0+1 = 5 \\
S_{D2} &=& 1+1+2+0+0+0 = 4 \\
S_{D3} &=& 0+0+2+1+1+0 = 4 \\
S_{D4} &=& 0+0+0+1+1+0 = 2 \\
S_{D5} &=& 1+1+1+0+1+0 = 4
\end{array}
$$

Ces sommes servent à normaliser : un document long (D1) aura des TF plus faibles qu’un document court (D4) pour une même fréquence brute.

#### Étape 2 : Calcul de l’IDF pour chaque terme

On compte $N_t$ (documents où freq > 0) :

| Terme    | Documents contenant le terme | $N_t$ | $5/N_t$ | IDF     |
| -------- | ---------------------------- | ----- | ------- | ------- |
| Algo     | D2, D5                       | 2     | 2.5     | 0.39794 |
| Informa  | D2, D5                       | 2     | 2.5     | 0.39794 |
| Programm | D1, D2, D3, D5               | 4     | 1.25    | 0.09691 |
| lang     | D1, D3, D4                   | 3     | 1.6667  | 0.22185 |
| fonct    | D3, D4, D5                   | 3     | 1.6667  | 0.22185 |
| const    | D1                           | 1     | 5       | 0.69897 |

L’IDF est d’autant plus grand que le terme est rare. « const » apparaît dans un seul document → IDF le plus élevé.

#### Étape 3 : Calcul du TF et du poids pour chaque document

##### Document D1 (somme = 5)

$$
\begin{array}{rcl}
TF(\text{Algo}) &=& 0/5 = 0 \;\Rightarrow\; W = 0 \\
TF(\text{Informa}) &=& 0 \;\Rightarrow\; W = 0 \\
TF(\text{Programm}) &=& 3/5 = 0.6 \;\Rightarrow\; W = 0.6 \times 0.09691 = 0.05815 \\
TF(\text{lang}) &=& 1/5 = 0.2 \;\Rightarrow\; W = 0.2 \times 0.22185 = 0.04437 \\
TF(\text{fonct}) &=& 0 \;\Rightarrow\; W = 0 \\
TF(\text{const}) &=& 1/5 = 0.2 \;\Rightarrow\; W = 0.2 \times 0.69897 = 0.13979
\end{array}
$$

##### Document D2 (somme = 4)

$$
\begin{array}{rcl}
TF(\text{Algo}) &=& 1/4 = 0.25 \;\Rightarrow\; W = 0.25 \times 0.39794 = 0.09949 \\
TF(\text{Informa}) &=& 1/4 = 0.25 \;\Rightarrow\; W = 0.09949 \\
TF(\text{Programm}) &=& 2/4 = 0.5 \;\Rightarrow\; W = 0.5 \times 0.09691 = 0.04846 \\
TF(\text{lang}) &=& 0 \;\Rightarrow\; W = 0 \\
TF(\text{fonct}) &=& 0 \;\Rightarrow\; W = 0 \\
TF(\text{const}) &=& 0 \;\Rightarrow\; W = 0
\end{array}
$$

##### Document D3 (somme = 4)

$$
\begin{array}{rcl}
TF(\text{Algo}) &=& 0 \;\Rightarrow\; W=0 \\
TF(\text{Informa}) &=& 0 \;\Rightarrow\; W=0 \\
TF(\text{Programm}) &=& 2/4 = 0.5 \;\Rightarrow\; W = 0.5 \times 0.09691 = 0.04846 \\
TF(\text{lang}) &=& 1/4 = 0.25 \;\Rightarrow\; W = 0.25 \times 0.22185 = 0.05546 \\
TF(\text{fonct}) &=& 1/4 = 0.25 \;\Rightarrow\; W = 0.25 \times 0.22185 = 0.05546 \\
TF(\text{const}) &=& 0 \;\Rightarrow\; W=0
\end{array}
$$

##### Document D4 (somme = 2) – le plus court

$$
\begin{array}{rcl}
TF(\text{lang}) &=& 1/2 = 0.5 \;\Rightarrow\; W = 0.5 \times 0.22185 = 0.11093 \\
TF(\text{fonct}) &=& 1/2 = 0.5 \;\Rightarrow\; W = 0.5 \times 0.22185 = 0.11093 \\
\text{autres termes} &\Rightarrow& W=0
\end{array}
$$

##### Document D5 (somme = 4)

$$
\begin{array}{rcl}
TF(\text{Algo}) &=& 1/4 = 0.25 \;\Rightarrow\; W = 0.25 \times 0.39794 = 0.09949 \\
TF(\text{Informa}) &=& 0.25 \;\Rightarrow\; W = 0.09949 \\
TF(\text{Programm}) &=& 1/4 = 0.25 \;\Rightarrow\; W = 0.25 \times 0.09691 = 0.02423 \\
TF(\text{fonct}) &=& 1/4 = 0.25 \;\Rightarrow\; W = 0.25 \times 0.22185 = 0.05546 \\
TF(\text{lang}) &=& 0 \;\Rightarrow\; W=0 \\
TF(\text{const}) &=& 0 \;\Rightarrow\; W=0
\end{array}
$$

#### Étape 4 : Tableau récapitulatif des poids $W(t_i, d_j)$

| Terme    | D1      | D2      | D3      | D4      | D5      |
| -------- | ------- | ------- | ------- | ------- | ------- |
| Algo     | 0       | 0.09949 | 0       | 0       | 0.09949 |
| Informa  | 0       | 0.09949 | 0       | 0       | 0.09949 |
| Programm | 0.05815 | 0.04846 | 0.04846 | 0       | 0.02423 |
| lang     | 0.04437 | 0       | 0.05546 | 0.11093 | 0       |
| fonct    | 0       | 0       | 0.05546 | 0.11093 | 0.05546 |
| const    | 0.13979 | 0       | 0       | 0       | 0       |
