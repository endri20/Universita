/*!
\mainpage MYSH
\section intro Introduzione
shell minimale a scopo didattico

\date 14/03/2005
\version   0.2
\author Roberto Alfieri
 */

/*!
*
* \file      mysh.cpp
* \brief    file principale
* \author    R.Alfieri
* \date      14.3.05
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#define MAXPARAMS 6  //!< Numero elementi del vettore comando
#define MAXPATH  60  //!< Numero elementi del vettore PATH

int string2vpunt(char *stringa, int maxchar, char *vpunt[], int maxpunt, char *sep);
int vpunt_print(char *vpunt[]);
int get_command(char *comando[]);
int esegui(char *cmd[], char *argv[], char *envp[]);

// AGGIUNTO
int which(char* cmd, char* &cmdfq); //!< Funzione which - Localizza un comando se esiste (trova la path del comando)

char *path[MAXPATH];       //!< path Vettore di puntatori che verra' riempito con i PATH
char *comando[MAXPARAMS];  //!< comando Vettore comando: comando e opzioni

/************************  main() ***********************/
/*!
    \brief  Funzione principale
    \param  argc Numero di elementi in argv
    \param  argv
    \param  envp
    \return 0=ok
*/
int main(int argc, char *argv[], char *envp[])
{
  string2vpunt((char *) getenv("PATH"), strlen(getenv("PATH")),path,MAXPATH, ":\n");

  while(!get_command(comando))
  {
    esegui(comando,argv,envp);
  }
  return 0;
}


/************************  esegui() ***********************/
/*!
    \brief  Esegue il comando
    \param  cmd vettore comando (VP)
    \param  argv vettore argv (VP)
    \param  envp vettore delle variabili d'ambiente (VP)
    \return 0=ok 1=cmd_not_found
*/
int esegui(char *cmd[], char *argv[], char *envp[])
{
         if(!strcmp(cmd[0],"printenv"))  {vpunt_print(envp); return 0;}
    else if(!strcmp(cmd[0],"printargv")) {vpunt_print(argv); return 0;}
    else if(!strcmp(cmd[0],"printpath")) {vpunt_print(path); return 0;}
    else if(!strcmp(cmd[0],"printcmd"))  {vpunt_print(cmd);  return 0;}
// AGGIUNTA parte del WHICH
    else if(!strcmp(cmd[0],"which")){char* cmdfq; which(cmd[1],cmdfq);printf("%s\n", cmdfq); return 0;} // Salva il percorso del comando, in cmdfq

      else {
        char* path;  // per tutti i comandi rimanenti
	    which(cmd[0],path);  // cerca il percorso dei comandi non definiti nel questo programma
	
	if( strcmp(path,"Path Not Found") )  // se il comando esiste
	{
		strcpy(cmd[0],path);

		int pid,retv =0;
		switch(pid = fork()){ // il figlio esegue il comando
			case -1:
				printf("Errore nell'esecuzione del comando\n");
			break;
			case 0:
			  execv(path,cmd); // esegue il figlio e quando termina torna al padre (la execv, quando finisce, uccide il chiamante, quindi ucciderebbe il padre)
			break;
		        default: wait(retv); // attende il figlio
		}
	}
	else { printf("command %s not found\n", cmd[0]); return 1; } // se il comando non esiste
      }
}

/************************  which() ***********************/
/*!
    \brief  Funzione per la ricerca del path di comandi
    \param  cmd = Comando 
    \param  cmdfq = Comando Fully Qualified (comprende path)
    \return 0 = ok ; 1 = Path not found
*/
int which(char* cmd, char* &cmdfq)
{
	int ret=1,i=0;
	char* percorso = new char;
	for (i=0;path[i];i++) // cerca il comando in ogni percorso
	{
		strcpy(percorso,path[i]);
		strcat(percorso,"/");
		strcat(percorso, cmd);

		if(!access(percorso, F_OK))
		{
			ret=0;
			break;
		}
	}
	
	if(ret)
		strcpy(percorso, "Path Not Found");
	cmdfq = percorso;
	return ret;
}


/********************** string2vpunt() ******************/
/*!
    \brief  Separa i  tokens di una stringa in un vettore di puntatori
    \param  stringa stringa da suddividere
    \param  maxchar massima lunghezza dele a stringa
    \param  vpunt vettore dei  tokens (VP)
    \param  maxpunt  massima lunghezza di vpunt
    \param  sep    stringa dei catarreri separatori
    \return 0=ok
*/

int string2vpunt(char *stringa, int maxchar, char *vpunt[], int maxpunt, char *sep)
{
   char temp[maxchar];
   int i;
   char *p;

//   for(i=0;i<maxpunt;i++) {free(vpunt[i]); vpunt[i]=NULL;}
   strcpy(temp, stringa);
   p=strtok(temp, sep);
   for(i=0; p && i< maxpunt ;i++)
     {
      vpunt[i]=(char *)malloc(strlen(p)+1);
      strcpy(vpunt[i],p);
      p=strtok(NULL,sep);
     }
   vpunt[i]=NULL;
   return 0;
}

/************************  get_command() ****************/
/*!
    \brief  Funzione per l'input e la gestione del comando
    \param  cmd  vettore comando (VP)
    \return 0=ok  1=exit
*/

int get_command(char *cmd[])
{
  char string_command[100];

  do
  {
  printf("mysh> ");
  fgets(string_command,sizeof(string_command),stdin);
  string2vpunt (string_command,100,cmd,MAXPARAMS," \n");
  }
  while (!cmd[0]);

  if(!strcmp(cmd[0],"exit"))  return 1; else return 0;

}

/************************* vpunt_print() ******************/
/*!
    \brief  Stampa le stringhe da un vettore di puntatori
    \param  vpunt  vettore di puntatori
    \return 0=OK
*/

int vpunt_print(char *vpunt[])
{
   int i;

   for (i=0;vpunt[i];i++) printf(" %s \n", vpunt[i]);
   return 0;
}