#!/bin/sh -e

cd "`dirname $(readlink -f "$0")`"
if which not >/dev/null && not changed_since -q . .install; then exit 0; fi
if [ -d .build/lib ]; then find .build/lib -size 0 | xargs -d'\n' -r rm; fi
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
touch .install
