; Smallest complete example. The process exits with status 42; it prints nothing.
define i32 @main() {
entry:
  %answer = add i32 19, 23
  ret i32 %answer
}
