#include "mpi.h"
#include <stdio.h>
#include<string.h>

int main(int argc, char* argv[]){

    int rank, size, len;
    char string[10], out[10], buffer[10];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;
    if (rank == 0){
        printf("Enter string: ");
        scanf("%s", &string);
        len = strlen(string);
        MPI_Ssend(&len, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
        MPI_Ssend(&string, len, MPI_CHAR, 1, 1, MPI_COMM_WORLD);
        
        MPI_Recv(&out, len, MPI_CHAR, 1, 1, MPI_COMM_WORLD, &status);
        
        out[len]= '\0';
        fprintf(stdout, "Output string: %s ", out);
        
        }

    else{
        MPI_Recv(&len, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(&buffer, len, MPI_CHAR, 0, 1, MPI_COMM_WORLD, &status);
        for (int i=0; i<len; i++){
            if (buffer[i] > 65 && buffer[i] <90) buffer[i] += 32;
            else buffer[i] -= 32;
        }

        
        MPI_Send(&buffer, len, MPI_CHAR, 0, 1, MPI_COMM_WORLD);

    }
    fflush(stdout);
    MPI_Finalize();
    return 0;
    
}