#package Brace::Coro;

# brace_process
# a nice syntax for coroutine processes
# requires the libb coroutine process libraries
# this should be run BEFORE other steps, like brace_header!

# TODO maybe: could eliminiate This variable

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

#my $uses_process = 0;
my @new_funcs;
for my $function (@function) {
	# two options for keyword - I can't decide!
	if ($function =~ s/^(?:proc|coro) (.*)/$1/) {
		my %port_type;
		my %state_type;
#		$uses_process = 1;
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
			$arg_name =~ s/(.*[ *&])//;
			$state_type{$arg_name} = $1;
			$init .= "\td->$arg_name = $arg_name\n";
			$state_type{$arg_name} = 1;
		}
		$init .= "\tproc_init(&d->p, ${proc_name}_f)";
		# add decls to struct
		# TODO initialisers

#		while ($body =~ /^(.*?\n)??(\t*)(for )?(state|port) (.*?)([A-Za-z_][A-Za-z_0-9]*?)( *=.*?)?\n(.*)\z/s) {
		while ($body =~ /^(.*?)(\t+)(for )?(state|port) (.*?)([A-Za-z_][A-Za-z_0-9]*?)( *=.*?)?\n(.*)\z/s) {
			my ($start, $indent, $for, $state_port, $decl1, $var_name, $assign, $rest) = ($1, $2, $3, $4, $5, $6, $7, $8);
			$start ||= "";
			$for ||= "";
			if ($state_port eq "port") {
				$decl1 =~ s/ +$//;
				$port_type{$var_name} = $decl1;
				$decl1 = "shuttle_$decl1 *";
			} else {
				($state_type{$var_name} = $decl1) =~ s/ +$//;
			}
			if ($assign || $for) {
				$body = "$start$indent$for$var_name$assign\n$rest";
			} else {
				$body = "$start$rest";
			}
			# get rid of any typeof(...) in the struct!
			$decl1 =~ s{^typeof\(\&(\w+)->d\)}{($port_type{$1}||die "unknown port $1")." *"}e;
			$decl1 =~ s{^typeof\((\w+)\)}{$state_type{$1}||$port_type{$1}||die "unknown state $1"}e;
			$decl1 =~ s{^typeof\(&(\w+)\)}{($state_type{$1}||$port_type{$1}||die "unknown state $1")." *"}e;
			if ($decl1 =~ /typeof\(/) { die "a typeof remains in a state/port variable declaration which needs to go in a struct:\n $_"; }
			$struct .= "\t$decl1$var_name\n";
		}
		# replace references to state var foo with This->foo in body (data)
		# replace references to port var foo with This->foo->d
		my $tokens = tokenize($body);
		my $prev;
		for (@$tokens) {
			# never convert foo->bar to foo->(This->bar) or same for foo.bar
			# with sh(a, out, b, in), the macro will exapand it first to something with a->out and b->in before this can mangle it.
			if ($state_type{$_} && (!$prev || $prev ne "." && $prev ne "->")) { $_ = "(This->$_)"; }
			elsif ($port_type{$_} && (!$prev || $prev ne "." && $prev ne "->")) { $_ = "(This->$_->d)"; }
			$prev = $_;
		}
		$body = untokenize($tokens);
		# indent body
		$body =~ s/^(\S*\t)/$1\t/mg;
		chomp($body);
		my $new_func = <<End;
int ${proc_name}_f(proc *b__p)
	$proc_name *This = ($proc_name *)b__p
	switch b__p->pc
	b__pc	.
$body
	return 0
End
	# "stop" -> "return 0"
	# but we can't use macros here
		$function = "";
		push @struct_union_class_template, $struct;
		push @new_funcs, $init, $new_func;
	} else {
		# In normal functions, remove any "state" prefix from variable declarations.
		# This is so macros can use "state" declarations and work in coros or functions.

		my ($ret, $proc_name, $args, $body) = $function =~ /^(.*?)([^\s\*\&]+?)\(([^\n]*)\)\n(.*)\z/s;
		next unless $proc_name;

		while ($body =~ /^(.*?\n)?(\t*)(for )?(state) (.*?)([A-Za-z_][A-Za-z_0-9]*?)( *=.*?)?\n(.*)\z/s) {
			my ($start, $indent, $for, $state_port, $decl1, $var_name, $assign, $rest) = ($1, $2, $3, $4, $5, $6, $7, $8);
			$start ||= "";
			$assign ||= "";
			$for ||= "";
			$body = "$start$indent$for$decl1$var_name$assign\n$rest";
		}
		chomp($body);
		my $new_func = <<End;
$ret$proc_name($args)
$body
End
		$function = "";
		push @new_funcs, $new_func;
	}
}
push @function, @new_funcs;

# This "auto include proc" is disabled, because "Brace::Process" now runs after "Brace::Include"
# Now you need to "use proc" manually.

#if ($uses_process) {
#	push @include, "use proc\n";
#	# add local channel struct defs... ?
#}

remove_deleted();

}

1
