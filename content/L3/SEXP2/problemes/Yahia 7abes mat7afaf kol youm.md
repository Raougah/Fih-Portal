# **Principe:**
1. Probleme du barbier
2. 7afaf vrai 3ayan
3. ki ykon wa7do fel sala yergod
4. ki yji client ynawdo yebda y7afeflo
5. ida yji client ou 7afaf 3ando deja wa7ed y7afeflo yeg3od y9ara3 fel la salle
6. ida yji client ou yel9a la salle m3amra yro7
# **Solution:**
```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define N 100
#define Max_Client 3
sem_t barbier;
sem_t client;
pthread_mutex_t mutex;

int NBR_CLIENT=0;

void coupa(){
	\\ tkhaylo hadi dir coupa
}


void* barbier(void* arg){
	while(1){
		sem_wait(&client);
		
		pthread_mutex_lock(&mutex);
		NBR_CLIENT--;
		pthread_mutex_unlock(&mutex);
		sem_post(&barbier);
		printf("oe la7bib dork ndirlek coupa peak");
		coupa();
		
		
	}
	pthread_exit();
}


void* client(void* arg){
	sleep(rand()%100+1); \\bech yewaslo fwa9t random mchi kamel darba wa7da
	pthread_mutex_lock(&mutex);
	if(NBR_CLIENT==Max_Client){
		printf("sem7oli ghachi dork nro7");
		pthread_exit();
	}else{
		NBR_CLIENT++;
	}
	pthread_mutex_unlock(&mutex);
	sem_post(&client);
	sem_wait(&barbier);
	printf("oe la7bib sa7it 3la el coupa peak");
	pthread_exit();
}

void main(){
	pthread_mutex_init(&mutex,NULL);
	sem_init(&barbier,0,0)
	sem_init(&client,0,0)
	pthread_t t[N];
	pthread_t B;
	pthread_create(&B,NULL,barbier,NULL);
	for(int i=0;i<N;i++){
		pthread_create(&t[i],NULL,client,NULL);
	}
	for(int i=0;i<N;i++){
		pthread_join(t[i],NULL);
	}
	pthread_join(B,NULL);
	pthread_mutex_destroy(&mutex);
	sem_destroy(&sem);
}

```