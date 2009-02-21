#package Brace::Strip;

# brace_strip
# get rid of unused function definitions, etc.
# this is useful in combination with $BRACE_STANDALONE

# syntax: brace_strip <name to keep> ...
# e.g.: brace_strip main

use strict;
use warnings;

our (	@define,
	@include, @extern_lang, @using_namespace,
	@enum, @struct_union_class_template_proto, @struct_union_typedef,
	@typedef, @struct_union_class_template, @function_proto, @var_proto,
	@local_and_global_var, @var_assignment, @function,
	
	@lines, @local_var, @global_var,
	);

our ($sym, $bracketed, $in_brackets, $funcname);

sub brace_strip {

if (@_ == 0) { warn "you probably should use `brace_strip main'"; }


# TODO do this in the parser...

my %def;
my $name;

for (@include, @extern_lang, @using_namespace) {
	s/(\0KEEP)?\z/\0KEEP/s;
}

my @cpp_stuff;
 # ^define, etc.  this should be in a separate list anyway.

for (@define) {
	if (/^\^/) {
		push @cpp_stuff, \$_; next;
	}
	($name) = /^\w+ *($sym)/o;
	defined $name or die "weird def: $_\n";
	push @{$def{$name}}, \$_;
}

for (@enum) {
	my $body;
	($name, $body) = /^enum +($sym)?(.*)\z/so;
	if ($name) {
		push @{$def{$name}}, \$_;
	}
	for my $token (@{tokenize($body)}) {
		if (my ($const) = $token =~ /^($sym)$/) {
			push @{$def{$const}}, \$_;
		}
	}
}
for (@struct_union_class_template_proto) {
	($name) = /($sym)$/o;
	defined $name or die "weird struct_union_class_template_proto: $_\n";
	push @{$def{$name}}, \$_;
}
for (@struct_union_typedef, @typedef) {
	($name) = /($sym)(?:\[\S*\])?$/o;
	if (!defined $name) {
		# cope with weird typedefs: func ptrs - see osched.bb
		($name) = /\(\s*\*\s*($sym)\s*\)/o;
	}
	defined $name or die "weird struct_union_typedef: $_\n";
	push @{$def{$name}}, \$_;
}
for (@struct_union_class_template) {
	my $proto = $_;
	$proto =~ s/\n.*/\n/s;
	$proto =~ s/\s*:.*//;
	($name) = $proto =~ /($sym)$/o;
	if (!defined $name && /\)$/) {
		# may be a function template
		# XXX function templates should really go with the function
		# definitions, not the structs
		($name) = $proto =~ /($funcname)\(/o;
	}
	defined $name or die "weird struct_union_class_template: $_\n";
	push @{$def{$name}}, \$_;
}
for (@function_proto) {
	($name) = /[^\n]*?($sym)\(/o;
	defined $name or die "weird function_proto: $_\n";
	push @{$def{$name}}, \$_;
}
for (@var_proto, @local_and_global_var) {
	my $decl = $_;
	$decl =~ s/\s*=\z//s;
	# get rid of array [...]
	my $array = "";
	if ($decl =~ s/(\s*(\[$in_brackets\])+)$//) {
		$array = $1;
	}
	($name) = $decl =~ /($sym)$/o;
	defined $name or die "weird var_proto: $_\n";
	push @{$def{$name}}, \$_;
}
for (@var_assignment) {
	my $decl = $_;
	$decl =~ s/\s*=.*//s;
	# get rid of array [...]
	my $array = "";
	if ($decl =~ s/(\s*(\[$in_brackets\])+)$//) {
		$array = $1;
	}
	($name) = $decl =~ /($funcname)$/o;
	defined $name or die "weird var_assignment: $_\n";
	push @{$def{$name}}, \$_;
}
for (@function) {
	($name) = /[^\n]*?($funcname)\(/o;
	defined $name or die "weird function: $_\n";
	push @{$def{$name}}, \$_;
}

my %names_to_keep;
my ($queue) = @_;

while (@$queue) {
	my $name = shift @$queue;
	$names_to_keep{$name} = 1;
	my $defs = $def{$name};
	if ($defs) {
		for (@$defs) {
			for my $token (@{tokenize($$_)}) {
				if (my ($n) = $token =~ /^($sym)$/) {
					push @$queue, $n if !exists $names_to_keep{$n};
				}
			}
		}
	} else {
		$names_to_keep{$name} = 0;
	}
}

for (keys %names_to_keep) {
	delete $names_to_keep{$_} if !$names_to_keep{$_};
}
for (keys %names_to_keep) {
	for (@{$def{$_}}) {
		$$_ =~ s/(\0KEEP)?\z/\0KEEP/s;
	}
	# how dodgy is this!
}

for (@cpp_stuff) {
	$$_ =~ s/(\0KEEP)?\z/\0KEEP/s;
}

our %lists;
for (grep {$_ ne "lines"} keys %lists) {
	for (@{$lists{$_}}) {
		if (!s/\0KEEP\z//s) {
			$_ = "";
		}
	}
}

remove_deleted();

}

1
