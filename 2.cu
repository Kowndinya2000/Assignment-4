#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#define arraySize 5

__global__ void addKernel(int* c, const int* a, const int* b, int size) 
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < size) {
        c[i] = a[i] + b[i];
    }
}

void addWithCuda(int* c, const int* a, const int* b, int size) {
    int* dev_a = nullptr;
    int* dev_b = nullptr;
    int* dev_c = nullptr;

    cudaMalloc((void**)&dev_c, size * sizeof(int));
    cudaMalloc((void**)&dev_a, size * sizeof(int));
    cudaMalloc((void**)&dev_b, size * sizeof(int));

    cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);

    addKernel<<<2, (size + 1) / 2>>>(dev_c, dev_a, dev_b, size);
    
    cudaDeviceSynchronize();

    cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
}

int main(int argc, char** argv) {
    
    
    int a[arraySize];
    int b[arraySize];
    for(int i=0; i< arraySize; i++)
    {
        a[i] = rand()%100;
        b[i] = rand()%100;
    }
    int c[arraySize] = { 0 };

    addWithCuda(c, a, b, arraySize);

    for(int i=0; i< arraySize; i++)
    {
        printf("%d ", c[i]);
    }
    cudaDeviceReset();

    return 0;
}