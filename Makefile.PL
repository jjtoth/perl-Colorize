use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Colorize',
    AUTHOR              => 'Jim Toth <jjtoth@vcu.edu>',
    VERSION_FROM        => 'lib/Colorize.pm',
    ABSTRACT_FROM       => 'lib/Colorize.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0.88,   # for "done_testing"
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Colorize-*' },
);
