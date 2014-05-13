#!/usr/local/bin/perl

use strict;
use warnings;

use 5.10.0;

use Test::Most;
use Test::NoWarnings "had_no_warnings";

# Make it solarized:
BEGIN {
    $ENV{SOLARIZED} = 1;
}

use Colorize qw(color_code_for);

my %seen;
$seen{$_}++ for map { color_code_for($_) } 1..300;

# Make sure we *do* use the dark stuff when we're solarized.
ok($seen{"\e[38;5;16m"},
    "We include black (when we're solarized)"
);
ok($seen{"\e[38;5;17m"},
    "We include dark blue (when we're solarized)"
);

my @too_darn_bright = qw(244 46 226 51 231);

foreach (@too_darn_bright) {
    ok(! $seen{"\e[38;5;${_}m"},
        "We don't include color $_ when we're solarized"
    );
}



$Test::NoWarnings::do_end_test = 0;
had_no_warnings;
done_testing;
