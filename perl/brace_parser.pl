# top-level brace parser

# NOTE - must NOT change @local_var or @global_var and then call
#   output_all, instead change @local_and_global_var

# TODO add support for `local' struct, class, template, enum
# TODO add support for `local' functions
# TODO replace extern "lang" blocks with something saner,
# i.e. an optional "lang" option per include statement

# XXX function templates should really go with the function
# definitions, not the structs
#   see also brace_strip

use strict;
use warnings;

use IO::File;
use IO::String;

our (	@define,
	@include, @extern_lang, @using_namespace,
	@enum, @struct_union_class_template_proto, @struct_union_typedef,
	@typedef, @struct_union_class_template, @function_proto, @var_proto,
	@local_and_global_var, @var_assignment, @function,
	
	@lines, @local_var, @global_var,
	);
our $text;

our ($sym, $bracketed, $in_brackets, $funcname);

our @list_names = qw(
	define
	include extern_lang using_namespace
	enum struct_union_class_template_proto struct_union_typedef
	typedef struct_union_class_template function_proto var_proto
	local_and_global_var var_assignment function
	
	lines local_var global_var
	);

our %lists;

our $cxx_using_c_lib = 0;

for (@list_names) {
	no strict 'refs';
	$lists{$_} = \@$_;
}

sub read_lines {
	@lines = ();
	read_lines_more(@_);
}

sub read_lines_more {
	my ($fh) = @_;
	if (!ref $fh) {
		$fh = IO::File->new($fh) or 
			die "can't open $_[0]";
	}
	while (defined ($_ = <$fh>)) {
		push @lines, $_;
	}
}

sub output_lines_string {
	$text = "";
	for (@lines) { $text .= $_ }
	return $text;
}

sub output_lines {
	my ($fh) = @_;
	$fh ||= \*STDOUT;
	if (!ref $fh) {
		$fh = IO::File->new($fh, "w") or 
			die "can't create $_[0]";
	}
	print $fh output_lines_string();
}

sub parse {
	parse_clear();
	parse_more(@_);
}

sub parse_more {
	my ($fh) = @_;
	if (!ref $fh) {
		$fh = IO::File->new($fh) or 
			die "can't open $_[0]";
	}
	my $copyblock = 0;
	my $block_ref;
	while (defined ($_ = <$fh>)) {
		push @lines, $_;
		if (/^\s*$/) { next } # skip blank lines
		if (/^\s*#/) { next } # skip comments
		if (/\t/) {  # anything with a tab in it is part of a block; may have a goto label at the start
			if ($copyblock) {
				$$block_ref.=$_;
				next;
			}
			die "unexpected block: $_";
		}
		$copyblock = 0;
		if (/^\t*((use|export) )/) {  # include
			push @include, $_;
		} elsif (/^\t*using namespace /) {  # using namespace
			push @using_namespace, $_;
		} elsif (/^\t*(l?(?:\^|def |Def |DEF ))/) { # macros, or cpp stuff starting with ^
			# XXX ^define, etc. should be elsewhere in a separate list.
			push @define, $_;
			$block_ref = \$define[$#define];
			$copyblock = 1;
		} elsif (/^(struct|union|class|template)[^A-Za-z_]/ &&
			!/^[a-z]+ \w+ ?[\*\&]* ?\w+\(/i && !/=/) { # DODGY regexp
			# struct, union, class, template - not a function returning such
			push @struct_union_class_template, $_;
			$block_ref = \$struct_union_class_template[$#struct_union_class_template];
			$copyblock = 1;
		} elsif (/^enum[^A-Za-z_]/) {
			# enum
			push @enum, $_;
			$block_ref = \$enum[$#enum];
			$copyblock = 1;
		} elsif (/^typedef[^A-Za-z_]/) { # typedef
			push @typedef, $_;
			$block_ref = \$typedef[$#typedef];
			$copyblock = 1;
		} elsif (/^(local|static)[^A-Za-z_]/ && (/=/ || !/[a-z0-9]\(/i)) {  # file-local definition (`static' in C)
			push @local_and_global_var, $_;
			$block_ref = \$local_and_global_var[$#local_and_global_var];
			$copyblock = 1;
#		} elsif (/^extern ".*?\t/) {
		} elsif (/^extern ".*?"/) {
			# an extern "C" or whatever block
			# XXX TODO handle these better, or disallow
			push @extern_lang, $_;
			$block_ref = \$extern_lang[$#extern_lang];
			$copyblock = 1;
		} elsif (/^extern / && /\)$/) {  # extern function
			# might be extern "C"
			if ($cxx_using_c_lib) {
				$_ =~ s/^(extern ("C" )?)?/extern "C" /s;
			}
			push @function_proto, $_;
		} elsif (/^extern /) { # extern variable
			# might be extern "C"
			if ($cxx_using_c_lib) {
				$_ =~ s/^(extern ("C" )?)?/extern "C" /s;
			}
			push @var_proto, $_;
		} elsif (!/=/ && /\)$/) {  # function decl
			push @function, $_;
			$block_ref = \$function[$#function];
			$copyblock = 1;
		} elsif (/^./) {  # variable?
			push @local_and_global_var, $_;
			$block_ref = \$local_and_global_var[$#local_and_global_var];
			$copyblock = 1;
		} else {
			# it's a blank line.  woohoo.
		}
	}
	for (@local_and_global_var) {
		if (/^(local|static)[^A-Za-z_]/) {
			push @local_var, $_;
		} else {
			push @global_var, $_;
		}
	}
	for (@function) {
		if (!/\t/) {
			if ($cxx_using_c_lib) {
				$_ =~ s/^(extern ("C" )?)?/extern "C" /s;
			}
			push @function_proto, $_;
			$_ = "";
		}
	}
	my %struct_union_names;
	for (@struct_union_class_template) {
		if (!/\t/) {
			push @struct_union_class_template_proto, $_;
			$_ = "";
		} elsif (/^(struct|union) (\w+)/) {
			# this is a C struct or union definition
			$struct_union_names{$2} = 1;
		}
	}
	for (@typedef) {
		if (/^typedef (struct|union) (\w+) \2$/s) {
			if ($struct_union_names{$2}) {
				push @struct_union_typedef, $_;
				$_ = "";
			}
		}
	}
	for (@local_and_global_var) {
		if (/=/) {
			push @var_assignment, $_;
			$_ = "";
		}
	}
	remove_deleted();
}

sub remove_deleted {
	no strict 'refs';
	for (@list_names) {
		@$_ = grep /./, @$_;
	}
}

sub parse_save {
	no strict 'refs';
	my %save;
	for (@list_names) {
		$save{$_} = [@$_];
	}
	return \%save;
}

sub parse_clear {
	no strict 'refs';
	for (@list_names) {
		@$_ = ();
	}
}

sub parse_text {
	my $fh = IO::String->new($_[0]);
	parse($fh);
}

sub reparse {
	my $program = output_all_string();
	parse_clear();
	parse_text($program);
}

sub parse_lines {
	my $program = output_lines_string();
	parse_text($program);
}

sub parse_append_saved {
	no strict 'refs';
	my ($saved) = @_;
	for (@list_names) {
		push @$_, @{$saved->{$_}};
	}
}

sub parse_prepend_saved {
	no strict 'refs';
	my ($saved) = @_;
	for (@list_names) {
		unshift @$_, @{$saved->{$_}};
	}
}

# output_all does what brace_shuffle used to do

our $section_comments;

sub output_all_string {
	$text = "";
	gappy("define", @define);
	adjacent("include", @include);
#	adjacent("extern_lang", @extern_lang);
	adjacent("using_namespace", @using_namespace);
	gappy("enum", @enum);
	adjacent("struct_union_class_template_proto", @struct_union_class_template_proto);
	adjacent("struct_union_typedef", @struct_union_typedef);
	adjacent("typedef", @typedef);
	gappy("struct_union_class_template", @struct_union_class_template);
	adjacent("extern_lang", @extern_lang);
	adjacent("function_proto", @function_proto);
	adjacent("var_proto", @var_proto);
	adjacent("local_and_global_var", @local_and_global_var);
	adjacent("var_assignment", @var_assignment);
	gappy("function", @function);
	return $text;
}

sub output_all {
	print output_all_string();
}

sub output_all_with_section_comments {
	local $section_comments = 1;
	output_all();
}

sub gappy {
	my $section = shift;
	if (@_) {
		if ($section_comments) { $text .= "# $section\n\n"; }
		for (@_) { $text .= "$_\n"; }
		if ($section_comments) { $text .= "\n\n"; }
	}
}

sub adjacent {
	my $section = shift;
	if (@_) {
		if ($section_comments) { $text .= "# $section\n\n"; }
		for (@_) { $text .= "$_"; }
		$text .= "\n";
		if ($section_comments) { $text .= "\n\n"; }
	}
}

# tokenizer - NOTE - this is a GREEDY tokenizer, like cpp, so if
# you write ugly code it may interpret it wrong.  This tokenizer
# is hopelessly imprecise, it will pass lots of buggy code.  I
# couldn't be bothered writing a "perfect" one (yet!) when this
# is good enough.  It should cope with C and C++ code, I hope.

# this has got to be slow when used on a whole file!  n^2 I suppose
# this will be so much better in brace.

sub tokenize {
	my ($text) = @_;
	my $quote_token = 0;
	my @tokens;
	for ($text) {
		while ($_ ne "") {
			# comment
			s/^(#[^\n]*)//s or
			# newline
			s/^(\n)//s or
			# tabs
			s/^(\t+)//s or
			# other whitespace
			s/^(\s+)//s or
			# hex int
			s/^(0x[0-9a-f]+(u|l|ul|lu)?)//si or
			# decimal floating-point
			s/^((\d*\.\d+|\d+\.)(e[-+]?\d+)?[fl]?)//si or
			s/^(\d+(e[-+]?\d+)[fl]?)//si or
			# oct int (including 0)
			s/^(0[0-7]*(u|l|ul|lu)?)//si or
			# decimal int
			s/^([1-9]\d*(u|l|ul|lu)?)//si or
			# quoted string - watch out, this can go across a newline (if it is escaped)
			s/^("([^"\\\n]|\\.)*")//s or
			# quoted character - actually allows any string!
			# this could be used for symbols, i.e. a unique number for every distinct identifier
			# with the characters being numbered 0-255 or whatever
			s/^('([^'\\\n]|\\.)*')//s or
			# quoted tokens - very cool!
			#   see below TODO expressions to be quotable, hence an expression is one "token"
			#   (a list ref)
			s/^(`+)//s or
			# indentifier - textual operators will be matched here
			s/^([a-z_\$][a-z0-9_\$]*)//si or
			# operator
			# are %: and %:%: operators ???
			# ^^ is the brace_expand token-pasting operator
			# ... is the brace_expand "block" operator
			s,^(->\*|<<=|>>=|\.\.\.|\^\^|->|\+\+|--|\+=|-=|\*=|/=|%=|&=|\|=|\^=|&&|\|\||==|!=|<<|>>|<=|>=|<:|:>|<%|%>|::|\.\*|[^\s'"]),,s or
			die "can't tokenize input - this probably means you have a missing quote:\n".first_lines_of_text($_, 3);
			my $token = $1;
			if ($token =~ /^['"]/) {
				# patch multi-line strings together
				$token =~ s/\\\n\s+//;
			}
			if ($token =~ /^`/) {
				$quote_token = $token;
			} else {
				if ($quote_token) {
					$token = "$quote_token$token";
					$quote_token = 0;
				}
				push @tokens, $token;
			}
		}
	}
	return \@tokens;
}

sub tokenize_ng {
	# this one does parens properly
	my ($text) = @_;
	my @stack;
	my $tokens = [];
	for ($text) {
		while ($_ ne "") {
			# comment
			s/^(#[^\n]*)//s or
			# newline
			s/^(\n)//s or
			# tabs
			s/^(\t+)//s or
			# other whitespace
			s/^(\s+)//s or
			# hex int
			s/^(0x[0-9a-f]+(u|l|ul|lu)?)//si or
			# decimal floating-point
			s/^((\d*\.\d+|\d+\.)(e[-+]?\d+)?[fl]?)//si or
			s/^(\d+(e[-+]?\d+)[fl]?)//si or
			# oct int (including 0)
			s/^(0[0-7]*(u|l|ul|lu)?)//si or
			# decimal int
			s/^([1-9]\d*(u|l|ul|lu)?)//si or
			# quoted string - watch out, this can go across a newline (if it is escaped)
			s/^("([^"\\\n]|\\.)*")//s or
			# quoted character - actually allows any string!
			# this could be used for symbols, i.e. a unique number for every distinct identifier
			# with the characters being numbered 0-255 or whatever
			s/^('([^'\\\n]|\\.)*')//s or
			# quoted tokens and bracketed expression -- very cool!
			#   see below TODO expressions to be quotable, hence an expression is one "token"
			#   (a list ref)
			s/^(`+)//s or
			# indentifier - textual operators will be matched here
			s/^([a-z_\$][a-z0-9_\$]*)//si or
			# brackets.  < and > are not brackets, bad luck C++
			# there's no problem, I can just use some other type of parens with the template form
			s/^([][(){}])//s or
			# operator
			# are %: and %:%: operators ???
			# ^^ is the brace_expand token-pasting operator
			# ... is the brace_expand "block" operator
			s,^(->\*|<<=|>>=|\.\.\.|\^\^|->|\+\+|--|\+=|-=|\*=|/=|%=|&=|\|=|\^=|&&|\|\||==|!=|<<|>>|<=|>=|<:|:>|<%|%>|::|\.\*|[^\s'"]),,s or
			die "can't tokenize input - this probably means you have a missing quote:\n".text_context($_);
			my $token = $1;
			if ($token =~ /^['"]/) {
				# patch multi-line strings together
				$token =~ s/\\\n\s+//;
			} elsif ($token =~ /^[`{[(]$/) {
				push @stack, $tokens;
				$tokens = [];
			}
			push @$tokens, $token;
			# once I fix the function syntax, ` will be able to quote a functional form
			# just like `(cat "/dev/null") of course
			if ($token =~ /^[]})]$/ or @$tokens == 2 && $$tokens[0] eq "`") {
				if ($token ne "`") {
					unless (@$tokens && $$tokens[0] eq bracket_pair($token)) {
						die "unmatched bracket `$token'\n".text_context($_);
					}
				}
				my $expr = $tokens;
				$tokens = pop @stack or die "unmatched token `$token'\n".text_context($_);
				push @$tokens, $expr;
			}
		}
	}
	# TODO parse block structure as a type of parenteses too (like { and }
	# - these are semantically but NOT lexically the same, use different tokens).

	# I think I do want a more GENERIC parser than this, maybe the macro
	# processor should handle all this stuff???

	if (@stack) {
		die "unmatched bracket/s / quotes/s: ".join(" ", $$tokens[0], map $$_[0], @stack[1.,$#stack])."\nat EOF";
	}
	return $tokens;
}

# we could possibly tokenize strings too?? no.  maybe into chars?  no!
sub bracket_pair {
	our $bracket_pair_hash ||= {qw,{ } ( ) [ ] } { ) ( ] [,};
	return $bracket_pair_hash->{$_[0]};
}

# untokenize - this will return text for the code

sub untokenize {
	my ($tokens) = @_;
	return join('', @$tokens);
}

sub untokenize_ng {
	my ($tokens) = @_;
	my $text = "";
	for (@$tokens) {
		if (ref $_) {
			$text .= untokenize_ng($_);
		} else {
			$text .= $_;
		}
	}
	return $text;
}

sub line_indent {
	my ($line) = @_;
	my $foo = $line;
	chomp $foo;
	$foo =~ s/[^\t]*//gs;
	return length($foo);
}

sub initial_indent {
	my ($tokens) = @_;
	my $indent = 0;
	for (@$tokens) {
		if (/^\t+$/) {
			$indent += length($_);
		} elsif (/\n/) {
			last;
		}
	}
	return $indent;
}

sub final_indent {
	my ($tokens) = @_;
	my $indent = 0;
	my $i = @$tokens - 1;
	if ($i >= 0 && $tokens->[$i] eq "\n") { --$i; }
	LOOP: for (; $i>=0; --$i) {
		for ($tokens->[$i]) {
			if (/^\t+$/) {
				$indent += length($_);
			} elsif (/^\n$/) {
				last LOOP;
			}
		}
	}
	return $indent;
}

# adjust_indent: this is a mess!
#   need a better rep for indent in tokenized code!

sub adjust_indent {
	my ($tokens, $delta_indent) = @_;
	my $line = [];
	my @result;
	for (@$tokens) {
		push @$line, $_;
		if ($_ eq "\n") {
			if (@$line && $line->[0] =~ /^(\t+)$/) {
				my $old_indent = length($1);
				my $new_indent = $old_indent + $delta_indent;
				if ($new_indent < 0) {
					die "adjust_indent: cannot adjust by $delta_indent\n  @$tokens";
				} elsif ($new_indent > 0) {
					$line->[0] = "\t" x $new_indent;
				} else {
					shift @$line;
				}
			} elsif (@$line > 1 && $line->[1] =~ /^(\t+)$/) {
				my $old_indent = length($1);
				my $new_indent = $old_indent + $delta_indent;
				if ($new_indent <= 0) {
					die "adjust_indent: cannot adjust by $delta_indent\n  @$tokens";
				}
				$line->[1] = "\t" x $new_indent;
			} else {
				if ($delta_indent < 0) {
					die "adjust_indent: cannot adjust by $delta_indent\n  @$tokens";
				} elsif ($delta_indent > 0) {
					unshift @$line, "\t" x $delta_indent;
				}
			}
			push @result, @$line;
			$line = [];
		}
	}
	if (@$line) {
		if (@result) {
			die "adjust_indent: multi-line code did not end with a newline\n  @$tokens";
		}
		return $line;
	}
	return \@result;
}

$sym = '[a-zA-Z_][a-zA-Z_0-9]*';
$funcname = "$sym|operator[^)a-zA-Z0-9]{1,3}";

# very dodgy regexps for matching nested brackets - to a limited level!
# XXX does not support nested brackets properly yet,
# limited to two deep!  will wait for real (non-perl)
# parser for proper support.
my $max_nesting_level = 3;
my $not_brackets = "[^][(){}]*";
$in_brackets = $not_brackets;
$bracketed = "\\($in_brackets\\)|\\{$in_brackets\\}|\\[$in_brackets\\]";
for (2..$max_nesting_level) {
	$in_brackets = "($not_brackets|$bracketed)*";
	$bracketed = "\\($in_brackets\\)|\\{$in_brackets\\}|\\[$in_brackets\\]";
}

sub first_token {
	my ($tokens) = @_;
	for (@$tokens) {
		if (!is_space($_)) {
			return $_;
		}
	}
	return "";
}

sub last_token {
	my ($tokens) = @_;
	for (reverse @$tokens) {
		if (!is_space($_)) {
			return $_;
		}
	}
	return "";
}

sub is_space {
	return $_[0] =~ /^ *$/;
}

sub strip_space_start {
	my ($tokens) = @_;
	while (@$tokens && is_space($$tokens[0])) {
		shift @$tokens;
	}
}

sub strip_space_end {
	my ($tokens) = @_;
	while (@$tokens && is_space($$tokens[-1])) {
		pop @$tokens;
	}
}

sub debug_print_a_line {
	my ($tokens, $minlevel) = @_;
	$minlevel ||= 1;
	return unless ($ENV{BRACE__MACRO_DEBUG}||0) >= $minlevel;
	for (@$tokens) {
		last if /\n/;
		print STDERR $_;
	}
	print STDERR "<<<\n";
}

sub debug_print_tokens {
	my ($tokens, $minlevel) = @_;
	$minlevel ||= 1;
	return unless ($ENV{BRACE__MACRO_DEBUG}||0) >= $minlevel;
	for (@$tokens) {
		print STDERR $_;
	}
	print STDERR "<<<\n";
}

sub strip_space {
	my ($arg) = @_;
	strip_space_start($arg);
	strip_space_end($arg);
}

# this is a bit inefficient...
sub strip_enclosing_parens {
	my ($arg) = @_;
	while (1) {
		strip_space($arg);
		my $level = 0;
		if (@$arg and $arg->[0] eq "(" && $arg->[-1] eq ")") {
			$level = 1;
			for (@$arg[1..$#$arg-1]) {
				if ($_ eq "(") { ++$level }
				elsif ($_ eq ")") { --$level }
				if ($level == 0) {
					last;
				}
			}
		}
		if ($level) {
			shift @$arg; pop @$arg;
		} else {
			last;
		}
	}
}

sub text_context {
	return first_lines_of_text($_[0], 3);
}

sub first_lines_of_text {
	# for contextual errors
	# this is SO dodgy
	my ($text, $n) = @_;
	my $lines = "";
	while ($n > 0) {
		--$n;
		$text =~ s/^(.*?\n)// or last;
		$lines .="$1";
	}
	return $lines;
}

sub debug {
	my ($message, $minlevel) = @_;
	$minlevel ||= 1;
	warn "$message\n" if ($ENV{BRACE__MACRO_DEBUG}||0) >= $minlevel;
}

1
