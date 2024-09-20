#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <signal.h>
#include <errno.h>
#include <unistd.h>

/*!
\mainpage Esempio Semafori
\section intro Introduzione
Esempio di utilizzo semafori

\date      02/05/2006
\version   0.0.0.1
\author    A.Dal Palu
*/


#define DOWN (-1)
#define UP (1)
#define MYCODE 'a'

// Definizione della struttura semun
#ifdef _SEM_SEMUN_UNDEFINED
#define _SEM_SEMUN_UNDEFINED  1
union semun /* definita in bits/sem.h */
{
  int val;                              /* value for SETVAL */
  struct semid_ds *buf;                 /* buffer for IPC_STAT & IPC_SET */
  unsigned short int *array;            /* array for GETALL & SETALL */
  struct seminfo *__buf;                /* buffer for IPC_INFO */
};
#endif


/************************  sem_up() ***********************/
/*!
    \brief  Dello zucchero sintattico per fare la UP
    \param  ipcid Riceve il numero dell`oggetto IPC
    \param  nsem Il semaforo su cui fare UP
    
    Questa chiamata maschera i dettagli implementativi sul buffer delle operazioni IPC
*/
void sem_up(int ipcid, int nsem)
{
    struct sembuf sops[1];
    sops[0].sem_num = nsem;
    sops[0].sem_op = UP;
    sops[0].sem_flg = 0;
    if (semop(ipcid, sops, 1) == -1) {
      perror("Errore in semop");
      exit(3);
    }
}

/************************  sem_down() ***********************/
/*!
    \brief  Dello zucchero sintattico per fare la DOWN
    \param  ipcid Riceve il numero dell`oggetto IPC
    \param  nsem Il semaforo su cui fare DOWN
    
    Questa chiamata maschera i dettagli implementativi sul buffer delle operazioni IPC
*/void sem_down(int ipcid, int nsem)
{
    struct sembuf sops[1];
    sops[0].sem_num = nsem;
    sops[0].sem_op = DOWN;
    sops[0].sem_flg = 0;
    //addormenta il filosofo che vuole quella quella bacchetta ma è gia utilizzata
    if (semop(ipcid, sops, 1) == -1) {
      perror("Errore in semop");
      exit(3);
    }
}

/************************  sem_set() ***********************/
/*!
    \brief  Dello zucchero sintattico per impostare il valore di un semaforo
    \param  ipcid Riceve il numero dell`oggetto IPC
    \param  nsem Il semaforo da impostare
    \param  initial Il valore iniziale del semaforo
    
    Questa chiamata maschera i dettagli implementativi sul buffer delle operazioni IPC
*/
void sem_set(int ipcid, int nsem, int initial)
{
  union semun arg;
  arg.val = initial;
  if (semctl(ipcid, nsem, SETVAL, arg) == -1) {
    perror("set value sem");
    exit(2);
  }
}


/// Funzione che simula quando il filosofo prende una bacchetta

void prendi(int ipcid, int nSem)
{
  if(nSem != 4)
  {
    sem_down(ipcid,nSem); // semaforo su una delle due bacchette che prende
    sem_down(ipcid,(nSem+4)%5); // semaforo sull'altra,una alla dx e l'altra alla sx, sarebbe indifferente
  }
  else
  {
    sem_down(ipcid,(nSem+4)%5); // filosofo "mancino" inizia dall'altra bacchetta
    sem_down(ipcid,nSem);
  }
}

/// Funzione che simula quando il filosofo posa una bacchetta

void posa(int ipcid, int nSem)
{
  if(nSem != 4)
  {
    sem_up(ipcid,(nSem+4)%5); // rilasciamo il semaforo con l'ordine inverso di come è stato preso, prima posiamo la bacchetta che era stata presa per seconda
    sem_up(ipcid,nSem);    
  }
  else
  {    
    sem_up(ipcid,nSem);
    sem_up(ipcid,(nSem+4)%5);
  }
}


/************************  filosofo() ***********************/
/*!
    \brief  Codice di prova per i filosofi
    \param  ipcid Riceve il numero dell`oggetto IPC

    Il filosofo pensa e mangia facendo up and down sul semaforo rappresentante le posate. 
*/
void filosofo(int ipcid, int i_filos){
        ///Filosofo Pensa
        printf("Filosofo %d pensa\n",i_filos);
	sleep(rand()%3+1);
        ///Filosofo Vuole mangiare
        printf("Filosofo %d vuole mangiare\n",i_filos);
	
	prendi(ipcid,i_filos);

        printf("Filosofo %d mangia\n", i_filos);
	sleep(rand()%3+1);
	printf("Filosofo %d lascia spazio ad altri\n",i_filos);

	posa(ipcid,i_filos);
}



int main()
{
    key_t key;
    int npro, sid, val, pid;
    char s[60];
    union semun arg;
    struct sembuf sops[2];

    if ((key = ftok(".", MYCODE)) == -1)
    {
        /* ottieni chiave IPC
        				       da pathname (".") e
        				       codice (MYCODE) */
        perror("ftok");
        exit(1);
    }
    if ((sid = semget(key, 5, 0600 | IPC_CREAT )) == -1)
    {
        perror("creazione 5 semafori");
        exit(1);
    }

    int i=0;
    while(i<5){ ///inizializza i semafori a 1
        sem_set(sid,i,1); 
	++i;
    }
    for(i=0; i<5; ++i)  ///ciclo per la creazione dei 5 figli filosofi
    {
        switch (pid = fork())
        {
        case -1:
            perror("fork");
            exit(2);
        case 0: /* Figlio: eredita indice del semaforo */
	    printf("Filosofo %d creato\n",i);
            filosofo(sid,i);
            printf("Filosofo %d : mi sono sganciato, termino\n",i);
            exit(0);
        default: /*Padre: osserva e sgancia i figli filosofi */
            ///Aggiorno contatore dei filosofi creati. Ogni filosofo avrà il giusto numero.
            
            if(i==5)
            {
                printf("Padre: attendo terminazione dei Filosofi \n");
                wait(&val); //attesa figli
                if (semctl(sid, 0, IPC_RMID, 0) == -1)
                    perror("rimozione semafori");
                printf("Padre: finito\n");
            }
        }

    }
}
