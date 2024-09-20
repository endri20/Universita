#include <stdio.h>
#include <unistd.h>

/*!
\mainpage Esempio Pipe
\section intro Introduzione
Esempio di creazione pipe per lanciare ls | sort\n

\date 02/05/2006
\version   0.0.0.1
\author    A.Dal Palu
*/

#define BUFFER_SIZE 50

int main() {
  int pid;
  int fd[2];
  char buffer[BUFFER_SIZE];

  pipe(fd);

  if ((pid = fork()) == 0) { /* figlio */
    /* chiusura lettura da pipe */
    close(fd[0]);
    /* redirezione stdout a pipe */
    dup2(fd[1], 1);

    //Aldo
    fgets(buffer,BUFFER_SIZE,stdin);
    fputs(buffer,stdout);
  }
  else if (pid > 0) { /* padre */
    /* chiusura scrittura su pipe */
    close(fd[1]);
    /* redirezione stdin a pipe */
    dup2(fd[0],0);

    //Aldo
    char c = ' ';
    void* cr = &c;
    int n = 1;
    do{
      read(fd[0],cr,1);
      printf("%c \n",c);
      ++n;
    }while(c != '.'  &&  n < BUFFER_SIZE);

    int retv = 0;
    wait(retv);
  }
}
