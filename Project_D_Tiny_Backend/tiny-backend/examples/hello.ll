; puts is implemented by the system C library. LLVM emits a reference to it;
; the link step arranges for that reference to resolve.
@message = private unnamed_addr constant [20 x i8] c"Hello from LLVM IR!\00"
declare i32 @puts(ptr)

define i32 @main() {
entry:
  %ignored = call i32 @puts(ptr @message)
  ret i32 0
}
