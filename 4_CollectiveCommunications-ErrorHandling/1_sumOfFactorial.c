#include<stdio.h>
#include<stdlib.h>
#include "mpi.h"

int main(int argc, char* argv[]){
    int rank, size, recvbuff, finalOut;
    MPI_Init( &argc, &argv);
    MPI_Comm_rank( MPI_COMM_WORLD , &rank);
    MPI_Comm_size( MPI_COMM_WORLD , &size);

    int temp = rank+1;
    MPI_Scan( &temp, &recvbuff , 1 , MPI_INT , MPI_PROD , MPI_COMM_WORLD);
    MPI_Reduce( &recvbuff , &finalOut , 1 , MPI_INT , MPI_SUM , 0 , MPI_COMM_WORLD);

    if (rank==0){
        fprintf(stdout, "Sum: %d", finalOut);
    }

    MPI_Finalize();
    fflush(stdout);
    return 0;
}