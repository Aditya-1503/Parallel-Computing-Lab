#include<stdio.h>
#include<stdlib.h>
#include "mpi.h"

int main(int argc, char* argv[]){
    int rank, size, arr[4][4], b[4], redBuff[4], outPut[4][4];
    MPI_Comm world = MPI_COMM_WORLD;
    MPI_Init( &argc, &argv);
    MPI_Comm_rank( world, &rank);
    MPI_Comm_size( world , &size);

    if (rank==0){
        printf("Enter 4x4 matrix elements: ");
        fflush(stdout);
        for(int i=0; i<4;i++){
            for(int j=0; j<4;j++)
                scanf("%d", &arr[i][j]);
                fflush(stdout);
        }
    }

    MPI_Scatter( arr , 4 , MPI_INT , b , 4 , MPI_INT , 0 , world);
    
    
    MPI_Scan( b , redBuff , 4 , MPI_INT , MPI_SUM , world);
    
    MPI_Gather( redBuff , 4 , MPI_INT , outPut , 4 , MPI_INT , 0 ,world);

    if (rank==0){
        printf("Output Arr: \n");
        fflush(stdout);
        for (int i=0; i<4; i++){
            for(int j=0;j < 4; j++){
                printf("%d ", outPut[i][j]);
            }
            printf("\n");
        }
    }
    MPI_Finalize();
    fflush(stdout);
}
