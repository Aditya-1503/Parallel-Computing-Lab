#include<stdio.h>
#include<stdlib.h>
#include "mpi.h"


void handle_mpi_error(int errcode) {
    char error_string[MPI_MAX_ERROR_STRING];
    int length_of_error_string;
    MPI_Error_string(errcode, error_string, &length_of_error_string);
    fprintf(stderr, "MPI Error: %s\n", error_string);
    fflush(stderr);
    MPI_Abort(MPI_COMM_WORLD, errcode);
}


int main(int argc, char* argv[]){
    int rank, size, arr[3][3], toSearch, b[3], ans=0, out;
    int errcode;

    MPI_Init( &argc, &argv);
    MPI_Comm_rank( MPI_COMM_WORLD , &rank);
    MPI_Comm_size( MPI_COMM_WORLD , &size);

    if (rank==0){
        printf("Enter 3x3 matrix elements: ");
        fflush(stdout);
        for(int i=0; i<3;i++){
            for(int j=0; j<3;j++)
                scanf("%d", &arr[i][j]);
        }
        printf("Element to be searched: ");
        fflush(stdout);
        scanf("%d", &toSearch);
    }
    MPI_Bcast( &toSearch , 1 , MPI_INT , 0 , MPI_COMM_WORLD);
    errcode = MPI_Scatter( arr , 3 , MPI_INT , b , 3 , MPI_INT , 0 , MPI_COMM_WORLD);
    if (errcode != MPI_SUCCESS){
        handle_mpi_error(errcode);
    }
    for(int i=0; i<3;i++){
        if (b[i] == toSearch)
            ans += 1;
    }

    MPI_Reduce( &ans , &out , 1 , MPI_INT , MPI_SUM , 0 , MPI_COMM_WORLD);
    if (rank == 0)
        fprintf(stdout, "Total Occurences: %d", out);
        fflush(stdout);

    MPI_Finalize();


}

