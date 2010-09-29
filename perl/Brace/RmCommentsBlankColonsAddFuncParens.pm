# brace_rm_comments_blank_colons_add_func_parens
# removes comments and blank lines
# removes colons at end of line (start block)
# changes foo: to foo(): at start of line for function decl

use strict; use warnings;

require 'brace_parser.pl';

our @lines;

sub brace_rm_comments_blank_colons_add_func_parens {

my @out;

for (@lines) {

my $had_comment = 0;
if (/#/) { # rough check first to speed up
	my $tokens = tokenize($_);
	my $indent = initial_indent($tokens);

	for (my $i=0; $i<@$tokens; ++$i) {
		if ($$tokens[$i] =~ /^#/) {
			my @start = splice @$tokens, 0, $i;
			while (@start && $start[-1] =~ /^\s*$/) { pop @start }
			if (grep /\S/, @start) {
				$_ = untokenize(\@start)."\n";
			} else {
				$_ = "";
			}
			$had_comment = 1;
			last;
		}
	}
}

if (/\S/) { if (s/([^ ]):$/$1/ && !/[\t ()]/) { s/$/()/; } push @out, $_ };

}

@lines = @out;

for (@lines) { s/\t +\t/\t\t/g; }  # cope with vim adding unwanted spaces in indent

}

1
