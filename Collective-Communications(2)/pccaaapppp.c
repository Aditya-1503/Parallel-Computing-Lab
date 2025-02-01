#include<stdio.h>
#include<stdlib.h>
#include "mpi.h"
#include <string.h>

int main(int argc, char* argv[]){
    int rank, size, recvLen;
    char string[100], buff;
    MPI_Comm world = MPI_COMM_WORLD;
    MPI_Init( &argc, &argv);
    MPI_Comm_rank( MPI_COMM_WORLD , &rank);
    MPI_Comm_size( MPI_COMM_WORLD , &size);
    MPI_Status status;
    if (rank==0){
        printf("Enter string: ");
        scanf("%s", string);
    }

    MPI_Scatter( string , 1 , MPI_CHAR , &buff , 1 , MPI_CHAR , 0 , world);
    char tempBuff[rank+1];
    for (int i=0; i<rank+1; i++){
        tempBuff[i] = buff;
    }

    if (rank==0){
        int i = 0;
        char output[100][100];
        for (i; i<size;i++){
            for (int j=0; j< i+1; j++){
                MPI_Recv( &output[i][j] , 1 , MPI_CHAR , i , i , world, &status);
            }
            
        }
    }
    else{
        for (int i=0; i<rank+1;i++){
            MPI_Send( &tempBuff[i] , 1 , MPI_CHAR , 0 , 1 , world);
        }
    }


    MPI_Finalize();
    fflush(stdout);
}