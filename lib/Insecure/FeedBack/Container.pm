package Insecure::FeedBack::Container;

use strict;
use warnings;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(service);

use Bread::Board;

my $services = container 'Services' => as {

    service AuthDB => (
        block => sub {
            my $s = shift;
            require Insecure::FeedBack::Schema;
            return Insecure::FeedBack::Schema->connect(
                $s->param('connection_string'), $s->param('username'),
                $s->param('password'),          $s->param('options'),
            ) || die 'Failed to connect';
        },
        dependencies => {
            connection_string => '/Config/authdb',
            username          => '/Config/authdb.username',
            password          => '/Config/authdb.password',
            options           => '/Config/authdb.options',
        },
    );

    service 'Encryption' => (
        class        => 'Insecure::FeedBack::Service::Encryption',
        dependencies => {
            hex_key => '/Config/key',
        },
    );

    service 'Passwords' => (
        class        => 'Insecure::FeedBack::Service::Passwords',
        dependencies => {
            min => '/Config/passwords.min',
            max => '/Config/passwords.max',
        },
    );
};

Bread::Board::set_root_container($services);

my $config = container 'Config' => as {};

# openssl rand -hex 32
my %defaults = (
    authdb => 'dbi:SQLite:auth.db',
    key => '65db976cb7385de5a2d48d8993d2f94d580a05a6153ebdc37ce267b6da9cef64',
    'passwords.max' => 20,
    'passwords.min' => 10,
);

# Look for config in env or use the defaults above.
for my $key (
    qw/key passwords.min passwords.max authdb authdb.username
    authdb.password authdb.options/
  )
{
    my $ekey = 'INSECURE_FEEDBACK_' . uc( $key =~ s/\./_/gr );
    $config->add_service( service $key => $ENV{$ekey} // $defaults{$key} );
}

# An alernative might be to load a config file
# and turn config sections into sub containers.

no Bread::Board;    # removes keywords

sub service {
    return $services->resolve( service => shift, @_ );
}

1;
