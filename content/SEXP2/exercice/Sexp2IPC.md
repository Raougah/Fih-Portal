## **Exercice 1**

### Question 1:Communication unidirectionnelle avec les tubes anonymes  

Écrire un programme C qui crée deux processus : le processus père écrit le message « Bonjour, fils. Je suis ton père ! ». Le fils le récupère, puis l'affiche en utilisant un tube anonyme.

### Question 2: Communication bidirectionnelle avec les tubes anonymes  

Écrire un programme C qui permet de réaliser une communication bidirectionnelle d'informations entre un processus père et son fils via des tubes anonymes. On souhaite réaliser cette communication dans laquelle deux processus A et B s'échangent une chaîne de caractères, plus précisément :

- Le processus A envoie la chaîne "hello, je suis le processus A"
- Le processus B répond par la chaîne "hello, je suis le processus B"

---

## **Exercice 2:** Application client/serveur

Écrire deux programmes en C

- Le premier programme : un serveur écrit des messages de 64 caractères dans un tube nommé.
- Le deuxième programme : un client lit sur ce tube nommé des messages de 64 caractères et les affiche sur la sortie standard.

---

## **Exercice 3**

Écrire un programme C qui effectue une communication entre deux processus par une file de message de clé 17.

---

## **Exercice 4**

Écrire un programme C qui crée trois fils, l'un affiche les entiers de 1 à 30, le deuxième de 31 à 60 et le troisième de 61 à 90.

On veut que l'affichage soit ordonné de 1 à 90, proposer une solution via les signaux (utiliser les signaux SIGUSR1 et SIGUSR2).