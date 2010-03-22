include ../.Make.conf

CFLAGS=$(EXE_CFLAGS)
LDFLAGS=$(EXE_LDFLAGS)
LDLIBS=$(EXE_LDLIBS)

# - for win32; can assume there was nothing needful in PERL5LIB  :)

build: boot bx$(EXE) bbx$(EXE) b1$(EXE) bb1$(EXE)
boot: brace$(EXE) .mk_foo_stamp .mk_bar_stamp .mk_baz_stamp

brace.c: brace.b
	<brace.b b2b0 | b02b1 | brace >brace.c
brace$(EXE): brace.o
	echo $(PERL5LIB)
	echo $(BRACE_LIB)
	$(CC) $(LDFLAGS) $(CFLAGS) -o brace brace.o $(LDLIBS)
	@<brace.b b2b0 | b02b1 | brace >.brace.test.c
#	@../util/vd brace.c .brace.test.c || . ../util/fail "TEST FAILED! brace is broken!"
	@echo "brace works ok, hopefully"

bx$(EXE): bx.b ../lib/$(SONAME)
	br bx.b bx$(EXE)
bbx$(EXE): bx$(EXE)
	lnorcp bx$(EXE) bbx$(EXE)

b1$(EXE): b1.b ../lib/$(SONAME)
	br b1.b b1$(EXE)
bb1$(EXE): b1$(EXE)
	lnorcp b1$(EXE) bb1$(EXE)

.mk_foo_stamp: brace_foo
	brace_mk_exes brace_foo
	touch .mk_foo_stamp
.mk_bar_stamp: brace_bar
	brace_mk_exes brace_bar
	touch .mk_bar_stamp
.mk_baz_stamp: brace_baz
	brace_mk_exes brace_baz
	touch .mk_baz_stamp

clean:
	< exe_types perl -ne 'chomp; s/\r//g; s/.*\t//; unlink $$_';
	rm -f .mk_foo_stamp .mk_bar_stamp .mk_baz_stamp brace brace.exe bx bx.exe bbx bbx.exe brace.o brace.bh bx.bh .brace.1 .brace.2 .brace.test.c .bx.1 .bx.2 .bx.bak .bx.b1 .bx.c .bx.log .bx.b.xbak b1 b1.exe bb1 bb1.exe .b1.bak .b1.c .b1.b.xbak .b1.b1 .b1.bak2

install: build
	$(INSTALL) -d '$(bindir)' "$(langdir)" || true
	$(INSTALL) `../util/lsx .` '$(bindir)'
	$(INSTALL) -m 644 brace_env '$(bindir)'
	lnorcp '$(bindir)/br' '$(bindir)/bbr'
	lnorcp bx$(EXE) '$(bindir)/bbx$(EXE)'
	lnorcp "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/b$(EXE) || true
	lnorcp "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/bb$(EXE) || true
	lnorcp b1$(EXE) '$(bindir)/bb1$(EXE)'

uninstall:
	for F in `../util/lsx`; do rm -f '$(bindir)'/"$$F" ; done
	rm -f '$(bindir)/bbr' '$(bindir)/bbx$(EXE)' '$(langdir)/b$(EXE)' '$(langdir)/bb$(EXE)' '$(bindir)/b1$(EXE)' '$(bindir)/bb1$(EXE)'
	rmdir '$(bindir)' '$(langdir)' || true

.PHONY: build boot clean install
