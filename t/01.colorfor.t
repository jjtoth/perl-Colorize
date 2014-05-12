#!/usr/local/bin/perl

use strict;
use warnings;

use 5.10.0;

use Test::Most;
use Test::NoWarnings "had_no_warnings";

use Colorize;
use Colorize qw(color_code_for);

my @codes = map { color_code_for($_) // "" } qw(0 1 2 3 4 5 0);

foreach (@codes) {
    like($_, qr/^\e\[38;5;\d+m$/,
        "Color for $_ is as expected"
    );
};

is($codes[0],$codes[-1],
    "Codes for the same thing are the same"
);
isnt($codes[0],$codes[1],
    "Codes for different things are different"
);

is(colorize(0), "$codes[0]0\e[m",
    "colorize() subroutine works as expected for one argument"
);
is(colorize(0, "Hi there!"), "$codes[0]Hi there!\e[m",
    "colorize() subroutine works as expected for two arguments"
);

my %seen;


$Test::NoWarnings::do_end_test = 0;
had_no_warnings;
done_testing;
