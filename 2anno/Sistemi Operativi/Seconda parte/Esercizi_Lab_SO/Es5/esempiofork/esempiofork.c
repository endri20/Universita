/*!
 \mainpage Esempio Fork
 \section intro Introduzione
 Esempio creazione di processi \n
 
 \date 15/03/2016
 \version   0.0.0.1
 \author Aldo Tragni
 */

/*!
 *
 * \file      esempiofork.c
 * \brief     File principale
 * \author    Aldo Tragni
 * \date      15/03/2016
 */

#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include <stdlib.h>
#define TEST //!< Macro globale

int temp; //!< Variabile globale

/************************  main() ***********************/
/*!
 \brief  E' la funzione principale
 \param  argc e' il numero di argomenti
 \param  argv e' vettore degli argomenti
 \return 0 = Esecuzione terminata con successo
 \return -1 = Esecuzione ha generato errore
 
 Questa funzione serve per lanciare un processo figlio,
 attendendo fino alla sua terminazione.
 */

int main(int argc, char *argv[])
{
    int pid;
    int retv; /// Riceve il valore di ritorno del figlio
    
    switch(pid=fork()){
        case -1: printf("Errore in creazione figlio\n");
            exit(-1);
        case 0 : printf("Il figlio attende per 2 secondi...\n");
            sleep(2);
            printf("Il PID del figlio e': %d\n", getpid());
            printf("Il figlio si sveglia\n");
            exit(3);
        default: printf("Padre esegue e attende il figlio\n");
            wait(&retv);
            printf("Padre riceve dal figlio, exit status %d\n",WEXITSTATUS(retv));
            printf("Il PID del padre e': %d\n", getppid());
        }
                   
        execl("/bin/ls", "ls", "-l", (char *)0);
        return 0;
}