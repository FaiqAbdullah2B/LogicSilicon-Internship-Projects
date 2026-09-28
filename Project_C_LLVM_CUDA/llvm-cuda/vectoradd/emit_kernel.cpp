//   int idx = threadIdx.x;
//   if (idx < sz) C[idx] = A[idx] + B[idx];

#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/TargetParser/Host.h"

using namespace llvm;
LLVMContext ctx;
Module TheModule("vectoradd_module", ctx);

void generateTargetCode() {
    using namespace llvm;

    // Only bring up the NVPTX backend — no need for every target LLVM supports
    LLVMInitializeNVPTXTargetInfo();
    LLVMInitializeNVPTXTarget();
    LLVMInitializeNVPTXTargetMC();
    LLVMInitializeNVPTXAsmPrinter();

    const std::string TargetTriple = "nvptx64-nvidia-cuda";

    std::string Error;
    const Target *Target = TargetRegistry::lookupTarget(TargetTriple, Error);
    if (!Target) {
        errs() << "lookupTarget failed: " << Error;
        return;
    }

    // sm_86 = Ampere (RTX 30-series)
    // ISA 7.1+ covers sm_86.
    const char *CPU      = "sm_86";
    const char *Features = "+ptx71";

    TargetOptions opt;
    std::unique_ptr<TargetMachine> TM(
        Target->createTargetMachine(Triple(TargetTriple), CPU, Features, opt, std::nullopt));

    TheModule.setDataLayout(TM->createDataLayout());
    TheModule.setTargetTriple(Triple(TargetTriple));

    std::error_code EC;
    raw_fd_ostream dest("output.ptx", EC, sys::fs::OF_Text);
    if (EC) {
        errs() << "Could not open file: " << EC.message();
        return;
    }

    legacy::PassManager pass;
    if (TM->addPassesToEmitFile(pass, dest, nullptr, CodeGenFileType::AssemblyFile)) {
        errs() << "TargetMachine can't emit PTX";
        return;
    }

    pass.run(TheModule);
    dest.flush();
}

int main() {
    
   
    TheModule.setTargetTriple(Triple("nvptx64-nvidia-cuda"));
    TheModule.setDataLayout(Triple("nvptx64-nvidia-cuda").computeDataLayout());

    IRBuilder<> builder(ctx);

    Type *i32Ty = builder.getInt32Ty();
    Type *i64Ty = builder.getInt64Ty();
    PointerType *i32PtrTy = PointerType::get(i32Ty, 0);

    // void vectorAdd(i32* A, i32* B, i32* C, i64 sz)
    FunctionType *fnTy = FunctionType::get(
      builder.getVoidTy(),
      {i32PtrTy, i32PtrTy, i32PtrTy, i64Ty},
      false
    );

    Function *fn = Function::Create(fnTy, Function::ExternalLinkage, "vectorAdd", TheModule);

    auto args = fn->arg_begin();
    Value *A = &*args++; A->setName("A");
    Value *B = &*args++; B->setName("B");
    Value *C = &*args++; C->setName("C");
    Value *sz = &*args++; sz->setName("sz");

    BasicBlock *entry = BasicBlock::Create(ctx, "entry", fn);
    BasicBlock *ifThen = BasicBlock::Create(ctx, "if.then", fn);
    BasicBlock *ifEnd  = BasicBlock::Create(ctx, "if.end", fn);

    builder.SetInsertPoint(entry);

    // NVPTX intrinsic
    FunctionType *tidFnTy = FunctionType::get(i32Ty, false);
    FunctionCallee tidIntrinsic = TheModule.getOrInsertFunction(
        "llvm.nvvm.read.ptx.sreg.tid.x", tidFnTy);
    Value *tid = builder.CreateCall(tidIntrinsic, {}, "tid");

    Value *idx64 = builder.CreateZExt(tid, i64Ty, "idx");
    Value *cmp = builder.CreateICmpULT(idx64, sz, "cmp");
    builder.CreateCondBr(cmp, ifThen, ifEnd);

    // if block
    builder.SetInsertPoint(ifThen);
    Value *aPtr = builder.CreateGEP(i32Ty, A, idx64, "A.idx");
    Value *bPtr = builder.CreateGEP(i32Ty, B, idx64, "B.idx");
    Value *cPtr = builder.CreateGEP(i32Ty, C, idx64, "C.idx");
    Value *aVal = builder.CreateLoad(i32Ty, aPtr, "a");
    Value *bVal = builder.CreateLoad(i32Ty, bPtr, "b");
    Value *sum  = builder.CreateAdd(aVal, bVal, "sum");
    builder.CreateStore(sum, cPtr);
    builder.CreateBr(ifEnd);

    builder.SetInsertPoint(ifEnd);
    builder.CreateRetVoid();

    // mark the function as kernel
    NamedMDNode *nvvmAnnotations = TheModule.getOrInsertNamedMetadata("nvvm.annotations");
    Metadata *annotMD[] = {
        ValueAsMetadata::get(fn),
        MDString::get(ctx, "kernel"),
        ValueAsMetadata::get(ConstantInt::get(i32Ty, 1))
    };
    nvvmAnnotations->addOperand(MDNode::get(ctx, annotMD));

    if (verifyModule(TheModule, &errs())) {
        errs() << "Module verification failed!\n";
        return 1;
    }

    std::error_code EC;
    raw_fd_ostream out("vectoradd.ll", EC);
    TheModule.print(out, nullptr);
    outs() << "Wrote vectoradd.ll\n";
    fn->setCallingConv(CallingConv::PTX_Kernel);
    generateTargetCode();

    return 0;
}