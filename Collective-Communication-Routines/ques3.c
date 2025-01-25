#include <stdio.h>
#include<string.h>
#include<stdbool.h>
#include "mpi.h"

bool vowelCheck(char ch){
    bool lowercase = (ch != 'a' && ch != 'e' && ch != 'i' && ch != 'o' && ch != 'u');
    bool uppercase = (ch != 'E' && ch != 'E' && ch != 'I' && ch != 'O' && ch != 'U');

    return lowercase & uppercase;
}

int main(int argc, char* argv[]){
    int rank, size, len, chunk, nonvow=0, count[10];
    char string[100], buff[100]; 
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0){
        printf("Enter String: ");
        scanf("%s", string); 
        len = strlen(string);
        chunk = len / size;
    }

    MPI_Bcast( &chunk , 1 , MPI_INT , 0 , MPI_COMM_WORLD);
    MPI_Scatter( string , chunk , MPI_CHAR , buff , chunk , MPI_CHAR , 0 , MPI_COMM_WORLD);
    for(int i=0; i<chunk; i++){
        if (vowelCheck(buff[i])) nonvow += 1;
    }
    
    MPI_Gather( &nonvow , 1 , MPI_INT , count , 1, MPI_INT , 0 , MPI_COMM_WORLD);
    if (rank == 0){
        int sum=0;
        for(int i=0; i<size; i++){
            sum += count[i];
            printf("Rank %d, Non-Vowel Cnt: %d\n", i, count[i]);
        }
        printf("Total Non-Vowel: %d\n", sum);

    }

    MPI_Finalize();
    fflush(stdout);
    return 0;
}
