#!/usr/bin/perl
use strict; use warnings;
our ($build, $c, $install, $libdir2, $mingw, $msys, $pathsep, $perl, $perlroot, $prefix, $pwd, $realprefix, $sep);
use File::Basename;
$mingw = $ENV{WINDIR}||$ENV{windir};
if ($mingw) {
	$sep = '/';
	$msys = $ENV{MSYSTEM};
	$pathsep = $msys ? ':' : ';';
	$c = fix_path("C:");
#	$prefix = "$c${sep}Program Files${sep}brace";
	$prefix = "/usr/local";
	$libdir2 = fix_path($mingw);
} else {
	$sep = '/';
	$pathsep = ':';
	$prefix = "/usr/local";
}
for (@ARGV) {
	if (/--prefix=(.*)/) {
		$prefix = fix_path($1);
	}
}
$pwd=fix_path($ENV{PWD});
$build="$pwd/.build";
$realprefix=$prefix;
$install = "install";

if (`which ginstall 2>.configure.tmp` ne "") {
	$install = "ginstall";
}

while (defined ($_=<STDIN>)) {
	s/^(srcdir=).*/$1$build/;
	s/^(realprefix=).*/$1$realprefix/;
	s/^(INSTALL=).*/$1$install/;
	s{[\\/]}{$sep}g;
	next if /^(perldir=)./;
	print;
}

my $path = fix_path($ENV{PATH});
if ($pathsep eq ":") { $path =~ s/;/:/g; }

print "\n";
print <<End;
BRACE_SO=\$(srcdir)${sep}lib
BRACE_LIB=\$(srcdir)${sep}lib
End

unless ($mingw) {
	print <<End;
SO_LDFLAGS=
SO_CFLAGS=-fpic
SONAME=libb.so
PLAIN_SONAME=libb_plain.so
DEBUG_SONAME=libb_debug.so
PLAIN_DEBUG_SONAME=libb_plain_debug.so
PERL5LIB:=\$(srcdir)${sep}perl:\$(srcdir)${sep}cpan
EXE=
PATH:=\$(srcdir)${sep}exe:\$(srcdir)${sep}util:$path
LD_LIBRARY_PATH:=\$(BRACE_SO):\$(LD_LIBRARY_PATH)
End
	if ($prefix eq "/usr" && -d "/usr/share/perl5") {
		print <<End
perldir:=\$\(prefix\)/share/perl5
End
	} elsif ($prefix eq "/usr/local") {
		print <<End
perldir:=\$\(prefix\)/lib/site_perl
End
	}

} else { # if ($mingw)
	print <<End;
SONAME=libb.dll
PLAIN_SONAME=libb_plain.dll
DEBUG_SONAME=libb_debug.dll
PLAIN_DEBUG_SONAME=libb_plain_debug.dll
PERL5LIB:=\$(srcdir)${sep}perl$pathsep\$(srcdir)${sep}cpan
EXE=.exe
PATH:=\$(srcdir)${sep}exe$pathsep\$(srcdir)${sep}util$pathsep$path
libdir2:=$libdir2
End
	$perl = fix_path(`which perl.exe`);
	$perlroot = dirname(dirname($perl));
	if ($perlroot eq "/") { $perlroot = ""; }
	my $perldir;
	for my $guess ("$perlroot/lib/perl5/site_perl", "$perlroot/site/lib") {
		$guess =~ s,/,$sep,g;
		$perldir = $guess;
		my $bork = $perldir; $bork =~ s,^/(.)/,$1:/,;
		last if -d $bork;
	}
	$perldir = "\$\(destdir\)$perldir";
	print <<End;
perldir:=$perldir
End
}

unlink ".configure.tmp";

sub fix_path {
	my ($path) = @_;
	$path =~ s{[/\\]}{$sep}g;
	$path = msys_fix_drive($path);
	return $path;
}

sub msys_fix_drive {
	my ($path) = @_;
	$path =~ s{(^|[;:])([a-z]):}{"$1/".lc($2)}gie if $msys;
	return $path;
}
