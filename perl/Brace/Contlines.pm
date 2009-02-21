use strict; use warnings;

require "brace_parser.pl";

our @lines;

sub brace_contlines {

my $line = "";

my @out;
my $bslashcont = -1; # so we don't get a blank line at top
my $indent = -1;
my $last_indent = 0;

for (@lines) {
	$indent = line_indent($_);
	chomp;
	if ($bslashcont == 1) {
		s/^\s*//;
	} elsif (/^\t* +/ and $indent >= $last_indent) {
		$_ = substr($_, $last_indent);
	} else {
		$line .= "\n";
		push @out, $line;
		$last_indent = $indent;
		$line = "";
	}
	if (s/\\$//) { $bslashcont = 1 }
	else { $bslashcont = 0 }
	$line .= $_;
}

if ($bslashcont == 1) {
	die "last line ends in \\ - how perverse!\n";
}

$line .= "\n";
push @out, $line;

@lines = @out;

}

1
