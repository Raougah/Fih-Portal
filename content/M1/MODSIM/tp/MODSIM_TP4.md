# Les files d'attente
Une file d'attente est un système dans lequel des clients arrivent, attendent si nécessaire, reçoivent un service, puis quittent le système.

## Caractéristiques
Une file d'attente est caractérisée par 3 éléments :

1. Le processus d'arrivée Comment les clients arrivent-ils ?

Taux d'arrivée : $\lambda$ = nombre moyen d'arrivées par unité de temps Temps moyen entre 2 arrivées : $1 / \lambda$

2. Le processus de service Comment les clients sont-ils servis ?

Taux de service : $\mu$ = nombre moyen de clients servis par unité de temps (si le serveur travaille sans arrêt) Temps moyen de service : $1 / \mu$ Nombre de serveurs : $c = 1, 2, 3...$

3. La capacité et la discipline

Capacité $K$ : nombre maximum de clients autorisés dans le système.

Si $K = \infty$, on ne perd personne. Si $K$ est fini, un client qui arrive quand le système est plein est perdu / rejeté.

Discipline $D$ : ordre de service.

Par défaut FIFO : First In, First Out, premier arrivé, premier servi.

## La notation de Kendall
c'est juste le langage standard pour décrire une file d'attente en 1 ligne.

Une file d'attente se note :

$$
A / B / c / K / N / D
$$

On n'utilise souvent que les 3 premiers, les 3 derniers sont optionnels (on suppose infini / FIFO par défaut).

A : Loi des arrivées (inter-arrivée)

B: Loi du service (temps de service)

c: Nombre de serveurs

K: Capacité max du système (optionnel)

N: Taille de la population (optionnel) $\infty$ par défaut

D : Discipline de service (optionnel) $FIFO, LIFO, ...$

Le code pour A et B :

- $M$ Markovian / Memoryless\*\* : arrivées selon un processus de Poisson, temps de service exponentiel. C'est le cas qui se ramène à une chaîne de Markov.
- Deterministic $D$\*\* : temps fixe, toujours le même. Ex : un paquet qui met exactement 10ms.
- Erlang-k: un intermédiaire entre $M$ et $D$.
- General : n'importe quelle loi, on ne sait pas.

## Exemples
1. $M/M/1$ : La file de base 1 serveur, arrivées Poisson de taux $\lambda$, service exponentiel de taux $\mu$. C'est la file d'un routeur avec 1 lien de sortie.

Exemple : $\lambda = 8$ paquets/s qui arrivent, $\mu = 10$ paquets/s que le routeur peut traiter.

2. $M/M/1/K$ : La file avec buffer limité Comme $M/M/1$, mais le buffer ne peut contenir que $K$ paquets max. Si un paquet arrive et le buffer est plein, il est perdu. $K$ = taille du buffer.

3. $M/M/c$ : Plusieurs serveurs $c$ serveurs en parallèle.

Ex : un centre d'appel avec 5 opérateurs, un serveur web avec 4 cœurs.

4. $M/D/1$ : Service déterministe Arrivées Poisson, mais service toujours identique. Ex : un lien qui envoie des paquets de taille fixe.

## Les formules clés pour $M/M/1$
C'est la seule file où tout se calcule à la main. C'est pour ça qu'on l'utilise tout le temps en examen.

Condition de stabilité :

$$
\rho = \frac{\lambda}{\mu} < 1
$$

Si $\rho \ge 1$, les arrivées vont plus vite que le service, la file explose vers l'infini. C'est un embouteillage.

Si $\rho < 1$, on a :

Nombre moyen de clients dans le système :

$$
L = \frac{\rho}{1-\rho}
$$

Nombre moyen en attente (sans celui en service) :

$$
L_q = \frac{\rho^2}{1-\rho}
$$

Temps moyen passé dans le système (Loi de Little : $L = \lambda W$) :

$$
W = \frac{1}{\mu - \lambda}
$$

Temps moyen d'attente :

$$
W_q = \frac{\rho}{\mu - \lambda}
$$

## Exemple: Un routeur modélisé par une file $M/M/1$
Contexte

Un routeur reçoit des paquets et les retransmet sur un lien de sortie. Il n'a qu'un seul serveur (le lien) et un buffer supposé infini. La discipline est FIFO : premier arrivé, premier servi.

On modélise cette file par la notation de Kendall :

$$
M / M / 1
$$

Premier $M$ : les arrivées suivent un processus de Poisson de taux $\lambda$. Cela veut dire que les temps entre deux arrivées successives suivent une loi exponentielle de moyenne $1/\lambda$.

Deuxième $M$ : les temps de service suivent une loi exponentielle de taux $\mu$, de moyenne $1/\mu$.

$1$ : un seul serveur.

**Paramètres** :

$\lambda = 8$ paquets / seconde $\mu = 10$ paquets / seconde

**Questions**

Q1 - Stabilité : Calculer l'intensité du trafic $\rho = \lambda / \mu$. La file est-elle stable ? Que se passe-t-il si $\rho \ge 1$ ?

Q2- Calculer avec les formules de $M/M/1$ : a) $L$ : nombre moyen de paquets dans le système

b) $L_q$ : nombre moyen de paquets en attente

c) $W$ : temps moyen passé dans le système

d) $W_q$ : temps moyen d'attente

e) $P_0$ : probabilité que le système soit vide

**Rappel** : Loi de Little : $L = \lambda W$

Q3 - Simuler l'arrivée et le service de $N = 20000$ paquets.

Pour chaque paquet, calculer son temps d'attente et son temps de séjour. Comparer les moyennes simulées aux valeurs théoriques. L'erreur est-elle faible ?

Q4 - Sensibilité : Refaire le calcul(Q2) pour $\lambda = 5, 9, 9.5 et 9.9$.

Que remarquez-vous quand $\rho$ s'approche de 1 ? Expliquer pourquoi un routeur ne doit jamais fonctionner à $\rho = 0.99$?

## Code
```python
import numpy as np

lam = 8.0   # arrivées : 8 paquets/s
mu = 10.0   # service : 10 paquets/s
rho = lam / mu
n_paquets = 20000

# Q2 - Calcul
L_theo = rho / (1 - rho)
Lq_theo = rho**2 / (1 - rho)
W_theo = 1 / (mu - lam)
Wq_theo = rho / (mu - lam)
P0_theo = 1 - rho

# Q3 - Simulation
np.random.seed(42)
inter_arrivees = np.random.exponential(1/lam, n_paquets)
services = np.random.exponential(1/mu, n_paquets)
arrivees = np.cumsum(inter_arrivees)
arrivees[0] = 0

departs = np.zeros(n_paquets)
debut_service = np.zeros(n_paquets)

for i in range(n_paquets):
    if i == 0:
        debut_service[i] = arrivees[i]
    else:
        # Le service commence quand le paquet arrive
        # ET que le serveur est libre
        debut_service[i] = max(arrivees[i], departs[i-1])
    departs[i] = debut_service[i] + services[i]

temps_systeme = departs - arrivees
temps_attente = debut_service - arrivees

print(f"L simulé = {np.mean(temps_systeme)*lam:.3f} (théorie {L_theo:.3f})")
print(f"W simulé = {np.mean(temps_systeme):.3f} s (théorie {W_theo:.3f})")
print(f"Wq simulé = {np.mean(temps_attente):.3f} s (théorie {Wq_theo:.3f})")
```

# Exercice

Dimensionnement d'une ferme de serveurs Web derrière un Load Balancer

Une entreprise héberge son API de paiement dans un datacenter à ORAN . L'architecture est la suivante :

· Le trafic arrivant sur le Load Balancer suit un processus de Poisson d'intensité lambda λ= 120 requêtes/s

- Chaque serveur si traite les requêtes avec un temps de service exponentiel de moyenne 20 ms, soit mu µ = 50 requêtes/s par serveur.
- Le Load Balancer possède une file d'attente commune infinie et répartit en Round-Robin vers le premier serveur libre. C'est exactement un modèle M/M/c avec c=3(paralléle)
- Le SLA (Service Level Agreement ) contractuel avec les clients impose un temps d'attente dans la file W_q < 30 ms et un temps de réponse total W < 100 ms.

**Travail à réaliser**:

1. Modélisation : Justifier pourquoi ce système est un M/M/c et non 3 systèmes M/M/1 séparés? Quelle est l'hypothèse sur le Load Balancer qui rend la mutualisation possible ?

2. Stabilité : Calculer ρ pour c=3 . Le système est-il stable ? Que se passe-t-il concrètement sur le réseau (file TCP, timeout) si ρ ≥ 1 ?

3. Calculs de base : Calculer P0 (probabilité que les 3 serveurs soient vides), L_q, W_q, W et L. Le SLA est-il respecté ?

4. Probabilité d'attente : Calculer P_{attente} = P(N ≥c) , c'est-à-dire la probabilité qu'une requête doive attendre dans le Load Balancer. Interpréter le résultat.

5. Pic de charge : Refaire les calculs pour un pic à lambda λ = 180 req/s (soldes). Que vaut W_q ? Que se passe-t-il ?

6. Dimensionnement SLA : On veut garantir W_q < 20ms pour lambda λ= 150 req/s. Calculer W_q et W pour c=3, 4, 5 . Combien de serveurs faut-il provisionner au minimum ? Quel est l'impact sur ρ ?

7. Comparaison d'architectures : Comparer avec 3 files M/M/1 isolées (chaque serveur a sa propre file avec λi = 40 req/s). Calculer W_q pour M/M/1 avec la formule W_q = ρ / (µ - λ). Conclure sur le gain de la mutualisation M/M/c.

8. Tracer les courbes nécessaires
