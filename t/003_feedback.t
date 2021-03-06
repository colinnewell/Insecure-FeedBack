use Test2::V0;

use Insecure::FeedBack;
use MIME::Base64;
use Test::WWW::Mechanize::PSGI;
use URI::Escape;

my $app = Insecure::FeedBack->to_app;
my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

subtest 'Not logged in' => sub {

    $mech->get_ok('/feedback');

    # should get bounced to login.
    is $mech->base,
      'http://localhost/login?return_url=http%3A%2F%2Flocalhost%2Ffeedback';

};

subtest 'Bad login attempts' => sub {
    $mech->submit_form_ok(
        {
            fields => {
                user     => 'test@example.org',
                password => 'badpass',
            }
        },
        'Bad password'
    );
    $mech->content_like(qr'Error');

    $mech->submit_form_ok(
        {
            fields => {
                user     => 'bad@example.org',
                password => 'badpass',
            }
        },
        'Bad user'
    );
    $mech->content_like(qr'Error');

};

subtest 'Log in' => sub {
    $mech->submit_form_ok(
        {
            fields => {
                user     => 'test@example.org',
                password => 'hash',
            }
        },
        'Login'
    );
    $mech->content_unlike(qr'Error');
};

subtest 'Submit feedback' => sub {

    $mech->get_ok('/feedback');
    is $mech->base, 'http://localhost/feedback';
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

};

subtest 'Log out' => sub {

    $mech->get_ok('/logout');
    is $mech->base, 'http://localhost/';

    $mech->get_ok('/feedback');

    # should get bounced to login.
    is $mech->base,
      'http://localhost/login?return_url=http%3A%2F%2Flocalhost%2Ffeedback';

};

subtest 'Invalid signup attempt' => sub {

    $mech->get_ok('/signup');
    $mech->submit_form_ok(
        {
            fields => {
                user => 'test@badactor.com'
            }
        }
    );
    $mech->content_like(qr'Error');

};

subtest 'Sign up a user' => sub {
    $mech->get_ok('/signup');
    $mech->submit_form_ok(
        {
            fields => {
                user => 'test@bigcorp.com'
            }
        }
    );
    $mech->content_like(qr'email has been sent');
};

subtest 'Sign up existing user' => sub {
    $mech->get_ok('/signup');
    $mech->submit_form_ok(
        {
            fields => {
                user => 'test@bigcorp.com'
            }
        }
    );
    $mech->content_like(qr'email has been sent');
};

done_testing;
