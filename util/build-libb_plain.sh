#!/bin/sh -e
v() {
	echo "$@" >&2
	"$@"
}
echo_run() {
	echo "$@" >&2
	eval "$@"
}
LIBB_BUILD=1
. ../.sh.conf
. brace_env
modules="str types buffer circbuf deq thunk list hash dict error process vec cstr rope sym cons path time m env find ccomplex proc priq timeout net vio io alloc util selector sched shuttle sock ccoro main darcs html http hunk cgi qmath mime meta device"


set -e
brace_update_headers
files=""
for A in $modules; do
	for U in . $BRACE_USE; do
		f="$U/$A.b"
		if [ -e "$f" ]; then files="$files $f"; fi
	done
done
( echo "use png.h" ; v cat $files | grep -v '^\(use\|export\) [^\.]*$' ) > .all.b
v b2c < .all.b >.all.c

if [ -n "$WINDIR" ]; then
	SONAME_FULL=$PLAIN_SONAME
else
	SONAME_FULL=$PLAIN_SONAME.$VERS
fi

( echo_run "$CC -o $SONAME_FULL $CFLAGS $CINCLUDE .all.c -fPIC $LDFLAGS -shared -Wl,-soname,$SONAME_FULL $LDLIBS_PLAIN" 2>&1 || echo "FAILED" 2>&1 ) | tee libb.log

#( v $CC -c $CFLAGS $CINCLUDE -fPIC .all.c 2>&1 || echo "FAILED" 2>&1
#v $CC -o $SONAME_FULL $LDFLAGS -shared -Wl,-soname,$SONAME_FULL .all.o $LDLIBS 2>&1 || echo "FAILED" 2>&1 ) | tee libb.log

grep 'FAILED' < libb.log && exit 1
chmod -x $SONAME_FULL
if [ -z "$WINDIR" ]; then
	ln -sf $SONAME_FULL $PLAIN_SONAME.$MAJOR ; ln -sf $PLAIN_SONAME.$MAJOR $PLAIN_SONAME
fi
#rm .all.b .all.c .all.o
