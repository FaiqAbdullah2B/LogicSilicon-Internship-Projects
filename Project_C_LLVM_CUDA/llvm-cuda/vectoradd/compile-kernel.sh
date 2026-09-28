clang++ emit_kernel.cpp $(llvm-config --cxxflags --ldflags --libs core support) -o emit_kernel

./emit_kernel                                        

llc -march=nvptx64 -mcpu=sm_86 vectoradd.ll -o vectoradd.ptx
