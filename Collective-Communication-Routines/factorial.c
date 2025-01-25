#include <stdio.h>
#include "mpi.h"

int factorial(int n){
    if (n == 1) return 1;

    return n * factorial(n-1);
}


int main(int argc, char* argv[]){
    int rank, size, arr[10], b;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0){
        fprintf(stdout, "enter %d elements:", size);
        for(int i=0;i<size;i++)
            scanf("%d", &arr[i]);
    }
    MPI_Scatter(arr , 1 , MPI_INT , &b , 1 , MPI_INT , 0 , MPI_COMM_WORLD);
    int facto = factorial(b);
    
    int recv_buf[size];

    MPI_Gather( &facto , 1 , MPI_INT , recv_buf , 1 , MPI_INT , 0 , MPI_COMM_WORLD);
    
    MPI_Barrier( MPI_COMM_WORLD);
    
    if (rank==0){
        int sum = 0;
        for (int i=0; i<size; i++){
            sum += recv_buf[i];
            fprintf(stdout, "Factorial in rank %d : %d\n", i, recv_buf[i]);
        }
        fprintf(stdout, "Sum of factorials: %d\n", sum);
    }
    MPI_Finalize();
    fflush(stdout);
    return 0;
}
