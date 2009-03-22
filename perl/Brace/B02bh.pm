#package Brace::B02bh

use strict; use warnings;

our @define;

require "brace_parser.pl";

#use Brace::SplitUse;
#use Brace::SplitVars;
use Brace::Process;
use Brace::Wrap;
use Brace::Proto;
use Brace::Header;
use Brace::Uniq;

sub b02bh {

if ($ENV{BH_NO_MACROS}) {
	@define = ();
}
#brace_split_use();
#brace_split_vars();
brace_process();
brace_wrap();
brace_proto();
brace_header();
brace_uniq();

}
