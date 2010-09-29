#package Brace::Typedef;

# brace_typedef
# adds typedefs for struct and union

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

sub brace_typedef {

# struct, union, class, template names
my @l = @struct_union_class_template_proto;
for (@l) {
	if (/^(struct|union) (.*)$/) {
		# add a typedef:
		push @struct_union_typedef, "typedef $1 $2 $2\n";
#		$_ = "";
	}
}
#@struct_union_class_template_proto = grep /./, @struct_union_class_template_proto;

}

1
