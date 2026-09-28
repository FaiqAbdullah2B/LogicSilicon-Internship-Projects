# Quick start

## Build

Install LLVM 22 development files, CMake 3.20+, a C++17 compiler, and Ninja or
Make. LLVM must include the X86 and RISCV targets.

```bash
bash build.sh
```

For a custom LLVM installation:

```bash
LLVM_CONFIG=/path/to/llvm-config bash build.sh
```

## x86-64 AOT compilation

```bash
mkdir -p out
./build/tiny-backend examples/hello.ll -o out/hello
./out/hello
```

The default is `--target=x86-64 --emit=exe`. To stop before linking:

```bash
./build/tiny-backend examples/add.ll --emit=obj -o out/add-x86.o
./build/tiny-backend examples/add.ll --emit=asm -o out/add-x86.s
```

## RISC-V 64 cross-compilation

```bash
./build/tiny-backend examples/add.ll \
  --target=riscv64 --emit=obj -o out/add-riscv64.o
./build/tiny-backend examples/add.ll \
  --target=riscv64 --emit=asm -o out/add-riscv64.s
```

These two commands do not need a RISC-V linker. Executable output does:

```bash
./build/tiny-backend examples/return42.ll \
  --target=riscv64 -o out/return42-riscv64
```

The default RISC-V linker driver is `riscv64-linux-gnu-gcc`. Override it with
`--cc=...` when necessary. Run the result on RISC-V hardware or with QEMU and a
matching RISC-V Linux runtime, not directly on an x86-64 CPU.

## Other output modes

```bash
llvm-as-22 examples/return42.ll -o out/return42.bc
./build/tiny-backend out/return42.bc --emit=llvm -o out/configured.ll
```

The tool accepts only `.ll` and `.bc` inputs and refuses to overwrite outputs.

## Tests

```bash
bash build.sh --test
```

The test suite verifies that x86-64 objects use ELF machine value 62 and RISC-V
objects use ELF machine value 243.
