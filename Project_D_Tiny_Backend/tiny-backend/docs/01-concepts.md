# AOT concepts

This project starts after frontend compilation. Its input is already LLVM IR.

```text
.ll/.bc -> llvm::Module -> TargetMachine -> .s/.o -> linker -> executable
```

## Host and target are different

The **host** is the machine running `tiny-backend`. The **target** is the machine
that will run the generated code. An x86-64 host can therefore generate RISC-V
code as long as LLVM was built with its RISC-V backend.

The target triple records architecture, OS, and ABI environment:

| CLI value | Triple | Generic CPU |
|---|---|---|
| `x86-64` | `x86_64-unknown-linux-gnu` | `generic` |
| `riscv64` | `riscv64-unknown-linux-gnu` | `generic-rv64`, RV64GC, `lp64d` |

The `TargetMachine` also supplies the data layout: endianness, pointer sizes,
alignment rules, and related properties required by code generation.

## What code generation does

`addPassesToEmitFile` builds LLVM's target-specific emission pipeline. It lowers
operations, selects instructions, allocates registers, creates stack frames, and
emits assembly or object bytes. This is required code generation, even though
the project deliberately has no separate LLVM IR optimization pipeline.

`--emit=llvm` stops before machine-code generation. `--emit=asm` and
`--emit=obj` run code generation. `--emit=exe` first emits a temporary object
and then invokes a compiler driver as a linker frontend.

## Why linking is separate

An object can contain machine code but still refer to external symbols such as
`puts`. The linker combines it with startup files, libc, and other libraries to
make an executable. For RISC-V Linux, those runtime files must come from a
RISC-V cross-toolchain or sysroot.

## What cross-compilation cannot fix

Changing a module's triple and layout works for the target-neutral examples in
this project. It cannot translate target-specific inline assembly, intrinsics,
calling conventions, ABI-lowered structures, runtime assumptions, or CPU
attributes. A real frontend should create IR for the requested target.
