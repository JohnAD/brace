include ../.Make.conf

CFLAGS=$(EXE_CFLAGS)
LDFLAGS=$(EXE_LDFLAGS)
LDLIBS=$(EXE_LDLIBS)

build: .install$(EXE)

.install$(EXE): install $(BRACE_SO)/$(LIBB_SONAME)
	br install .install$(EXE)

clean:
	rm -f .install$(EXE)

.PHONY: build boot clean
