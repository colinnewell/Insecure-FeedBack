use Test2::V0;

use Insecure::FeedBack::Container qw/service/;

my $passwords = service('Passwords');
is $passwords->min, 10;
is $passwords->max, 20;

done_testing;
