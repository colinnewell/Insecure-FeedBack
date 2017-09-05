use Test2::V0;

use Insecure::FeedBack;
use Plack::Test;
use HTTP::Request::Common;

my $app = Insecure::FeedBack->to_app;
is( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create($app);

subtest 'Check a split test cookie is generated' => sub {
    my $res = $test->request( GET '/signup' );

    ok( $res->is_success, '[GET /signup] successful' );

    # check we have been given a split test cookie.
    like [ $res->header('set-cookie') ], [qr/split_test=\d-/];
};

subtest 'Split test showing name' => sub {
    my $res = $test->request( GET '/signup',
        Cookie => 'split_test=0-0.0574763587799225' );
    ok( $res->is_success, '[GET /signup] successful' );
    unlike $res->content, qr'Name';
};

subtest 'Split test showing name' => sub {
    my $res = $test->request( GET '/signup',
        Cookie => 'split_test=1-0.0574763587799225' );
    ok( $res->is_success, '[GET /signup] successful' );
    like $res->content, qr'Name';
};

done_testing;
