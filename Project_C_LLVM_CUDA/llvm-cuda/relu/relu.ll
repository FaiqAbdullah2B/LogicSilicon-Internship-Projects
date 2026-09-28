; ModuleID = 'relu_module'
source_filename = "relu_module"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

define void @relu(ptr %X, i64 %n) {
entry:
  %tid = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  %idx = zext i32 %tid to i64
  %in_bounds = icmp ult i64 %idx, %n
  br i1 %in_bounds, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %X.idx = getelementptr float, ptr %X, i64 %idx
  %val = load float, ptr %X.idx, align 4
  %isneg = fcmp olt float %val, 0.000000e+00
  %relu = select i1 %isneg, float 0.000000e+00, float %val
  store float %relu, ptr %X.idx, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!nvvm.annotations = !{!0}

!0 = !{ptr @relu, !"kernel", i32 1}
