#package Brace::SplitVars;

# brace_split_vars
# split variable definitions / assignments onto separate lines

use strict;
use warnings;

our (	@define,
	@include, @extern_lang, @using_namespace,
	@enum, @struct_union_class_template_proto, @struct_union_typedef,
	@typedef, @struct_union_class_template, @function_proto, @var_proto,
	@local_and_global_var, @var_assignment, @function,
	
	@lines, @local_var, @global_var,
	);

our ($sym, $bracketed, $in_brackets);

my @vars;

sub brace_split_vars {

@vars = ();
split_vars(\@var_proto);
@var_proto = @vars;

@vars = ();
split_vars(\@local_and_global_var);
@local_and_global_var = @vars;

@vars = ();
split_vars(\@var_assignment);
@var_assignment = ();
for (@vars) {
	if (/=/) {
		push @var_assignment, $_;
	} else {
		push @local_and_global_var, $_;
	}
}

}

sub split_vars {
	for (@{$_[0]}) {
		my $decl = $_;
		if ($decl =~ /\n./s) {
			# has a multi-line assignment; assume doesn't have multiple variables
			push @vars, $_;
		} else {
			# we may have multiple variables
			my @var_assign;
			chomp $decl;
			do {
				# get rid of assignment
				my $assign = "";
				if ($decl =~ s/(\s*=([^][(){}=,]|$bracketed)*)$//) {
					$assign = $1;
				}
				# get rid of array [...]
				my $array = "";
				if ($decl =~ s/(\s*(\[$in_brackets\])+)$//) {
					$array = $1;
				}
				my $name;
				if ($decl =~ s/($sym)$//o) {
					$name = $1;
				} else {
					# can't understand it, probably a function ptr decl or s.t.
					push @vars, $_;
					next;
#					die "malformed variable decl or too many levels of brackets (3 is max with this dodgy parser!): $_\n";
				}
				unshift @var_assign, "$name$array$assign";
			} while ($decl =~ s/\s*,\s*$//);
			my $type = $decl;
			for (@var_assign) {
				push @vars, "$type$_\n";
			}
		}
	}
}

1
