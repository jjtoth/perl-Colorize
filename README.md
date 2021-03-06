perl-Colorize
=============

Perl module for (semi-randomly) colorizing strings


Colorize is intended to give colorization without worrying about what the
colors "ought" to be.  Use Term::ANSIColors for that.

Example:

    use Colorize;

    print for map { colorized($_) . " " }
        qw(This isn't a good example but it's an example anyway);
    print "\n"

will print all the words in their own color (so the two "example"'s will be
given the same color).

We assume that you have a terminal that supports 256 colors.  That said, after
assigning 200ish colors, we start back at the begining.  (Using different
backgrounds is a future feature).

    colorized("thing");

Gives "thing" it's own unique color and surrounds it with the proper ANSI
codes.

    colorized("relevant","everything here");

Colorizes "everything here" based on the unique color for "relevant".

    color_code_for("thing")

Returns the ANSI code we've assigned to "thing".

INSTALLATION

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

Alternatively, to install with Module::Build, you can use the following commands:

	perl Build.PL
	./Build
	./Build test
	./Build install


DEPENDENCIES

None.


COPYRIGHT AND LICENCE

Copyright (C) 2014, Jim Toth

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
