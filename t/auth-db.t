use Test2::V0;
use Test::DBIx::Class { schema_class => 'Insecure::FeedBack::Schema', },
  'Users';

ok my $user = Users->create( { email => 'test@example.org', name => 'Test' } );
$user->update( { password => 'hash' } );
ok $user->check_password('hash');

done_testing;
