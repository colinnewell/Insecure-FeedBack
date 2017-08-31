use Test2::V0;

use Insecure::FeedBack::Container qw/service/;

my $srv = service('Passwords');
my $pw  = $srv->generate_password;
for ( 1 .. 10 ) {
    isnt $pw, $srv->generate_password, 'Check it\'s not obviously broken';
}

done_testing;
