#include "Backend.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

std::unique_ptr<llvm::Module> readInput(llvm::StringRef path,
                                      llvm::LLVMContext &context) {
  auto extension = llvm::sys::path::extension(path);
  if (extension != ".ll" && extension != ".bc") {
    llvm::errs() << "Unsupported input format: '" << path
                 << "'. Expected a .ll or .bc file\n";
    return nullptr;
  }

  // parseIRFile accepts textual LLVM IR (.ll) and bitcode (.bc).
  llvm::SMDiagnostic diagnostic;
  auto module = llvm::parseIRFile(path, diagnostic, context);
  if (!module)
    diagnostic.print("tiny-backend", llvm::errs());
  return module;
}
