#!/bin/bash
BRACE_USE="unix nonmingw x nonbsd linux io-epoll"
files="str types buffer circbuf deq thunk list hash error process vec cstr rope sym cons path time m env find ccomplex proc priq timeout net vio io alloc util selector sched shuttle sock ccoro main darcs html http hunk cgi qmath mime meta sound music colours sprite gr event turtle tsv key b"
time (
echo "use png.h"
for A in $files; do
	for U in . $BRACE_USE; do
		f="$U/$A.b"
		if [ -e "$f" ]; then
			v cat "$f" | grep -v '^\(use\|export\) [^\.]*$'
			echo
		fi
	done
done
) > all.b
time v b2c < all.b > all.c
time v ccw -o libb.so -shared -fpic -Wl,-soname,libb.so all.c -lpng 2>&1 | tee libb.log
