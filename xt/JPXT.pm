package JPXT;
use warnings;
use strict;
use utf8;
use Carp;
use Test::More;
use JSON::Parse ':all';
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = (qw/daft_test/,  @Test::More::EXPORT, @JSON::Parse::EXPORT_OK);

# Set all the file handles to UTF-8

my $builder = Test::More->builder;
binmode $builder->output,         ":encoding(utf8)";
binmode $builder->failure_output, ":encoding(utf8)";
binmode $builder->todo_output,    ":encoding(utf8)";
binmode STDOUT, ":encoding(utf8)";
binmode STDERR, ":encoding(utf8)";

sub import
{
    my ($class) = @_;

    strict->import ();
    utf8->import ();
    warnings->import ();
    Test::More->import ();
    JSON::Parse->import (':all');
    JPXT->export_to_level (1);
}

# Skip the tests of the JSON Test Suite where it says that JSON
# parsers should process broken UTF-8. See module documentation for
# discussion.

sub daft_test
{
    my ($y) = @_;
    if ($y =~ /FFF[EF]/ || $y =~ /FDD0/ || $y =~ /surrogates/ ||
	$y =~ /noncharacter/) {
	note ("Skipping test '$y' which requires us to process broken UTF-8");
	return 1;
    }
    return undef;
}

1;
