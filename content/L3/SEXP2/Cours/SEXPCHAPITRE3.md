lk# Achya2at momila fel debut ta3 el cours

### **Définition:**
#### Ressource critique:
Ressource li etat final ta3ha yetbedel b des accés concurrents
#### Race condition:
Une situation li tetbeded 3la 7sab l'ordre ta3 les opérations
#### Section atomique:
Une section li mat9adch ta7bes 3la jal un autre process
#### Section Critique ou SC:
section li tmanipuli une **ressource critique**
#### Exclusion mutuelle:
ki tkon sur bli section critique jaya atomique

### **Caractéristique Section Critique:**

- **La tolérance aux défaillance:** Ida process yeta7wa f **SC** mayeblokich ga3 system
- **La symétrie:** kamel yedokhlo ou yokhorjo en SC b nafs tari9a
- Mat9adch ta3raf la vitesse wela nombre ta3 process en avance
- exclusion mutelle makanch ida:
	1. wa7ed y9ad yedkhol mais kayen wa7ed fel SC **(exclusion mutuelle)**
	2. wa7ed may9adch yedkhol mais makan 7ata wa7ed fel SC **(progress)**
	3. 7bibna ymout bel jo3 **(bounded waiting-attente borné)**
### **Solution lel critical section:**

#### Solution Logiciel:
##### Peterson:
```c
#define FALSE 0
#define TRUE 1
#define N 2              /* nombre de process */
int turn;    /* à qui le tour */
int interested[N];    /* toutes valeurs initialement 0 (FALSE) */

void enter_region(int process)    /* le process est 0 ou 1*/
{
   int other;    /* nombre des autres process*/
   other = 1 - process;    /* l'opposé du process*/
   interested[process] = TRUE;    /* Montre que vous êtes intéressé*/
   turn = process    /* définit indicateur */
   while (turn == process && interested[other] == TRUE)
               /* instruction null */
}

void leave_region(int process)    /* process: qui quitte */
{
   interested[process] = FALSE;    /* indique départ de critical section */
}
```
- yesta3mel le principe ta3 l'attente active mala ki yedkhol fel la boucle while yeb9a yesta3mel CPU
- yetmecha ghir f le cas ta3 2 processus


#### Solution Matériel:
##### Masquage des interruptions:
t7abas ga3 les interruptions menhom ta3 l'horloge ida l'horloge mat9adch dir intérruption makanch switch mabin les processus tetmecha ghir f les systeme b processeur wa7ed
##### Instruction spécial:
[[Andrew-S.-Tanenbaum-Modern-Operating-Systems.pdf#page=157|3jezt]]

---
# Achaya2at mofida
### Kifach dir semaphore ou mutex
```c
#include <pthread.h>
#include <semaphore.h>

pthread_mutex_t mutex;
sem_t semaphore;

// Mutex
pthread_mutex_init(&mutex, NULL);
pthread_mutex_lock(&mutex);
pthread_mutex_unlock(&mutex);
pthread_mutex_trylock(&mutex);
pthread_mutex_destroy(&mutex);

// Semaphore
sem_init(&semaphore, 0, 1); \\0 ma3netha partagi fel le meme process (threads)
                            \\1 valeur initial ta3 sémaphore
sem_wait(&semaphore);
sem_post(&semaphore);
sem_trywait(&semaphore);
sem_destroy(&semaphore);
```
### Probleme
- [[Producteur Consomateur]]
- [[Table des 7altitat]]
- [[Lecteur Redacteur]]
- [[Oe bebe Rwa7 ndiro date]]
- [[Yahia 7abes mat7afaf kol youm]]

# Fichiers Utiles
- [[SEXPCOURS3.pdf|Cours]]
- [[Andrew-S.-Tanenbaum-Modern-Operating-Systems.pdf#page=150|Tanenbaum]]