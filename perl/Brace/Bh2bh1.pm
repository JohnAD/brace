#package Brace::Bh2bh1;

use strict; use warnings;

require "brace_parser.pl";

use Brace::Proto;
use Brace::Typedef;
use Brace::HeaderExport;

sub bh2bh1 {

usage "guard_prefix filename" unless @_ == 1 && @{$_[0]} == 2;
my ($prefix, $filename) = @{$_[0]};

# requires parsed tokens

brace_proto();
brace_typedef();
# convert to text
our $text = output_all_string();
brace_header_export($prefix, $filename);

# returns $text

}
