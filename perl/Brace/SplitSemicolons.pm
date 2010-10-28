# brace_split_semicolons
# split multi-statement lines onto separate lines

use strict; use warnings;

require 'brace_parser.pl';

# cope with "for", very bogus.  later fix syntax

our @lines;

sub brace_split_semicolons {

my @out;

for (@lines) {

if (/;/) { # rough check first to speed up
	my $tokens = tokenize($_);
	my $indent = initial_indent($tokens);

	my $skip = 0;

	for (my $i=0; $i<@$tokens; ++$i) {
		if ($$tokens[$i] eq "for") {
			$skip = 2;
		} elsif ($$tokens[$i] eq ";" && $skip-- == 0) {
			$skip = 0;
			my @start = splice @$tokens, 0, $i;
			if ($start[-1] =~ /^ *$/) { pop @start }
			$_ = untokenize(\@start)."\n";
			push @out, $_ if /\S/;
			shift @$tokens;
			if ($$tokens[0] =~ /^ *$/) { shift @$tokens }
			unshift @$tokens, "\t"x$indent if $indent;
			$i = -1;
		}
	}
	$_ = untokenize($tokens);
	push @out, $_ if /\S/;
} else {
	push @out, $_;
}
}

@lines = @out;
}

1
