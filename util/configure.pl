#!/usr/bin/perl
use File::Basename;
$mingw = $ENV{WINDIR}||$ENV{windir};
if ($mingw) {
	$sep = '/';
	$msys = $ENV{MSYSTEM};
	$pathsep = $msys ? ':' : ';';
	$c = fix_path("C:");
	$prefix = "$c${sep}Program Files${sep}brace";
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
$realprefix=$prefix;


while (defined ($_=<STDIN>)) {
	s/^(srcdir=).*/$1$pwd/;
	s/^(realprefix=).*/$1$realprefix/;
	s{[\\/]}{$sep}g;
	print;
}

my $path = fix_path($ENV{PATH});
if ($pathsep eq ":") { $path =~ s/;/:/g; }

print "\n";
print <<End;
BRACE_SO=\$(srcdir)${sep}lib
BRACE_LIB=\$(srcdir)${sep}lib
EXE=.exe
End
if ($mingw) {
	print <<End;
LIBB_SONAME=libb.dll
LIBB_PLAIN_SONAME=libb_plain.dll
PERL5LIB:=\$(srcdir)${sep}perl$pathsep\$(srcdir)${sep}cpan
PATH:=\$(srcdir)${sep}exe$pathsep\$(srcdir)${sep}util$pathsep$path
libdir2:=$libdir2
End
	$perl = fix_path(`which perl.exe`);
	$perlroot = dirname(dirname($perl));
	if ($perlroot eq "/") { $perlroot = ""; }
#	$perldir = "\$\(destdir\)$perlroot${sep}site${sep}lib";
	$perldir = "\$\(destdir\)$perlroot${sep}lib${sep}perl5${sep}site_perl";
	print <<End;
perldir:=$perldir
End
} else {
	print <<End;
LIBB_LDFLAGS=
LIBB_CFLAGS=-fpic
LIBB_SONAME=libb.so
LIBB_PLAIN_SONAME=libb_plain.so
PERL5LIB:=\$(srcdir)${sep}perl:\$(srcdir)${sep}cpan
EXE=
PATH:=\$(srcdir)${sep}exe:\$(srcdir)${sep}util:$path
End
	if ($prefix eq "/usr" && -d "/usr/share/perl5") {
		print <<End
perldir:=\$\(prefix\)/share/perl5
End
	}
}

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
