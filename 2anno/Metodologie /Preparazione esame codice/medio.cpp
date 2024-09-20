/*
Crea una classe "Calcolatrice" che supporti operazioni 
di base come somma, sottrazione, moltiplicazione e divisione. 
Utilizza il template per consentire l'uso di diversi tipi di dati.
*/

#include <iostream>
using namespace std;

template <typename T>
class Calcolatrice{
    
    public:

    T somma(T a, T b){
        return a + b;
    }

    T sottrazione(T a, T b){
        return a - b;
    }

    T moltiplicazione(T a, T b){
        return a * b;
    }

    T divisione(T a, T b){
        if(b != 0){
            return a / b;
        }else{
            cout << "Divisione per 0." << endl;
            return static_cast<T>(0);
        }
    }

};

int main(){

    Calcolatrice<int> prova;
    

    cout << "somma" << prova.somma(10,5) << endl; 
    cout << "sottrazione" << prova.sottrazione(10,5) << endl;
    cout << "Moltiplicazione" << prova.moltiplicazione(10,5) << endl;
    cout << "Divisione" << prova.divisione(10,5);

    return 0;
}