#include "Backend.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Program.h"
#include "llvm/Support/raw_ostream.h"
#include <optional>

bool emitExecutable(llvm::Module &module, llvm::TargetMachine &machine,
                    llvm::StringRef output, llvm::StringRef driver) {

  auto program = llvm::sys::findProgramByName(driver);
  if (!program) {
    llvm::errs() << "Cannot find linker driver '" << driver << "': "
                 << program.getError().message() << '\n';
    return false;
  }

  llvm::SmallString<128> objectPath;

  if (auto error = llvm::sys::fs::createTemporaryFile("tiny-backend", "o", objectPath)) {
    llvm::errs() << "Cannot create temporary object: " << error.message() << '\n';
    return false;
  }

  bool emitted = emitFile(module, machine, objectPath, "obj");
  if (!emitted) {
    llvm::sys::fs::remove(objectPath);
    return false;
  }
  
  llvm::StringRef args[] = {*program, "-pie", objectPath, "-o", output, "-lm"};

  llvm::errs() << "Linking with " << *program << '\n';
  std::string error;
  int result = llvm::sys::ExecuteAndWait(*program, args, std::nullopt, {}, 0, 0, &error);
  llvm::sys::fs::remove(objectPath);
  if (result != 0) {
    llvm::errs() << "Link failed (status " << result << "). " << error << '\n';
    return false;
  }
  
  return true;
}
