#include "Backend.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/TargetParser/Triple.h"
#include <optional>
#include <string>

std::unique_ptr<llvm::TargetMachine>
configureTarget(llvm::Module &module, llvm::StringRef architecture) {

  LLVMInitializeX86TargetInfo();
  LLVMInitializeX86Target();
  LLVMInitializeX86TargetMC();
  LLVMInitializeX86AsmPrinter();
  LLVMInitializeX86AsmParser();
  LLVMInitializeRISCVTargetInfo();
  LLVMInitializeRISCVTarget();
  LLVMInitializeRISCVTargetMC();
  LLVMInitializeRISCVAsmPrinter();
  LLVMInitializeRISCVAsmParser();

  // The target is chosen by the user
  const bool isRISCV = architecture == "riscv64";
  const char *tripleName = isRISCV
                               ? "riscv64-unknown-linux-gnu"
                               : "x86_64-unknown-linux-gnu";
  const char *cpu = isRISCV ? "generic-rv64" : "generic";

  // Linux RISC-V toolchains normally use RV64GC with the lp64d ABI.
  // F and D provide hardware float/double instructions; lp64d passes
  const char *features = isRISCV ? "+m,+a,+f,+d,+c" : "";
  llvm::Triple triple(llvm::Triple::normalize(tripleName));

  std::string error;
  const llvm::Target *target = llvm::TargetRegistry::lookupTarget(triple, error);
  if (!target) {
    llvm::errs() << error << '\n';
    return nullptr;
  }

  llvm::TargetOptions options;
  if (isRISCV)
    options.MCOptions.ABIName = "lp64d";

  auto machine = std::unique_ptr<llvm::TargetMachine>(target->createTargetMachine(
      triple, cpu, features, options, llvm::Reloc::PIC_,
      std::nullopt, llvm::CodeGenOptLevel::None));
  if (!machine) {
    llvm::errs() << "Could not create a TargetMachine\n";
    return nullptr;
  }

  module.setTargetTriple(triple);
  module.setDataLayout(machine->createDataLayout());
  llvm::errs() << "Target: " << triple.str();
  if (isRISCV)
    llvm::errs() << " | ISA: RV64GC | ABI: lp64d";
  llvm::errs() << '\n';

  return machine;
}

bool emitFile(llvm::Module &module, llvm::TargetMachine &machine,
              llvm::StringRef path, llvm::StringRef kind) {
  std::error_code error;
  llvm::ToolOutputFile output(path, error, llvm::sys::fs::OF_None);
  if (error) {
    llvm::errs() << "Cannot open '" << path << "': " << error.message() << '\n';
    return false;
  }

  if (kind == "llvm") {
    module.print(output.os(), nullptr);
  } else {
    llvm::legacy::PassManager codegen;
    auto fileType = kind == "asm" ? llvm::CodeGenFileType::AssemblyFile
                                  : llvm::CodeGenFileType::ObjectFile;
    if (machine.addPassesToEmitFile(codegen, output.os(), nullptr, fileType)) {
      llvm::errs() << "This target cannot emit the requested file type\n";
      return false;
    }
    codegen.run(module);
  }
  output.os().flush();
  if (output.os().has_error()) {
    llvm::errs() << "Failed writing '" << path << "'\n";
    output.os().clear_error();
    return false;
  }

  output.keep();
  return true;
}
