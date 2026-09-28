# Input contract

| Topic | Requirement |
|---|---|
| LLVM version | LLVM 22.x |
| Input | Valid textual LLVM IR (`.ll`) or bitcode (`.bc`) |
| Pointers | LLVM 22 opaque pointer syntax (`ptr`) |
| Complete executable | ABI-compatible `main` and resolvable external symbols |
| Targets | 64-bit x86 Linux or 64-bit RISC-V Linux |
| Runtime | Supply any nonstandard runtime or library during a manual link |

The command-line target replaces the module's target triple and data layout.
This makes the included target-neutral examples convenient to cross-compile.

It does **not** make arbitrary LLVM IR portable. Regenerate IR in the frontend
for the destination when it contains:

- target-specific intrinsics or inline assembly;
- architecture-specific calling conventions or ABI lowering;
- function attributes such as `target-cpu` or `target-features`;
- assumptions about a particular operating system runtime;
- layouts already baked into pointer arithmetic or structure access.

If the module calls a custom function, emit an object and link its implementation:

```bash
./build/tiny-backend input.ll --emit=obj -o out/input.o
cc out/input.o runtime.c -o out/program
```

Use the matching RISC-V compiler and runtime files for RISC-V objects.
