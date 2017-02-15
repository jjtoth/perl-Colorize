#!/usr/local/bin/perl

use strict;
use warnings;

use Test::More;
eval {
    require Test::NoWarnings;
};
my $have_test_nowarnings = ! $@;

use Colorize qw(color_code_for);

# Make sure we're not using solarized.
BEGIN {
    undef $ENV{SOLARIZED};
}

my @codes = map { color_code_for($_) } qw(0 1 2 3 4 5 0);
for (@codes) { $_ = "" unless defined }

foreach (@codes) {
    like($_, qr/^\e\[38;5;\d+m$/,
        "Color for $_ is as expected\e[m"
    );
};

is($codes[0],$codes[-1],
    "Codes for the same thing are the same"
);
isnt($codes[0],$codes[1],
    "Codes for different things are different"
);

is(Colorize::colorized(0), "$codes[0]0\e[m",
    "colorized() subroutine works as expected for one argument"
);
is(Colorize::colorized(0, "Hi there!"), "$codes[0]Hi there!\e[m",
    "colorized() subroutine works as expected for two arguments"
);

my %seen;
$seen{$_}++ for @codes;

# Now.  Generate lots of things:
$seen{$_}++ for map { color_code_for($_) } 6..300;

{
    local $TODO = "We're not doing backgrounds yet.";
    is(0 + keys %seen, 301, "We use backgrounds for uniqueness");
}

# Make sure we're not using icky dark blue (unless we're solarized).
ok(! $seen{"\e[38;5;16m"},
    "We don't include black (when we're not solarized)"
);
ok(! $seen{"\e[38;5;17m"},
    "We don't include dark blue (when we're not solarized)"
);

my @bright = qw(196 46 226 51 231);

foreach (@bright) {
    ok($seen{"\e[38;5;${_}m"},
        "We include color $_ when we're not solarized"
    );
}



if ($have_test_nowarnings) {
    no warnings "once";
    $Test::NoWarnings::do_end_test = 0;
    Test::NoWarnings::had_no_warnings();
}
done_testing;
