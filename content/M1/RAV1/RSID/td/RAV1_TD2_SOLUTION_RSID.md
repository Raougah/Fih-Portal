## Exercice 1

Une université possède un domaine `univ-usto.dz` et met à la disposition de ses étudiants plusieurs services :

- Site Web institutionnel : `www.univ-usto.dz`
- Plateforme d'apprentissage en ligne : `elearning.univ-usto.dz`
- Serveur de messagerie : `mail.univ-usto.dz`

Un étudiant souhaite consulter la plateforme pédagogique, télécharger un cours au format PDF, puis se connecter à son espace étudiant.

On suppose que les échanges HTTP étudiés utilisent **HTTP/1.1**, que le poste client est connecté au réseau et possède déjà une adresse IP.

### Partie I — DNS : résolution des noms de domaine

Enregistrements DNS fournis par l'administrateur :

```
univ-usto.dz.             3600 IN A      203.0.113.10
www.univ-usto.dz.         3600 IN CNAME  univ-usto.dz.
elearning.univ-usto.dz.   3600 IN A      203.0.113.20
mail.univ-usto.dz.        3600 IN A      203.0.113.30
univ-usto.dz.             3600 IN MX 10  mail.univ-usto.dz.
univ-usto.dz.             3600 IN NS     ns1.univ-usto.dz.
ns1.univ-usto.dz.         3600 IN A      203.0.113.53
```

#### 1. Adresse IPv4 de chaque nom

| Nom                    | Adresse IPv4 |
| ---------------------- | ------------ |
| www.univ-usto.dz       |              |
| elearning.univ-usto.dz |              |
| mail.univ-usto.dz      |              |

#### 2. Justifier la réponse concernant le premier nom

**Réponse :**


#### IPv6 : associer `2001:db8:1::20` à `elearning.univ-usto.dz`

**a) Type d'enregistrement DNS à ajouter dans la zone `univ-usto.dz` :**

**Réponse :**


**b) Enregistrement DNS correspondant (TTL = 3600 s) :**

```

```

#### 3. Résolution par le résolveur `192.168.1.10` (cache vide) pour `elearning.univ-usto.dz`

Décrire les principales étapes, le type de requêtes DNS utilisées par le résolveur et le rôle de chaque serveur interrogé.

**Réponse :**

| Étape | Requête de → vers | Type de requête | Rôle du serveur interrogé / réponse obtenue |
|-------|-------------------|-----------------|---------------------------------------------|
| 1 |  |  |  |
| 2 |  |  |  |
| 3 |  |  |  |
| 4 |  |  |  |
| 5 |  |  |  |

Explications complémentaires :


#### 4. Différence entre requête DNS récursive et itérative

**Réponse :**

- Requête récursive :
- Requête itérative :
- Type de requête généralement adressée par le client au résolveur :

---

### Partie II — HTTP : accès à la plateforme pédagogique

#### 5. Requête HTTP/1.1 pour `/index.html`

Doit contenir : la méthode et la ressource, l'en-tête du serveur virtuel, l'en-tête du type de contenu accepté, l'en-tête de maintien de la connexion.

```http

```

#### 6. Réponse du serveur

```http
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Content-Length: 1250
Connection: keep-alive

<html>...</html>
```

Signification et rôle :

- Code `200` :
- `Content-Type` :
- `Content-Length` :
- `Connection` :

#### 7. Requête pour télécharger `/cours/reseaux.pdf`

```http

```

#### 8. Réponse du serveur

```http
HTTP/1.1 200 OK
Content-Type: application/pdf
Content-Length: 245760
```

**a) Pourquoi le serveur utilise-t-il `application/pdf` ?**

**Réponse :**


**b) Que représente la valeur de `Content-Length` ?**

**Réponse :**


**c) Pourquoi la valeur de `Accept` envoyée par le client n'est-elle pas nécessairement identique à celle de `Content-Type` reçue ?**

**Réponse :**


#### 9. Soumission du formulaire de connexion

Valeurs : `login=amina` / `password=azerty`, format `application/x-www-form-urlencoded`, données dans le corps de la requête.

**Requête HTTP :**

```http

```

**Longueur du corps (`login=amina&password=azerty`, ASCII) en octets :**

Calcul :

Résultat : ______ octets

#### 10. Réponse du serveur

```http
HTTP/1.1 302 Found
Location: /espace-etudiant
Content-Length: 0
```

**a) Rôle de `Location` :**

**Réponse :**


**b) Action habituelle du navigateur :**

**Réponse :**


**c) Différence entre redirection 302 et 301 :**

**Réponse :**


#### 11. Accès à `/cours/ancien-cours.pdf`

```http
HTTP/1.1 404 Not Found
Content-Type: text/html; charset=UTF-8
```

**a) Interpréter le code 404 :**

**Réponse :**


**b) Différence entre 404 Not Found et 403 Forbidden :**

**Réponse :**


**c) Le serveur peut-il renvoyer une page HTML expliquant l'erreur ? Justifier :**

**Réponse :**


---

## Exercice 2 — QCM

**1. Quel type d'enregistrement permet d'associer un nom à une adresse IPv6 ?**
- [x] A. AAAA
- [ ] B. A
- [ ] C. PTR
- [ ] D. NS

**2. À quoi sert un enregistrement MX ?**
- [x] A. À désigner un serveur de messagerie
- [ ] B. À indiquer l'adresse IPv6 d'un serveur
- [ ] C. À définir un alias Web
- [ ] D. À indiquer la durée du cache DNS

**3. Quel est le rôle d'un enregistrement CNAME ?**
- [ ] A. Définir un serveur de noms faisant autorité
- [x] B. Associer un nom à un alias d'un autre nom canonique
- [ ] C. Définir une adresse IPv4
- [ ] D. Indiquer le serveur de messagerie prioritaire

**4. Quel enregistrement indique les serveurs de noms d'une zone DNS ?**
- [ ] A. TXT
- [ ] B. PTR
- [x] C. NS
- [ ] D. MX

**5. Un étudiant saisit `elearning.univ-usto.dz`. Quel serveur est généralement interrogé en premier par son ordinateur ?**
- [ ] A. Un serveur racine
- [ ] B. Le serveur faisant autorité pour .dz
- [x] C. Le résolveur DNS configuré sur son ordinateur ou son réseau
- [ ] D. Le serveur Web directement, sur le port 80

**6. Lors d'une résolution itérative, que peut retourner un serveur DNS interrogé ?**
- [ ] A. Uniquement une adresse IPv4
- [x] B. Une référence vers un autre serveur DNS à interroger
- [ ] C. Toujours une réponse HTTP
- [ ] D. Une adresse IP attribuée par DHCP

**7. Lors d'une résolution récursive, qu'attend le client du résolveur ?**
- [x] A. Qu'il lui fournisse la réponse finale ou une erreur
- [ ] B. Qu'il lui demande d'interroger lui-même tous les serveurs racine
- [ ] C. Qu'il lui fournisse uniquement une référence vers un serveur racine
- [ ] D. Qu'il ouvre une connexion FTP

**8. Quel est le rôle du TTL d'un enregistrement DNS ?**
- [ ] A. Définir la taille maximale d'une réponse DNS
- [x] B. Indiquer pendant combien de temps l'enregistrement peut rester en cache
- [ ] C. Indiquer le numéro de port du serveur DNS
- [ ] D. Déterminer la vitesse de la connexion Internet

**9. Un enregistrement a un TTL de 3600 secondes. Après 15 minutes, quel TTL reste-t-il approximativement dans un cache qui l'a conservé depuis sa réception ?**
- [ ] A. 900 secondes
- [ ] B. 1800 secondes
- [x] C. 2700 secondes
- [ ] D. 3600 secondes

**10. Le résolveur possède encore une réponse DNS valide dans son cache. Que fait-il généralement lors d'une nouvelle demande identique ?**
- [ ] A. Il recommence obligatoirement depuis le serveur racine
- [x] B. Il réutilise la réponse en cache
- [ ] C. Il supprime l'enregistrement
- [ ] D. Il interroge systématiquement tous les serveurs faisant autorité

**11. Quel est l'objectif principal de DNSSEC ?**
- [ ] A. Chiffrer toutes les requêtes DNS
- [x] B. Vérifier l'authenticité et l'intégrité des données DNS signées
- [ ] C. Remplacer le DNS par DHCP
- [ ] D. Masquer les adresses IP des serveurs Web

**12. Un navigateur ne parvient pas à résoudre `www.univ-usto.dz`. Quelle affirmation est correcte ?**
- [ ] A. Le serveur Web a nécessairement répondu 404 Not Found
- [x] B. Une erreur de résolution DNS peut survenir avant l'envoi d'une requête HTTP au serveur
- [ ] C. Le navigateur a nécessairement reçu un code HTTP 403
- [ ] D. Le DNS a automatiquement attribué une autre adresse IP

**13. Quel protocole de transport est généralement utilisé par les requêtes DNS classiques ordinaires ?**
- [ ] A. TCP uniquement, sur le port 80
- [x] B. UDP, généralement sur le port 53
- [ ] C. HTTP, sur le port 443 exclusivement
- [ ] D. FTP, sur le port 21
