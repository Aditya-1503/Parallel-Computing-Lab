#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void add(int *A, int *B, int *C, int m){
    int i = blockDim.x * blockIdx.x + threadIdx.x ;
    
    C[i] = A[i] + B[i];
}


void vecAdd(int *a, int *b, int m){
    int datasize = sizeof(int) * m;
    int *d_a, *d_b, *d_c;
    int *c;
    c = (int*)malloc(datasize);
    cudaMalloc((void**)&d_a, datasize);
    cudaMemcpy(d_a, a, datasize, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&d_b, datasize);
    cudaMemcpy(d_b, b, datasize, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&d_c, datasize);

    //N threads 1 block
    printf("N threads 1 block\n");
    add<<<m, 1>>>(d_a, d_b, d_c, m);
    cudaMemcpy(c, d_c, datasize, cudaMemcpyDeviceToHost);

    for (int i=0;i <m;i++){
        printf("row %d \n" , c[i]);
    }
    

    //N blocks 1 thread each
    printf("N blocks 1 thread each\n");
    add<<<1,m>>>(d_a, d_b, d_c, m);
    cudaMemcpy(c, d_c, datasize, cudaMemcpyDeviceToHost);

    for (int i=0;i <m;i++){
        printf("row %d \n" , c[i]);
    }

    //256 size
    printf("256 threads per ceil(m/256) blocks\n");
    dim3 dimGrid(ceil(m/256), 1, 1);
    dim3 dimBlock(256, 1 , 1);
    add<<<dimGrid, dimBlock>>> (d_a, d_b, d_c, 256);
    cudaMemcpy(c, d_c, datasize, cudaMemcpyDeviceToHost);

    for (int i=0;i <m;i++){
        printf("row %d \n" , c[i]);
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

}


int main(){
    int *a, *b;
    const int elements = 3;
    int datasize = elements*sizeof(int);

    a = (int*)malloc(datasize);
    b = (int*)malloc(datasize);
printf("enter elements for a:");
for(int i = 0; i < elements; i++)
{
    scanf("%d", a+i);
}

printf("enter elements for b:");
for(int i = 0; i < elements; i++)
{
   scanf("%d", b+i);
}
 printf("\n");
vecAdd( a,b,elements);

   free(a);
     free(b);
return 0; 
}