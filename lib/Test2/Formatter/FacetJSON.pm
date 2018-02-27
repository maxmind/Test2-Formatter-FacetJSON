package Test2::Formatter::FacetJSON;

use strict;
use warnings;

use parent 'Test2::Formatter';

use JSON::PP;

our $VERSION = '1.0000';

my $coder = JSON::PP->new;

# always output in ascii to avoid encoding issues
$coder->ascii;

# pretty print, and sort keys
$coder->pretty->canonical;

# Are the facets just plain old data structures?  When I asked Chad he said:
#  "The core facets are, other tools, such as the harness can do
#     what they want. "
# ...so handle this as gracefully as we can
$coder->allow_blessed;

use Data::Dumper;

sub new { return bless {}, shift }

sub write {
    my $self  = shift;
    my $event = shift;
    print $coder->encode( $event->facet_data );
}

# ignore all of this - we're print ascii no matter what!
sub encoding { return; }

1;

=head1 NAME

Test2::Formatter::FacetJSON - print facet data as JSON

=head1 SYNOPSIS

    # directly use the formatter when running a test
    shell$ T2_FORMATTER=FacetJSON perl test.t

    # use the formatter when running a test suite with yath
    shell$ yath test --formatter FacetJSON

=head1 DESCRIPTION

A very simple Test2::Formatter that prints out the facet data for each event as
pretty-printed canonically sorted JSON.

Designed for debugging, this is very similar to using the C<-L> option to
C<yath>, except:

=over

=item This is a standard formatter meaning output goes to STDOUT not a log file.

=item This pretty-prints the JSON making it (hopefully) easier to read.

=item The JSON only includes the facet data, not any other metadata.

=back

=head1 SEE ALSO

L<Test2::Formatter>, L<App::Yath>.
