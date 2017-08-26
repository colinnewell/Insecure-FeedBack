use Test2::V0;

use Insecure::FeedBack::Service::Passwords;
my $srv = Insecure::FeedBack::Service::Passwords->new({ min => 10, max => 20 });
my $pw = $srv->generate_password;
isnt $pw, $srv->generate_password, 'Check it\'s not obviously broken';

done_testing;
