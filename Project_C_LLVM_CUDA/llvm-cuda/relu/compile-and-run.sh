clang++ emit_relu_kernel.cpp $(llvm-config --cxxflags --ldflags --libs core support) -o emit_relu_kernel

./emit_relu_kernel                               

llc -march=nvptx64 -mcpu=sm_86 relu.ll -o relu.ptx

nvcc relu_host.cu -lcuda -o relu_host
./relu_host                                               