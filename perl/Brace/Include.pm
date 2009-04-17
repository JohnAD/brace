#package Brace::Include;

# brace_include
# this slurps in included brace files recursively

use strict;
use warnings;

use Brace::ResolveDeps;
use Brace::B2b0;

use IO::File;

our (	@define,
	@include, @extern_lang, @using_namespace,
	@enum, @struct_union_class_template_proto, @struct_union_typedef,
	@typedef, @struct_union_class_template, @function_proto, @var_proto,
	@local_and_global_var, @var_assignment, @function,
	
	@lines, @local_var, @global_var,
	);

our ($sym, $bracketed, $in_brackets);

our $cxx_using_c_lib;

my $language;
my $is_cxx;
my $standalone;
#my @include_path;
my (@c_include, %c_include_export);
my %already;

sub brace_include {
my $uses = brace_resolve_deps_init_uses();
@include = (@$uses, @include);

$language = $ENV{BRACE_LANGUAGE} || "C";

$is_cxx = $language =~ /^c\+\+$/i;
if (!$is_cxx && $language !~ /^c$/i) {
	die "unknown target language: $language\n";
}

# Set $BRACE_STANDALONE to include the source code of the libraries instead of
# just the headers.
$standalone = $ENV{BRACE_STANDALONE} || 0;

(@c_include, %c_include_export) = ();

%already = ();

do_includes();

for (@c_include) {
	if ($c_include_export{$_}) {
		push @include, "export $_\n";
	} else {
		push @include, "use $_\n";
	}
}

}

sub do_includes {
	my $save = parse_save();
	parse_clear();
	while (@{$save->{include}}) {
		my $include = shift @{$save->{include}};
		my $includes = resolve_include($include);
		for $include (@$includes) {
			my ($command, $file) = $include =~ /^(use|export) ((\\.|\S)+)$/;
			$file =~ s/\\(.)/$1/g;
			if (!$already{$file}) {
				$already{$file} = 1;
				if ($file =~ /\.(b|bb)h?$/) {
					if ($standalone) {
						$file =~ s/\.(b|bb)h$/.$1/;
					}
					include_file($file);
				} else {
					push @c_include, $file;
					if ($include =~ /^export /) {
						$c_include_export{$file} = 1;
					}
				}
			}
		}
	}
#	use Data::Dumper;
#	print Dumper \@struct_union_class_template;
#	print Dumper $save->{struct_union_class_template};
	parse_append_saved($save);
#	print Dumper \@struct_union_class_template;
#	print "----------------------\n";
}

sub include_file {
 # this is getting really inefficient!
	my ($file) = @_;
	my $save;
	$save = parse_save();
	parse_clear();
	my $ok = 0;
	if (-r $file) {
		$cxx_using_c_lib = $is_cxx && $file =~ /\.bh$/;
		if ($file =~ /\.(b|bb)$/) {
			read_lines($file);
			b2b0();
		} else {
			parse_more($file);
		}
		$cxx_using_c_lib = 0;
		do_includes();
		$ok = 1;
	}
	if (!$ok) {
		die "could not find include file: $file\n";
	}
	parse_prepend_saved($save);
}

1
