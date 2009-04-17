include ../.Make.conf

LIBB_BUILD:=1

ifdef NPROCESSORS
MAKE:=make -j$(NPROCESSORS)
else
MAKE:=make
endif

build:
	PATH="$(PATH)" PERL5LIB="$(PERL5LIB)" BRACE_LIB="$(BRACE_LIB)" BRACE_USE="$(BRACE_USE)" LIBB_BUILD="$(LIBB_BUILD)" CFLAGS="$(LIBB_CFLAGS)" LDFLAGS="$(LIBB_LDFLAGS)" LDLIBS="$(LIBB_LDLIBS)" SONAME="$(LIBB_SONAME)" PLAIN_SONAME="$(LIBB_PLAIN_SONAME)" DEBUG_SONAME="$(LIBB_DEBUG_SONAME)" PLAIN_DEBUG_SONAME="$(LIBB_PLAIN_DEBUG_SONAME)" MK_HEADERS=1 DEBUG=1 MAKE="$(MAKE)" mk

clean:
	PATH="$(PATH)" PERL5LIB="$(PERL5LIB)" mk-clean
	rm -f `find . -name '*.so.*' -or -name '*.so' -or -name '*.dll' -or -name '*.bh' -or -name '*.bbh' -or -name '*.b1' -or -name '*.c' -or -name '*.h' -or -name '*.o' -or -name '*.a'`
	echo done

install:
	install -d '$(libdir)'
	for D in `find . -path '*/.*' -prune -or -type d -print`; do \
		install -d '$(includedir)'/"$$D"; \
		needargs 4 install -m 644 `find "$$D" -maxdepth 1 -type f \
		 \( -name '*.b' -or -name '*.bb' -or -name '*.bh' -or -name '*.bbh' -or -name '*.h' -or -name '*.c' -or -name '*.cc' \)` '$(includedir)'/"$$D"; \
	done
#	install -m 644 *.b *.bb *.bh *.bbh $(includedir)
	install -m 644 $(LIBB_SONAME) '$(libdir)'
	install -m 644 $(LIBB_PLAIN_SONAME) '$(libdir)'
	install -m 644 libb.a '$(libdir)'
	install -m 644 libb_plain.a '$(libdir)'
	install -m 644 $(LIBB_DEBUG_SONAME) '$(libdir)'
	install -m 644 $(LIBB_PLAIN_DEBUG_SONAME) '$(libdir)'
	install -m 644 libb_plain_debug.a '$(libdir)'
	install -m 644 libb_debug.a '$(libdir)'
	if [ -n '$(libdir2)' ]; then install -m 644 $(LIBB_SONAME) '$(libdir2)'; fi
	if [ -n '$(libdir2)' ]; then install -m 644 $(LIBB_PLAIN_SONAME) '$(libdir2)'; fi
	if [ -n '$(libdir2)' ]; then install -m 644 $(LIBB_DEBUG_SONAME) '$(libdir2)'; fi
	if [ -n '$(libdir2)' ]; then install -m 644 $(LIBB_PLAIN_DEBUG_SONAME) '$(libdir2)'; fi
#	install -m 644 libb.so.$(VERSION) '$(libdir)'
##	install -m 644 libbb.so.$(VERSION) '$(libdir)'
#	ln -sf libb.so.$(VERSION) '$(libdir)'/libb.so.$(MAJOR)
##	ln -sf libbb.so.$(VERSION) '$(libdir)'/libbb.so.$(MAJOR)
#	ln -sf libb.so.$(MAJOR) '$(libdir)'/libb.so
#	ln -sf $(LIBB_SONAME) '$(libdir)'/$(LIBB_SONAME)
#	ln -sf libbb.so.$(MAJOR) '$(libdir)'/libbb.so
	@echo you might need to run ldconfig

uninstall:
	find . -depth -path '*/.*' -prune -or -type d -print >.tmp.1 ; \
	<.tmp.1 sed 's,\\,/,g' >.tmp.2 ; \
	while read D; do \
		find "$$D" -maxdepth 1 -type f \( -name '*.b' -or -name '*.bb' -or -name '*.bh' -or -name '*.bbh' -or -name '*.h' \) >.tmp.3 ; \
		<.tmp.3 sed 's,\\,/,g' >.tmp.4 ; \
		while read F; do \
			rm -v -f '$(includedir)'/"$$F"*; \
		done <.tmp.4 ; \
		rmdir -v '$(includedir)'/"$$D" || true; \
	done <.tmp.2
	rm .tmp.1 .tmp.2 .tmp.3 .tmp.4
	rm -v -f '$(libdir)/$(LIBB_SONAME)'
	rm -v -f '$(libdir)/$(LIBB_PLAIN_SONAME)'
	rm -v -f '$(libdir)/libb.a'
	rm -v -f '$(libdir)/libb_plain.a'
	rm -v -f '$(libdir)/$(LIBB_DEBUG_SONAME)'
	rm -v -f '$(libdir)/$(LIBB_PLAIN_DEBUG_SONAME)'
	rm -v -f '$(libdir)/libb_debug.a'
	rm -v -f '$(libdir)/libb_plain_debug.a'
	if [ -n '$(libdir2)' ]; then rm -v -f '$(libdir2)/$(LIBB_SONAME)'; fi
	if [ -n '$(libdir2)' ]; then rm -v -f '$(libdir2)/$(LIBB_PLAIN_SONAME)'; fi
	if [ -n '$(libdir2)' ]; then rm -v -f '$(libdir2)/$(LIBB_DEBUG_SONAME)'; fi
	if [ -n '$(libdir2)' ]; then rm -v -f '$(libdir2)/$(LIBB_PLAIN_DEBUG_SONAME)'; fi
	
	rmdir -v '$(libdir)' || true

.PHONY: build clean install
