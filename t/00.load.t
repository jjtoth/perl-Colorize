use Test::More;

use strict;
use warnings;

BEGIN {
    use_ok( 'Colorize' );
}

eval 'color_code_for("foo")';

like($@, qr/Undefined subroutine.*\bcolor_code_for/, 
    "We don't export color_code_for by default"
);


diag( "Testing Colorize $Colorize::VERSION" );

done_testing;
