#!/usr/bin/perl
@lines = <STDIN>;
@lines = sort @lines;
for (@lines) {
	print;
}
