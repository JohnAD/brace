#package Brace::HeaderExport;

# brace_header
# transforms brace header files to be usable by C or C++
# (the output must be piped through "brace" to produce C or C++ code)

use strict;
use warnings;

use IO::File;

our @lines;
our $text;

sub brace_header_export {

@_ == 1 && @{$_[0]} == 2 or
	usage "guard_prefix filename < filename";

my ($guard_prefix, $filename) = @{$_[0]};

my $language = $ENV{BRACE_LANGUAGE} || "C";

my $is_c_plus_plus = $language =~ /^c\+\+$/i;
if (!$is_c_plus_plus && $language !~ /^c$/i) {
	die "unknown target language: $language\n";
}

my $guard = $filename;
for ($guard) {
	s/\.bb?h//g;
	s/(_+)/_$1/g;
	s/([^A-Za-z0-9_])/"_".sprintf("%02x",ord($1))/ge;
}
$guard = $guard_prefix.$guard;

my $text1 = "";

# prelude
if ($guard ne "") {
	$text1 .= <<End;
^ifndef $guard
^define $guard 1
End
}
if (!$is_c_plus_plus) {
	$text1 .= <<End;
^ifdef __cplusplus
extern "C" {
^endif
End
}
$text1 .= "\n";
# end prelude

$text =~ s/^(use|export) (\S+)\.bb?h$/$1\.h/gm;

$text1 .= $text;

# postlude
if (!$is_c_plus_plus) {
	$text1 .= <<End;
^ifdef __cplusplus
}
^endif
End
}
if ($guard ne "") {
	$text1 .= <<End;
^endif
End

}
# end postlude

$text = $text1;

}

1
