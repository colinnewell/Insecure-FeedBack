use Test2::V0;

use Insecure::FeedBack;
use Test::WWW::Mechanize::PSGI;

my $app = Insecure::FeedBack->to_app;
my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

$mech->get_ok('/feedback');
$mech->content_contains('Feedback');
$mech->submit_form_ok(
    {
        fields => {
            'feedback' => 'This is just a test'
        }
    }
);
$mech->content_contains('This is just a test');

done_testing;
