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
### Fork:
```C
#include <stdio.h>
#include <unistd.h> //hna kayen fork ou getpid

int main() {
  printf("hallo ana el ab\n");
  int x = fork(); //treturni pid ta3 le fils 3and le pere ou 0 3and le fils
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


### Wait:
ida ymout le pere 9bel le fils, le fils y2adoptih process init (pid 1) bech t2eviti heka dir wait:
```C
#include <stdio.h>
#include <stdlib.h> // exit hna
#include <sys/wait.h>
#include <unistd.h> //hna kayen fork ou getpid

int main() {
  int status;
  printf("hallo ana el ab\n");
  int x = fork();
  printf("hallo ana el ab wela el ibn\n");
  if (x == -1) {
    printf("oe bebe kayen erreur\n");
  }
  if (x == 0) {
    printf("oe bebe ghadi nergod\n");
    sleep(3);
    printf("oe bebe kemelt nergod\n");
    exit(199);
  } else {
    printf("oe bebe ghadi n9ara3 weldi\n");
    if (wait(&status) > 0) { //-1 ma3netha ma3andoch fils
	  //hna ghadi t2afichi 199
      printf("oe bebe weldi reja3li %d\n", WEXITSTATUS(status));
    }
    printf("oe bebe kemelt man9ara3 weldi\n");
  }
  return 0;
} //Kayen waitpid(int pid, int *pstatus,int options) hadi t9ara3 lel fils li tmedo fel argument lowl

```

### exec:
T9ad t2executi un autre programme b exec  kayen 6 exec: execl,execlp,execle,execv,execvp,execvpe
- l=list
- v=vecteur
- p=path
- e=environnement
```C
#include <stdio.h>
#include <stdlib.h> // exit hna
#include <sys/wait.h>
#include <unistd.h> //hna kayen fork ou getpid
int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("oe bebe medli ch7al men argument");
    return 1;
    }
  int status;
  printf("hallo ana el ab\n");
  int x = fork();
  printf("hallo ana el ab wela el ibn\n");
  if (x == -1) {
    printf("oe bebe kayen erreur\n");
  }
  if (x == 0) {
    execvp(argv[1], argv + 1); // tmed les arguments b vecteur yekmel b NULL
    //execlp(argv[1], argv[1],argv[2] NULL); execl tmed les argument 7aba b 7aba ou tkemelha b NULL
    //execl("path","assem program","argument","argument",NULL); ida madirch p lazem dir el path complet kima /bin/ls
  } else {
    printf("oe bebe ghadi n9ara3 weldi\n");
    if (wait(&status) > 0) { //-1 ma3netha ma3andoch fils
      printf("oe bebe weldi reja3li %d\n", WEXITSTATUS(status));
    }
    printf("oe bebe kemelt man9ara3 weldi\n");
  }
  return 0;
}

```

### Thread:
les processus jayin t9al bzaf mala sa3at testa3mel les threads khir
les thread ypartagiw:
- le code
- le tas
- les donné global
- les ressource kima fichiers ect
les thread maypartagiw:
- la file
- les registres
- compteurs d'instructions

```C
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h> // exit hna
#include <sys/wait.h>
#include <unistd.h> //hna kayen fork ou getpid

typedef struct {
    int id;
    float blbl;
} BZAF;


void *Fonction1(void *arg){
   printf("oe bebe ana thread\n");
   pthread_exit(NULL);
}

void *Fonction2(void *arg) {
    int x = *(int *)arg;
    printf("oe bebe ana thread%d\n", x);
    pthread_exit(NULL);
}

void *Fonction3(void *arg) {
    BZAF *data = (BZAF *)arg;
    printf("oe bebe id: %d, blbl: %f\n", data->id, data->blbl);
    pthread_exit(NULL);
}

void *Fonction4(void *arg) {
    int *result = malloc(sizeof(int));
    *result = 69;
    printf("br br patapim\n");
    pthread_exit(result);
}

int main(int argc, char *argv[]) {
  int x=5;
  BZAF chkil;
  chkil.id=67;
  chkil.blbl=10.6;
  pthread_t t[5];
  pthread_create(&t[0],NULL,Fonction1,NULL);
  pthread_create(&t[1],NULL,Fonction2,&x);
  pthread_create(&t[2],NULL,Fonction3,&chkil);
  pthread_create(&t[3],NULL,Fonction4,NULL);
  pthread_join(t[0],NULL);
  pthread_join(t[1],NULL);
  pthread_join(t[2],NULL);
  void *ret;
  pthread_join(t[3],&ret);
  int result = *(int *)ret;
  printf("oe bebe thread reja3li %d",result);
  return 0;
}


```
# Fichiers Utiles
- [[SEXPCOURS2.pdf|Cours rani gala3 meno les pages li yahadro 3la les signaux ou rani gale3 hadra li kanet fel chapitres 1]] 