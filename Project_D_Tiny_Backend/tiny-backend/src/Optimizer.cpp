#include "Optimizer.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/Scalar/GVN.h"
#include "llvm/Transforms/Scalar/Reassociate.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"
#include "llvm/Transforms/Utils/Mem2Reg.h"
#include <utility>

void runBasicOptimizations(llvm::Module &module,
                           llvm::TargetMachine &machine) {
  // Analysis managers provide information that optimization passes request
  llvm::LoopAnalysisManager loops;
  llvm::FunctionAnalysisManager functions;
  llvm::CGSCCAnalysisManager callGraph;
  llvm::ModuleAnalysisManager modules;

  llvm::PassBuilder builder(&machine);
  builder.registerLoopAnalyses(loops);
  builder.registerFunctionAnalyses(functions);
  builder.registerCGSCCAnalyses(callGraph);
  builder.registerModuleAnalyses(modules);
  builder.crossRegisterProxies(loops, functions, callGraph, modules);

  llvm::FunctionPassManager functionPasses;
  functionPasses.addPass(llvm::PromotePass());       // alloca/load/store -> SSA
  functionPasses.addPass(llvm::InstCombinePass());   // simplify instructions
  functionPasses.addPass(llvm::ReassociatePass());   // reorder expressions
  functionPasses.addPass(llvm::GVNPass());           // remove repeated values
  functionPasses.addPass(llvm::SimplifyCFGPass());   // simplify branches/blocks

  llvm::ModulePassManager pipeline;
  pipeline.addPass(llvm::createModuleToFunctionPassAdaptor(
      std::move(functionPasses)));
  pipeline.run(module, modules);
}
