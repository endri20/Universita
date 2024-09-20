// compila con:  gcc semthread.c -o semthread -lpthread
#include <stdio.h>
#include <unistd.h>
#include <semaphore.h>
#include <pthread.h>

/*!
\mainpage Esempio di Lettori e Scrittori
\section intro Introduzione
Esempio di utilizzo Lettori e Scrittori

\date 10/05/2006
\version   0.0.0.1
\author    A.Dal Palu con modifiche
*/

#define DIM_BUFFER 100

static sem_t sem_lettore,sem_scrittore;  /// semafori 
int A[DIM_BUFFER];
int nLettori;

/*!
    \brief  Codice del lettore 
    
    Il thread legge dal buffer condiviso e lo stampa, in mutua esclusione con lo scrittore
*/
void *lettore(void * arg)
{
  int pausa = ((int*)arg)[1];

  int i;
  while(1){
    sem_wait(&sem_lettore); // fa la down per proteggere la scrittura sul numero di lettori
    ++nLettori;
    if(nLettori == 1)
      sem_wait(&sem_scrittore); // mutua esclusione dello scrittore e dei lettori sul buffer
    sem_post(&sem_lettore); // up semaforo lettori, per permettere agli altri lettori di leggere

    // il codice sopra e sotto questo blocco permettono al lettore di leggere senza che lo scrittore stia scrivendo
    printf("lettore %d:\n", ((int*)arg)[0]);
    int n=0;
    for(;n<DIM_BUFFER;++n)  // legge tutto il buffer
	printf("%d ",A[n]);
    printf("\n");


    sem_wait(&sem_lettore);
    --nLettori;
    if(nLettori == 0)
      sem_post(&sem_scrittore);
    sem_post(&sem_lettore);

    sleep(pausa);
  }

  printf("lettore exit\n");
  pthread_exit (0);
}


/*!
    \brief  Codice dello scrittore
    
    Il thread scrive sul buffer condiviso a intervalli di 5 secondi
*/
void *scrittore(void * arg)
{
  int i;
  while(1){
    sem_wait(&sem_scrittore); // per evitare lettura mentre lui scrive
    printf("Scrittore inizia a scrivere\n");
    A[rand()%100] = rand()%100+1;  // scrittura
    printf("Scrittore finisce di scrivere\n");
    sem_post(&sem_scrittore);

    sleep(5);
  }
  printf("Scrittore exit\n");
  pthread_exit (0);
}


int main()
{
  pthread_t tid1,tid2, tid3; // lancio 3 thread, 1 scrittore e gli altri 2 lettori
  void * ret;
  
  nLettori = 0;

  int g=0;
  for(;g<DIM_BUFFER;++g)
    A[g] = 0;

  sem_init(&sem_lettore,0,1); // semaforo lettori(solo dei lettori), serve a proteggere la modifica sul contatore di quanti lettori ci sono, altrimenti se modificassero contemporaneamente si avrebbero valori errati
  sem_init(&sem_scrittore,0,1); // semaforo scrittore e lettori, protezione buffer quando si scrive e i lettori vogliono leggere e viceversa
  
  int arg1[] = {1,6}; // parametri passati, temporizzazione e numero lettore che è
  int arg2[] = {2,8};
  // scrittore
  if (pthread_create(&tid1, NULL, scrittore, NULL) < 0)
    { fprintf (stderr, "pthread_create error for thread 1\n");
    exit (1);
    }
  // lettore
  if (pthread_create(&tid2, NULL, lettore, arg1) < 0)
    { fprintf (stderr, "pthread_create error for thread 2\n");
    exit (1);
    }
  // lettore
  if (pthread_create(&tid3, NULL, lettore, arg2) < 0)
    { fprintf (stderr, "pthread_create error for thread 2\n");
    exit (1);
    }

  pthread_join (tid1, &ret);
  pthread_join (tid2, &ret);
  pthread_join (tid3, &ret);

  printf("Exit\n");
}







