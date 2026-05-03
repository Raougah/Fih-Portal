# **Principe:**
[[Andrew-S.-Tanenbaum-Modern-Operating-Systems.pdf#page=202|Tanenbaum]]
1. Lecteur howa wa7ed ya9ra valeur ta3 ressource
2. Redacteur howa wa7ed ya9ra ou yektob valeur ta3 ressource
3. ki ykon kayen lecteur fel SC redacteur may9adch yedkhol bsa7 lecteurs lokhrin y9ado
4. ki ykon kayen Redacteur fel SC redacteur lokhrin ou lecteur may9adoch yedokhlo
# **Solution:**
### 1 Lecteur 1 Redacteur:
kima producteur consomateur za3ma
### N Lecteur M Redacteur:

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define N 5 
#define M 7 

sem_t sem;
pthread_mutex_t mutex;

int NbL=0;
int rc=rand()%100+1;

void* lecteur(void* arg){
	while(1){
		pthread_mutex_lock(&mutex);
		if(NbL==0){
			sem_wait(&sem);
		}
		NbL++;
		pthread_mutex_unlock(&mutex);
		printf("oe ana lecteur 9rit hadi %d", rc);
		pthread_mutex_lock(&mutex);
		NbL--;
		if(NbL==0){
			sem_post(&sem);
		}
		pthread_mutex_unlock(&mutex);
		
	}
	pthread_exit();
}

void* redacteur(void* arg){
	while(1){
		sem_wait(&sem);
		rc=rand()%100+1;
		printf("oe ana lecteur 9rit hadi %d", rc);
		sem_post(&sem);
	}
	pthread_exit();
}

void main(){
	pthread_mutex_init(&mutex,NULL);
	sem_init(&sem,0,1)
	pthread_t lec[N],red[M];
	for(int i=0;i<N;i++){
		pthread_create(&lec[i],NULL,lecteur,NULL);
	}
	for(int i=0;i<M;i++){
		pthread_create(&red[i],NULL,redacteur,NULL);
	}
	for(int i=0;i<N;i++){
		pthread_join(lec[i],NULL);
	}
	for(int i=0;i<M;i++){
		pthread_join(red[i],NULL);
	}
	pthread_mutex_destroy(&mutex);
	sem_destroy(&sem);
}

```