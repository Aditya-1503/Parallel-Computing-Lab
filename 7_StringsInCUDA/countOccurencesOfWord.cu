#include <stdio.h>
#include<cuda_runtime.h>
#include <device_launch_parameters.h>
#include <string.h>
#include <stdlib.h>

__global__ void count(char * sequence, char* word, int * count, int sequenceLen, int wordLen){
    int idx = threadIdx.x + blockDim.x * blockIdx.x;

    if (idx + wordLen > sequenceLen) return ;


    int match = 1;
    for (int i=0;i<wordLen;i++){
        if (sequence[idx + i] != word[i]){
            match = 0;
            break;
        }
    }
    if (match) atomicAdd(count, 1);

}


int main(){
    int sequenceLen, wordLen, output=0;
    char * sequence, *word;

    printf("Enter the length of sequence: ");
    scanf("%d", &sequenceLen);
    
    printf("Enter the length of word: ");
    scanf("%d", &wordLen);

    int seqSize = (sequenceLen+1) * sizeof(char);
    int wordSize = (wordLen+1) * sizeof(char);

    sequence = (char *)malloc(seqSize);
    word = (char *)malloc(wordSize);
    
    getchar();
    
    printf("Enter the sequence: "); 
    fgets(sequence, sequenceLen+1, stdin);
    getchar();
    printf("Enter the word to search: ");
    fgets(word, wordLen+1, stdin);

    sequence[sequenceLen] = '\0';
    word[wordLen] = '\0';

    char * d_sequence, *d_word;
    int *d_out;

    cudaMalloc((void**)&d_sequence, seqSize);
    cudaMemcpy(d_sequence, sequence, seqSize, cudaMemcpyHostToDevice);
    
    cudaMalloc((void**)&d_word, wordSize);
    cudaMemcpy(d_word, word, wordSize, cudaMemcpyHostToDevice);
    
    cudaMalloc((void**) &d_out, sizeof(int));
    cudaMemcpy(d_out, &output, sizeof(int), cudaMemcpyHostToDevice);

    dim3 dimGrid(ceil(sequenceLen/256.0), 1, 1);
    dim3 dimBlock(256, 1, 1);

    count <<<dimGrid, dimBlock>>>(d_sequence, d_word, d_out, sequenceLen, wordLen);
    cudaMemcpy(&output, d_out, sizeof(int), cudaMemcpyDeviceToHost);

    printf("Count: %d", output);
    

    cudaFree(d_out);
    cudaFree(d_sequence);
    cudaFree(d_word);
    return 0;
}