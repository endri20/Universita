/*
Scrivi un programma per realizzare una lista di interi inseriti da tastiera, l'inserimento deve 
essere effettuato da una funzione (push) che inserisce un elemento in fondo alla lista.
 Il programma deve prevedere la presenza di una funzione (pop) che toglie l'ultimo 
elemento inserito dall'utente nella lista, implementando così una struttura a pila.
*/

#include <iostream>
using namespace std;

void push(int *p, int &indice){
    int t;
    cout << "Inserisci il valore che vuoi:";
    cin >> t;

    indice++;
    p[indice] = t;

}

void pop(int *p, int &indice){
    indice--;
}

int main(){
    int indice = 0;
    int* p; 
    p = new int;

    
}