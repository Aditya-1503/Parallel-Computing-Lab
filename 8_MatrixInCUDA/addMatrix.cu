#include<cuda_runtime.h>
#include<stdio.h>
#include<device_launch_parameters.h>


__global__ void rowThread(int * A, int *B ,int *C, int n){
    int rid = threadIdx.x;
    
    if (rid < n){
        for(int i=0; i<n;i++){
            C[rid*n + i] = A[rid*n + i] + B[rid*n+i];
        }
    }

}


__global__ void colThread(int * A, int *B ,int *C, int n){
    int cid = threadIdx.x;
    
    if (cid < n){
        for(int i=0; i<n;i++){
            C[i*n + cid] = A[i*n + cid] + B[i*n + cid];
        }
    }

}


__global__ void eleThread(int * A, int *B ,int *C, int n){
    int col = threadIdx.x + blockIdx.x * blockDim.x;
    int row = threadIdx.y + blockIdx.y * blockDim.y;
    
    if (col < n && row < n){
        int index = row * n + col;
        C[index] = A[index] + B[index];
        
    }

}



int main(){
    int A[3][3], B[3][3], C[3][3], D[3][3], E[3][3];

    printf("enter A:");
    for(int i=0;i<3;i++){
        for(int j=0;j<3; j++) scanf("%d", &A[i][j]);
    }
    printf("enter B:");
    for(int i=0;i<3;i++){
        for(int j=0;j<3; j++) scanf("%d", &B[i][j]);
    }

    int *d_A, *d_B, *d_C;

    cudaMalloc((void**)&d_A, sizeof(int)*9);
    cudaMalloc((void**)&d_B, sizeof(int)*9);
    cudaMalloc((void**)&d_C, sizeof(int)*9);

    cudaMemcpy(d_A, A, 9*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, 9*sizeof(int), cudaMemcpyHostToDevice);

    dim3 gridDim (1, 1);
    dim3 blockDim(3,3);
    rowThread<<<gridDim, blockDim>>>(d_A, d_B, d_C, 3);
    cudaMemcpy(C, d_C, 9 * sizeof(int), cudaMemcpyDeviceToHost);
    colThread<<<gridDim, blockDim>>>(d_A, d_B, d_C, 3);
    cudaMemcpy(D, d_C, 9 * sizeof(int), cudaMemcpyDeviceToHost);
    eleThread<<<gridDim, blockDim>>>(d_A, d_B, d_C, 3);
    cudaMemcpy(E, d_C, 9 * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Row using one thread\n");
    for(int i=0;i<3;i++){
        for(int j=0;j<3; j++)
            printf("%d ", C[i][j]);
        printf("\n");
    }

    printf("Col using one thread\n");
    for(int i=0;i<3;i++){
        for(int j=0;j<3; j++)
            printf("%d ", D[i][j]);
        printf("\n");
    }

    printf("Element using one thread\n");
    for(int i=0;i<3;i++){
        for(int j=0;j<3; j++)
            printf("%d ", E[i][j]);
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}
