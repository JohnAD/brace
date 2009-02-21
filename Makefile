include Make.conf

build:
	if [ -n "$(BRACE_STANDALONE)" ]; then echo; echo >&2 please unset BRACE_STANDALONE; echo; exit 1; fi
	cd exe ; $(MAKE) boot
	cd lib ; $(MAKE)
	cd exe ; $(MAKE)
clean:
	cd exe ; $(MAKE) clean
	cd lib ; $(MAKE) clean
	cd eg ; $(MAKE) clean
install: build
	cd exe ; $(MAKE) install
	cd lib ; $(MAKE) install
	install -d "$(libdir)" "$(perldir)"
	install -m 644 lib/mk "$(libdir)"/mk
	ln -sf "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/b$(EXE) || cp "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/b$(EXE)
	ln -sf "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/bb$(EXE) || cp "$(realprefix)"/bin/bx$(EXE) "$(langdir)"/bb$(EXE)
	cp -pR perl/* "$(perldir)"
	perl -MIO::String -e '' 2>/dev/null || cp -pR cpan/IO "$(perldir)"

uninstall:
	cd exe ; $(MAKE) uninstall
	cd lib ; $(MAKE) uninstall
	rm -f '$(libdir)'/mk
	for D in `ls perl`; do rm -rf '$(perldir)'/"$$D"; done
	rmdir '$(libdir)' '$(includedir)' '$(perldir)' '$(bindir)' '$(langdir)' '$(realprefix)' || true

distclean: clean
	rm Make.conf
#Make.conf: Make.conf.in
#	./configure
#	# to keep the "clean/distclean" targets working after a distclean

.PHONY: build clean install distclean
