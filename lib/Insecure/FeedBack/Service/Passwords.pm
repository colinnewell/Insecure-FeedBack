package Insecure::FeedBack::Service::Passwords;

use Moo;
use strictures 2;
use Crypt::GeneratePassword qw(chars word);

has [qw/min max/] => ( is => 'ro', required => 1 );

sub generate_password {
    my $self = shift;
    return chars( $self->min, $self->max );
}

1;

