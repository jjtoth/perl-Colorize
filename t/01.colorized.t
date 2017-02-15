#!/usr/local/bin/perl

use strict;
use warnings;

use Test::More;
eval {
    require Test::NoWarnings;
};
my $have_test_nowarnings = ! $@;


use Colorize;

my $colorized_of_XXX = colorized("XXX");
my $colorized_re = qr/^(\e\[38;5;\d+m)XXX\e\[m$/;

like($colorized_of_XXX, $colorized_re,
    "Colorization is as expected"
);

my ($code) = $colorized_of_XXX =~ $colorized_re;
# Evidentally, we can't say "$code = $1;" and expect like() to capture.

is(colorized("XXX", "foo"), "${code}foo\e[m",
    "Colorization recolors as expected"
);

if ($have_test_nowarnings) {
    no warnings "once";
    $Test::NoWarnings::do_end_test = 0;
    Test::NoWarnings::had_no_warnings();
}
done_testing;
