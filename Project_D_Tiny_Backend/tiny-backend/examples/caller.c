#include <stdio.h>
extern int add(int a, int b);

int main(void) {
  int answer = add(19, 23);
  printf("add(19, 23) = %d\n", answer);
  return answer == 42 ? 0 : 1;
}
