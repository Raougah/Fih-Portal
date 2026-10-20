## Exercice 1 — Paradigmes de communication

Pour chaque situation, indiquez le paradigme (**Client/Serveur**, **Peer-to-Peer** ou **Publish/Subscribe**) et justifiez.

| N°  | Situation                                                                                                                               | Paradigme |
| --- | --------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| 1   | Un étudiant consulte son relevé de notes depuis une application universitaire.                                                          | CS        |
| 2   | Deux utilisateurs échangent directement des fichiers sans passer par un serveur central.                                                | PP        |
| 3   | Un capteur de température publie périodiquement sa température sur un serveur MQTT. Plusieurs applications reçoivent cette information. | PS        |
| 4   | Un navigateur Web demande une page HTML à un serveur Web.                                                                               | CS        |
| 5   | Une application de messagerie reçoit automatiquement les notifications concernant un sujet auquel elle s'est abonnée.                   | PS        |
| 6   | Deux ordinateurs utilisent un système de partage de fichiers dans lequel chaque ordinateur peut être à la fois client et serveur.       | PP        |

---

## Exercice 2 — Avantages et limites

Indiquez le paradigme correspondant principalement : **C/S**, **P2P** ou **Pub/Sub**.

| N°  | Avantage ou limite                                                                                                                                                                                                      | Paradigme |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| 1   | Centralisation de la gestion et des ressources.                                                                                                                                                                         | CS        |
| 2   | Absence de serveur central, ce qui évite qu'un serveur unique constitue un point de défaillance.                                                                                                                        | PP        |
| 3   | Le producteur de données n'a pas besoin de connaître directement les destinataires.                                                                                                                                     | PS        |
| 4   | La défaillance du serveur central peut rendre le service indisponible.                                                                                                                                                  | CS        |
| 5   | Bonne adaptation à la diffusion d'une même information vers un grand nombre de destinataires.                                                                                                                           | PS        |
| 6   | Chaque pair peut à la fois fournir et consommer des ressources.                                                                                                                                                         | PP        |
| 7   | La présence d'un serveur central peut créer un goulot d'étranglement lorsque le nombre de clients devient très important.                                                                                               | CS        |
| 8   | Les communications sont généralement organisées autour de sujets (topics), ce qui facilite le découplage entre producteurs et consommateurs.                                                                            | PS        |
| 9   | La gestion et la coordination du réseau peuvent devenir complexes lorsque le nombre de pairs augmente.                                                                                                                  | PP        |
| 10  | Le serveur peut facilement appliquer des mécanismes centralisés d'authentification, de contrôle d'accès et de gestion des ressources.                                                                                   | CS        |
| 11  | Le producteur et le consommateur sont découplés dans le temps : un abonné peut recevoir une information sans communiquer directement avec le producteur au moment où celle-ci est produite, selon le mécanisme utilisé. | PS        |
| 12  | Les performances peuvent dépendre fortement de la disponibilité et de la capacité du serveur central.                                                                                                                   | CS        |
| 13  | L'absence d'infrastructure centrale peut rendre plus difficile la mise en œuvre de politiques globales de sécurité et de contrôle.                                                                                      | PP        |
| 14  | Un broker peut constituer un point central dont la panne affecte la communication entre producteurs et abonnés.                                                                                                         | PS        |
| 15  | La répartition des ressources entre plusieurs pairs peut permettre de mieux répartir la charge.                                                                                                                         | PP        |

---

## Exercice 3

### Partie 1 — QCM

**1. Que signifie l'acronyme HTTP ?**
- [x] A) HyperText Transfer Protocol
- [ ] B) HyperText Transmission Process
- [ ] C) High Transfer Text Protocol
- [ ] D) Hyperlink Test Transfer Program

**2. Quelle est la principale différence entre HTTP et HTTPS ?**
- [ ] A) HTTPS est plus rapide que HTTP.
- [ ] B) HTTP chiffre les données alors que HTTPS ne le fait pas.
- [x] C) HTTPS ajoute une couche de chiffrement (SSL/TLS) pour sécuriser les données.
- [ ] D) HTTP utilise le port 443 et HTTPS utilise le port 80.

**3. Sur quel port par défaut fonctionne le protocole HTTP non sécurisé ?**
- [ ] A) Port 21
- [x] B) Port 80
- [ ] C) Port 443
- [ ] D) Port 8080

**4. Quel protocole de sécurité est utilisé par HTTPS pour chiffrer les échanges ?**
- [ ] A) FTP
- [ ] B) SSH
- [x] C) SSL/TLS
- [ ] D) TCP

**5. Quel est le risque principal si vous saisissez un mot de passe sur un site utilisant uniquement le HTTP ?**
- [ ] A) Votre ordinateur attrape un virus instantanément.
- [x] B) Les données voyagent en clair et peuvent être lues par un piratage sur le réseau (Man-in-the-Middle).
- [ ] C) Le site web se ferme automatiquement.
- [ ] D) Le navigateur bloque le processeur.

### Partie 2 — Vrai ou Faux

| N°  | Affirmation                                                                                                                    | Vrai / Faux |
| --- | ------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| 1   | Le protocole HTTPS utilise par défaut le port 443.                                                                             | V           |
| 2   | Les données transmises via HTTP sont illisibles car elles sont automatiquement transformées en code crypté.                    | F           |
| 3   | Un certificat numérique (émis par une autorité de certification) aide le navigateur à vérifier l'identité du serveur en HTTPS. | V           |

---

## Exercice 4

Un étudiant saisit l'adresse suivante dans son navigateur : `https://www.universite.dz`

L'ordinateur vient d'être connecté au réseau et ne possède pas encore d'adresse IP.

### 1. Étapes (protocoles) dans l'ordre logique

**Réponse :**

1.
2.
3.
4.
5.
6.

### 2. Pour chaque protocole

| Protocole | a) Qui communique avec qui ? | b) Objectif de l'échange | c) Type d'information échangée |
|-----------|------------------------------|--------------------------|--------------------------------|
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

### 3. À quel moment intervient le TLS Handshake ?

**Réponse :**


### 4. Quand la requête HTTP devient-elle protégée ?

**Réponse :**


### 5. Rôle du certificat du serveur

**Réponse :**


### 6. HTTPS garantit-il que le contenu d'un site Web est fiable ? Pourquoi ?

**Réponse :**


### 7. Piles de protocoles

| Version | Pile de protocoles (de haut en bas) |
|---------|-------------------------------------|
| HTTP/1.1 |  |
| HTTP/2 |  |
| HTTP/3 |  |
