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

my $config = container 'Config' => as {
    service key => 'test';
    service 'passwords.min' => 10;
    service 'passwords.max' => 20;
};

no Bread::Board; # removes keywords

sub service
{
    $DB::single = 1;
    return $services->resolve(service => shift, @_);
}
 
 

