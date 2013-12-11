use warnings;
use strict;
use Test::More;
use JSON::Parse qw/valid_json validate_json/;

# https://github.com/benkasminbullock/JSON-Parse/issues/2

my $fdegir1 = <<'EOF';
{
"gav": {
"groupId": "mygroup",
"artifactId": "myartifact"
"version": "1.0"
}
}
EOF

ok (! valid_json ($fdegir1));
eval {
    validate_json ($fdegir1);
};
ok ($@, "validate_json dies");
like ($@, qr/line 5/i, "line number OK");

my $empty = '  ';
run_fail_like ($empty, qr/empty input/i);

my $undef = undef;
ok (! valid_json ($undef));
eval {
    no warnings 'uninitialized';
    validate_json ($undef);
    use warnings 'uninitialized';
};
ok ($@, "undef input dies");
like ($@, qr/empty input/i, "flagged as empty input");

# Test comma and colon parsing.

my $stray_comma = qr/stray comma/i;
my $unknown_character = qr/unknown character/i;
my $illegal_trailing_comma = qr/illegal trailing comma/i;
my $bad_comma_1 = '{,"bad":"bad"}';
run_fail_like ($bad_comma_1, $stray_comma);
my $bad_comma_array = '[,"bad","bad"]';
run_fail_like ($bad_comma_array, $stray_comma);
my $bad_comma_2 = '{"bad",:"bad"}';
run_fail_like ($bad_comma_2, $unknown_character);
my $bad_comma_3 = '{"bad":,"bad"}';
run_fail_like ($bad_comma_3, $unknown_character);
my $bad_comma_4 = '{"bad":"bad",}';
run_fail_like ($bad_comma_4, $illegal_trailing_comma);
my $bad_comma_5 = '["bad","bad",]';
run_fail_like ($bad_comma_5, $illegal_trailing_comma);
my $no_comma_array = '["bad" "bad"]';
run_fail_like ($no_comma_array, $unknown_character);
# Single-element array OK
run_ok ('["bad"]');
# Empty array OK
run_ok ('[]');

TODO: {
    local $TODO = 'known bugs';
};
done_testing ();

sub run_fail_like
{
    my ($json, $expected) = @_;
    my $error = run_fail ($json);
    like ($error, $expected,
	  "Got expected error '$expected' parsing '$json'");
}

sub run_fail
{
    my ($json) = @_;
    ok (! valid_json ($json), "Parsing of '$json' with 'valid_json' failed");
    eval {
	validate_json ($json);
    };
    ok ($@, "Parsing of '$json' with 'validate_json' failed");
    return $@;
}

sub run_ok
{
    my ($json) = @_;
    ok (valid_json ($json), "Parsing of '$json' with 'valid_json' succeeded");
    eval {
	validate_json ($json);
    };
    ok (! $@, "Parsing of '$json' with 'validate_json' succeeded");
}
