include .Make.conf

export BRACE_STANDALONE=

all: tgz

tgz: dotbuild
	tgz `readlink -f .`

dotbuild:
	mkdir -p .build
	cp -alf .Make.conf * .build/
	cd .build ; $(MAKE) build
build:
	cd exe ; $(MAKE) boot
	cd lib ; $(MAKE)
	cd exe ; $(MAKE)
clean:
	rm -rf .build
	cd exe ; $(MAKE) clean
	cd lib ; $(MAKE) clean
	cd eg ; $(MAKE) clean
install: .build
	cd .build/exe ; $(MAKE) install
	cd .build/lib ; $(MAKE) install
	install -d "$(libdir)" "$(perldir)"
	install -m 644 lib/mk "$(libdir)"/mk
	ln -sf "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/b$(EXE) || cp "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/b$(EXE)
	ln -sf "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/bb$(EXE) || cp "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/bb$(EXE)
	cp -pR perl/* "$(perldir)"
	perl -MIO::String -e '' 2>/dev/null || cp -pR cpan/IO "$(perldir)"

uninstall:
	cd .build/exe ; $(MAKE) uninstall
	cd .build/lib ; $(MAKE) uninstall
	rm -f '$(libdir)'/mk
	for D in `ls perl`; do rm -rf '$(perldir)'/"$$D"; done  # XXX this could trash other Brace::* packages
	rmdir '$(libdir)' '$(includedir)' '$(perldir)' '$(bindir)' '$(langdir)' '$(realprefix)' || true

distclean: clean
	rm .Make.conf

.PHONY: dotbuild build clean install distclean
