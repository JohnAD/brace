package Brace::Macrospace;

use strict; use warnings;

use base 'Brace::Namespace';

sub new {
	my $pkg = shift;
	my $self = $pkg->SUPER::new(@_, keymap=>\&macro_lookup_key);
	return $self;
}

sub lookup_vague {
	my ($self, $macro_name) = @_;
	return $self->{vague}{$macro_name} || $self->{parent} && $self->{parent}->lookup_vague($macro_name);
}

sub set {
	my ($self, $key, $val) = @_;
	my ($macro_name, $n_args) = @$key;
	$self->{vague}{$macro_name} = 1 if defined $val;
	$self->SUPER::set($key, $val);
}

sub macro_lookup_key {
	use Carp;
	my ($key) = @_;
	my ($name, $n_args) = @$key;
	my $realkey = $name;
	defined $n_args || confess "undef n_args";
	if ($n_args ne "") {
		$realkey .= "(";
		$realkey .= "_, "x$n_args;
		$realkey =~ s/, $/)/;
	}
	return $realkey;
}

1
