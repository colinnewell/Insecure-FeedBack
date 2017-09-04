use Test2::V0;
use Insecure::FeedBack::Container qw/service/;

# FIXME: this is a bit shady.
# messing with a test db that could be changed in dev.
# could do with a better solution, perhaps I should create
# the db and make use of the env var to load it?
my $db = service('AuthDB');
is $db->resultset('Users')->count, 1;

done_testing;
