#!/usr/bin/perl
use strict; use warnings;
use Tie::IxHash;

my %alloced;

tie %alloced, "Tie::IxHash";

my $n = 1;

while (defined($_ = <STDIN>)) {
	chomp;
	if ($_ !~ /^[AF]\t/) {
		next;
	}
	my ($type, $func, $addr, $size, $location) = split /\t/, $_;
	if ($type eq "A") {
		if ($alloced{$addr}) {
			print "bad\t$_\n";
		} else {
			$alloced{$addr} = $_;
		}
	} else {  # $type eq "free"
		if ($addr =~ /[^0]/ && !$alloced{$addr}) {
			print "bad\t$_\n";
		} else {
			delete $alloced{$addr};
		}
	}
}

for (keys %alloced) {
	print "unfreed\t$alloced{$_}\n";
}
