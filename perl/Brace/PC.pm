#package Brace::PC;

# brace_pc
# this provides a per-function "process counter"
# which is used to help implement coroutine processes

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

sub brace_pc {

for my $function (@function) {
	my $pc = 1;
	1 while $function =~ s/\b(b__pc|b__pc_inc|b__pc_next)\b/
		if ($1 eq "b__pc") {
			$pc;
		} elsif ($1 eq "b__pc_inc") {
			++$pc;
			"";
		} else {
			$pc+1;
		}
	/ges;
	1 while $function =~ s/\n\t*\n/\n/g;
}

}

1
