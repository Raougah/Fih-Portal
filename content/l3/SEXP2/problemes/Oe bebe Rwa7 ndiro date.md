# **Principe:**
1. Probleme du rendez vous
2. 3andek ch7al men thread ydiro khadma mathemch vraiment
3. ki ykemlo had khadma yeb9aw y9ar3o 7ata ykemlo kamel khadmethom
4. ki yji thread tali y3awdo y9el3o
# **Solution:**
```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define N 5 

sem_t sem;
pthread_mutex_t mutex;

int threads_li_waslo=0;

void khadma(){
	\\mathemch bzaf
}

void* bebeRwa7NdiroDate(void* arg){
	while(1){
		khadma();
		pthread_mutex_lock(&mutex);
		threads_li_waslo++;
		if(threads_li_waslo==N){
			for(int i=0;i<N;i++){
				sem_post(&sem);
			}
			threads_li_waslo=0;
		}
		pthread_mutex_unlock(&mutex);
		sem_wait(&sem);	
	}
	pthread_exit();
}

void main(){
	pthread_mutex_init(&mutex,NULL);
	sem_init(&sem,0,0)
	pthread_t t[N];
	for(int i=0;i<N;i++){
		pthread_create(&t[i],NULL,bebeRwa7NdiroDate,NULL);
	}
	for(int i=0;i<N;i++){
		pthread_join(t[i],NULL);
	}
	pthread_mutex_destroy(&mutex);
	sem_destroy(&sem);
}

```