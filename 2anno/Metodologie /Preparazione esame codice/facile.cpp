/*
Scrivi una funzione che somma due numeri di tipo generico utilizzando un template.
*/

#include <iostream>
using namespace std;

template <typename T>
T somma(T a, T b){
    return a +b;
}

int main(){
    int x,y;
    cin >> x;
    cin >> y;

    cout << somma(x,y) << endl;
    return 0;
}