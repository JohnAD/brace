#package Brace::B02b1;

use strict; use warnings;

require "brace_parser.pl";

#use Brace::SplitUse;
use Brace::Process;
use Brace::Wrap;
use Brace::Include;
#use Brace::SplitVars;
use Brace::Strip;
use Brace::Expand;
use Brace::PC;
use Brace::Proto;
use Brace::Typedef;
use Brace::Uniq;

sub b02b1 {

#brace_split_use();
brace_process();
brace_wrap();
brace_include();
#brace_split_vars();
brace_expand();
if ($ENV{BRACE_STANDALONE}) {
	brace_strip(["main"]);
}
brace_pc();
brace_proto();
brace_typedef();
brace_uniq();

}
