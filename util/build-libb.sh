#!/bin/sh -e
v() {
	echo "$@" >&2
	"$@"
}
LIBB_BUILD=1
. ../.sh.conf
. brace_env
modules="str types buffer circbuf deq thunk list hash error process vec cstr rope sym cons path time m env find ccomplex proc priq timeout net vio io alloc util selector sched shuttle sock ccoro main darcs html http hunk cgi qmath mime meta sound music colours sprite gr event turtle tsv key b"
time (
	set -e
	time brace_update_headers
	time (
		set -e
		files=""
		for A in $modules; do
			for U in . $BRACE_USE; do
				f="$U/$A.b"
				if [ -e "$f" ]; then files="$files $f"; fi
			done
		done
		( echo "use png.h" ; v cat $files | grep -v '^\(use\|export\) [^\.]*$' ) > .all.b
	)
	time v b2c < .all.b >.all.c

	echo_run() {
		if [ -n "$BR_DEBUG" ]; then echo "$@"; fi
		eval "$@"
	}

  if [ -n "$WINDIR" ]; then
		SONAME_FULL=$SONAME
  else
		SONAME_FULL=$SONAME.$VERS
	fi

	( time echo_run "$CC -o $SONAME_FULL $CFLAGS $CINCLUDE .all.c -fPIC $LDFLAGS -shared -Wl,-soname,$SONAME_FULL $LDLIBS" 2>&1 || echo "FAILED" 2>&1 ) | tee libb.log

#	( time v $CC -c $CFLAGS $CINCLUDE -fPIC .all.c 2>&1 || echo "FAILED" 2>&1
#	time v $CC -o $SONAME_FULL $LDFLAGS -shared -Wl,-soname,$SONAME_FULL .all.o $LDLIBS 2>&1 || echo "FAILED" 2>&1 ) | tee libb.log 

	grep 'FAILED' < libb.log && exit 1
	chmod -x $SONAME_FULL
	if [ -z "$WINDIR" ]; then
		ln -sf $SONAME_FULL $SONAME.$MAJOR ; ln -sf $SONAME.$MAJOR $SONAME
	fi
#	rm .all.b .all.c .all.o
)
