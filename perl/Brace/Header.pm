#package Brace::Header;

# brace_header
# generates header files for import for brace files

use strict;
use warnings;

our (	@define,
	@include, @extern_lang, @using_namespace,
	@enum, @struct_union_class_template_proto, @struct_union_typedef,
	@typedef, @struct_union_class_template, @function_proto, @var_proto,
	@local_and_global_var, @var_assignment, @function,
	
	@lines, @local_var, @global_var,
	);

our ($sym, $bracketed, $in_brackets);

sub brace_header {

for (@define) {
	$_ = "" if s/^l//;
}

# TODO use local instead of export?

for (@include) {
	$_ = "" unless /^export /;
}

for (@extern_lang) {
	my $o = "";
	my @lines = split /\n/, $_;
	$o .= shift(@lines) . "\n";
	for (@lines) {
		$o .= "$_\n" if /export /;
	}
	$_ = $o;
	$_ = "" unless /\t/;
}

# keep @using_namespace
# keep @enum

# lose @struct_union_class_template_proto
@struct_union_class_template_proto = ();
# lose @struct_union_typedef
@struct_union_typedef = ();

# keep @typedef

# keep @struct_union_class_template

# function prototypes
for (@function_proto) {
	if (/^(local|static) /) {
		$_ = "";
	}
}

for (@var_proto) {
	if (/^(local|static) /) {
		$_ = "";
	}
}

for (@local_and_global_var) {
	if (!/^(local|static) /) {
		push @var_proto, "extern $_";
	}
	$_ = "";
}

# lose @var_assignment
@var_assignment = ();
# lose @function
@function = ();

remove_deleted();

}

1
