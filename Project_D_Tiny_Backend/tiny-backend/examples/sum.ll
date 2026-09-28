; Compute 1 + 2 + ... + n. A phi selects a value from the predecessor block.
; main passes 10, so the program exits with 55.
define i32 @sum_to(i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 1, %entry ], [ %next_i, %body ]
  %total = phi i32 [ 0, %entry ], [ %next_total, %body ]
  %continue = icmp sle i32 %i, %n
  br i1 %continue, label %body, label %exit

body:
  %next_total = add i32 %total, %i
  %next_i = add i32 %i, 1
  br label %loop

exit:
  ret i32 %total
}

define i32 @main() {
entry:
  %result = call i32 @sum_to(i32 10)
  ret i32 %result
}
