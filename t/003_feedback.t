use Test2::V0;

use Insecure::FeedBack;
use MIME::Base64;
use Test::WWW::Mechanize::PSGI;
use URI::Escape;

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

# lets fudge the cookie and check we get an
# error
my $cookie =
  $mech->{cookie_jar}->{COOKIES}->{'localhost.local'}->{'/'}->{test}->[1];
my $data = decode_base64( uri_unescape($cookie) );
$data =~ s/.$/X/;
$mech->{cookie_jar}->{COOKIES}->{'localhost.local'}->{'/'}->{test}->[1] =
  uri_escape( encode_base64($data) );
$mech->get('/feedback');
$mech->content_contains('Invalid padding bytes');

done_testing;
