#package Brace::Expand;

# brace_expand
# this does macro substitutions

# This should not be run in the header pipeline, headers should contain macro
# definitions and be processed after inclusion in another program.

# brace_expand should be run _after_ including headers; this means that macros in the
# source file can affect the interpretation of headers if those headers contain
# calls to that macro.

# brace_expand should also be run _after_ joining continued lines together.

# A macro will never affect the definition of another macro.

# macro arguments may contain calls to other macros
# macro definitions may contain calls to other macros

# TODO avoid macro recursion, so it stops expanding when (mutual)recursion is detected

use strict;
use warnings;

$ENV{BRACE__MACRO_DEBUG} ||= 0;

use Brace::Macrospace;

our (	@define,
	@include, @extern_lang, @using_namespace,
	@enum, @struct_union_class_template_proto, @struct_union_typedef,
	@typedef, @struct_union_class_template, @function_proto, @var_proto,
	@local_and_global_var, @var_assignment, @function,
	
	@lines, @local_var, @global_var,
	);

our ($sym, $bracketed, $in_brackets);

use Brace::Builtins;
our $builtins;

my $private_count;

sub new_private_prefix {
	my $private_prefix = "my__${private_count}_";
	++$private_count;
	return $private_prefix;
}

my $global;

sub brace_expand {

$global = Brace::Macrospace->new(parent=>$builtins);

$private_count = 0;
my $private_prefix = new_private_prefix();
$global->set(['my__prefix', ""], [undef, [$private_prefix], 'expr']);

 # should we keep incing this across calls to brace_expand?  no
 # hash with something else?

# a hash of macros, structured like this:
#   $global{$name}{$n_args} = [\@args, tokenize($_)];
# and also
#   $global{$name}{""} = [undef, tokenize($_)];

for (@define) {
	/^\^/ && next;
	chomp;
	s/^l?(def|Def|DEF)\s+(.+?)(?:\((.*?)\))?( +|\n)// or
		die "invalid macro definition syntax: $_\n";
	my ($def, $name, $args, $initial_space) = ($1, $2, $3, $4);
	my $type = "";
	if ($def eq "Def") { $type = "raw"; }
	elsif ($def eq "DEF") { $type = "rawraw"; }
	my $n_args;
	my $arg_ary;
	if (defined $args) {
		$arg_ary = [split /,\s*/, $args, -1];
		$args = "($args)";
		$n_args = 0+@$arg_ary;
	} else {
		$args = "";
		$n_args = "";
		$arg_ary = undef;
	}
	if ($initial_space eq "\n") {
		$type .= "block";
	} else {
		$type .= "expr";
	}
	if ($type =~ /block/) {
		$_ .= "\n";
	} else {
		/\n/ and die "the block-macro macro $name$args has text on the line with the def keyword\n";
	}
	# TODO use let later when we do macros in order...
	$global->set([$name, $n_args], [$arg_ary, tokenize($_), $type]);
	$_ = "";
}
remove_deleted();


# TODO check out the m4 macro language, and try to make brace_expand as
# powerful

# NOTE XXX brace macro does not currently apply macros to ALL parts of the source, only the following:

for my $text (
	@struct_union_class_template, @enum, @typedef, @function,
	@var_assignment, @local_and_global_var,
	@struct_union_class_template_proto, @struct_union_typedef,
	@function_proto, @var_proto
	) {
	$text = expand_macros_text($text, $global);
}

# XXX this is inefficient:
reparse();

}

sub expand_macros_text {
	my ($text, $namespace) = @_;
	return untokenize(expand_macros_tokenized(tokenize($text), $namespace));
}

# XXX how to deal with passing a macro-name as a macro parameter,
# will the named macro then be evaluated?  yes?
# what about passing a function name as a macro parameter,
# and invoking the function in the macro.
#
# If we make each macro parameter effectively a new macro having the scope of
# the evaluation, 

# NOTE expand_macros_tokenized eats its input array

sub expand_macros_tokenized {
	my ($tokens, $namespace) = @_;
	my $result;
	my $indent = 0;
	my $paste = 0;
	debug_print_a_line($tokens);
	while (@$tokens) {
		my $token = shift @$tokens;
		# indent
		if ($token eq "\n") {
			$indent = 0;
			debug_print_a_line($tokens);
		} elsif ($token =~ /^\t+$/) {
			#$indent = length($token);
			$indent += length($token);
		}
		my $macro;
		if ($token =~ /^[a-z_\$]/i) {
			my $name = $token;
			# are there any macros with this name?
			debug("$name: lookup up macro name", 1);
			if ($namespace->lookup_vague($name)) {
				debug("$name: found (vague)", 1);
				# look for a macro without args first
				$macro = $namespace->lookup([$name, ""]);
				if (defined $macro) {
					debug("$name: found macro without args", 1);
					apply_macro($name, $macro, undef, $namespace, $tokens, $indent, $result);
				} else {
					# get the arguments
					my ($all_args_raw, $n_args, $args) = get_macro_args($tokens, $name, $namespace);
					debug("$name: found $n_args possible args", 2);
					if ($n_args ne "") {
						# look for a macro having the correct number of args
						$macro = $namespace->lookup([$name, $n_args]);
						if (defined $macro) {
							debug("$name: found macro with args", 2);
							apply_macro($name, $macro, $args, $namespace, $tokens, $indent, $result);
						} else {
							# put the supposed arguments back!
							debug("$name: putting args back: @$all_args_raw");
							unshift @$tokens, "(", @$all_args_raw, ")";
							undef $args;
						}
					}
				}
			}
		} elsif ($token eq "^^") {
			# paste tokens!
			$paste = 1;
			$macro = 1;
		}
		if (defined $macro) {
			debug_print_a_line($tokens);
		} else {
			if ($paste) {
				$paste = 0;
				if (@$result == 0) {
					die "missing left arg to the token pasting operator ^^\n";
				}
				my $prepend = pop(@$result);
				if ($prepend =~ /"$/ && $token =~ /^"/) { $prepend =~ s/"$//; $token =~ s/^"//; }
				$token = $prepend.$token;
				unshift @$tokens, $token;
				debug("pasting: made >>>$token<<<");
				debug_print_a_line($tokens);
			} else {
				push @$result, $token;
			}
		}
	}
	if ($paste == 1) { die "missing right arg to the token pasting operator ^^\n"; }
	return $result;
}

sub apply_macro {
	my ($name, $macro, $args, $namespace, $tokens, $indent, $result) = @_;
	if (defined $macro) {
		my ($formal_args, $template, $type) = @$macro;
		my $expansion = expand_macro($name, $macro, $args, $namespace);
		my $initial_indent = initial_indent($expansion);
		if ($initial_indent) {
			my $final_indent = final_indent($expansion);
			# it's a block expansion;
			# fix the indentation
			$expansion = adjust_indent($expansion, $indent-$initial_indent);
			if ($expansion->[0] =~ /^\t+$/) {
				# kill the indent for the first line;
				# we have already passed it
				shift @$expansion;
			}
			# kill the last line if it has just a single dot...
			if (kill_last_line_if_just_dot_and_not_only_line($expansion)) {
#				adjust_indent($expansion, $final_indent-$initial_indent);
			}
			# if multiple block macro calls on a line with ';' delimiting
			# we want to kill the ';', similarly we want to skip a newline.
			kill_break($tokens, $indent);
		}
		if ($type =~ /expr/ && $type !~ /raw/ and
			((first_token($tokens) eq ")" and last_token($result) eq "(") or
			@$expansion == 3)) {
			# yay!
			strip_enclosing_parens($expansion);
		}
		#push @$result, @$expansion;
		unshift @$tokens, @$expansion;
	}
}

sub kill_break {
	my ($tokens, $indent) = @_;
	if (@$tokens && $tokens->[0] =~ /^ +$/) {
		shift @$tokens;
	}
	if (@$tokens && $tokens->[0] =~ /^\n$/) {
		shift @$tokens;
	} elsif (@$tokens && $tokens->[0] =~ /^;$/) {
		shift @$tokens;
		if (@$tokens && $tokens->[0] =~ /^ +$/) {
			shift @$tokens;
		}
		unshift @$tokens, "\t" x $indent;
	}
}

sub kill_last_line_if_just_dot_and_not_only_line {
	my ($expansion) = @_;
#	print STDERR "kill_last_line_if_just_dot_and_not_only_line: @$expansion<<<\n";
	if (@$expansion < 2 || $expansion->[-1] ne "\n") { return 0; }
	my $i = $#$expansion;
	while ($i >= 0 && $expansion->[$i-1] ne "\n") { --$i; }
	my $line;
	my $start = $i;
	return if $start == 0;
	while ($i <= $#$expansion) { $line .= $expansion->[$i]; ++$i; }
	if ($line =~ /^\t*\.\n\z/) {
		splice @$expansion, $start;
#		print STDERR "  did kill: @$expansion<<<\n";
		return 1;
	}
	return 0;
}

# TODO a way to get an argument quoted as a string
#   how does cpp do this?

sub macro_invocation {
	my ($name, $macro, $args) = @_;
	if (defined $args) {
		return $name."(".join(", ", map untokenize($_), @$args).")";
	}
	return $name;
}

sub expand_macro {
	# this expands a macro and expands macros recursively in the expansion
	my ($name, $macro, $args, $namespace) = @_;

	debug("  ".macro_invocation($name, $macro, $args));
	debug("\n    -> ");

	$args ||= [];

	my @value;
	my ($formal_args, $template, $type) = @$macro;
	# setup args hash
	my %args;
	my @args_list;
	for (@$formal_args) {
		# Would it ever make any sense to have a macro argument which actually
		# became a macro with arguments instead of a 0-argument macro?
		# ?????!
		my $arg = shift @$args;
		if (@$arg) {
#			$arg->[0] =~ s/^ //;
#			shift @$arg if $arg->[0] eq "";  #???
			# get rid of whitespace and extra parens
			if ($type !~ /rawraw/) {
				strip_enclosing_parens($arg);
			}
		}
		if ($type !~ /raw/ && @$arg > 1 && $$arg[-1] !~ /^[*&]$/) {
			unshift @$arg, "(";
			push @$arg, ")";
		}
		$args{$_} = $arg;
		push @args_list, $arg;
	}

	my $result;
	
	if (ref $template eq "CODE") {
		# handle "builtins"
		$result = &$template($namespace, @args_list);
	} else {
		# just do simple argument substitution here,
		# not macro expansion.  Macros and arguments are DIFFERENT!
		$result = [];
		for (@$template) {
			if ($args{$_}) {
				push @$result, @{$args{$_}};
			} else {
				push @$result, $_;
			}
		}
	}
	if ($type =~ /expr/ && $type !~ /raw/ && @$result > 1) {
		unshift @$result, "(";
		push @$result, ")";
	}
	debug("  ".untokenize($result)."\n-----------------\n");
	
	# give it a new namespace with a my__prefix for "my"
	my $private_prefix = new_private_prefix();
	my $new_namespace = $namespace->let(['my__prefix', ""], [undef, [$private_prefix], 'expr']);
	$result = expand_macros_tokenized($result, $new_namespace);
	if ($type =~ /expr/ and grep /\n/, @$_) {
		die "a block macro expanded in an expression macro's expansion!";
	}

	return $result;
}

# get_macro_args
# returns ($n_args, \@args)
# n_args and the second rv are undef for a token-macro (i.e. with no brackets)

#		$args = expand_macro_args($type, $args, $namespace);
# XXX do this in get_macro_args before splitting

sub get_macro_args {
	my ($tokens, $keyword, $namespace) = @_;
	my $all_args_raw = [];
	if (@$tokens == 0 || $$tokens[0] ne "(") {
		return undef, "", undef;
	}

	# get the raw args between parens into $arg_tokens (excluding the enclosing parens)
	shift @$tokens; # the (
	my $paren_depth = 0;
	while (1) {
		if (!@$tokens || $$tokens[0] eq "\n") {
			die "unbalanced parentheses in possible macro $keyword(".join("", @$all_args_raw)."\n";
		}
		my $tok = shift @$tokens;

		if ($tok =~ /^[[({]$/) { $paren_depth ++; }
		elsif ($tok =~ /^[])}]$/) {
			$paren_depth --;
			last if $paren_depth < 0;
		}

		push @$all_args_raw, $tok;
	}

#	warn "args raw: @$all_args_raw\n";

	# expand macros in the args - we copy them as may need to put raw args back
	my $args_unsplit = expand_macros_tokenized([@$all_args_raw], $namespace);
#	if ($args_unsplit =~ /\n/) {
#		die "a block macro expanded in the middle of an expression!";
#	}
#	warn "args expanded: @$args_unsplit\n";

	# split the args on the commas
	my @args;
	my $arg = [];

	$paren_depth = 0;
	for my $tok (@$args_unsplit) {
		if ($tok eq "," && $paren_depth == 0) {
			push @args, $arg;
			$arg = [];
		} else {
			push @$arg, $tok;
		}
		if ($tok =~ /^[[({]$/) { $paren_depth ++; }
		elsif ($tok =~ /^[])}]$/) { $paren_depth --; }
	}
	if (@$arg || @args) { push @args, $arg; }

#	use Data::Dumper;
#	warn "returning: ". Dumper($all_args_raw, 0+@args, \@args);

	return $all_args_raw, 0+@args, \@args;
}

1
