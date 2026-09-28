#pragma once

namespace llvm {
  class Module;
  class TargetMachine;
}

// explicit IR optimization pipeline
void runBasicOptimizations(llvm::Module &module,
                           llvm::TargetMachine &machine);
