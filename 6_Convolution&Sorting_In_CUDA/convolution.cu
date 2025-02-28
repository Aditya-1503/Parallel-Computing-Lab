#include <stdio.h>
#include<cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void convolution(float *N, float *M, float *P, int Mask_width, int width){
    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    float Pvalue = 0;
    int start_point = tid - (Mask_width/2);
    for(int i=0; i<Mask_width;i++){
        if (start_point + i >= 0 && (start_point + i) < width)
            Pvalue += N[start_point+i] * M[i];
        
    }P[tid] = Pvalue;
}


int main(){
    int width, mask_width;
    float *h_a, *h_mask, *h_out;
    printf("Enter width of arr: ");
    scanf("%d", &width);
    printf("Enter width of mask: ");
    scanf("%d", &mask_width);
    int arrSize = sizeof(float) * width;
    int maskSize = sizeof(float) * mask_width;
    h_a = (float*) malloc(arrSize);
    h_mask = (float*) malloc(maskSize);
    h_out = (float *) malloc(arrSize);

    printf("Enter elements of arr: ");
    for(int i=0; i<width; i++)
        scanf("%f", h_a+i);
    
    printf("Enter elements of mask: ");
    for(int i=0; i<mask_width; i++)
        scanf("%f", h_mask+i);

    float *d_mask, *d_arr, *d_out;
    cudaMalloc((void**)&d_arr, arrSize);
    cudaMemcpy(d_arr, h_a, arrSize, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&d_mask, maskSize);
    cudaMemcpy(d_mask, h_mask, maskSize, cudaMemcpyHostToDevice);

    cudaMalloc((void**)&d_out, arrSize);
    dim3 dimGrid(ceil(width/256.0), 1, 1);
    dim3 dimBlock(256, 1, 1);

    convolution <<<dimGrid, dimBlock>>>(d_arr, d_mask, d_out, mask_width, width);


    cudaMemcpy(h_out, d_out, arrSize, cudaMemcpyDeviceToHost);

    printf("Output: \n");
    for(int i=0;i<width; i++){
        printf("%f ", h_out[i]);
    }

    cudaFree(d_arr);
    cudaFree(d_out);
    cudaFree(d_mask);
    

}