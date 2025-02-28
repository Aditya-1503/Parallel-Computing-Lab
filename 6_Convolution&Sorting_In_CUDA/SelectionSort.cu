#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void SelSort(int *A, int *o, int n){
    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    if (tid >= n) return; 
    int data = A[tid], pos= 0;

    for(int i=0; i<n;i++){
        if (A[i] < data || (A[i] == data && i <tid ))
        pos++;
    }
    o[pos] = data;
}


int main(){
    int n, *arr, *out;
    printf("enter size of array: ");
    scanf("%d", &n);
    int arrSize = n * sizeof(int);

    arr = (int*)malloc(arrSize);
    out = (int*)malloc(arrSize);
    printf("Enter elements: \n");
    for(int i=0; i<n; i++)
        scanf("%d", arr + i);

    int *d_arr, *d_out;

    cudaMalloc((void**)&d_arr, arrSize);
    cudaMemcpy(d_arr, arr, arrSize, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&d_out, arrSize);
    dim3 dimGrid (ceil(n/256.0), 1, 1);
    dim3 dimBlock (256, 1, 1);

    SelSort <<<dimGrid, dimBlock>>> (d_arr, d_out, n);

    cudaMemcpy(out, d_out, arrSize, cudaMemcpyDeviceToHost);

    for(int i=0; i<n;i++)
        printf("%d ", out[i]);

    cudaFree(d_arr);
    cudaFree(d_out);
    
}