#package Brace::Deps

use strict; use warnings;

require "brace_parser.pl";

our @list_names;

sub brace_deps {
	no strict 'refs';
	for (@list_names) {
		@$_ = () unless $_ eq "include";
	}
}

1
