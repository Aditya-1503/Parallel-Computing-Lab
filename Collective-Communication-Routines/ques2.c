#include <stdio.h>
#include "mpi.h"

int main(int argc, char* argv[]){
    int rank, size, arr[100], chunk, recv_buf[10];
    float avg=0, recv_avg[10]; 
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0){
        printf("enter m:");
        scanf("%d", &chunk);
        for(int i=0;i<size*chunk;i++)
            scanf("%d", &arr[i]);
    }

    MPI_Bcast( &chunk , 1 , MPI_INT , 0 , MPI_COMM_WORLD);  
    MPI_Scatter( arr , chunk , MPI_INT , recv_buf , chunk , MPI_INT , 0 , MPI_COMM_WORLD);
    
    for (int i=0; i<chunk; i++){
        avg += recv_buf[i];
    }
    avg = avg / (float)chunk;
    MPI_Gather( &avg , 1 , MPI_FLOAT , recv_avg , 1 , MPI_FLOAT , 0 , MPI_COMM_WORLD);
    
    if (rank==0){
        float temp=0;
        for (int i=0;i<size;i++){
            fprintf(stdout, "Avg in Rank %d: %f\n", i, recv_avg[i]);
            temp += recv_avg[i];
        }
        temp = temp / size;

        fprintf(stdout, "Total Average: %f\n", temp);
    }

    MPI_Finalize();
    fflush(stdout);
    return 0;
}
