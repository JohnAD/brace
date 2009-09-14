# brace_remove_comments
# removes comments and blank lines

use strict; use warnings;

require 'brace_parser.pl';

our @lines;

sub brace_rm_comments_blank {

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
				push @out, untokenize(\@start), "\n";
			}
			$had_comment = 1;
			last;
		}
	}
}
if (!$had_comment) {
	if (/\S/) { s/([^ ]):$/$1/; push @out, $_ };
}
}

@lines = @out;

for (@lines) { s/\t +\t/\t\t/g; }  # cope with vim adding unwanted spaces in indent

}

1
