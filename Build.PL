use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Colorize',
    license             => 'VCU',
    dist_author         => 'Jim Toth <jjtoth@vcu.edu>',
    dist_version_from   => 'lib/Colorize.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Colorize-*' ],
);

$builder->create_build_script();
