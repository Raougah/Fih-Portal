## 2. Les trois grandes situations

### Cas 1 : One-to-One (1:1)
*Un à un*

> [!example] Exemple
> Une personne possède un seul passeport, et un passeport appartient à une seule personne.
> - **Personne** `(1,1)`
> - **Passeport** `(1,1)`

En ODL, chaque côté contient une référence vers un seul objet.

```java
class Personne {
    relationship Passeport passeport
        inverse Passeport::proprietaire;
};

class Passeport {
    relationship Personne proprietaire
        inverse Personne::passeport;
};
```

### Cas 2 : One-to-Many (1:N)
*Un à plusieurs*

> [!example] Exemple
> Un bibliothécaire enregistre plusieurs livres, mais chaque livre est enregistré par un seul bibliothécaire.
> - **Bibliothécaire** `(0,N)`
> - **Livre** `(1,1)`

En ODL :

```java
class Bibliothecaire {
    relationship set<Livre> livres
        inverse Livre::enregistre_par;
};

class Livre {
    relationship Bibliothecaire enregistre_par
        inverse Bibliothecaire::livres;
};
```

> [!question]- Pourquoi `set<Livre>` d'un côté et `Bibliothecaire` seul de l'autre ?
> - **`set<Livre>`** : Parce qu'un bibliothécaire peut être lié à *plusieurs* livres.
> - **`Bibliothecaire` seul** : Parce qu'un livre est lié à *un seul* bibliothécaire.

### Cas 3 : Many-to-Many (N:M)
*Plusieurs à plusieurs*

> [!example] Exemple
> Un étudiant peut suivre plusieurs modules, et un module peut être suivi par plusieurs étudiants.
> - **Étudiant** `(0,N)`
> - **Module** `(0,N)`

En ODL :

```java
class Etudiant {
    relationship set<Module> modules
        inverse Module::etudiants;
};

class Module {
    relationship set<Etudiant> etudiants
        inverse Etudiant::modules;
};
```

> [!question]- Pourquoi `set` des deux côtés ?
> Parce que chaque étudiant peut avoir *plusieurs* modules, et chaque module peut avoir *plusieurs* étudiants.

## 3. Comment traduire chaque cardinalité en ODL ?

Voici la règle à mémoriser :

| Cardinalité Merise | Type ODL                  |
| ------------------ | ------------------------- |
| `(0,1)`            | Objet simple, facultatif  |
| `(1,1)`            | Objet simple, obligatoire |
| `(0,N)`            | `set<Classe>`             |
| `(1,N)`            | `set<Classe>`             |

**Exemples de syntaxe :**
```java
// Un seul livre (0,1 ou 1,1)
relationship Livre livre;

// Plusieurs livres (0,N ou 1,N)
relationship set<Livre> livres;
```

> [!note] Note sur la contrainte de participation
> La différence entre `(0,N)` et `(1,N)` ne se voit pas directement dans le type `set`. Elle concerne la contrainte de participation : le premier autorise une collection vide, le second exige au moins un élément.
