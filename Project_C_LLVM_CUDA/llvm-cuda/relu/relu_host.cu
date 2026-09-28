// relu_host.cpp
// Plain CUDA driver API host code -- loads relu.ptx and runs it.
//
// Build: g++ relu_host.cpp -lcuda -o relu_host
// Run:   ./relu_host        (relu.ptx must be in the same directory)

#include <cuda.h>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>

#define N 8
#define CHECK(call) do { \
    CUresult res = (call); \
    if (res != CUDA_SUCCESS) { \
        const char *msg; cuGetErrorString(res, &msg); \
        fprintf(stderr, "CUDA error %s at %s:%d\n", msg, __FILE__, __LINE__); \
        exit(1); \
    } \
} while (0)

int main() {
    std::ifstream f("relu.ptx");
    std::stringstream ss;
    ss << f.rdbuf();
    std::string ptx = ss.str();

    CHECK(cuInit(0));
    CUdevice dev;
    CHECK(cuDeviceGet(&dev, 0));
    CUcontext ctx;
    CHECK(cuCtxCreate(&ctx, nullptr, 0, dev));

    CUmodule mod;
    CHECK(cuModuleLoadData(&mod, ptx.c_str()));
    CUfunction kernel;
    CHECK(cuModuleGetFunction(&kernel, mod, "relu"));

    float X[N] = {-3, -2, -1, 0, 1, 2, 3, 4};
    size_t size = sizeof(X);

    CUdeviceptr X_d;
    CHECK(cuMemAlloc(&X_d, size));
    CHECK(cuMemcpyHtoD(X_d, X, size));

    size_t n = N;
    void *args[] = { &X_d, &n };

    // grid(1,1,1), block(8,1,1) -- one thread per element
    CHECK(cuLaunchKernel(kernel,
                          1, 1, 1,
                          N, 1, 1,
                          0, 0, args, nullptr));
    CHECK(cuCtxSynchronize());

    CHECK(cuMemcpyDtoH(X, X_d, size));
    for (int i = 0; i < N; i++) printf("%.1f, ", X[i]);
    printf("\n");

    cuMemFree(X_d);
    cuModuleUnload(mod);
    cuCtxDestroy(ctx);
    return 0;
}