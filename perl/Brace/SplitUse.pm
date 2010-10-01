#package Brace::SplitVars;

# brace_split_use
# split use statements onto separate lines

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

sub brace_split_use {
	my @out;
	for my $include (@include) {
		push @out, @{split_use($include)};
	}
	@include = @out;
}

sub split_use {
	my ($include) = @_;
	chomp $include;
	my ($command, @files) = split / /, $include, -1;
	my @out;
	for (@files) {
		/./ or die "bad use statement: $include\n";
		push @out, "$command $_\n";
	}
	return \@out;
}

1
