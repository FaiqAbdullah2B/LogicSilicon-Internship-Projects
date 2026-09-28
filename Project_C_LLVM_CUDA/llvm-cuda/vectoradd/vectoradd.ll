; ModuleID = 'vectoradd_module'
source_filename = "vectoradd_module"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

define void @vectorAdd(ptr %A, ptr %B, ptr %C, i64 %sz) {
entry:
  %tid = call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  %idx = zext i32 %tid to i64
  %cmp = icmp ult i64 %idx, %sz
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %A.idx = getelementptr i32, ptr %A, i64 %idx
  %B.idx = getelementptr i32, ptr %B, i64 %idx
  %C.idx = getelementptr i32, ptr %C, i64 %idx
  %a = load i32, ptr %A.idx, align 4
  %b = load i32, ptr %B.idx, align 4
  %sum = add i32 %a, %b
  store i32 %sum, ptr %C.idx, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!nvvm.annotations = !{!0}

!0 = !{ptr @vectorAdd, !"kernel", i32 1}
