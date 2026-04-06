## **Fiche:**

[[FICHERITD2.pdf]]

---

### Exercice 1 — Loi de Zipf

##### **Liste des termes unique:**

| **#**   | Terme        |
| --- | ------------ |
| **1**   | recherche    |
| **2**   | informations |
| **3**   | domaine      |
| **4**   | algorithmes  |
| **5**   | moteurs      |
| **6**   | fondamental  |


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

> [!abstract] Formule de Zipf
> $$f(r) = \frac{C}{r^s}$$
> - $C$ = constante de normalisation = fréquence du mot do rang 1= **3**
> - $s$ = coefficient = **1** (valeur classique)
> - $r$ = rang du mot

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

##### **Données initiales**

|     | t1  | t2  | t3  | t4  | t5  |
| --- | :-: | :-: | :-: | :-: | :-: |
| d1  |  6  |  2  |  3  |  6  |  2  |
| d2  |  6  |  1  |  2  |  0  |  2  |
| d3  |  6  |  5  |  1  |  0  |  0  |
