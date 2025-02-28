#include<stdio.h>
#include<cuda_runtime.h>
#include<device_launch_parameters.h>

__global__ void oddEven(int *A, int n){
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    if (tid % 2 != 0 && tid+1 < n){
        if (A[tid] > A[tid+1]){
            int temp = A[tid];
            A[tid] = A[tid+1];
            A[tid+1]= temp;
        }
    }
}

__global__ void evenOdd(int * A, int n){
    int tid = blockDim.x * blockIdx.x + threadIdx.x;

    if (tid %2 == 0 && tid+1 < n){
        if (A[tid] > A[tid+1]){
            int temp = A[tid];
            A[tid] = A[tid+1];
            A[tid+1]= temp;
        }
    }
}

int main(){
    int n;
    printf("Enter size of array: ");
    scanf("%d", &n);
    int datasize = n * sizeof(int);
    int *arr = (int*)malloc(datasize);

    printf("Enter elements of arr: ");
    for(int i=0; i<n;i++)
        scanf("%d", arr+i);

    int *d_arr;
    cudaMalloc((void**)&d_arr, datasize);
    cudaMemcpy(d_arr, arr, datasize, cudaMemcpyHostToDevice);

    dim3 dimGrid(ceil(n/256.0), 1, 1);
    dim3 dimBlock(256, 1, 1);

    for(int i=0;i<n ;i++){
        oddEven <<<dimGrid, dimBlock>>>(d_arr, n);
        evenOdd <<<dimGrid, dimBlock>>>(d_arr, n);
    }

    cudaMemcpy(arr, d_arr, datasize, cudaMemcpyDeviceToHost);

    printf("Sorted arr: \n");
    for(int i=0; i<n;i++){
        printf("%d ", *(arr+i));
    }
    

    cudaFree(d_arr);
}