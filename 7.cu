#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include <stdlib.h>

#define VECTOR_SIZE 256*1024
int main(void)
{
    // allocating host_vector with 256K elements (as defined in the constant VECTOR_SIZE)
    thrust::host_vector<int> vector_cpu(VECTOR_SIZE);
 
  // Initializing random values on host
    thrust::generate(vector_cpu.begin(), vector_cpu.end(), rand);

    // copying vector_cpu data to the GPU
    thrust::device_vector<int> vector_gpu = vector_cpu;

    // performing sort operation in GPU (on the gpu vector)
    thrust::sort(vector_gpu.begin(), vector_gpu.end());
 
    // transferring the sorted vector contents to the host vector

    thrust::copy(vector_gpu.begin(), vector_gpu.end(), vector_cpu.begin());
 
    // Printing the sorted vector
     //for(int i = 0; i < vector_cpu.size(); i++)
     // std::cout <<  vector_cpu[i] << " ";

    return 0;
} 