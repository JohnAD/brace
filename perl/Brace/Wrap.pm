#package Brace::Wrap;

# brace_wrap
# a nice syntax for wrapping library functions (with LD_PRELOAD)
# this should be run BEFORE other steps, like brace_header!

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

sub brace_wrap {

my $uses_wrap = 0;
for my $function (@function) {
	my %checked;
	my $checks = "";
	if ($function =~ s/^wrap (.*)/$1/) {
		$uses_wrap = 1;
		my $unwrapped = $1;
		$unwrapped =~ s/([^\s\*\&]+)\(/(*__brace_unwrapped_$1)(/;
		$unwrapped = "local $unwrapped = NULL\n";
		push @var_assignment, $unwrapped;
	}
	my ($func_name) = $function =~ /([^\s\*\&]+?)\(/;
	$function =~ s/unwrapped/unwrap($func_name)/g;
	while ($function =~ s/unwrap\(([^)]+)\)/__brace_unwrapped_$1/) {
		my $libcall = $1;
		if (not $checked{$libcall}) {
			$checks .= <<END;
	if __brace_unwrapped_$libcall == NULL
		__brace_unwrapped_$libcall = dlsym(RTLD_NEXT, "$libcall")
END
			$checked{$libcall} = 1;
		}
	}
	$function =~ s/\n/\n$checks/;
}

if ($uses_wrap) {
#	push @define, "^define _GNU_SOURCE\n";
	push @include, "use dlfcn.h\n";
}

}

1
