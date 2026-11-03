# **Principe:**
[[Andrew-S.-Tanenbaum-Modern-Operating-Systems.pdf#page=159|Tanenbaum]]
1. 3andek tableau buffer
2. Jma3a ta3 les consommateur ya9raw meno
3. Jma3a ta3 les producteurs yeketbo fih
4. ki ykon khawi les consomateur y9ar3o
5. ki ykon m3amar les producteur y9ar3o
# **Solution:**
### 1 Producteur 1 Consomateur:
```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define Taille 5

int  buffer[Taille];
int in=0;
int out=0;

sem_t mutex;  //t9ad dir pthread_mutex hna mayhemch 
sem_t vide;     
sem_t plein; 
  
void tektob_bullshit(){
    
    sem_wait(&mutex);
	buffer[in]= rand()%100+1;
	printf("le producteur ktob %d\n",buffer[in]);
	sem_post(&mutex);
	
	in=(in+1)%Taille;
}

void ta9ra_bullshit(){
	
	sem_wait(&mutex);
    printf("le consomatteur 9ra %d\n",buffer[out]);	
	buffer[out]= 0;
	sem_post(&mutex);
	out=(out+1)%Taille;
}

void* producteur(void* arg) {
    while(1){
	    sem_wait(&vide);
	    
	    tektob_bullshit();
	    
	    sem_post(&plein);
    }
    pthread_exit(NULL);
}
void* consommateur(void* arg) {
	while(1){
	    sem_wait(&plein);
	    
	    ta9ra_bullshit();
	    
	    sem_post(&vide);
    }
    pthread_exit(NULL);
}


int main() {

    sem_init(&mutex, 0, 1);
    sem_init(&vide,  0, Taille);
    sem_init(&plein, 0, 0);

    pthread_t prod, cons;
    pthread_create(&prod, NULL, producteur, NULL);
	pthread_create(&cons, NULL, consommateur, NULL);
    pthread_join(prod, NULL);
    pthread_join(cons, NULL);

    sem_destroy(&mutex);
    sem_destroy(&vide);
    sem_destroy(&plein);
    
    return 0;
}
```

### N Producteur M Consomateur:
- in/out yweliw ressource critique pcq homa yesta3melhom ch7al men producteur ou ch7al men consomatteur mala dakhalhom fel mutex
```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define Taille 5
#define N 5
#define M 8
int  buffer[Taille];
int in=0;
int out=0;

sem_t mutex;  //t9ad dir pthread_mutex hna mayhemch 
sem_t vide;     
sem_t plein; 
  
void tektob_bullshit(){
    sem_wait(&mutex);
	buffer[in]= rand()%100+1;
	printf("le producteur ktob %d\n",buffer[in]);
	in=(in+1)%Taille;
	sem_post(&mutex);
}

void ta9ra_bullshit(){
	sem_wait(&mutex);
    printf("le consomatteur 9ra %d\n",buffer[out]);	
	buffer[out]= 0;
	out=(out+1)%Taille;
	sem_post(&mutex);
}

void* producteur(void* arg) {
    while(1){
	    sem_wait(&vide);
	    
	    tektob_bullshit();
	    
	    sem_post(&plein);
    }
    pthread_exit(NULL);
}
void* consommateur(void* arg) {
	while(1){
	    sem_wait(&plein);
	    
	    ta9ra_bullshit();
	    
	    sem_post(&vide);
    }
    pthread_exit(NULL);
}


int main() {

    sem_init(&mutex, 0, 1);
    sem_init(&vide,  0, Taille);
    sem_init(&plein, 0, 0);

    pthread_t prod[N], cons[M];
    for(int i=0;i<N;i++){
	    pthread_create(&prod[i], NULL, producteur, NULL);
    }
    for(int i=0;i<M;i++){
	    pthread_create(&cons[i], NULL, consommateur, NULL);
    }
	for(int i=0;i<N;i++){
	    pthread_join(prod[i], NULL);
    }
    for(int i=0;i<M;i++){
	    pthread_join(cons[i], NULL);
    }
    sem_destroy(&mutex);
    sem_destroy(&vide);
    sem_destroy(&plein);
    
    return 0;
}
```