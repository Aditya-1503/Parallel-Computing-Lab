#include<stdio.h>
#include<mpi.h>


void customError(MPI_Comm * comm, int * errcode, ...){
    char errorString[MPI_MAX_ERROR_STRING];
    int length_of_error;

    MPI_Error_string(*errcode, errorString, &length_of_error);
    fprintf(stderr, "Custom Error: %s\n", errorString);

    MPI_Abort(*comm, *errcode);

}


int main(int argc, char * argv[]){
    int rank, size, output;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Errhandler custErr;
    MPI_Comm_create_errhandler (customError, &custErr);
    MPI_Comm_set_errhandler(MPI_COMM_WORLD, custErr);

    int n = rank +1;
    int result, errcode;

    errcode = MPI_Scan(&n, &result, 1, MPI_INT, MPI_PROD, MPI_COMM_NULL);
    if (errcode != MPI_SUCCESS){
        MPI_Comm comm = MPI_COMM_WORLD;
        customError(&comm, &errcode);
    }
    MPI_Reduce(&result, &output,1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0)
        printf("Output: %d\n", output);

    MPI_Errhandler_free(&custErr);
    MPI_Finalize();
    return 0;



}