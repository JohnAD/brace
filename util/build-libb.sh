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
	( time v $CC -c $CFLAGS -fPIC .all.c 2>&1 || echo "FAILED" ;
	  time v ${LD:-ld} -o $SONAME.$VERS -shared -soname $SONAME.$VERS $LDFLAGS .all.o $LDLIBS 2>&1 || echo "FAILED" ) | \
	  tee libb.log 
	grep 'FAILED' < libb.log && exit 1
	chmod -x $SONAME.$VERS
	ln -sf $SONAME.$VERS $SONAME.$MAJOR ; ln -sf $SONAME.$MAJOR $SONAME
#	rm .all.b .all.c .all.o
)
