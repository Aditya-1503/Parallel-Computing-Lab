#include <stdio.h>
#include<string.h>
#include<stdbool.h>
#include "mpi.h"

int main(int argc, char* argv[]){
    int rank, size, len, chunk, nonvow=0, count[10], iter = 0;;
    char string1[100],string2[100], buff1[100], buff2[100], buffArr[100], temp[100];; 
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0){
        printf("Enter String1: ");
        scanf("%s", string1); 
        printf("Enter String2: ");
        scanf("%s", string2); 
        len = strlen(string1);
        chunk = len / size;
    }

    MPI_Bcast( &chunk , 1 , MPI_INT , 0 , MPI_COMM_WORLD);
    MPI_Scatter( string1 , chunk , MPI_CHAR , buff1 , chunk , MPI_CHAR , 0 , MPI_COMM_WORLD);
    MPI_Scatter( string2 , chunk , MPI_CHAR , buff2 , chunk , MPI_CHAR , 0 , MPI_COMM_WORLD);
    for(int i=0; i<chunk; i++){
        temp[iter++] = buff1[i];
        temp[iter++] = buff2[i];
        }
    MPI_Gather( temp , chunk*2 , MPI_CHAR , buffArr , chunk*2 , MPI_CHAR , 0 , MPI_COMM_WORLD);

    if (rank == 0){
        buffArr[len*2] = '\0';
        printf("%s", buffArr);
    }

    MPI_Finalize();
    fflush(stdout);
    return 0;
}
