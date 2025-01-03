package Colorize;

use warnings;
use strict;
use Carp;

use version;
our $VERSION = qv('0.0.8');

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(colorized); ## no critic -- [Since this module only exists for this.]
our @EXPORT_OK = qw(color_code_for set_code_for set_escape_code_for colorized has_color);
our %EXPORT_TAGS;

push @{$EXPORT_TAGS{all}}, @EXPORT_OK;

my $reset = "\e[m";

=head1 NAME

Colorize - Colorize things uniquely.


=head1 VERSION

This document describes Colorize version 0.0.7


=head1 SYNOPSIS

    use Colorize;

    print "Not " . colorized("invented") . " here.";


=head2 colorized

print for map { colorized($_) . " " }
    qw(This isn't a good example but it's an example anyway);

    Gives each word its own color (so the two "example"'s will be give the same color

colorized("relevant","everything here");

    Colorizes "everything here" as above, but uses "relevant" for its code.

=cut

sub colorized {
    @_ = (@_,@_) if @_ == 1;
    return color_code_for($_[0]) . $_[1] . $reset;
}

=head2 color_code_for,has_color

use Colorize qw(color_code_for set_code_for set_escape_code_for);
# or just
# use Colorize qw(:all);
print color_code_for("frobinizeer");

    Returns the ANSI code we've assigned to "frobinizeer", setting it if it
    doesn't already exist.

if (! has_color("foo")) {
    say "we haven't colorized foo yet";
}

    Tests if something is colored *without* adding a colorization to it if it
    doesn't have one.  (But the truthy value it returns if there is one is the
    assigned color code).

=head2 set_code_for,set_escape_code_for

    Added in Colorize .007.  Must be imported explicitly (or with "use Colorize qw(:all);")

my $what = "This is gray on magenta or some such";
set_code_for(
    $what,
    "48;5;128;38;5;232",
);

    Sets the ANSI code for $what.  Must be color parameters only

set_escape_code_for(
    $what,
    "\e[48;5;128;38;5;232m",
);

    Same thing, but takes the escape codes explicitly.


=cut

my %num_for;
my $inc = 55;
my $first = 73;
# These look pretty good both solarized and non.  This should be configurable,
# however.

my $cur_num;
$cur_num = $first - 16 - $inc;
# 16 is the magic number, sorry.  That's where the 6x6x6 color cube begins.

sub __next_code {
    do {
        $cur_num += $inc;
        $cur_num %= 216;
    } while (
        ($ENV{SOLARIZED} and __brightness($cur_num) > 0.6 )
        or
        (! $ENV{SOLARIZED} and __brightness($cur_num) < 0.08)
    );
    return "\e[38;5;" .  ($cur_num + 16) . "m";
}


# Returns the approximate brightness, assuming we're using the current HDTV
# standard. Cribbed from the "HSL and HSV" wikipedia page.
sub __brightness {
    my $fg = shift;
    # Turn into rgb coordinates (assuming we're in a 6x6x6 cube -- except
    # really more like 7x7x7 because we jump from 0 to 2, basically)
    my ($r, $g, $b);
    foreach ($b, $g, $r) {
        $_ = $fg % 6;
        $fg = int($fg / 6);

    # Then normalize to a 1x1x1 cube.
        $_++ if $_;
        $_ /= 7;
    }
    my $Y_709 = 0.21*$r + 0.72*$g + 0.07*$b;
    return $Y_709;
}

sub set_code_for {
    my ($thing, $code) = @_;
    croak "Cannot use escape codes with set_code_for"
        unless $code =~ /^[0-9;]+$/;
    set_escape_code_for($thing,"\e[${code}m");
    return;
}

sub set_escape_code_for {
    my ($thing, $code) = @_;
    $num_for{$thing} = $code;
    return;
}

sub color_code_for {
    my ($thing) = @_;
    return $num_for{$thing} ||= __next_code;
}

sub has_color {
    my ($thing) = @_;
    return unless $num_for{$thing};
    return color_code_for($thing);
}

1; # Magic true value required at end of module
__END__

=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 EXAMPLE

    use Colorize "c";   # Itsy bitsy alias.  Not actually in existence...

    # Initialize so that we always have the same few things have the same
    # colors every time.

    colorized($_) for qw(noun verb adj);

    say
        c(qw(noun Here)),
        c(qw(verb is)),
        c(qw(adj a)),
        c(qw(adj bad)),
        c(qw(noun example));

=cut


=head1 INTERFACE

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.

Colorize requires no configuration files.

If an environment variable called SOLARIZED exists (and is truthy -- e.g., "1"),
then we assume we have a bright background and will choose colors for that.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-colorize@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Jim Toth  C<< <jjtoth@vcu.edu> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2014, Jim Toth C<< <jjtoth@vcu.edu> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
