#include <iostream>
using namespace std;

class Calcolatrice {
public:
    double dividi(int a, int b) {
        if (b == 0) {
            throw runtime_error("OOOOO");
        }
        return static_cast<double>(a) / b;
    }
};

int main() {
    int num1, num2;
    Calcolatrice calc;

    cout << "Inserisci due numeri interi: ";
    cin >> num1 >> num2;

    try {
        double risultato = calc.dividi(num1, num2);
        cout << "Il risultato della divisione è: " << risultato << endl;
    } catch (const runtime_error& e) {
        cout << e.what() << endl;
    }

    return 0;
}