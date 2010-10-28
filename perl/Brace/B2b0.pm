#package Brace::B2b0;

use strict; use warnings;

require "brace_parser.pl";

our @lines;

use Brace::RmCommentsBlankColonsAddFuncParens;
use Brace::Contlines;
use Brace::SplitSemicolons;
use Brace::SplitUse;
use Brace::SplitVars;

sub b2b0 {

brace_rm_comments_blank_colons_add_func_parens();
brace_contlines();
brace_split_semicolons();

parse_lines();

brace_split_use();
brace_split_vars();

}

1
