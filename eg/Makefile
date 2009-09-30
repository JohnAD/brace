# just for cleaning at the moment!

include ../.Make.conf

PATH:=$(srcdir)/exe:$(srcdir)/util:$(PATH)

build:
	@echo examples are not built yet
clean:
	PATH="$(PATH)" PERL5LIB="$(PERL5LIB)" bk-clean
#	find . -type f \( -perm -u+x -o -perm -g+x -o -perm -o+x \) | xargs file | grep ELF | sed 's/:.*//' | xargs rm -f
