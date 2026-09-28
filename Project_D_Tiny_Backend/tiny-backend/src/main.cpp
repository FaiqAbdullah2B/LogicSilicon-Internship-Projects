#include "Backend.h"
#include "Optimizer.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

namespace {
llvm::cl::OptionCategory category("Tiny backend options");
llvm::cl::opt<std::string> input(llvm::cl::Positional, llvm::cl::Required,
    llvm::cl::desc("input.ll | input.bc"), llvm::cl::cat(category));
llvm::cl::opt<std::string> output("o", llvm::cl::Required,
    llvm::cl::desc("Output file"), llvm::cl::cat(category));
llvm::cl::opt<std::string> emit("emit", llvm::cl::init("exe"),
    llvm::cl::desc("exe (default), obj, asm, or llvm"), llvm::cl::cat(category));
llvm::cl::opt<std::string> target("target", llvm::cl::init("x86-64"),
    llvm::cl::desc("x86-64 (default) or riscv64"), llvm::cl::cat(category));
llvm::cl::opt<std::string> driver("cc", llvm::cl::init(""),
    llvm::cl::desc("Linker driver (default: cc, or riscv64-linux-gnu-gcc)"),
    llvm::cl::cat(category));
llvm::cl::opt<bool> optimize("optimize", llvm::cl::init(false),
    llvm::cl::desc("Run a small IR optimization pipeline"),
    llvm::cl::cat(category));
}

int main(int argc, char **argv) {
  llvm::InitLLVM initialize(argc, argv);
  llvm::cl::HideUnrelatedOptions(category);
  llvm::cl::ParseCommandLineOptions(argc, argv, "A small LLVM 22 backend\n");
  if (emit != "exe" && emit != "obj" && emit != "asm" && emit != "llvm") {
    llvm::errs() << "--emit must be exe, obj, asm, or llvm\n";
    return 1;
  }
  if (target != "x86-64" && target != "riscv64") {
    llvm::errs() << "--target must be x86-64 or riscv64\n";
    return 1;
  }
  if (input == "-" || output == "-" || output.empty()) {
    llvm::errs() << "Use file paths; stdin/stdout mode is not supported\n";
    return 1;
  }
  if (llvm::sys::fs::exists(output)) {
    llvm::errs() << "Output already exists: " << output << ". Choose a new path.\n";
    return 1;
  }

  llvm::LLVMContext context;
  auto module = readInput(input, context);
  if (!module)
    return 1;
  if (llvm::verifyModule(*module, &llvm::errs()))
    return 1;

  // Build a target machine, then use it for AOT code generation.
  auto machine = configureTarget(*module, target);
  if (!machine)
    return 1;

  // Optimization is optional so the original IR remains easy to inspect.
  if (optimize) {
    runBasicOptimizations(*module, *machine);
    if (llvm::verifyModule(*module, &llvm::errs()))
      return 1;
  }

  std::string selectedDriver = driver;
  if (selectedDriver.empty())
    selectedDriver = target == "riscv64" ? "riscv64-linux-gnu-gcc" : "cc";

  bool success = emit == "exe"
      ? emitExecutable(*module, *machine, output, selectedDriver)
      : emitFile(*module, *machine, output, emit);
  if (!success)
    return 1;

  llvm::outs() << "Wrote " << output << '\n';
  
  return 0;
}
