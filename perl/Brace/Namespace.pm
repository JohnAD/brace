package Brace::Namespace;

use strict; use warnings;

sub id { return @_; }

sub new {
	my ($pkg, %args) = @_;
	return bless {
		parent => $args{parent},
		keymap => $args{keymap} || \&id,
		hash => {},
	}, $pkg;
}

sub child {
	my ($self) = @_;
	return (ref $self)->new(parent=>$self);
}

sub parent {
	my ($self) = @_;
	return $self->{parent}
}

sub lookup {
	my ($self, $key) = @_;
	my $k = $self->{keymap}->($key);
	return $self->{hash}{$k} if exists $self->{hash}{$k};
	if ($self->{parent}) {
		return $self->{parent}->lookup($key);
	} else {
		return undef;
	}
}

# use let, not set!
# set changes the meaning of the existing macro for parent scopes up to the last time it was defined but not above;
# probably NOT what you want.

# I could write a "kill" function and a "SET" function to completely redefine a macro for everyone, but YAGNI ATM

sub set {
	my ($self, $key, $val) = @_;
	my $k = $self->{keymap}->($key);
	$self->{hash}{$k} = $val;
	$self->{hash_order}{$k} = $self->{counter}
}

sub let {
	my ($self, $key, $val) = @_;
	my $k = $self->{keymap}->($key);
	my $ns = $self;
	if (exists $self->{hash}{$k}) {
		$ns = $self->child();
		# !!
	}
	$ns->set($key, $val);
	return $ns;
}


sub delete {
	my ($self, $key, $val) = @_;
	$self->let($key, undef);
	# we use "exists", so it won't be looked up in the parent!
}

sub defined {
	my ($self, $key) = @_;
	return defined $self->lookup($key);
}

sub dump {
	my ($self) = @_;
	for (sort keys %{$self->{hash}}) {
		print "$_\n";
	}
	print "\n";
	$self->{parent} && $self->{parent}->dump();
}

sub lookup_skip {
	# this skips the first definition of something and goes to the "next" one up, * n.
	my ($self, $key, $n) = @_;
	if ($n == 0) {
		return $self->lookup($key);
	}
	my $k = $self->{keymap}->($key);
	if (exists $self->{hash}{$k}) {
		return $self->{parent} && $self->{parent}->lookup_skip($key, $n-1);
	} else {
		return $self->{parent} && $self->{parent}->lookup_skip($key, $n);
	}
}

1
