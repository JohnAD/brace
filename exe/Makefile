include ../.Make.conf

# - for win32; can assume there was nothing needful in PERL5LIB  :)

CFLAGS:=-Wall -I'$(srcdir)/lib' $(CFLAGS)
LDFLAGS:=-L'$(srcdir)/lib' $(LDFLAGS) -s

build: boot bx$(EXE) bbx$(EXE) b1$(EXE) bb1$(EXE)
boot: brace$(EXE) .mk_foo_stamp .mk_bar_stamp .mk_baz_stamp

brace.c: brace.b
	<brace.b PERL5LIB="$(PERL5LIB)" b2b0 | BRACE_LIB="$(BRACE_LIB)" PERL5LIB="$(PERL5LIB)" b02b1 | brace >brace.c
brace$(EXE): brace.o
	echo $(PERL5LIB)
	echo $(BRACE_LIB)
	$(CC) $(LDFLAGS) $(CFLAGS) -o brace brace.o $(LDLIBS)
	@<brace.b PERL5LIB="$(PERL5LIB)" b2b0 | BRACE_LIB="$(BRACE_LIB)" PERL5LIB="$(PERL5LIB)" b02b1 | brace >.brace.test.c
	@../util/vd brace.c .brace.test.c || . ../util/fail "TEST FAILED! brace is broken!"
	@echo "brace works ok"

bx$(EXE): bx.b $(BRACE_SO)/$(LIBB_SONAME)
	PATH="$(PATH)" PERL5LIB='$(PERL5LIB)' BRACE_SO='$(BRACE_SO)' BRACE_LIB='$(BRACE_LIB)' BRACE_USE='$(BRACE_USE)' CC='$(CC)' br bx.b bx
bbx$(EXE): bx$(EXE)
	ln -sf bx$(EXE) bbx$(EXE) || cp bx$(EXE) bbx$(EXE)

b1$(EXE): b1.b $(BRACE_SO)/$(LIBB_SONAME)
	PATH="$(PATH)" PERL5LIB='$(PERL5LIB)' BRACE_SO='$(BRACE_SO)' BRACE_LIB='$(BRACE_LIB)' BRACE_USE='$(BRACE_USE)' CC='$(CC)' br b1.b b1
bb1$(EXE): b1$(EXE)
	ln -sf b1$(EXE) bb1$(EXE) || cp b1$(EXE) bb1$(EXE)

.mk_foo_stamp: brace_foo
	PATH="$(PATH)" PERL5LIB="$(PERL5LIB)" brace_mk_exes brace_foo
	touch .mk_foo_stamp
.mk_bar_stamp: brace_bar
	PATH="$(PATH)" PERL5LIB="$(PERL5LIB)" brace_mk_exes brace_bar
	touch .mk_bar_stamp
.mk_baz_stamp: brace_baz
	PATH="$(PATH)" PERL5LIB="$(PERL5LIB)" brace_mk_exes brace_baz
	touch .mk_baz_stamp

clean:
	< exe_types perl -ne 'chomp; s/\r//g; s/.*\t//; unlink $$_';
	rm -f .mk_foo_stamp .mk_bar_stamp .mk_baz_stamp brace brace.exe bx bx.exe bbx bbx.exe brace.o brace.bh bx.bh .brace.1 .brace.2 .brace.test.c .bx.1 .bx.2 .bx.bak .bx.b1 .bx.c .bx.log .bx.b.xbak b1 b1.exe bb1 bb1.exe .b1.bak .b1.c .b1.b.xbak .b1.b1 .b1.bak2

install: build
	install -d '$(bindir)' "$(langdir)"
	install `../util/lsx .` '$(bindir)'
	ln -sf br '$(bindir)/bbr' || cp '$(bindir)/br' '$(bindir)/bbr'
	ln -sf bx '$(bindir)/bbx' || cp '$(bindir)/bx$(EXE)' '$(bindir)/bbx$(EXE)'
	ln -sf "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/b$(EXE) || cp "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/b$(EXE)
	ln -sf "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/bb$(EXE) || cp "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/bb$(EXE)
	ln -sf b1 '$(bindir)/bb1' || cp '$(bindir)/b1$(EXE)' '$(bindir)/bb1$(EXE)'

uninstall:
	for F in `../util/lsx`; do rm -f '$(bindir)'/"$$F" ; done
	rm -f '$(bindir)/bbr' '$(bindir)/bbx$(EXE)' '$(langdir)/b$(EXE)' '$(langdir)/bb$(EXE)' '$(bindir)/bb1$(EXE)'
	rmdir '$(bindir)' '$(langdir)' || true

.PHONY: build boot clean install
