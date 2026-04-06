# Achya2at momila fel debut ta3 el cours

### Introduction
RI hiya **trouver des documents peu ou faiblement structurés ki ta7taj une information**
### Types d'information
1. **Information Structurée:** facile a utiliser par la machine et sa nature claire, se trouve dans les bases de données 
2. **Information Semi Structurée:** jaya nos nos, kima les pages web une partie *structurée* lel la machine kima les *balise* et une partie lel l'humain jaya *non-structurée* kima *texte*
3. **Information Non Structurée:** kima *texte* 
### Win takhdem bel RI ta3 tech
1. T7awes 3la nas 3andhom bac f bzaf les CV
2. Tel9a teswira ta3 diddy mabin 70 tewira
3. Tchouf khatra talia li rba7t f 1xbet ***(jamais)***
### Opérateur booléens
- ET
- OU
- SAUF
![[RISYSTEM.png]]
### Cha dir fi 7yatek ki
- **3andek bzaf les résultats:** Utiliser des opérateur de recherche/etre plus précis
- **Ma3andekch bzaf les résultats**: Alléger équation/etre plus général
### Element des RI
1. Document **(meta information)**
2. Contenu des documents **(contenu brut)**
3. Besoin d'information de l'utilisateur
4. Satisfaction
### Notion de pertinence
- **Niveau Utilisateur**: Satisfaction du user
- **Niveau Systeme**: niveau de similitude document/requete (ida document ychebah lel request wela la)
### RI vs BDD

| SGBD              | SRI                 |
| ----------------- | ------------------- |
| donné structuré   | donné non-structuré |
| satisfaction 100% | sa3at wah sa3at la  |
| language spécial  | language humain     |

##### **Remarque**:
t9ad testa3mel SGBD fel RI bech trecherchi attributs externes
### RI Difficulté
- 0 structure donc impossible tejbed relation
- tkon basé sur le contenu
# Achaya2at mofida
### Précision et Rappel
- **Précision**: Systeme precis = bzaf les documents renvoyé ykono pertinent 
- **Rappel**: bzaf rappel =  bzaf les documents pertinent ykono renvoyé
en gros precision par rapport el ga3 li trenvoyaw ou rappel par rapport el ga3 el corpus
- **Mo3adalat**:
R: Documents rapportés *(swala7 li reja3hom systeme)*
P: Collection des documents pertinents *(swala7 li nichan)*
Rr: Documets pertinents rapportés *(swala7 nichan li reja3hom systeme)*
 $$Precision = \frac{Rr}{R}$$
 $$Rappel = \frac{Rr}{P}$$
- **Relation**: En general kayen Relation inverse kol matetla3 precision yahbet el rappel
ki tjarab dir exemple men rassek tji bizarre bsa7 ki tchouf example réel tji logique ktar
> A brain surgeon removing a cancerous tumor from a patient's brain illustrates the tradeoffs as well: The surgeon needs to remove all of the tumor cells since any remaining cancer cells will regenerate the tumor. Conversely, the surgeon must not remove healthy brain cells since that would leave the patient with impaired brain function. The surgeon may be more liberal in the area of the brain they remove to ensure they have extracted all the cancer cells. This decision increases recall but reduces precision. On the other hand, the surgeon may be more conservative in the brain cells they remove to ensure they extract only cancer cells. This decision increases precision but reduces recall. That is to say, greater recall increases the chances of removing healthy cells (negative outcome) and increases the chances of removing all cancer cells (positive outcome). Greater precision decreases the chances of removing healthy cells (positive outcome) but also decreases the chances of removing all cancer cells (negative outcome).

> [!abstract] Remarque
> - Kayen Tani F mesure dir equilibre mabin Precision ou Rappel
> $$F = \frac{2 \times Precision \times Rappel}{Precision + Rappel}$$
> - F tale3 mli7
> - F habet mchi mli7
# Fichiers Utiles
- [[RICOURS1.pdf|Cours]]
- [Precision et Rappel - Wikipedia](https://en.wikipedia.org/wiki/Precision_and_recall)