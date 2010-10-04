use warnings; use strict;

use Brace::Macrospace;
use Brace::Expand;

our ($sym);

our $builtins = Brace::Macrospace->new;

$builtins->set(["skip", 2], [[qw(level expr)], sub {
	my ($ns, $level, $expr) = @_;
	if (!defined $expr || @$level != 1) {
		die "syntax: skip(level, `expr)\n";
	}
	if (@$expr != 1) {
		die "skip: sorry, can't handle expressions yet, just single symbols!\n";
	}
	my $name = $expr->[0];
	$level = $level->[0];
	$name =~ s/^`// or die "skip: expr must be quoted with `!\n";
	my $macro = $ns->lookup_skip([$name, ""], $level);
	defined $macro || die "skip: no such macro $name up $level level/s\n";
	return expand_macro($name, $macro, undef, $ns);
}, "expr"]);

# my

# $builtins->set(["my", 1], [[qw(var)], sub {
# 	my ($var) = @_;
# 	@$var == 1 && $$var[0] =~ /($sym)/o or die "syntax: my(var-name)\n";
# 	warn "eval my: ", $builtins_eval_context->{private_prefix}."_$$var[0]", "\n";
# 	return [$builtins_eval_context->{private_prefix}."_$$var[0]"];
# }, "expr"];

1
