#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void sineFunc(float *A, float *B, int m){
    int i = blockDim.x * blockIdx.x + threadIdx.x ;
    
    B[i] = sin(A[i]);
}


void sineConvert(float *a, int m){
    int datasize = sizeof(int) * m;
    float *d_a, *d_b;
    float *b;
    b = (float*)malloc(datasize);
    cudaMalloc((void**)&d_a, datasize);
    cudaMemcpy(d_a, a, datasize, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&d_b, datasize);

    dim3 dimGrid(ceil(m/256.0), 1, 1);
    dim3 dimBlock(256, 1 , 1);
    sineFunc<<<dimGrid, dimBlock>>> (d_a, d_b, 256);
    cudaMemcpy(b, d_b, datasize, cudaMemcpyDeviceToHost);

    for (int i=0;i <m;i++){
        printf("row %f \n" , b[i]);
    }

    cudaFree(d_a);
    cudaFree(d_b);
}


int main(){
    float *a;
    const int elements = 3;
    int datasize = elements*sizeof(float);

    a = (float*)malloc(datasize);
    printf("enter elements for a:");
    for(int i = 0; i < elements; i++)
    {
        scanf("%f", a+i);
    }

    sineConvert(a,elements);

    free(a);
    return 0; 
}