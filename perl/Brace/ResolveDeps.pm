#package Brace::ResolveDeps

use strict; use warnings;

require "brace_parser.pl";
use L;
use Cwd;

our @include;

my $PATH_COLON;
my $PATH_SEP;

if (defined $ENV{WINDIR}) {
	$PATH_COLON = ";";
	$PATH_SEP = "\\";
} else {
	$PATH_COLON = ":";
	$PATH_SEP = "/";
}

if (! exists $ENV{BRACE_LIB}) {
	for my $dir ("/usr/local/include", "/usr/include") {
		if (-e "$dir${PATH_SEP}b.b") {
			$ENV{BRACE_LIB} = $dir; last;
		}
	}
	if (! exists $ENV{BRACE_LIB}) {
		die "\$BRACE_LIB must be defined\n";
	}
}

chomp(my $TARGET = `gcc -dumpmachine`);
chomp(my $VERSION = `gcc -dumpversion`);
(my $MAJORVERSION = $VERSION) =~ s/^(\d+\.\d+)\..*/$1/;
my $INCLUDE_PATH = $ENV{INCLUDE_PATH};
$INCLUDE_PATH = '' unless defined $INCLUDE_PATH;
my @B_INCLUDE_PATH;
my @C_INCLUDE_PATH;

#my @INCLUDE_PATH = ('.', $ENV{BRACE_LIB});

#		@INCLUDE_PATH('.', $ENV{BRACE_LIB}, '/MinGW/include', '/MinGW/include/c++/3.2.3', "/usr/include/c++/$MAJORVERSION", '/usr/local/include', "/usr/lib/gcc-lib/$TARGET/$VERSION/include", "/usr/$TARGET/include", '/usr/include', grep /./, split /$PATH_COLON/, $INCLUDE_PATH);

sub brace_resolve_deps {
	my $to_include = brace_resolve_deps_init_uses();
	for (@include) {
		push @$to_include, @{resolve_include($_)};
	}
	@include = @$to_include;
}

# now "use mingw" for example adds ".../lib/mingw" to the search path,
# this resets the search path to the base for a new file.  uses "BRACE_LIB"
# and "BRACE_USE"

sub brace_resolve_deps_init {
	@B_INCLUDE_PATH = ();
	# we can "use" a directory now which add's it to @B_INCLUDE_PATH..
	# so need a function (this one) to reset that for a new file/module!
	# wow complex :p

	# what to do with BRACE_USE, has the default "use" for all files?
	# give to caller!
	my $files = [];
	$ENV{BRACE_USE} = "" if !defined $ENV{BRACE_USE};
	for my $use (uniqo (split / +/, $ENV{BRACE_USE})) {
		my $files_ = resolve_dep($use);
		push @$files, @$files_
	}
	return $files;
}
sub brace_resolve_deps_init_uses {
	my $headerfiles = brace_resolve_deps_init();

	my $uses = $headerfiles;
	for (@$uses) { $_ = "use $_\n"; }
	return $uses;
}

# may return more than one "use" statement!
# or none, if it was directory/s - which are appended to @B_INCLUDE_PATH
sub resolve_include {
	my ($include) = @_;
	my $includes = [];
	for ($include) {
		/^(\t*)(use|export) (\S+)$/ or die "bad use statement: $_\n";
		my ($indent, $command, $file) = ($1, $2, $3);
		my $files = resolve_dep($file);
		for my $file (@$files) {
			push @$includes, "$indent$command \Q$file\E\n";
		}
	}
	return $includes;
}

sub resolve_dep {
	my $language = $ENV{BRACE_LANGUAGE} || "C";
#	@B_INCLUDE_PATH = ('.');
#	@B_INCLUDE_PATH = ();
	push @B_INCLUDE_PATH, '.';
	@C_INCLUDE_PATH = ('.');
	if ($language eq "C++") {
		push @C_INCLUDE_PATH, ('/MinGW/include/c++/3.2.3', "/usr/include/c++/$MAJORVERSION");
	}
	my $cwd = getcwd();
	push @B_INCLUDE_PATH, grep { $_ ne $cwd } split /$PATH_COLON/, $ENV{BRACE_LIB};
	push @C_INCLUDE_PATH, ('/MinGW/include', '/usr/local/include', "/usr/lib/gcc/$TARGET/$VERSION/include", "/usr/lib/gcc-lib/$TARGET/$VERSION/include", "/usr/$TARGET/include", '/usr/include', grep /./, split /$PATH_COLON/, $INCLUDE_PATH);

	@B_INCLUDE_PATH = uniqo(@B_INCLUDE_PATH);
	@C_INCLUDE_PATH = uniqo(@C_INCLUDE_PATH);

	my ($h) = @_;
	# if it already has a path, don't try to resolve further.
	if ($h =~ m,^["</],) { return [$h]; }

	my @c_names;
	my @b_names;
	my @dir_names;
	my ($name, $suffix) = $h =~ m,^(.*)(\..*)$,;
	# $suffix includes the `.', can be ""
	if (defined $suffix && $suffix =~ /^(bb|cc)h?$/ && $language ne "C++") {
		die "can't include bb/C++ header file `$h' from b/C code";
	}
	if (!defined $suffix) {
		$name = $h;
		push @dir_names, $name;
		if ($language eq "C++") {
#			push @c_names, $name;
			push @b_names, "$name.bbh";
			 # remove? just put C++ / C only libs as foo.b
			 # in a separate dir under BRACE_LIB??
		}
		push @b_names, "$name.bh";
	} else {
		if ($suffix =~ /^(b|bb)h?$/) {
			push @b_names, $h;
		} else {
			push @c_names, $h;
		}
		if ($language eq "C++" && $suffix eq "hh") {
			push @c_names, $name;
			 # a bit bogus ;)  so "use rope.hh" -> #include <rope>
		}
	}

	if (@b_names && @c_names) {
		die "internal error - confused between brace and C headers!!";
	}

	if (@b_names) {
#		warn "b header: @b_names  :  @B_INCLUDE_PATH\n";
		# it's a brace header,
		# include dirs and ALL from B_INCLUDE_PATH in order
		my $matches = [];
		for my $dir (@B_INCLUDE_PATH) {
			for my $name (@b_names) {
				my $path = "$dir$PATH_SEP$name";
				if (-f $path) {
					push @$matches, $path;
				}
				elsif ($path =~ s/\.(b|bb)h$/.$1/ && -f $path) {
					push @$matches, "${path}h";
				}
			}
		}
		my $dir_matches = [];
		for my $dir (@B_INCLUDE_PATH) {
			for my $name (@dir_names) {
				my $path = "$dir$PATH_SEP$name";
				if (-d $path) {
					push @$dir_matches, $path;
				}
			}
		}
		if (@$dir_matches) {
			push @B_INCLUDE_PATH, @$dir_matches;
			# if a dir matches lets try for file/s too
		}
		if (@$matches || @$dir_matches) {
#			warn "matched to brace includes: @$matches\n";
			return $matches;
		}
	} else {
#		warn "c header: @c_names  :  @C_INCLUDE_PATH\n";
		# it's a C header
		# include the first found
		for my $dir (@C_INCLUDE_PATH) {
			for my $name (@c_names) {
				my $path = "$dir$PATH_SEP$name";
				if (-f $path) {
					if ($dir eq ".") {
						return [qq{"$name"}];
					} elsif ($ENV{BRACE_RESOLVE_INCLUDES}) {
						return [qq{"$path"}];
					} else {
						return [qq{<$name>}];
					}
				}
			}
		}
	}

#	warn "could not resolve include file $h\n";
	return [qq{<$h>}];
	 # returns $h for cpp to presumably barf on it.
#	return [];  # if no matches, could just silently drop it?
	 # should it do an error message?
}

1
