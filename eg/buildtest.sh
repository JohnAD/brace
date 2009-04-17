#!/bin/sh

rm .testgl.b.exe
CC=echo ./testgl.b
gcc -I"/c/Program Files/brace/include" -Wall -Werror -I. -L"/c/Program Files/brace/lib" -Wl,--enable-auto-import,--enable-runtime-pseudo-reloc "/c/Program Files/brace/lib/libb.dll" -o.testgl.b.exe ./.testgl.c /mingw/lib/libopengl32.a /mingw/lib/libglu32.a /mingw/lib/libgdi32.a

./.testgl.b.exe
