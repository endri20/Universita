/*
 *  Memorizzare in un array di dieci posizioni i primi dieci numeri naturali.
 */




#include <iostream>
using namespace std;

int main() {
    int a[9];

    cout <<"ciao";
    for(int i = 1; i < 12; i++){
        a[i-1] = i;
    }

    for(int i = 0; i < 10; i++){
        cout << a[i];

    }
    return 0;
}
