Now that I'm done with generating some LLVM IR using the builder API, It's time to generate some target code. Let's learn how to do it and then move onto figuring out how to do it for an NVIDIA GPU.

# Following the Kaleidoscope Tutorial

To specify the architecture in LLVM we use a target triple with the `<arch><sub>-<vendor>-<sys>-<abi>` format

LLVM provides `sys::getDefaultTargetTriple`, which returns the target triple of the current machine.

We then initialize all the stuff LLVM needs to emit target code in the following code block

```
InitializeAllTargetInfos();

InitializeAllTargets();

InitializeAllTargetMCs();

InitializeAllAsmParsers();

InitializeAllAsmPrinters();
```

Then we use our target triple to get our **target**, which is basically the architecture family:
`auto Target = TargetRegistry::lookupTarget(Triple(TargetTriple), Error);`

We need to then choose our **specific** machine / CPU we need to compile the code for. For now, let's keep it generic and not use any target specific features:
```
auto CPU = "generic";
auto Features = "";

TargetOptions opt;
auto TargetMachine = Target->createTargetMachine(TargetTriple, CPU, Features, opt, Reloc::PIC_);
```

Then we finally use the legacy pass manager and run the pass to emit the object code for our IR stored in the module:

```
legacy::PassManager pass;
auto FileType = CodeGenFileType::ObjectFile;

if (TargetMachine->addPassesToEmitFile(pass, dest, nullptr, FileType)) {
  errs() << "TargetMachine can't emit a file of this type";
  return 1;
}

pass.run(*TheModule);
dest.flush();
```

We're not done yet, we only have the object file for the IR and haven't done any linking yet to use any of the C functions like that extern call, so we link using clang

```
clang output.o -o my_program
```

# Clang Shortcut

Although another thing you could though if you just want an output and are not building a full fledged compiler, is to just use clang to convert your IR into an executable:

` clang sandbox.ll -o shortcut_compile`

# Writing CUDA Kernels using the Builder API

The inside of the kernel is the same as writing conventional IR, until you have to use some CUDA functions or registers, such as threadIdx. For that we have intrinsics in LLVM which we represent as function calls. A function call to threadIdx.x looks like the following:

```
FunctionCallee tidIntrinsic = mod.getOrInsertFunction(

"llvm.nvvm.read.ptx.sreg.tid.x", FunctionType::get(i32Ty, false));

Value *tid = builder.CreateCall(tidIntrinsic, {}, "tid");
```

Then, after writing the kernel, we have to put some meta data information in the module to let it know that it's not a host function but rather a kernel, like the `__global__` keyword in cuda:


```
NamedMDNode *nvvmAnnotations = mod.getOrInsertNamedMetadata("nvvm.annotations");

Metadata *annotMD[] = {

ValueAsMetadata::get(fn),

MDString::get(ctx, "kernel"),

ValueAsMetadata::get(ConstantInt::get(i32Ty, 1))

};

nvvmAnnotations->addOperand(MDNode::get(ctx, annotMD));
```

First of all we access the Named meta data node of our module, and if not present we create it.

Then we construct a metadata triplet array of the format 
`{ function, property_name, property_value }`

so our function we want to create a kernel, the kernel property and 1 meaning it is a kernel

Then we convert our triplet to a tuple like meta data node using `MDNode::get(ctx, annotMD)`

And then we just add it to the top level annotations metadata