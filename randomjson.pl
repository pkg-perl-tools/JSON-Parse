#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use lib 'blib/lib';
use lib 'blib/arch';
use JSON::Parse;

for (0..20) {
    JSON::Parse::random_json ();
}
