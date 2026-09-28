# Exercises

Use a fresh output path for every command.

## 1. Compare target assembly

```bash
./build/tiny-backend examples/add.ll --target=x86-64 --emit=asm -o out/add-x86.s
./build/tiny-backend examples/add.ll --target=riscv64 --emit=asm -o out/add-riscv.s
```

Find the return-value register and addition instruction in each file. Explain
why the same LLVM IR becomes different instruction sets.

## 2. Inspect object headers

Generate both object files and inspect them with `llvm-readobj-22 --file-headers`.
Confirm `EM_X86_64` versus `EM_RISCV`.

## 3. Link manually

```bash
./build/tiny-backend examples/add.ll --emit=obj -o out/add.o
cc examples/caller.c out/add.o -o out/caller
./out/caller
```

Explain why `add.ll` can become an object but cannot become a standalone
executable without a `main` function.

## 4. Inspect configured IR

```bash
./build/tiny-backend examples/return42.ll \
  --target=x86-64 --emit=llvm -o out/x86.ll
./build/tiny-backend examples/return42.ll \
  --target=riscv64 --emit=llvm -o out/riscv.ll
```

Compare target triples and data layouts. Confirm that the actual arithmetic IR
is unchanged.

## 5. Follow the pipeline in a debugger

Set breakpoints in `readInput`, `configureTarget`, `emitFile`, and
`emitExecutable`. Object mode should never enter `emitExecutable`.
