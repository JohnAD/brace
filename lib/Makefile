include ../.Make.conf

LIBB_BUILD:=1

ifdef NPROCESSORS
MAKE:=make -j$(NPROCESSORS)
else
MAKE:=make
endif

CFLAGS=$(SO_CFLAGS)
LDFLAGS=$(SO_LDFLAGS)
LDLIBS=$(SO_LDLIBS)
BK_HEADERS=1
DEBUG=1

build: mingw/keysym.b
#	bk
	../util/build-libb.sh
	cp $(SONAME) $(PLAIN_SONAME)
	cp $(SONAME) $(DEBUG_SONAME)
	cp $(SONAME) $(PLAIN_DEBUG_SONAME)

clean:
	bk-clean
	rm -f `find . -name '*.so.*' -or -name '*.so' -or -name '*.dll' -or -name '*.bh' -or -name '*.bbh' -or -name '*.b1' -or -name '*.c' -or -name '*.o' -or -name '*.a'`
	echo done

#		 \( -name '*.b' -or -name '*.bb' -or -name '*.bh' -or -name '*.bbh' -or -name '*.h' -or -name '*.c' -or -name '*.cc' \) | while read F; do \

install:
	$(INSTALL) -d '$(libdir)'
	find . -path '*/.*' -prune -or -type d -print | while read D; do \
		$(INSTALL) -d '$(includedir)'/"$$D"; \
		$(INSTALL) -v -m 644 "$$D"/*.bh '$(includedir)'/"$$D"; \
	done
#	$(INSTALL) -m 644 *.b *.bb *.bh *.bbh $(includedir)
	$(INSTALL) -m 644 $(SONAME) '$(libdir)'
	$(INSTALL) -m 644 $(PLAIN_SONAME) '$(libdir)'
	$(INSTALL) -m 644 $(DEBUG_SONAME) '$(libdir)'
	$(INSTALL) -m 644 $(PLAIN_DEBUG_SONAME) '$(libdir)'
#	$(INSTALL) -m 644 libb.a '$(libdir)'
#	$(INSTALL) -m 644 libb_plain.a '$(libdir)'
#	$(INSTALL) -m 644 libb_plain_debug.a '$(libdir)'
#	$(INSTALL) -m 644 libb_debug.a '$(libdir)'
	if [ -n '$(libdir2)' ]; then cp $(SONAME) '$(libdir2)'; fi
	if [ -n '$(libdir2)' ]; then cp $(PLAIN_SONAME) '$(libdir2)'; fi
	if [ -n '$(libdir2)' ]; then cp $(DEBUG_SONAME) '$(libdir2)'; fi
	if [ -n '$(libdir2)' ]; then cp $(PLAIN_DEBUG_SONAME) '$(libdir2)'; fi
#	$(INSTALL) -m 644 libb.so.$(VERSION) '$(libdir)'
##	$(INSTALL) -m 644 libbb.so.$(VERSION) '$(libdir)'
#	ln -sf libb.so.$(VERSION) '$(libdir)'/libb.so.$(MAJOR)
##	ln -sf libbb.so.$(VERSION) '$(libdir)'/libbb.so.$(MAJOR)
#	ln -sf libb.so.$(MAJOR) '$(libdir)'/libb.so
#	ln -sf $(SONAME) '$(libdir)'/$(SONAME)
#	ln -sf libbb.so.$(MAJOR) '$(libdir)'/libbb.so
	@if [ -z "$$WINDIR" ]; then echo you might need to run ldconfig; fi

uninstall:
	find . -depth -path '*/.*' -prune -or -type d -print >.tmp.1 ; \
	<.tmp.1 sed 's,\\,/,g' >.tmp.2 ; \
	while read D; do \
		find "$$D" -maxdepth 1 -type f \( -name '*.b' -or -name '*.bb' -or -name '*.bh' -or -name '*.bbh' -or -name '*.h' \) >.tmp.3 ; \
		<.tmp.3 sed 's,\\,/,g; s/\.[^.]*$$//' >.tmp.4 ; \
		while read F; do \
			rm -v -f '$(includedir)'/"$$F".{c,b,bh}; \
		done <.tmp.4 ; \
		rmdir -v '$(includedir)'/"$$D" || true; \
	done <.tmp.2
	rm .tmp.1 .tmp.2 .tmp.3 .tmp.4
	rm -v -f '$(includedir)/b.h'
	rm -v -f '$(includedir)/b_plain.h'
	rm -v -f '$(libdir)/$(SONAME)'
	rm -v -f '$(libdir)/$(PLAIN_SONAME)'
	rm -v -f '$(libdir)/$(DEBUG_SONAME)'
	rm -v -f '$(libdir)/$(PLAIN_DEBUG_SONAME)'
	rm -v -f '$(libdir)/libb.a'
	rm -v -f '$(libdir)/libb_plain.a'
	rm -v -f '$(libdir)/libb_debug.a'
	rm -v -f '$(libdir)/libb_plain_debug.a'
	if [ -n '$(libdir2)' ]; then rm -v -f '$(libdir2)/$(SONAME)'; fi
	if [ -n '$(libdir2)' ]; then rm -v -f '$(libdir2)/$(PLAIN_SONAME)'; fi
	if [ -n '$(libdir2)' ]; then rm -v -f '$(libdir2)/$(DEBUG_SONAME)'; fi
	if [ -n '$(libdir2)' ]; then rm -v -f '$(libdir2)/$(PLAIN_DEBUG_SONAME)'; fi
	
	rmdir -v '$(libdir)' || true

mingw/keysym.b: mingw/keysymdef.h ../util/make_mingw_keysym
	../util/make_mingw_keysym

.PHONY: build clean install
