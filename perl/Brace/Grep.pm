# brace_grep

use strict; use warnings; use L;
require "brace_parser.pl";

#package Brace::Grep

our @lines;

sub brace_grep {

my $pattern = {};
for (@_) { $pattern->{$_} = 1; }

@lines = grep { grep {$pattern->{$_}} @{tokenize($_)} } @lines;

}

1
