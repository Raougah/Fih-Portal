# Les chaines de Markov

Les chaînes de Markov sont un des outils les plus puissants pour modéliser tout ce qui évolue dans le temps de façon aléatoire, mais avec une mémoire très courte. Une chaîne de Markov modélise un système où l’état futur dépend uniquement de l’état présent, et en Python on la représente généralement par une matrice de transition utilisée pour simuler l’évolution des états.

## **L'idée de base**

Imagine que tu observes un système qui change d'état à chaque étape : la météo, le cours d'une action, la page web sur laquelle tu cliques, la lettre suivante dans un texte...

Une chaîne de Markov dit ceci :

**Pour prédire l'avenir, seul le présent compte. Le passé n'apporte rien de plus.**

C'est la propriété de Markov (ou propriété sans mémoire) :

$$
P(X_{n+1} = j \mid X_n = i, X_{n-1}, ..., X_0) = P(X_{n+1} = j \mid X_n = i)
$$

En clair : si aujourd'hui il pleut, la probabilité qu'il pleuve demain ne dépend que du fait qu'il pleut aujourd'hui, pas de toute la météo de la semaine dernière.

## **Propriétés des chaînes de Markov**

Une chaîne de Markov est un processus stochastique défini par :

1. **Un ensemble d’états** : S={$s_1$,$s_2$,...,$s_n$}
2. **Une matrice de transition** : $P$
   Elle contient toutes les probabilités de passage d'un état à un autre.Somme de chaque ligne est égal à $1$.
3. **Une distribution initiale** : $\pi_0$  
   La probabilité d'être dans chaque état au départ.

**Comment on l'utilise ?**

Pour prédire après $n$ étapes, on multiplie simplement :

$$
\pi_n = \pi_0 \times P^n
$$

$P^n$ c'est la matrice $P$ multipliée par elle-même $n$ fois. Elle te donne la probabilité d'aller de n'importe quel état à n'importe quel autre en $n$ étapes.

## **Les concepts importants**

- Chaîne homogène : $P$ ne change pas avec le temps. C'est le cas le plus étudié.
- État absorbant : Une fois qu'on y entre, on n'en sort plus. Probabilité de rester = 1. Exemple : dans un jeu, l'état "Partie terminée".
- Distribution stationnaire : Après très longtemps, la chaîne se stabilise vers une distribution $\pi$ qui ne change plus, même si on applique $P$ :

$$
\pi = \pi \times P
$$

- Irréductible / Périodique : Est-ce qu'on peut atteindre tous les états depuis tous les états ? Est-ce qu'on revient dans un état à intervalles réguliers ?

# Exemple : Prévision de la météo

On observe la météo d'une ville chaque jour. On suppose que la météo du lendemain ne dépend que de la météo d'aujourd'hui, et pas des jours précédents. C'est la propriété de Markov.

1. Les états

La météo peut prendre 3 états possibles :

$S$ : Soleil
$N$ : Nuage
$P$ : Pluie

2. La matrice de transition

Les probabilités de passage d'un jour à l'autre sont données par la matrice $P$ :

$$
P = \begin{pmatrix} P_{S \to S} & P_{S \to N} & P_{S \to P} \\ P_{N \to S} & P_{N \to N} & P_{N \to P} \\ P_{P \to S} & P_{P \to N} & P_{P \to P} \end{pmatrix} = \begin{pmatrix} 0,70 & 0,20 & 0,10 \\ 0,30 & 0,40 & 0,30 \\ 0,20 & 0,30 & 0,50 \end{pmatrix}
$$

Interprétation : Si aujourd'hui il fait Soleil, demain il y a 70% de chance qu'il fasse encore Soleil, 20% de chance qu'il fasse Nuage, et 10% de chance qu'il pleuve.

On suppose qu'au jour 0, il fait Soleil à 100%. Donc la distribution initiale est :

$$
\pi_0 = [1, 0, 0]
$$

Questions

Q1 - Simulation : Simuler la météo sur 30 jours en partant de Soleil. Afficher la trajectoire jour par jour.

Q2 - Évolution de la distribution : Calculer la distribution de probabilité $\pi_n = \pi_0 \times P^n$ pour $n = 1, 2, 5, 10, 50$ jours. Que remarquez-vous quand $n$ devient grand ?

Q3 - Distribution stationnaire : Calculer la distribution stationnaire $\pi$ telle que $\pi = \pi \times P$. Interpréter le résultat : sur le très long terme, quel pourcentage du temps fait-il Soleil, Nuage, Pluie ?

Q4 - Visualisation : Tracer un graphique en barres montrant la météo simulée sur les 30 jours (une couleur par état).

Code

```python
import numpy as np
import matplotlib.pyplot as plt

# 1. Définition de la chaîne
etats = ['Soleil', 'Nuage', 'Pluie']
# Matrice de transition P : lignes = aujourd'hui, colonnes = demain
#          Soleil  Nuage  Pluie
P = np.array([
    [0.7,    0.2,   0.1],  # Si Soleil aujourd'hui
    [0.3,    0.4,   0.3],  # Si Nuage aujourd'hui
    [0.2,    0.3,   0.5],  # Si Pluie aujourd'hui
])
```

Simulation : Simuler la météo sur 30 jours en partant de Soleil. Afficher la trajectoire jour par jour.

```python
# 2. Q1 : Simulation d'une trajectoire de 30 jours
np.random.seed(42)
n_jours = 30
etat_actuel = 0  # On commence au Soleil (indice 0)
trajectoire = [etat_actuel]

for _ in range(n_jours - 1):
    # On choisit le prochain état selon la ligne de P
    etat_actuel = np.random.choice([0, 1, 2], p=P[etat_actuel])
    trajectoire.append(etat_actuel)

print("Q1 - Trajectoire sur 30 jours :")
print([etats[i] for i in trajectoire])
```

Évolution de la distribution : Calculer la distribution de probabilité πn=π0×Pn pour n=1,2,5,10,50 jours. Que remarquez-vous quand n devient grand ?

```python
# 3. Q2 : Distribution après n étapes : pi_n = pi_0 * P^n
pi_0 = np.array([1.0, 0.0, 0.0])  # On commence à 100% Soleil
print("\nQ2 - Évolution de la distribution :")
for n in [1, 2, 5, 10, 50]:
    pi_n = pi_0 @ np.linalg.matrix_power(P, n)
    print(f"Après {n:2d} jours : Soleil={pi_n[0]:.3f} | Nuage={pi_n[1]:.3f} | Pluie={pi_n[2]:.3f}")
```

Q3 - Distribution stationnaire : Calculer la distribution stationnaire π telle que π=π×P . Interpréter le résultat : sur le très long terme, quel pourcentage du temps fait-il Soleil, Nuage, Pluie ?

```python
# 4. Q3 : Distribution stationnaire (vecteur propre)
valeurs, vecteurs = np.linalg.eig(P.T)
idx = np.argmin(np.abs(valeurs - 1))
pi_stat = np.real(vecteurs[:, idx])
pi_stat = pi_stat / pi_stat.sum()
print(f"\nQ3 - Distribution stationnaire : Soleil={pi_stat[0]:.3f} | Nuage={pi_stat[1]:.3f} | Pluie={pi_stat[2]:.3f}")
```

Q4 - Visualisation : Tracer un graphique en barres montrant la météo simulée sur les 30 jours (une couleur par état).

```python
# 5. Q4 : Graphique
fig, ax = plt.subplots(figsize=(10, 4))
couleurs = {'Soleil': '#FFC107', 'Nuage': '#9E9E9E', 'Pluie': '#2196F3'}
for i, etat in enumerate(trajectoire):
    ax.bar(i, 1, color=couleurs[etats[etat]], edgecolor='white')
ax.set_yticks([])
ax.set_xlabel('Jour')
ax.set_title('Simulation d\'une chaîne de Markov - Météo sur 30 jours')
ax.set_xticks(range(0, 30, 2))
from matplotlib.patches import Patch
ax.legend(handles=[Patch(color=v, label=k) for k, v in couleurs.items()], loc='upper right')
plt.tight_layout()
plt.show()
```

# Réseau de Pétri

les réseaux de Petri servent à modéliser la logique : qui attend qui, qui bloque qui, ce qui se passe en parallèle.

C'est l'outil de base en informatique pour les systèmes concurrents, les protocoles réseau, les systèmes embarqués.

## **Principe**

Un réseau de Petri, c'est un graphe avec 2 types de nœuds :

1. Les Places (ronds) : Ce sont les états / les ressources / les conditions.  
   Exemple : Machine libre, Pièce en attente, Buffer plein.
2. Les Transitions (rectangles / barres) : Ce sont les événements / les actions.  
   Exemple : Commencer l'usinage, Envoyer un paquet, Prendre un jeton.

Et entre les deux, des flèches qui relient Places -> Transitions et Transitions -> Places.

3. Le Jeton (point noir •) : il circule dans les places. C'est lui qui dit où on en est.

**Un réseau de Petri = Places + Transitions + Jetons qui se déplacent**

## **La régle du jeu**

Une transition peut se déclencher (tirer) si et seulement si :

Toutes les places en entrée ont au moins 1 jeton.

**Quand elle se déclenche** :

On retire 1 jeton de chaque place d'entrée  
On ajoute 1 jeton dans chaque place de sortie

# **Exemple**

Contexte : Un émetteur veut envoyer des paquets à un récepteur. On utilise le protocole le plus simple : Stop-and-Wait.

L'émetteur envoie un paquet, puis attend.  
Le récepteur reçoit le paquet, puis envoie un ACK (acquittement).  
L'émetteur ne peut envoyer le paquet suivant que quand il a reçu le ACK.

On veut modéliser ce protocole avec un réseau de Petri pour vérifier qu'il ne bloque jamais (pas de deadlock).

1. Les Places (ronds = états / ressources)

$P_0$ : Émetteur prêt
$P_1$ : Paquet en transit (sur le canal)
$P_2$ : Récepteur prêt
$P_3$ : ACK en transit
$P_4$ : Paquets reçus (compteur)

Marquage initial $M_0$ : 1 jeton en $P_0$, 1 jeton en $P_2$, 0 ailleurs.

$$
M_0 = [1, 0, 1, 0, 0]
$$

2. Les Transitions (rectangles = événements)

$T_0$ : Envoyer - Entrée : $P_0$ / Sortie : $P_1$
$T_1$ : Recevoir + Envoyer ACK - Entrées : $P_1, P_2$ / Sorties : $P_2, P_3, P_4$
$T_2$ : Recevoir ACK - Entrée : $P_3$ / Sortie : $P_0$

Règle de franchissement : Une transition est franchissable si toutes ses places d'entrée contiennent au moins 1 jeton. Quand elle tire, on retire 1 jeton de chaque entrée et on ajoute 1 jeton dans chaque sortie.

Questions

Q1 - Simulation : Simuler l'envoi de 3 paquets complets. Donner la séquence de tirs et l'évolution du marquage pas à pas.

Q2 - Analyse : Le réseau est-il :  
a) Borné ? Le nombre de jetons reste-t-il limité dans chaque place ?  
b) Vivant ? Peut-on toujours continuer à envoyer des paquets, ou peut-on arriver dans un état de blocage (deadlock) ?  
c) Réversible ? Peut-on revenir au marquage initial (à part le compteur $P_4$) ?

Q3 - Interprétation réseau : Que se passe-t-il si le paquet est perdu ? Quelle transition faudrait-il ajouter pour modéliser un timeout et une retransmission ?

## **Code**

```python
# Marquage initial : [P0, P1, P2, P3, P4]
marquage = [1, 0, 1, 0, 0]

def est_franchissable(m, entrees):
    return all(m[p] >= 1 for p in entrees)

def tirer(m, entrees, sorties, nom):
    if not est_franchissable(m, entrees):
        print(f"BLOQUÉ : {nom}")
        return False
    for p in entrees:
        m[p] -= 1
    for p in sorties:
        m[p] += 1
    print(f"{nom:35s} -> Marquage = {m}")
    return True

print(f"Initial : {marquage}")

# 3 paquets = 9 tirs : T0 -> T1 -> T2 répété 3 fois
for i in [1, 2, 3]:
    tirer(marquage, [0], [1], f"T0: Envoyer paquet {i}")
    tirer(marquage, [1, 2], [2, 3, 4], f"T1: Recevoir + Envoyer ACK {i}")
    tirer(marquage, [3], [0], f"T2: Recevoir ACK {i}")

print(f"\nMarquage final : {marquage}")
```

![[MODSIM_TP3_image.png]]

## **Réponses**

Q2 a) Borné : Oui. $P_0, P_1, P_2, P_3$ ne dépassent jamais 1 jeton. Seul $P_4$ grandit, c'est normal, c'est un compteur.

Q2 b) Vivant : Oui, pas de deadlock. À chaque étape, exactement une transition est franchissable. L'émetteur ne peut pas envoyer 2 paquets d'affilée car $P_0$ est vide après $T_0$ : il doit attendre le ACK. C'est exactement ce qu'on veut prouver.

Q2 c) Réversible : Oui. Après chaque paquet, on revient à $[1, 0, 1, 0, k]$.

Q3 - Si perte : Dans ce modèle simple, si le paquet est perdu, on bloque pour toujours. En vrai, il faut ajouter une transition $T_{timeout}$ : Entrée $P_1$ / Sortie $P_0$ (on abandonne et on redevient prêt à retransmettre). C'est comme ça qu'on modélise la retransmission dans TCP.

# Exercices

## **Exercice 1: Modélisation d'une liaison sans fil avec une chaîne de Markov**

Contexte

On étudie une liaison WiFi entre un client et un point d'accès. On envoie une suite de paquets, un par un, à intervalles réguliers.

Contrairement à un modèle simpliste, la perte d'un paquet n'est pas indépendante de la perte du paquet précédent : quand la liaison se dégrade (obstacle, interférence, éloignement), plusieurs paquets consécutifs sont perdus. On dit que les erreurs arrivent en rafales.

Pour modéliser cela, on utilise le modèle de Gilbert-Elliott, qui est une chaîne de Markov à 2 états.

1. Les états du canal

Le canal peut être dans l'un des deux états suivants à chaque instant $n$ :

État $G$ (Good / Bon) : la liaison est de bonne qualité.  
État $B$ (Bad / Mauvais) : la liaison est dégradée.

La transition entre les états suit la matrice de transition $P$ :

$$
P = \begin{pmatrix} P_{G \to G} & P_{G \to B} \\ P_{B \to G} & P_{B \to B} \end{pmatrix} = \begin{pmatrix} 0,95 & 0,05 \\ 0,30 & 0,70 \end{pmatrix}
$$

Interprétation : Si le canal est Bon, il a 95% de chance de rester Bon au paquet suivant et 5% de chance de devenir Mauvais. Si le canal est Mauvais, il a 30% de chance de redevenir Bon et 70% de chance de rester Mauvais.

2. La perte de paquets

La probabilité de perdre un paquet dépend uniquement de l'état actuel du canal :

Si le canal est en état $G$ : $P(\text{perte} \mid G) = 0,01$ (1% de perte)  
Si le canal est en état $B$ : $P(\text{perte} \mid B) = 0,40$ (40% de perte)

Au départ, à $n=0$, on suppose que le canal est en état $G$.

Questions

Q1 - Simulation : Simuler l'envoi de $N = 500$ paquets. Pour chaque paquet, déterminer l'état du canal et si le paquet est perdu ou reçu.

Q2 - Analyse des résultats : À partir de la simulation, calculer :  
a) Le pourcentage du temps passé dans l'état Mauvais.  
b) Le taux de perte global de paquets.  
c) Le taux de perte conditionnel : quand le canal est Bon, et quand il est Mauvais.

Q3 - Analyse théorique : Calculer la distribution stationnaire $\pi = [\pi_G, \pi_B]$ de la chaîne. En déduire le taux de perte théorique sur le long terme :

$$
P_{perte} = \pi_G \times 0,01 + \pi_B \times 0,40
$$

Q4 - Durée des rafales : Calculer la durée moyenne d'une période Bonne et d'une période Mauvaise. En déduire pourquoi on parle d'erreurs en rafales.

Q5 - Interprétation réseau : Expliquer en quoi ce modèle est plus réaliste qu'un modèle où chaque paquet aurait une probabilité de perte fixe et indépendante de 6%. Quelles conséquences cela a-t-il pour le choix d'un mécanisme de correction d'erreur (FEC) ou pour TCP ?

## **Exercice 2: Simulation d'une onde verte répartie**

Modéliser et simuler le comportement de deux carrefours adjacents (Carrefour A et Carrefour B) synchronisés en réseau pour créer une "onde verte". Chaque carrefour est régi par une machine à états finis (FSM) locale contrôlant l'alternance des feux entre l'Axe Principal (AP) et l'Axe Secondaire (AS) .

1. Spécifications des machines à états locales :

- Chaque carrefour cycle à travers 4 états :  
  AP_VERT → AP_ORANGE → AS_VERT → AS_ORANGE → AP_VERT.
- Durées par défaut des feux : Vert = 15 secondes, Orange = 3 secondes.

2. Spécifications du protocole réparti (Synchronisation) :

- Les voitures mettent 10 secondes pour rouler du Carrefour A au Carrefour B.
- Lorsque le Carrefour A passe au vert (AP_VERT), il doit envoyer un signal réseau qui parviendra au Carrefour B exactement 10 secondes plus tard.
- À la réception de ce signal (SIGNAL_SYNCHRO), le Carrefour B doit immédiatement forcer sa transition vers l'état AS_VERT afin d'accueillir le flux de véhicules arrivant, réinitialisant ainsi son propre cycle.

**Travail demandé :**

Implémenter un moteur de simulation à événements discrets en Python capable d'ordonnancer chronologiquement les événements locaux (les temporisateurs des feux) et les événements répartis (les messages réseau inter-carrefours), puis afficher le suivi temporel précis des états du système.
