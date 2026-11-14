**Simulation avec la bibliothéque SciPy** 
  
SciPy = boite à outils scientifique qui s'appuie sur NumPy. Elle est découpée en sous-modules

Imports :

```python
import scipy
import numpy as np
```

**scipy.stats**  - Le MODULE PRINCIPAL (lois + tests)

**Fonctions Utiles**

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

def afficher_loi(data, x_theo, y_theo, titre, bins=50, discret=False):
    plt.figure(figsize=(6,4))
    if discret:
        plt.hist(data, bins=bins, density=True, alpha=0.5, label='Simulé', rwidth=0.8)
        plt.stem(x_theo, y_theo, linefmt='r-', markerfmt='ro', basefmt=' ', label='Théorique')
    else:
        plt.hist(data, bins=bins, density=True, alpha=0.5, label='Simulé')
        plt.plot(x_theo, y_theo, 'r-', lw=2, label='Théorique')
    plt.title(titre)
    plt.legend()
    plt.grid(alpha=0.3)
    plt.show()
```

# ***1-Lois Discrétes***

```python
from scipy import stats

# 1. Créer une loi discrète
X_disc = stats.binom(n=10, p=0.5) # Binomiale

# Valeurs de test pour éviter les erreurs de variables non définies
x = 0.0
k = 5
q = 0.95


# Fonctions magiques pour les lois DISCRÈTES :
print("\n--- Loi Discrète (Binomiale) ---")
print("pmf(k) :", X_disc.pmf(k))   # proba P(X = k)
print("cdf(k) :", X_disc.cdf(k))   # P(X <= k)
print("ppf(q) :", X_disc.ppf(q))   # quantile
print("stats  :", X_disc.mean(), X_disc.var(), X_disc.std())
print("rvs    :", X_disc.rvs(size=5)) # Simulation
```

# ***Exemples***

Exemple 1 : Loi de Bernoulli - succès / échec

Pile ou face truqué. p=0.7

```python
p = 0.7
data = stats.bernoulli.rvs(p, size=10000)
x = [0,1]
y = stats.bernoulli.pmf(x, p)
afficher_loi(data, x, y, f"Bernoulli(p={p})", bins=[-0.5,0.5,1.5], discret=True)
```

Exemple 2 : Loi Binomiale - $n$ répétitions de Bernoulli

Sur 20 paquets, combien ont un défaut si $p=0.5$ ?

```python
n, p = 20, 0.5
data = stats.binom.rvs(n, p, size=10000)
x = np.arange(0, n+1)
y = stats.binom.pmf(x, n, p)
afficher_loi(data, x, y, f"Binomiale(n={n}, p={p})", bins=np.arange(-0.5,n+1.5,1), discret=True)
```

Exemple 3 : Loi de Poisson -événements rares par intervalle

Nombre d'appels par minute à un call-center, $\lambda=4$

```python
lam = 4
data = stats.poisson.rvs(lam, size=10000)
x = np.arange(0, 15)
y = stats.poisson.pmf(x, lam)
afficher_loi(data, x, y, f"Poisson(λ={lam})", bins=np.arange(-0.5,15.5,1), discret=True)
```

Exemple 4 : Loi Géométrique p=0.3 (nombre d'échecs avant 1er succès)

```python
p = 0.3
data = stats.geom.rvs(p, size=10000)
x = np.arange(1, 15)
y = stats.geom.pmf(x, p)
afficher_loi(data, x, y, f"Géométrique(p={p})", bins=np.arange(0.5,15.5,1), discret=True)
```

![[MODSIM_TP2_image1.jpg]]

# ***2- Lois Continues***

```python
# 2. Créer une loi continue
X_cont = stats.norm(loc=0, scale=1) # Normale
# Valeurs de test pour éviter les erreurs de variables non définies
x = 0.0
k = 5
q = 0.95
# Fonctions magiques pour les lois CONTINUES :
print("--- Loi Continue (Normale) ---")
print("pdf(x) :", X_cont.pdf(x))   # densité f(x)
print("cdf(x) :", X_cont.cdf(x))   # P(X <= x)
print("ppf(q) :", X_cont.ppf(q))   # inverse de cdf (quantile)
print("stats  :", X_cont.mean(), X_cont.var(), X_cont.std())
print("rvs    :", X_cont.rvs(size=5)) # Simulation
```

# Exemples

Exemple 1 : Loi Uniforme - $U(a,b)$

Générateur de base $U \sim U[0,1[$, c'est Le LCG

```python
data = stats.uniform.rvs(0, 1, size=10000)
x = np.linspace(0, 1, 100)
y = stats.uniform.pdf(x, 0, 1)
afficher_loi(data, x, y, "Uniforme U[0,1]", bins=30)
```

Exemple 2 : Loi Exponentielle - temps d'attente

Temps entre 2 pannes, $\lambda=0.2$

```python
lam = 0.2
data = stats.expon.rvs(scale=1/lam, size=10000)
x = np.linspace(0, 15, 100)
y = stats.expon.pdf(x, scale=1/lam)
afficher_loi(data, x, y, f"Exponentielle(λ={lam})", bins=50)
```

Exemple 3 : Loi Normale - $N(\mu, \sigma^2)$

Taille d'étudiants $\mu=175, \sigma=6$

```python
mu, sigma = 0, 1
data = stats.norm.rvs(mu, sigma, size=10000)
x = np.linspace(-4, 4, 100)
y = stats.norm.pdf(x, mu, sigma)
afficher_loi(data, x, y, f"Normale N({mu},{sigma})", bins=50)
```

Exemple 4 : Loi Gamma

```python
a, scale = 2, 2
data = stats.gamma.rvs(a, scale=scale, size=10000)
x = np.linspace(0, 15, 100)
y = stats.gamma.pdf(x, a, scale=scale)
afficher_loi(data, x, y, f"Gamma(k={a}, θ={scale})", bins=50)
```

> [!important] IMPORTANT
> - Loi Discrète : utilise `.pmf(k)` = Probabilité
> - Loi Continue : utilise `.pdf(x)` = Densité et `.cdf(x)` = $P(X \le x)$
> - Toujours : `.rvs(n)` pour simuler

![[MODSIM_TP2_image2.jpg]]

# ***Exercice 1 : Centre d'appel Djezzy à Oran - Loi de Poisson + Exponentielle***

Le centre d'appel Djezzy Oran reçoit en moyenne λ= 120 appels / heure entre 8h-18h.
  
Un téléconseiller traite un appel en moyenne en 3 minutes.

**Questions :**

1- Avec stats.poisson.rvs (μ=120), simule le nombre d'appels reçus pendant 1 heure sur 1000 jours.

2- Quelle est la probabilité d'avoir plus de 140 appels en 1h?

3- Avec stats.expon.rvs(scale=3), simule 1000 durées d'appels en minutes. Quelle proportion dure plus de 5 min?

4- Si on a c=8 agents, simule une journée complète avec la méthode de l'Exercice file d'attente. Quel est le temps d'attente moyen?

5- Combien d'agents faut-il pour avoir $w_q < 30$ secondes?

# ***Exercice 2 :***

Une superette à Oran vend en moyenne $μ =350$ baguettes / jour avec un écart-type $σ  =50$.

Chaque baguette invendue est perdue. Chaque baguette en rupture = client perdu. Elle commande chaque matin.
  
 **Données :**

- Demande journalière D ~$N$($350$, $50^2$)
- Coût achat 15 DA, vente 25 DA, perte 15 DA si invendu

**Questions :**

1-Génère 1 an (365 jours) de demande avec stats.norm.rvs(loc=350, scale=50, size=365). Tracer l'histogramme.

2- Si elle commande 350 chaque jour, simule le profit sur 1 an. Combien de jours en rupture? Combien de jours avec gaspillage?

3- Trouve la quantité optimale $Q^*$ qui maximise le profit moyen. Teste Q de 300 à 450. C'est la formule du Newsvendor.

4- Quelle est la probabilité que la demande dépasse 400? Avec norm.cdf().

# ***Exercice 3: Serveur Moodle USTO***

Le serveur Moodle de l'USTO reçoit des requêtes. La taille des fichiers uploadés par les étudiants suit une loi Log-Normale (beaucoup de petits PDFs, quelques gros projets).
  
Le temps entre 2 requêtes en période d'examens suit Exp(λ=5 req/s)
  
**Données réelles mesurées USTO :**

- Taille fichier : moyenne 2MB
- σ=1.5MB -> Log-Normale
- Inter-arrivée : Exp(5)
    
**Questions :**

1. Génère 5000 tailles de fichiers avec stats.lognorm.rvs(s=0.8, scale=2).
2. Tracer la courbe .
3. Quelle est la taille moyenne? Médiane?
4. Quelle est la probabilité qu'un étudiant upload un fichier >10MB qui fait ramer le serveur? lognorm.sf(10)
5. Simule 1 heure d'examens : (3600s × 5 req/s = 18000 requêtes)
6. Génère les temps d'arrivée avec expon.rvs().
7. Le serveur a 100GB de bande passante / heure. Quelle est la probabilité de saturation?
8. Refais la simulation 1000 fois.
