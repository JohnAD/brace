# brace_map

use strict; use warnings; use L;
require 'brace_parser.pl';

#package Brace::Map;

our @lines;

sub brace_map {
	my ($map_fh) = @_;
	my ($map, $globby) = read_map($map_fh);
	return brace_map_hash($map, $globby);
}

sub brace_map_hash {
	my ($map, $globby) = @_;
	my $n = 0;
	# globby is a hash of tokens that are the target of a map but are not
	# themselves remapped to some other token

	for (@lines) {
		my $tokens = tokenize($_);
		my $changed = 0;
		for (@$tokens) {
			if (exists $map->{$_}) {
				print STDERR ".";
				++$n;
				$_ = $map->{$_};
				$changed = 1;
			} elsif (my $other = $globby->{$_}) {
				print STDERR "X\n\n";
				warn <<End;
can't map tokens - target of $other->$_ is in use
If you wish to glob to a token foo, you must include
foo->foo in the map.
End
				return 0;
			}
		}
		if ($changed) {
			$_ = untokenize($tokens);
		}
	}
	return $n;
}

sub read_map {
	my ($file) = @_;
	my $map = read_map_fh(op($file));
	return $map, globby($map);
}

# read a map file
# will prob want to read maps from inside source eventually
sub read_map_fh {
	my ($fh) = @_;
	my %map;
	while (defined ($_ = <$fh>)) {
		chomp;
		# strip comments and junk
		next if /^  /;
		s/   .*//;
		s/#.*//;
		next if /^\s*$/;

		die "  space at start of line in map file\n" if /^ /;

		my ($old, $new, $rest) = split /\s+/, $_;
		die "  too many columns in map file:\n$_\n" if defined $rest;
		die "  not enough columns in map file:\n$_\n" if !defined $new;
		$map{$old} = $new;
	}
	return \%map;
}

sub globby {
	my ($map) = @_;
	my $globby = {};
	while (my ($from, $to) = each %$map) {
		if ($from ne $to and !exists $map->{$to}) {
			$globby->{$to} = $from;
		}
	}
	return $globby;
}

1
