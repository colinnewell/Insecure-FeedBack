package Insecure::FeedBack::Container;

use strict;
use warnings;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(service);

use Bread::Board;

my $services = container 'Services' => as {

    service 'Encryption' => (
        class => 'Insecure::FeedBack::Service::Encryption',
        dependencies => {
            key => '/Config/key',
        },
    );

    service 'Passwords' => (
        class => 'Insecure::FeedBack::Service::Passwords',
        dependencies => {
            min => '/Config/passwords.min',
            max => '/Config/passwords.max',
        },
    );
};

Bread::Board::set_root_container($services);

my $config = container 'Config' => as {};

my %defaults = (
    key => 'test',
    'passwords.max' => 20,
    'passwords.min' => 10,
);

# Look for config in env or use the defaults above.
for my $key (qw/key passwords.min passwords.max/)
{
    my $ekey = 'INSECURE_FEEDBACK_' . uc ($key =~ s/\./_/gr);
    $config->add_service(service $key => $ENV{$ekey} // $defaults{$key});
}
# An alernative might be to load a config file
# and turn config sections into sub containers.

no Bread::Board; # removes keywords

sub service
{
    return $services->resolve(service => shift, @_);
}
 
 
1;
