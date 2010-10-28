#!/usr/bin/perl

use strict; use warnings;

my $status = "/var/lib/dpkg/status";
my $archives = "/var/cache/apt/archives";
my $partial = "/var/cache/apt/archives/partial";

open STATUS, $status or
	die "can't open $status: $!\n";

sub read_block {
	my $hash = {};
	my $order = [];
	my ($k,$v);
	while (defined ($_ = <STATUS>)) {
		chomp;
		if (/^$/) {
			return $hash, $order;
		} else {
			if (/^\s/) {
				defined $k or die "continuing line before main line in database: $_\n";
				$hash->{$k} .= "\n$_";
			} else {
				($k, $v) = /(.*?):(?: (.*))?$/;
				defined $k or
					die "bad syntax in database: $_\n";
				exists $hash->{$k} and
					die "duplicate key in database: $_\n";
				$hash->{$k} = $v;
				push @$order, $k;
			}
		}
	}
	@$order and die "missing newline at end of file\n";
	return;
}

while (1) {
	my ($hash, $order) = read_block();
	last if !defined $hash;
	if ($hash->{Status} =~ / installed$/) {
		my $debprefix = escape($hash->{Package}."_".$hash->{Version}."_");
		my @globbed = (<$archives/$debprefix*>, <$partial/$debprefix*>);
		for (@globbed) {
			unlink "$_" or die "can't remove $_\n";
		}
	}
}

sub escape {
	my $f = shift;
	$f =~ s/:/%3a/g;
	return $f;
}
