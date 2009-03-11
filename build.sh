#!/bin/sh -e

cd "`dirname $(readlink -f "$0")`"
if [ ! -e Make.conf ]; then
	./configure.sh
fi
if [ -n "$WINDIR" -o -n "$windir" ]; then
	make install
else
	export NPROCESSORS=2
	make -j$NPROCESSORS
	sudo make install
fi
