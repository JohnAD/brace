#!/usr/bin/make -f

include .Make.conf

BRACE_STANDALONE=

all: !README dotbuild

!README: debian/changelog
	vers=`vers`; <\!README sed "s/([0-9][^)]*)/($$vers)/g" >.README.new
	mv .README.new !README

tgz:
	tgz+ .
	chmod go+r .brace.tgz

dotbuild: cp
	cd .build ; $(MAKE) build
cp:
	mkdir -p .build
	-if cp --help 2>&1 | grep -- '-a' >/dev/null; then opt=-afl; else opt=-pfR; fi; cp $$opt .Make.conf .sh.conf * .build/
	#mkdir -p .build/lib/debug
build:
	cd exe ; $(MAKE) boot
	cd lib ; $(MAKE)
	cd exe ; $(MAKE)
	#cd util ; $(MAKE)
clean:
	cd exe ; $(MAKE) clean
	cd lib ; $(MAKE) clean
	cd eg ; $(MAKE) clean
	cd util ; $(MAKE) clean
	rm -rf .build
install: .build
	#cp .build/lib/$(SONAME) .build/util
	$(INSTALL) -d "$(libdir)" "$(perldir)"
	$(INSTALL) -m 644 lib/bk "$(libdir)"
	cp -pR perl/* "$(perldir)"
	PERL5LIB= perl -MIO::String -e '' 2>/dev/null || cp -pR cpan/IO "$(perldir)"
	cd .build/exe ; $(MAKE) install
	cd .build/lib ; $(MAKE) install

uninstall:
	cd .build/exe ; $(MAKE) uninstall
	cd .build/lib ; $(MAKE) uninstall
	rm -f '$(libdir)'/bk
	for D in `ls perl`; do rm -rf '$(perldir)'/"$$D"; done  # XXX this could trash other Brace::* packages
	rmdir '$(libdir)' '$(includedir)' '$(perldir)' '$(bindir)' '$(langdir)' '$(realprefix)' || true

distclean: clean
	rm .Make.conf .sh.conf

.PHONY: dotbuild build clean install distclean
