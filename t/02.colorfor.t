#!/usr/local/bin/perl

use v5.12;
use warnings;

use Test::More;
eval {
    require Test::NoWarnings;
};
my $have_test_nowarnings = ! $@;

use Colorize qw(0.0.8 :all);

# Make sure we're not using solarized.
BEGIN {
    undef $ENV{SOLARIZED};
}

my @things = qw(0 1 2 3 4 5 0);
my @codes = map { color_code_for($_) } @things;
for (@codes) { $_ = "" unless defined }

foreach (@codes) {
    state $i = 0;
    like($_, qr/^\e\[38;5;\d+m$/,
        "Color for thing number $i ($things[$i])$_ is as expected\e[m"
    );
    $i++;
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

eval { set_code_for("bad","\e[we are bad") };
like($@, qr/Cannot use/,
    "We cannot send in weird characters to set_code_for"
);

my ($reallybad, $evil)  = ("really bad","\e[10Cwe are evil");

eval { set_escape_code_for($reallybad, $evil) };
is($@, "",
    "We can indeed send in weird characters in set_escape_code_for"
);

my $one = "one";
my $fg = "38;5;48";
set_code_for($one, $fg);
is (color_code_for($one), "\e[${fg}m",
    "Color code setting works for foreground"
);
is(color_code_for($reallybad), $evil,
    "Using set_escape_code_for sets the code"
);
is(colorized($reallybad), "${evil}${reallybad}\e[m",
    "Using colorized with what we set_escape_code_for is as expected"
);


# Example out of the docs:
my $gray_on_magenta = '48;5;128;38;5;232';
my $what = "This is gray on magenta or some such";
set_code_for(
    $what,
    $gray_on_magenta,
);
is(colorized($what), "\e[${gray_on_magenta}m$what\e[m",
    qq{"$what" is colored gray on magenta (or such)}
);

TODO: {
    local $TODO = "We don't actually do these yet";
}


if ($have_test_nowarnings) {
    no warnings "once";
    $Test::NoWarnings::do_end_test = 0;
    Test::NoWarnings::had_no_warnings();
}
done_testing;
