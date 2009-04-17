#!/bin/sh -e
if [ -n "$WINDIR" -o -n "$windir" ]; then
	./configure
else
	./configure --prefix=/usr
fi
