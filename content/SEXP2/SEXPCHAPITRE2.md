# Achya2at momila fel debut ta3 el cours

### **Définition:**
#### Programme:
Ensemble d'instruction et donné jay fel passif (fel disque) t9ad t2exicutih ch7al men khatra
#### Processus:
programme ki t2executih jay actif ki yekmel yweda3 3ando:
- **PID**
- **Espace d'adressage:** blacto fel mémoire fiha le code,Les données globales,le tas(allocation dynamique de la mémoire),la pile (appel de fonction, variable local ect) ghir la pile mchi partagé mabin les threads
- **Ensemble de registres:** compteur ordinal, pointeur de pile ect
- les fichiers mefto7in périphériques les signaux bli bli bli blou blou blou
- ma3lomat khlaf process pere, fils, groupe ect
#### definition khlaf maybanoch mohim:
- **MultiProgrammation:** Pc ya7chihalek ydir ghir 3afsa wa7da bsa7 nta dir f rassek dir ch7al men 7aja
- **multi-processeur:** pc fih ch7al men processeur hada maya7chihalekch t9ad dir processeur central ygeri le reste wela dir OS el kol processeur ou tkhalihom yethadro
- **Multi-Core:** bzaf cores f processeur mala t9ad tpartagi swala7 kima la RAM
#### État du process:
- New
- Ready
- Running
- Waiting
- Terminated
- Zombie hadi kayna ghir f linux 
- Swappé et Préempté hado fel cours ta3 alnafie diro bihom cha tebgho
#### PCB:
Process Control Block hna win kayen ma3lomat ta3 process

---
# Achaya2at mofida
Fork:
```C
#include <stdio.h>
#include <unistd.h> //hna kayen fork ou getpid

int main() {
  printf("hallo ana el ab\n");
  int x = fork();
  printf("hallo ana el ab wela el ibn\n");
  if (x == -1) {
    printf("oe bebe kayen erreur\n");
  }
  if (x == 0) {
    printf("oe bebe ana el ibn %d ou bouya %d\n", getpid(), getppid());
  } else {
    printf("oe bebe ana el ab %d\n", getpid());
  }
  return 0;
}
```
ida ymout le pere 9bel le fils, le fils y2adoptih process init (pid 1) bech t2eviti heka dir wait

Wait:

```C
#include <stdio.h>
#include <unistd.h> //hna kayen fork ou getpid

int main() {
  printf("hallo ana el ab\n");
  int x = fork();
  printf("hallo ana el ab wela el ibn\n");
  if (x == -1) {
    printf("oe bebe kayen erreur\n");
  }
  if (x == 0) {
    printf("oe bebe ana el ibn %d ou bouya %d\n", getpid(), getppid());
  } else {
    printf("oe bebe ana el ab %d\n", getpid());
  }
  return 0;
}
```
# Fichiers Utiles
- [[SEXPCOURS2.pdf|Cours]]