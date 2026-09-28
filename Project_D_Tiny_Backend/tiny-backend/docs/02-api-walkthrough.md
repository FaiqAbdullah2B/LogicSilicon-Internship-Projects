# Backend API walkthrough

Read `src/main.cpp`, then `src/Backend.cpp`.

## 1. Parse and verify

`readInput` uses `llvm::parseIRFile` to build an owning
`std::unique_ptr<llvm::Module>`. `llvm::verifyModule` checks core IR invariants.

## 2. Select a target

`configureTarget` maps the simple CLI name to fixed settings:

```cpp
x86-64 -> x86_64-unknown-linux-gnu + generic
riscv64 -> riscv64-unknown-linux-gnu + generic-rv64 + RV64GC + lp64d
```

The explicit `LLVMInitializeX86...` and `LLVMInitializeRISCV...` calls register
only the two backends used by this project. This also keeps static LLVM builds
from needing every target library.

## 3. Create a TargetMachine

`TargetRegistry::lookupTarget` finds the implementation associated with the
triple. `createTargetMachine` supplies the triple, generic CPU, target feature
string, PIC relocation model, default code model, and
`CodeGenOptLevel::None`.

For RISC-V, the feature string enables M/A/F/D/C and `MCOptions.ABIName` selects
`lp64d`. This matches the standard double-float Linux cross-toolchain and avoids
mixing soft-float objects with double-float runtime files.

The module is then updated with:

```cpp
module.setTargetTriple(triple);
module.setDataLayout(machine->createDataLayout());
```

Those are the target facts LLVM needs for emission.

## 4. Optionally optimize IR

`--optimize` calls `runBasicOptimizations` after target configuration and before
emission. The target is configured first because optimization can use its data
layout and analysis information.

The deliberately small pipeline is:

1. `PromotePass` (`mem2reg`) replaces eligible stack loads/stores with SSA values.
2. `InstCombinePass` folds constants and simplifies redundant instructions.
3. `ReassociatePass` rearranges associative expressions to expose simplifications.
4. `GVNPass` removes repeated computations that produce the same value.
5. `SimplifyCFGPass` removes unnecessary branches and merges basic blocks.

These are popular introductory passes because their effects are easy to see in
LLVM IR. This is not intended to reproduce LLVM's complete `-O1` or `-O2`
pipeline. Without `--optimize`, the project preserves the input computations.

## 5. Emit code

For assembly or an object, `emitFile` creates a legacy pass manager and asks the
`TargetMachine` to add its emission passes. Running the pass manager performs
the AOT machine-code pipeline. `ToolOutputFile::keep()` preserves the file only
after successful output.

## 6. Link when requested

`emitExecutable` emits a temporary object and executes a compiler driver with an
argument array. x86-64 defaults to `cc`; RISC-V defaults to
`riscv64-linux-gnu-gcc`. Object and assembly modes never invoke either driver.
