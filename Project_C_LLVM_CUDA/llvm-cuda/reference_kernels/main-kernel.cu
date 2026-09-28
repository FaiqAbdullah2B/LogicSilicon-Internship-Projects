#include <cuda_runtime.h>
#include <stdio.h>

#define N 5

__global__ void vectorAdd(int A[], int B[], int C[], size_t sz) {
  int idx = threadIdx.x;
  if (idx < sz)
    C[idx] = A[idx] + B[idx];
} 

int main() {
  int A[N] = {1, 2, 3, 4, 5};
  int B[N] = {1, 2, 3, 4, 5};
  int C[N] = {0};

  int *A_d, *B_d, *C_d;
  size_t size = sizeof(int) * N;
  cudaMalloc(&A_d, size);
  cudaMalloc(&B_d, size);
  cudaMalloc(&C_d, size);

  cudaMemcpy(A_d, A, size, cudaMemcpyHostToDevice);
  cudaMemcpy(B_d, B, size, cudaMemcpyHostToDevice);

  vectorAdd<<<1, 16>>>(A_d, B_d, C_d, N);

  cudaMemcpy(C, C_d, size, cudaMemcpyDeviceToHost);

  for (int i = 0; i < N; i++)
    printf("%d, ", C[i]);

  printf("\n");

  return 0;
}