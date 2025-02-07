#include "mpi.h"
#include <stdio.h>

int main(int argc, char* argv[]){

    int rank, size;
    char string[10], out[10], buffer;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;
    if (rank == 0){
        printf("Enter string: ");
        scanf("%s", &string);
    
        for (int i=1;i < size; i++){
            MPI_Send(&string[i] , 1, MPI_CHAR, i, i, MPI_COMM_WORLD);
        }
        for (int i = 1;i < size; i++){
            MPI_Recv(&out[i], 1, MPI_CHAR, i, i, MPI_COMM_WORLD, &status);
        }
        if (string[0] >65 && string[0] < 90) out[0] = string[0] + 32;
        else out[0] = string[0] - 32;
        out[size]= '\0';
        printf("Output string: %s ", out);
        
        }

    else{
        MPI_Recv(&buffer, 1, MPI_CHAR, 0, rank, MPI_COMM_WORLD, &status);
        if (90 > buffer && buffer > 65)
            buffer += 32;
        else
            buffer -= 32;
        
        MPI_Send(&buffer, 1, MPI_CHAR, 0, rank, MPI_COMM_WORLD);

    }
}