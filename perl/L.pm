package L;

use strict; use warnings;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(slurp belch prod p x touch odds evens escape_tsv unescape_tsv
	mtime rmpath min max In
	text_to_html html_to_text text_to_textarea_html textarea_html_to_text
	random_string str2hex hex2str program usage openfile openstr range_str
	needargs op shuffle cp
	uniqo
	);
#	sql_connect sql_dbh sql_command sql_query sql_query_hash sql_multi_query sql_multi_query_headers sql_multi_query_hash
use IO::File;
use IO::String;
#use DBI;
#use File::Copy;

use Carp;

use strict;

our $dbh;

sub slurp {
	my ($f) = @_;
	if (! ref $f) {
		$f = IO::File->new($f, "r") ||
			die "can't open file `$f' to read: $!";
	}
	local $/;
	return <$f>;
}

sub belch {
	my $f = $_[0];
	if (! ref $f) {
		$f = IO::File->new($f, "w") ||
			die "can't open file `$f' to write: $!";
	}
	print $f $_[1] or
		die "can't write to `$f': $!";
}

sub prod {
	# used to be called belch_if_changed
	if (! -e $_[0] || slurp($_[0]) ne $_[1]) {
		belch($_[0], $_[1]);
	}
}

sub p {
	@_ == 0 and @_ = ($_);
	$_="@_"; chomp;
	print "$_\n";
}

sub x {
	return join " ", map { sprintf("%02x", ord($_)) } split //, $_[0];
}

# warning, this `touch' will also `trunc'!
sub touch {
	open my $OUT, ">", $_[0];
	close $OUT;
}

sub odds {
  my $a = shift;
  my @r;
  for (my $i=0; $i<@$a; $i+=2) {
    push @r, $$a[$i];
  }
  return \@r;
}

sub evens {
  my $a = shift;
  my @r;
  for (my $i=1; $i<@$a; $i+=2) {
    push @r, $$a[$i];
  }
  return \@r;
}

# this function escapes tabs to \t, newlines to \n, null to \0, \ to \\, and undef to null
sub escape_tsv {
	my $v = shift;
	return "\0" unless defined $v;
	for ($v) {
		s/\\/\\\\/g;
		s/\t/\\t/g;
		s/\n/\\n/g;
		s/\0/\\0/g;
	}
	return $v;
}

sub unescape_tsv {
	my $v = shift;
	return undef if $v eq "\0";
	for ($v) {
		s/(?:(?<=[^\\])|^)((?:\\\\)*)\\0/$1\0/g;
		s/(?:(?<=[^\\])|^)((?:\\\\)*)\\n/$1\n/g;
		s/(?:(?<=[^\\])|^)((?:\\\\)*)\\t/$1\t/g;
		s/\\\\/\\/g;
	}
	return $v;
}

#sub sql_connect {
#    $dbh = DBI->connect(@_)
#	or die "can't connect to database: " . $DBI::errstr;
#    return $dbh;
#}
#
#sub sql_dbh {
#    return $dbh;
#}
#
#sub sql_command {
#    my $sth = $dbh->prepare(shift)
#	or croak("Cannot prepare: " . $dbh->errstr());
#    $sth->execute(@_)
#	or croak("Cannot execute: " . $sth->errstr());
#    $sth->finish();
#}
#
#sub sql_query {
#    my $sth = $dbh->prepare(shift)
#	or croak("Cannot prepare: " . $dbh->errstr());
#    $sth->execute(@_)
#	or croak("Cannot execute: " . $sth->errstr());
#    my $ary_ref = $sth->fetchrow_arrayref;
#    $sth->finish();
#    return $ary_ref;
#}
#
#sub sql_query_hash {
#    my $sth = $dbh->prepare(shift)
#	or croak("Cannot prepare: " . $dbh->errstr());
#    $sth->execute(@_)
#	or croak("Cannot execute: " . $sth->errstr());
#    my $hash_ref = $sth->fetchrow_hashref;
#    $sth->finish();
#    return $hash_ref;
#}
#
#sub sql_multi_query {
#    my $sth = $dbh->prepare(shift)
#	or croak("Cannot prepare: " . $dbh->errstr());
#    $sth->execute(@_)
#	or croak("Cannot execute: " . $sth->errstr());
#    my $ary_ref_ary_ref = $sth->fetchall_arrayref();
#    $sth->finish();
#    return $ary_ref_ary_ref;
#}
#
## TODO rename to sql_multi_query_names ?
#sub sql_multi_query_headers {
#    my $sth = $dbh->prepare(shift)
#	or croak("Cannot prepare: " . $dbh->errstr());
#    $sth->execute(@_)
#	or croak("Cannot execute: " . $sth->errstr());
#    my $names = $sth->{NAME};
#    my $ary_ref_ary_ref = $sth->fetchall_arrayref();
#    unshift @$ary_ref_ary_ref, $names;
#    $sth->finish();
#    return $ary_ref_ary_ref;
#}
#
#sub sql_multi_query_hash {
#	my $ary_ref_ary_ref = sql_multi_query_headers(@_);
#	my $names = shift @$ary_ref_ary_ref;
#	my $n = @$names;
#	my @results;
#	for my $row (@$ary_ref_ary_ref) {
#		my %hash;
#		for (my $i; $i<$n; ++$i) {
#			$hash{$names->[$i]} = $row->[$i];
#		}
#		push @results, \%hash;
#	}
#	return \@results;
#}

sub mtime {
	my ($filename) = @_;
	return (stat($filename))[9];
}

use File::Basename;

sub rmpath {
	my ($dir) = @_;
	# this should be in File::Path, does an rmdir -p
	rmdir($dir) and
		rmpath(dirname($dir));
}

sub min {
	my $min = shift;
	for (@_) {
		$min = $_ if $_ < $min;
	}
	return $min
}

sub max {
	my $max = shift;
	for (@_) {
		$max = $_ if $_ > $max;
	}
	return $max
}

sub In {
	my ($e, $l) = @_;
	$l eq "the universe!" and
		return 1;
	for (@$l) {
		$_ eq $e and
			return 1;
	}
	return 0;
}

sub Or {
	if (@_ == 2) {
		my ($l1, $l2) = @_;
		$l1 eq "the universe!" || $l2 eq "the universe!" and
			return "the universe!";
		my @ret = @$l1;
		for (@$l2) {
			In($_, $l1) or
				push @ret, $_;
		}
		return \@ret;
	}
	if (@_ > 2) { return Or(Or(shift, shift), @_); }
	if (@_ == 1) { return [@{$_[0]}] }
	if (@_ == 0) { return [] }
}

sub And {
	if (@_ == 2) {
		my ($l1, $l2) = @_;
		$l1 eq "the universe!" and
			return $l2;
		$l2 eq "the universe!" and
			return $l1;
		my @ret;
		for (@$l1) {
			In($_, $l2) and
				push @ret, $_;
		}
		return \@ret;
	}
	if (@_ > 2) { return And(And(shift, shift), @_); }
	if (@_ == 1) { return [@{$_[0]}] }
	if (@_ == 0) { return "the universe!" }
}

sub Sub {
	my ($l1, $l2) = @_;
	$l1 eq "the universe!" and
		die "sorry can't sub from the universe yet!";
	$l2 eq "the universe!" and
		return [];
	my @ret;
	for (@$l1) {
		In($_, $l2) or
			push @ret, $_;
	}
	return \@ret;
}

# NOTE these don't handle all entities,
# should use the right module to help with this

# these seem to have become somewhat specialized for NIML - should move them there?

sub text_to_html {
	my ($text) = @_;
	for ($text) {
		s/&/&amp;/g;
		s/</&lt;/g;
		s/>/&gt;/g;
		s/"/&quot;/g;
		s/\n/<br>\n/g;
		# cope with lynx being bogus w.r.t multiple consecutive <br>s :
		s/\n<br>/\n&nbsp;<br>/g;
		s/(  +)/"&nbsp;" x (length($1)-1)." "/ge;
	}
	return $text;
}

sub html_to_text {
	my ($text) = @_;
	for ($text) {
		# cope with lynx being bogus w.r.t multiple consecutive <br>s :
		s/\n&nbsp;<br>/\n<br>/g;
		s/\r\n?/\n/g;
		s/\n/ /g;
		s/<br>/\n/g;
		s/&lt;/</g;
		s/&gt;/>/g;
		s/&quot;/"/g;
		s/&amp;/&/g;
		s/  +/ /g;
		s/&nbsp;/ /g;
	}
	return $text;
}

sub text_to_textarea_html {
	my ($text) = @_;
	for ($text) {
		s/&/&amp;/g;
		s/</&lt;/g;
		s/>/&gt;/g;
		s/"/&quot;/g;
	}
	$text .= "\n" unless $text =~ /\n\z/;
	return $text;
}

sub textarea_html_to_text {
	my ($text) = @_;
	for ($text) {
		s/&lt;/</g;
		s/&gt;/>/g;
		s/&quot;/"/g;
		s/&amp;/&/g;
	}
	if ($text !~ /\n\z/) {
		$text .= "\n";
	}
	return $text;
}

sub random_string {
	my ($length) = @_;
	my $s = "";
	for (my $i=0; $i<$length; ++$i) {
		$s .= chr(rand(256));
	}
	return $s;
}

sub str2hex {
	my ($s) = @_;
	return unpack("%H*", $s);
}

sub hex2str {
	my ($s) = @_;
	return pack("%H*", $s);
}

sub program {
	my $program = $0;
	$program =~ s,^.*/,,;
	return $program;
}

sub usage {
	my $program = program();
	die "usage: $program ".(join "", map "$_\n", @_);
}

sub openfile {
	return IO::File->new(@_) || die "can't openfile: @_";
}

sub openstr {
	return IO::String->new(@_) || die "can't open string!";
}

#TODO test and use this in any function that takes a "file"
sub op {
	my ($fh) = @_;
	if (!ref $fh) {
		$fh = openfile($fh);
	}
	return $fh;
}

# this is a localizable function!
sub range_str {
	my ($min, $max) = @_;
	if ($min == $max) { return $min; }
	else { return "$min-$max" }
}

sub needargs {
	my ($min, $max, @error) = @_;
	$max ||= $min;
	if (@ARGV < $min or $ARGV > $max) {
		my $range = str_range($min, $max);
		@error or @error = "needs ".str_range($min, $max)." arguments";
		usage @error;
	}
}

sub shuffle {
	my $ary = $_[0];
	my @out;
	while (@$ary) {
		my $i = int rand(@$ary);
		push @out, splice @$ary, $i, 1;
	}
	return \@out;
}

#sub cp {
#	return copy(@_);
#}

sub uniqo {
	my @res;
	my %already;
	for (@_) {
		if (!$already{$_}) {
			push @res, $_;
			$already{$_} = 1;
		}
	}
	return @res;
}

1
