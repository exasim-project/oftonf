#include <iostream>

using namespace std;

int bad_global = -1;

class fvScalarField
{

public:

    fvScalarField(int a) {}
};

void print()
{
    cout << "hallo" << endl;

    fvScalarField fieldA(1);
    auto fieldB = fvScalarField(2);
    int variable = 0;
}

int main()
{
    print();
    print();
    {
        int a = 0, b = 1;
        b = a;
    }
}
