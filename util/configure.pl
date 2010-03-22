#!/usr/bin/perl
use strict; use warnings;
our ($version, $vers, $major, $minor, $build, $c, $install, $libdir2, $mingw, $msys, $pathsep, $perl, $perlroot, $prefix, $pwd, $realprefix, $sep);
use File::Basename;
use Cwd;
$version = $ARGV[0];
($major, $minor) = $version =~ /^(\d+)\.(\d+\.\d+)/;
defined $minor or die "invalid version number: $version, should be like 1.2.3[suffix] - is debian/changelog intact?\n";
$vers = "$major.$minor";
$mingw = $ENV{WINDIR}||$ENV{windir};
if ($mingw) {
	$sep = '/';
	$msys = $ENV{MSYSTEM};
	$pathsep = $msys ? ':' : ';';
	$c = fix_path("C:");
#	$prefix = "$c${sep}Program Files${sep}brace";
	$libdir2 = fix_path($mingw);
} else {
	$sep = '/';
	$pathsep = ':';
}
$prefix = "/usr/local";
for (@ARGV) {
	if (/--prefix=(.*)/) {
		$prefix = fix_path($1);
	}
}
$pwd=fix_path(getcwd());
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
	s/^(VERSION=).*/$1$version/;
	s/^(VERS=).*/$1$vers/;
	s/^(MAJOR=).*/$1$major/;
	s/^(MINOR=).*/$1$minor/;
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
SO_CFLAGS=-fPIC
SONAME=libb.so
PLAIN_SONAME=libb_plain.so
DEBUG_SONAME=libb_debug.so
PLAIN_DEBUG_SONAME=libb_plain_debug.so
PERL5LIB:=\$(srcdir)${sep}perl:\$(srcdir)${sep}cpan
EXE=
PATH:=\$(srcdir)${sep}exe:\$(srcdir)${sep}util:$path
LD_LIBRARY_PATH:=\$(BRACE_SO):\$(LD_LIBRARY_PATH)
End
	my $perldir;
	if ($prefix !~ m{^/usr(/.*)?$}) {
		$perldir = '$(destdir)$(prefix)/perl';   # XXX ok on mingw?
	} elsif ($prefix eq "/usr" && -d "/usr/share/perl5") {
		$perldir = '$(destdir)$(prefix)/share/perl5';
	} elsif ($prefix eq "/usr/local" && -d "/usr/local/lib/site_perl") {
		$perldir = '$(destdir)$(prefix)/lib/site_perl';
	} elsif (-e "/usr/lib/perl5/site_perl" && $prefix =~ m{^/usr(/.*)?$}) {
		$perldir = '$(destdir)/usr/lib/perl5/site_perl';
	} else {
		my $best = "/usr/local/lib/perl5/site_perl";
		my $bestscore = -1;
		my $bestlen = 0;
		for (@INC) {
			my $len = length($_);
			my $score = /\b(local|pkg)\b/+/vendor/+(/site/ / 2);
			# TODO bonus if it's under $prefix!! or exclude if not?
			if ($score > $bestscore || ($score == $bestscore && $len < $bestlen)) {
				$best = $_; $bestscore = $score; $bestlen = $len
			}
		}
#		$perldir = $best;    # XXX was this
		$perldir = '$(destdir)'.$best;  # XXX changed to this, ok?
	}
	$perldir =~ s{^(\Q$prefix\E|/usr/local|/usr/pkg|/usr)/}{$prefix/};
	print <<End
perldir:=$perldir
End

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
	my $perldir = "$perlroot/lib/perl5/site_perl";
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
