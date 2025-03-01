#include<stdio.h>
#include<cuda_runtime.h>
#include<device_launch_parameters.h>
#include<string.h>
#include<stdlib.h>

__global__ void prodRS(char *S, char* RS, int * pos, int n){
    int tid = threadIdx.x + blockDim.x * blockIdx.x;

    int len = n - tid;

    for(int i=0;i<len; i++)
        RS[pos[tid] + i] = S[i];
}

void positions(int * pos, int n){
    pos[0] = 0;
    for (int i=1; i<n;i++)
        pos[i] = pos[i-1] + (n-i+1);
}


int main(){
    int n, *pos;
    char *S, *RS;
    printf("Enter lenght of S:");
    scanf("%d", &n);
    int Slen = sizeof(char) * n;
    int RSlen = sizeof(char) * (n*(n+1)/2);
    
    S = (char*)malloc(Slen);
    RS = (char*)malloc(RSlen);
    pos = (int*) malloc(n*sizeof(int));


    printf("enter string: ");
    getchar();
    fgets(S, Slen+1, stdin);
    getchar();

    positions(pos, n);
    char *d_S, *d_RS;
    int *d_pos;

    cudaMalloc((void**)&d_S, Slen);
    cudaMemcpy(d_S, S, Slen, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&d_pos, n*sizeof(int));
    cudaMemcpy(d_pos, pos, n*sizeof(int), cudaMemcpyHostToDevice);
    cudaMalloc((void**)&d_RS, RSlen);
    
    dim3 dimGrid(ceil(n/256.0), 1, 1);
    dim3 dimBlock(256, 1, 1);
    prodRS<<<dimGrid, dimBlock>>>(d_S, d_RS, d_pos, n);

    cudaMemcpy(RS, d_RS, RSlen, cudaMemcpyDeviceToHost);

    printf("output string: %s\n", RS);
    
    cudaFree(d_S);
    cudaFree(d_RS);

    return 0;
}