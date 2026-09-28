#include <cuda.h>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>

#define N 5
#define CHECK(call) do { \
    CUresult res = (call); \
    if (res != CUDA_SUCCESS) { \
        const char *msg; cuGetErrorString(res, &msg); \
        fprintf(stderr, "CUDA error %s at %s:%d\n", msg, __FILE__, __LINE__); \
        exit(1); \
    } \
} while (0)

int main() {
    // read the ptx
    std::ifstream f("vectoradd.ptx");
    std::stringstream ss;
    ss << f.rdbuf();
    std::string ptx = ss.str();

    // using the cuda driver API
    CHECK(cuInit(0));
    CUdevice dev;
    CHECK(cuDeviceGet(&dev, 0));
    CUcontext ctx;
    CHECK(cuCtxCreate(&ctx, nullptr, 0, dev));
    CUmodule mod;
    CHECK(cuModuleLoadData(&mod, ptx.c_str()));
    CUfunction kernel;
    CHECK(cuModuleGetFunction(&kernel, mod, "vectorAdd"));

    // arrays for input and output
    int A[N] = {1, 2, 3, 4, 5};
    int B[N] = {1, 2, 3, 4, 5};
    int C[N] = {0};
    size_t size = sizeof(int) * N;

    CUdeviceptr A_d, B_d, C_d;
    CHECK(cuMemAlloc(&A_d, size));
    CHECK(cuMemAlloc(&B_d, size));
    CHECK(cuMemAlloc(&C_d, size));
    CHECK(cuMemcpyHtoD(A_d, A, size));
    CHECK(cuMemcpyHtoD(B_d, B, size));

    size_t sz = N;
    void *args[] = { &A_d, &B_d, &C_d, &sz };

    CHECK(cuLaunchKernel(kernel,
                          1, 1, 1,
                          16, 1, 1,
                          0, 0, args, nullptr));
    CHECK(cuCtxSynchronize());

    CHECK(cuMemcpyDtoH(C, C_d, size));
    for (int i = 0; i < N; i++) printf("%d, ", C[i]);
    printf("\n");

    cuMemFree(A_d); cuMemFree(B_d); cuMemFree(C_d);
    cuModuleUnload(mod);
    cuCtxDestroy(ctx);
    return 0;
}