pkg-config x11 || \
cc -o /dev/null \
  -I/usr/include \
  -I/usr/local/include \
  compiletest.c
