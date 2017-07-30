#include <stdio.h>

main(argc, argv)
  int argc;
  char *argv[];
{
  char c;

  printf(">");

  while((c = getchar()) != EOF) {
    switch(c) {
    case '\n':
      printf("\n>");
      break;
    default:
      putchar(c);
      break;
    }
  }

}
