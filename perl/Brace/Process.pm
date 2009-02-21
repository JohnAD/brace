#package Brace::Coro;

# brace_process
# a nice syntax for coroutine processes
# requires the libb coroutine process libraries
# this should be run BEFORE other steps, like brace_header!

# TODO maybe: could eliminiate b__P variable

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

sub brace_process {

my $uses_process = 0;
my @new_funcs;
for my $function (@function) {
	# two options for keyword - I can't decide!
	if ($function =~ s/^(?:proc|coro) (.*)/$1/) {
		my %local;
		$uses_process = 1;
		my ($proc_name, $args, $body) = $function =~ /^([^\s\*\&]+?)\(([^\n]*)\)\n(.*)\z/s;
		next unless $proc_name;
		my @args = split /, */, $args; # this is dodgy wrt brackets
		$args = ", $args" if $args ne "";
		my $struct = <<End;
struct $proc_name
	proc p
End
		$struct .= join "", map {"\t$_\n"} @args;
		my $init = "${proc_name}_init($proc_name *d$args)\n";
		for (@args) {
			my $arg_name = $_;
			$arg_name =~ s/.*[ *&]//;
			$init .= "\td->$arg_name = $arg_name\n";
			$local{$arg_name} = 1;
		}
		$init .= "\tproc_init(&d->p, ${proc_name}_f)";
		# add decls to struct
		# TODO initialisers

		while ($body =~ /^(.*?\n)?(\t*)(state|port) (.*?)([A-Za-z_][A-Za-z_0-9]*?)( *=.*?)?\n(.*)\z/s) {
			my ($start, $indent, $state_port, $decl1, $var_name, $assign, $rest) = ($1, $2, $3, $4, $5, $6, $7);
			$start ||= "";
			if ($state_port eq "port") {
				$decl1 =~ s/ +$//;
				$decl1 = "sh($decl1 *) ";
			}
			if ($assign) {
				$body = "$start$indent$var_name$assign\n$rest";
			} else {
				$body = "$start$rest";
			}
			$struct .= "\t$decl1$var_name\n";
			$local{$var_name} = 1;
		}
		# replace references to local var foo with b__d(foo) in body (data)
		my $tokens = tokenize($body);
		for (@$tokens) {
			if ($local{$_}) { $_ = "b__d($_)"; }
		}
		$body = untokenize($tokens);
		# indent body
		$body =~ s/^/\t/mg;
		chomp($body);
		my $new_func = <<End;
int ${proc_name}_f(proc *b__p)
	$proc_name *b__P = ($proc_name *)b__p
	switch b__p->pc
	b__pc	.
$body
	stop
End
		$function = "";
		push @struct_union_class_template, $struct;
		push @new_funcs, $init, $new_func;
	}
}
push @function, @new_funcs;

if ($uses_process) {
	push @include, "use proc\n";
	# add local channel struct defs... ?
}

remove_deleted();

}

1
