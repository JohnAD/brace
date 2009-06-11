#!/bin/sh -e

cd "`dirname $(readlink -f "$0")`"
if util/not util/changed_since . .install; then exit 0; fi
if [ -d .build/lib ]; then find .build/lib -size 0 | xargs -d'\n' -r rm; fi
if [ ! -e .Make.conf ]; then
	./configure.sh
fi
if [ -n "$WINDIR" -o -n "$windir" ]; then
	make
	make install
else
	if [ -z "$NPROCESSORS" ]; then
		if [ -e /proc/cpuinfo ]; then
			NPROCESSORS=`< /proc/cpuinfo grep '^processor' | wc -l`
		else
			NPROCESSORS=2
		fi
		export NPROCESSORS
	fi
	make -j$NPROCESSORS
	sudo make install
fi
touch .install
