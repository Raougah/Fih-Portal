
# Générateur de Nombres pseudo-aléatoire

**(PRNG - Pseudo-Random Number Generator)**

Un PRNG, c'est une machine déterministe qui imite le hasard.

On lui dannantune graine(seed)  $X_0$, et il donne en résultat une suite $U_1, U_2, ...$ qui passe tous les tests statistiques du hasard

# ***Propriétés d'un bon PRNG***

1- Période trés longue :
La suite $X_0, X_1, X_2...$ est forcément périodique car l'état interne est fini. Si un état fait $k$ bits, période max $= 2^k$

2-Uniformité : Les nombres générés par un PRNG doivent être uniformément distribués dans un intervalle donné.

3-indépendance: Les nombres générés doivent être statistiquement indépendants les uns des autres.

# **Le LCG — Linear Congruential Generator**

Le LCG est le modèle historique le plus simple. Il est défini par la relation de récurrence :

$$X_{n+1} = (a \cdot X_{n} + c) \bmod m$$

• X₀ est la graine (seed): C'est ton point de départ, 

$$0 \le X_0 < m$$

• m est le modulo : C'est lui qui fixe la période maximale possible. On ne peut jamais avoir plus de $m$ valeurs distinctes.

• a est le multiplicateu: 

$$0 < a < m$$

• c est l'incrément:

$$0 \le c < m$$

**A retenir :**

`X = (a * X + c) % m` *(seed)*

`U = X / m` *(générateur)*

# ***Programme :***

1- Histogramme

```python
import matplotlib.pyplot as plt
from collections import Counter
from time import time  #قيمة الوقت الحالي
from math import floor #تحويل رقم حقيقي إلى عدد صحيح بتقريب إلى أسفل

# Display histogram of different types of data: floats (continuous), ints or string (discrete).
# عرض الهيستوغرام لأنواع مختلفة من البيانات: أعداد عشرية (بيانات مستمرة)، أعداد صحيحة أو سلاسل نصية (بيانات متقطعة).
# data: list of data values  قائمة بقيم البيانات
# title: title to display with the histogram  عنوان لعرضه مع الهيستوغرام
# bins: number of bars to draw or intervals  عدد الأعمدة لرسمها أو الفواصل
# proba: False -> display frequencies عرض عدد التكرارات, True -> display probabilities عرض الاحتمالات
def histogram(data, title="Histogram", bins=None, proba=False):
    if all(isinstance(val, float) for val in data): #أعداد عشرية
        if bins is None: bins=10
        plt.hist(data, bins=bins, alpha=0.7, edgecolor="black", density=proba)
    elif all(isinstance(val, int) for val in data): #أعداد صحيحة
        if bins is None: bins=range(min(data), max(data) + 2)
        plt.hist(data, bins=bins, alpha=0.7, edgecolor="black", rwidth=0.6, align="left", density=proba)
    else: #سلاسل نصية
        data = [str(val) for val in data]
        value_counts = dict(sorted(Counter(data).items()))
        unique_values = list(value_counts.keys())
        frequencies = list(value_counts.values())
        if proba:
            total_freq = sum(frequencies)
            frequencies = [freq/total_freq for freq in frequencies]
        plt.bar(unique_values, frequencies, alpha=0.7, edgecolor='black', width=0.6)
        plt.xticks(rotation=45)

    plt.title(title)
    plt.xlabel("Values")
    plt.ylabel("Probability" if proba else "Frequency")
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    plt.show()
```

2- PRNG

```python
def lcg(seed, n, m, a, c):
    """
    Générateur LCG
    seed : X0, la graine initiale
    n : nombre de valeurs à générer
    m, a, c : paramètres du LCG

    retourne : (X, U) avec X entiers et U = X / m dans [0,1[
    """
    X = [0] * n
    U = [0.0] * n

    X[0] = seed
    U[0] = X[0] / m

    for i in range(1, n):
        X[i] = (a * X[i-1] + c) % m
        U[i] = X[i] / m

    return X, U
```

# Exercices

Créez un nouveau Jupyter Notebook pour compléter le programme fourni selon les instructions et utilisez-le pour répondre aux exercices.

(N'utilisez pas les générateurs aléatoires des bibliothèques importées)

# ***Exercice 1 : Visualiser la qualité d'un PRNG***

Soient  3 LCG avec :

LCG1  : m=256, a=65, c=1

LCG2  : m=2048, a=65, c=1

LCG3  : m=`2**32`, a=1664525, c=1013904223

**Questions :**

1- Écrivez la fonction lcg(seed, n, m, a, c) qui qui retourne les 2 tableaux X et  U.

2- Pour chaque LCG, générez 2000 paires ($U_{\text{n}}$, $U_{\text{n+1}}$).

3- Tester avec LCG3 seed = 12345 et n=10 .

4- Affichez les 10 valeurs . Que remarquez-vous sur l’intervalle de  U  ?

5- Relancez 2 fois avec le même seed. Que constatez-vous?

6- Relancez avec un seed différent. La séquence est-elle identique? Pourquoi cette propriété est-elle cruciale en simulation et en debug?

7- Modifiez m à 16. Que se passe-t-il pour la période? Pourquoi on ne l'utilise jamais en pratique?

8- Sur une même figure avec 3 sous-graphiques, affichez le nuage de points ($U_{\text{n}}$, $U_{\text{n+1}}$).

9- Que voyez-vous pour LCG1 et LCG2 ?  Pourquoi est-ce catastrophique pour un réseau ? (Indice : si deux machines tirent deux backoff consécutifs, elles vont re-collisionner).

10- Tracez l'histogramme des U_n pour les 3 LCG avec 20 bins. Lequel est vraiment uniforme ?

# ***Exercice 2 : DHCP & IP aléatoires***

Contexte : Vous assignez des IPs aléatoirement dans un réseau 10.0.0.0/16 ( en fixant $m$ à $65536$) sans garder d'état.

1- Tracez  P_collision(n) pour $m=256$, $m = 65536$ et $m=2^{24}$.

Axe X : nombre d'appareils $n$ de $0$ à $2000$. Axe Y : probabilité de collision.

2- Votre patron veut P_collision< 0.1% pour $n=1000$ objets. Quel $m$  minimal doit-on choisir ?

3- Déduisez le masque réseau nécessaire. Montrez-le graphiquement avec une ligne horizontale à 0.001.

4- Fixez $m=65536$ et  $n=500$. Simulez 1000 fois l'assignation avec :

- LCG1 mauvais
- LCG3 bon (voir exercice 1 )

5- Comparez le nombre moyen de collisions observées dans un diagramme à barres. Conclusion ?

# ***Exercice 3: Attaque DNS - Courbe de Kaminsky***

ID DNS sur 16 bits ( on prend $m$=$65536$). l’attaquant envoie $n$ requêtes et $n$ fausses réponses.

**Probabilité de succès :**

$$P_{\text{succès}}(n) = 1 - e^{-\frac{n^2}{m}}$$

1- Tracez $P_{\text{succès}}(n)$   pour $n=0$ à 500.

2- Ajoutez une ligne horizontale à 50% et 90%.

3- Combien de paquets doit envoyer l'attaquant pour avoir 50% de chance ? 90% ?

4- Sachant qu'il peut envoyer 1000 paquets/seconde, combien de temps dure l'attaque ?

5-Aujourd'hui on ajoute le port source aléatoire (16 bits de plus) => $m=2^{32}$.

6-Sur le même graphique, tracez la nouvelle courbe $P_{\text{succès}}(n)$ pour $m=2^{32}$.

7- Combien de paquets faut-il maintenant pour 50% ? Concluez sur l'efficacité de la contre-mesure.
