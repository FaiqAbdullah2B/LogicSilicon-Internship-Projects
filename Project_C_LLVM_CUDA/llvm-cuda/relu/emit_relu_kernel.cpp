#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/raw_ostream.h"
 
using namespace llvm;
 
int main() {
    LLVMContext ctx;
    Module mod("relu_module", ctx);
    mod.setTargetTriple(Triple("nvptx64-nvidia-cuda"));
    mod.setDataLayout(Triple("nvptx64-nvidia-cuda").computeDataLayout());
 
    IRBuilder<> builder(ctx);
    Type *i32Ty = builder.getInt32Ty();
    Type *i64Ty = builder.getInt64Ty();
    Type *f32Ty = builder.getFloatTy();
    PointerType *ptrTy = PointerType::getUnqual(f32Ty->getContext());
 
    // void relu(float* X, i64 n)
    FunctionType *fnTy = FunctionType::get(builder.getVoidTy(), {ptrTy, i64Ty}, false);
    Function *fn = Function::Create(fnTy, Function::ExternalLinkage, "relu", mod);
    auto args = fn->arg_begin();
    Value *X = &*args++; X->setName("X");
    Value *n = &*args++; n->setName("n");
 
    BasicBlock *entry  = BasicBlock::Create(ctx, "entry", fn);
    BasicBlock *ifThen = BasicBlock::Create(ctx, "if.then", fn);
    BasicBlock *ifEnd  = BasicBlock::Create(ctx, "if.end", fn);
 
    builder.SetInsertPoint(entry);
    FunctionCallee tidIntrinsic = mod.getOrInsertFunction(
        "llvm.nvvm.read.ptx.sreg.tid.x", FunctionType::get(i32Ty, false));
    Value *tid = builder.CreateCall(tidIntrinsic, {}, "tid");
    Value *idx = builder.CreateZExt(tid, i64Ty, "idx");
    Value *cmp = builder.CreateICmpULT(idx, n, "in_bounds");
    builder.CreateCondBr(cmp, ifThen, ifEnd);
 
    builder.SetInsertPoint(ifThen);
    Value *ptr = builder.CreateGEP(f32Ty, X, idx, "X.idx");
    Value *val = builder.CreateLoad(f32Ty, ptr, "val");
    Value *isNeg = builder.CreateFCmpOLT(val, ConstantFP::get(f32Ty, 0.0), "isneg");
    Value *clamped = builder.CreateSelect(isNeg, ConstantFP::get(f32Ty, 0.0), val, "relu");
    builder.CreateStore(clamped, ptr);
    builder.CreateBr(ifEnd);
 
    builder.SetInsertPoint(ifEnd);
    builder.CreateRetVoid();
 
    NamedMDNode *nvvmAnnotations = mod.getOrInsertNamedMetadata("nvvm.annotations");
    Metadata *annotMD[] = {
        ValueAsMetadata::get(fn),
        MDString::get(ctx, "kernel"),
        ValueAsMetadata::get(ConstantInt::get(i32Ty, 1))
    };
    nvvmAnnotations->addOperand(MDNode::get(ctx, annotMD));
 
    if (verifyModule(mod, &errs())) { errs() << "verification failed\n"; return 1; }
 
    std::error_code EC;
    raw_fd_ostream out("relu.ll", EC);
    mod.print(out, nullptr);
    outs() << "Wrote relu.ll\n";
    return 0;
}
 

