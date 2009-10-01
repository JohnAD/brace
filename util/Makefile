include ../.Make.conf

CFLAGS:=-Wall -I'$(srcdir)/lib' $(CFLAGS)
LDFLAGS:=-L'$(srcdir)/lib' $(LDFLAGS) -s

build: .install$(EXE)

.install$(EXE): install $(BRACE_SO)/$(LIBB_SONAME)
	PATH="$(PATH)" PERL5LIB='$(PERL5LIB)' BRACE_SO='$(BRACE_SO)' BRACE_LIB='$(BRACE_LIB)' BRACE_USE='$(BRACE_USE)' CC='$(CC)' br install .install$(EXE)

clean:
	rm -f .install$(EXE)

.PHONY: build boot clean
