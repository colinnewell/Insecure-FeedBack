use Test2::V0;
BEGIN { $ENV{INSECURE_FEEDBACK_AUTHDB} = 'dbi:SQLite:dbname=:memory:'; }
use Insecure::FeedBack::Container qw/service/;

my $db = service('AuthDB');
$db->deploy;
my $users = $db->resultset('Users');
ok $users->create(
    {
        email => 'test@blah.com',
        name  => 'test',
    }
);
is $users->count, 1;

done_testing;
