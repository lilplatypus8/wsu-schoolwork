#include <stdio.h> // You do not have to implement stdio.h in assembly
#define MAX_ARRAY_SIZE 5

int sumOfSquares(int a[], int arraySize);
int square(int x);

int ar[MAX_ARRAY_SIZE] = {2, 3, 5, 0, 1}; // sumOfSquares = 39

int main()
{
    int *array = ar;   
    int total;
    
    // Calculate the sum of all squares in an array, i.e. 2^2 + 3^2 + 5^2 + 0^2 + 1^2 = 4 + 9 + 25 + 0 + 1 = 39
    
    total = sumOfSquares(array, MAX_ARRAY_SIZE);

    printf("Total: %d", total); // You do not have to implement a printf in assembly

    return total;
}

// Function:    sumOfSquares
//
// Inputs:      array pointer (a)
//              size of array (arraySize)
//
// Outputs:     sum of all squared elements in array (sum)

int sumOfSquares(int a[], int arraySize)
{
    int counter = 0; // counter is used to keep track of how many times we loop
    int sum = 0;
    
    while(counter < arraySize)
    {
        //call the square function until counter > arraySize, add the result to the current sum
        sum = square(a[counter]) + sum;
        counter = counter + 1;
    }
    
    return sum;
}

// Function:    square
//
// Inputs:      number to square (x)
//
// Outputs:     the squared number (product)

int square(int x)
{
    int product = 0;
    
    product = x * x;
    
    return product;
}