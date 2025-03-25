#include <stdio.h>
#include <cuda.h>
#include <math.h>

// Kernel for matrix transformation
__global__ void transformMatrix(int* mat, int m, int n) {
    int row = blockIdx.x * blockDim.x + threadIdx.x; // Compute global row index

    if (row < m && row > 0) { // Ensure valid row index and skip row 0
        for (int k = 0; k < n; k++) {
            int idx = row * n + k;
            int base = mat[idx];
            int result = 1;
            for (int i = 0; i < row + 1; i++) { // Compute power using a loop
                result *= base;
            }
            mat[idx] = result;
        }
    }
}

int main() {
    int m, n;

    // Input matrix dimensions
    printf("Enter m: ");
    scanf("%d", &m);
    printf("Enter n: ");
    scanf("%d", &n);

    int* mat = (int*)malloc(m * n * sizeof(int));

    // Input matrix elements
    printf("Enter elements:\n");
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            scanf("%d", &mat[i * n + j]);

    int* d_mat;
    cudaError_t err;

    // Allocate memory on device
    err = cudaMalloc((void**)&d_mat, m * n * sizeof(int));
    if (err != cudaSuccess) {
        printf("CUDA malloc failed: %s\n", cudaGetErrorString(err));
        free(mat);
        return -1;
    }

    // Copy matrix to device
    cudaMemcpy(d_mat, mat, m * n * sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel with multiple blocks and threads
    int threadsPerBlock = 256;
    int blocksPerGrid = (m + threadsPerBlock - 1) / threadsPerBlock;
    transformMatrix<<<blocksPerGrid, threadsPerBlock>>>(d_mat, m, n);

    // Check for kernel launch errors
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("Kernel launch failed: %s\n", cudaGetErrorString(err));
        cudaFree(d_mat);
        free(mat);
        return -1;
    }

    // Copy transformed matrix back to host
    cudaMemcpy(mat, d_mat, m * n * sizeof(int), cudaMemcpyDeviceToHost);

    // Print transformed matrix
    printf("Transformed Matrix:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", mat[i * n + j]);
        }
        printf("\n");
    }

    // Free allocated memory
    cudaFree(d_mat);
    free(mat);

    return 0;
}
