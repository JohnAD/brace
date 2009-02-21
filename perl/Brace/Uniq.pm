#package Brace::Uniq;

# brace_uniq
# this eliminates exact duplicate forms from the code

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

our @list_names;

sub brace_uniq {

no strict 'refs';
for (grep { $_ ne "lines" } @list_names) {
	my %already;
	@$_ = grep {
		if ($already{$_}) { 0 }
		else { $already{$_} = 1; 1 }
	} @$_;
}

# TODO always do this in output_all() ?

}

1
