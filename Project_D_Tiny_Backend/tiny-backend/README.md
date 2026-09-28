# Tiny LLVM AOT Backend

A small teaching project that turns LLVM IR (`.ll` or `.bc`) into machine code
ahead of time. It supports two command-line targets:

- `--target=x86-64` (default)
- `--target=riscv64`

The backend deliberately uses generic CPUs. IR optimization is optional so the
essential AOT path stays visible:

```text
LLVM IR -> target setup -> optional optimization -> object -> linker -> executable
```

Add `--optimize` to run a short, explicit teaching pipeline before code
generation:

```text
mem2reg -> instcombine -> reassociate -> GVN -> simplify-cfg
```

The project targets LLVM 22.x, C++17, and Linux.

The RISC-V configuration uses the common Linux `RV64GC` instruction set and
`lp64d` ABI so its objects are compatible with `riscv64-linux-gnu-gcc` and the
usual double-float RISC-V glibc toolchain.

## Build

Requirements: LLVM 22 development files, CMake 3.20+, a C++17 compiler, and
Ninja or Make. LLVM must have both the X86 and RISCV targets enabled.

```bash
bash build.sh
```

The executable is written to `build/tiny-backend`.

## Generate x86-64 code

Build and run a native Linux executable:

```bash
mkdir -p out
./build/tiny-backend examples/hello.ll -o out/hello
./out/hello
```

Generate an object or assembly file without linking:

```bash
./build/tiny-backend examples/add.ll --emit=obj -o out/add-x86.o
./build/tiny-backend examples/add.ll --emit=asm -o out/add-x86.s
```

`--target=x86-64` is optional because it is the default.

## Cross-compile to RISC-V 64

Object and assembly generation only need LLVM's RISC-V backend:

```bash
./build/tiny-backend examples/add.ll \
  --target=riscv64 --emit=obj -o out/add-riscv64.o

./build/tiny-backend examples/add.ll \
  --target=riscv64 --emit=asm -o out/add-riscv64.s
```

To produce a RISC-V Linux executable, install a RISC-V cross-toolchain. The
default linker driver is `riscv64-linux-gnu-gcc`:

```bash
./build/tiny-backend examples/return42.ll \
  --target=riscv64 -o out/return42-riscv64
```

You can choose another compatible driver explicitly:

```bash
./build/tiny-backend examples/return42.ll \
  --target=riscv64 --cc=riscv64-linux-gnu-gcc \
  -o out/return42-riscv64
```

The generated RISC-V executable cannot run directly on an x86-64 processor.
Run it on RISC-V hardware or through a suitable emulator such as QEMU with the
matching RISC-V Linux runtime.

## Command-line options

| Option | Values | Default |
|---|---|---|
| `--target` | `x86-64`, `riscv64` | `x86-64` |
| `--emit` | `exe`, `obj`, `asm`, `llvm` | `exe` |
| `--cc` | Compatible compiler/linker driver | `cc` for x86-64; `riscv64-linux-gnu-gcc` for RISC-V |
| `--optimize` | Run the basic IR optimization pipeline | Off |
| `-o` | Output path | Required |

Examples:

```bash
# Print configured LLVM IR
./build/tiny-backend examples/return42.ll --emit=llvm -o out/return42.ll

# Print optimized LLVM IR so you can compare it with the input
./build/tiny-backend examples/return42.ll \
  --optimize --emit=llvm -o out/return42-optimized.ll

# Explicit x86-64 object
./build/tiny-backend examples/add.ll \
  --target=x86-64 --emit=obj -o out/add-x86.o
```

The program refuses to overwrite an existing output file.

## Where the AOT code lives

| File | Purpose |
|---|---|
| `src/main.cpp` | Parse options and run the compilation pipeline |
| `src/Input.cpp` | Read `.ll` or `.bc` into an LLVM `Module` |
| `src/Backend.cpp` | Select x86-64/RISC-V, create the `TargetMachine`, and emit code |
| `src/Linker.cpp` | Link a temporary object into an executable |
| `src/Optimizer.cpp` | Run the optional, explicit IR optimization passes |
| `src/Backend.h` | Shared declarations |
| `tests/integration.py` | End-to-end tests, including RISC-V ELF verification |

The simplified target setup in `Backend.cpp` does only four important things:

1. Registers the X86 and RISC-V LLVM backends.
2. Maps `--target` to a target triple and generic CPU.
3. Creates an LLVM `TargetMachine`.
4. Applies its target triple and data layout to the module.

If requested, `runBasicOptimizations` transforms the IR after the target data
layout is known. `emitFile` then asks the target machine to emit either assembly
or an object file. Executable mode performs one additional link step.

## Tests

```bash
bash build.sh --test
```

The RISC-V tests generate object/assembly files and inspect the ELF architecture;
they do not require RISC-V hardware or a cross-linker.

## Important input assumption

Selecting a target replaces the module's declared target triple and data layout.
That is appropriate for the target-neutral examples in this project. It cannot
make target-specific inline assembly, intrinsics, ABI-lowered types, runtime
calls, or per-function CPU attributes portable. A real frontend should produce
LLVM IR specifically for the chosen target.

More explanation is available in [`docs/`](docs/00-quickstart.md).
