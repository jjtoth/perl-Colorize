#!/usr/local/bin/perl

use v5.12;
use warnings;

use Test::More;
eval {
    require Test::NoWarnings;
};
my $have_test_nowarnings = ! $@;

use Colorize qw(0.0.8 colorized has_color color_code_for);

ok ! has_color("Frob"), "Frob doesn't have a color yet";
ok ! has_color("Frob"), "Frob still doesn't have a color";
my $code = color_code_for("Frob");
ok has_color("Frob"), "Frob has a color now";
is has_color("Frob"), $code, qq{Frob's color is @{[quotemeta $code]}, and that's what has_color("Frob") returns.}; 

if ($have_test_nowarnings) {
    no warnings "once";
    $Test::NoWarnings::do_end_test = 0;
    Test::NoWarnings::had_no_warnings();
}

done_testing;
