#package Brace::Proto;

# brace_proto
# this inserts prototypes

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

sub brace_proto {

# struct, union, class, template names
for (@struct_union_class_template) {
	my $proto = $_;
	$proto =~ s/\n.*/\n/s;
	$proto =~ s/\s*:.*//;
	push @struct_union_class_template_proto, $proto;
}

# function prototypes
for (@function) {
	my $proto = $_;
	$proto =~ s/\n.*/\n/s;
	push @function_proto, $proto unless $proto =~ /^[^(]*::[\S]+\(/;  # C++ member funcs are prototyped in their class, not elsewhere
}

for (@var_assignment) {
	my $proto = $_;
	$proto =~ s/\s*=.*/\n/s;
	if ($proto !~ /^(static|local) /) {
		$proto = "extern $proto";
	}
	push @var_proto, $proto;
}

# hopefully that's everything!

}

1
