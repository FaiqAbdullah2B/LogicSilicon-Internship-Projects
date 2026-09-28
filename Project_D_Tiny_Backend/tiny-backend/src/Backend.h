#pragma once

#include "llvm/ADT/StringRef.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Target/TargetMachine.h"
#include <memory>

std::unique_ptr<llvm::Module> readInput(llvm::StringRef path,
                                      llvm::LLVMContext &context);

// Select the generic x86-64 or RISC-V 64 Linux target.
std::unique_ptr<llvm::TargetMachine>
configureTarget(llvm::Module &module, llvm::StringRef architecture);

// Emit "obj", "asm", or "llvm". true means success
bool emitFile(llvm::Module &module, llvm::TargetMachine &machine,
              llvm::StringRef path, llvm::StringRef kind);

// Emit a temporary object using LLVM, then launch a C compiler driver to link it.
bool emitExecutable(llvm::Module &module, llvm::TargetMachine &machine,
                    llvm::StringRef output, llvm::StringRef driver);
