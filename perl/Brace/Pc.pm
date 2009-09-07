#package Brace::Pc;

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
	if ($function =~ /b__pc/) {  # quick check
		my $tokens = tokenize($function);
		for (@$tokens) {
			if ($_ eq "b__pc") {
				$_ = $pc;
			} elsif ($_ eq "b__pc_next") {
				$_ = $pc + 1;
			} elsif ($_ eq "b__pc_inc") {
				++$pc;
			}
		}
		$function = untokenize($tokens);
		1 while $function =~ s/\n\t*\n/\n/g;
	}
}

}

1
