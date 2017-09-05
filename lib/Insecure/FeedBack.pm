package Insecure::FeedBack;

# ABSTRACT: A site to demonstrate various security issues.

use Dancer2;
use Dancer2::Plugin::Auth::Tiny;
use Dancer2::Plugin::CSRF;
use Insecure::FeedBack::Container 'service';

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'Insecure::FeedBack' };
};

get '/signup' => sub {

    # doing a split test with whether we get more
    # sign ups when we display the name.
    my $split_test_cookie = cookie('split_test');
    my $name_test;
    if ($split_test_cookie) {

        # only care about the number at the start
        ($name_test) = $split_test_cookie->value =~ /^(\d)-/;
    }
    else {
        # lets generate one.
        my $r = rand;
        $name_test = ( $r * 10 ) % 2;

        # store $r in case we need to debug.
        cookie 'split_test' => "$name_test-$r";
    }
    template 'signup' => {
        csrf_token => get_csrf_token(),
        name_test  => $name_test,
    };
};

post '/signup' => sub {
    my $email = body_parameters->{user};
    unless ( $email =~ /\@bigcorp\.com$/ ) {
        return template 'signup' => {
            csrf_token => get_csrf_token(),
            error => 'Only @bigcorp.com addresses can be used for sign up.',
        };
    }

    # create the user.
    my $users    = service('AuthDB')->resultset('Users');
    my $password = service('Passwords')->generate_password;
    eval {
        my $user = $users->create(
            {
                email    => $email,
                name => body_parameters->{name} || undef,
                password => $password
            }
        );
    };
    if ( $@ =~ /UNIQUE/ ) {

        # FIXME: send a password reminder email instead.
    }

    # TODO: send a sign up email with the password
    template 'signup-sent' => { signup_email => $email, };
};

get '/login' => sub {
    template 'login' => {
        csrf_token => get_csrf_token(),
        return_url => params->{return_url},
    };
};

post '/login' => sub {
    if ( _is_valid( params->{user}, params->{password} ) ) {
        my $return_url = params->{return_url};

        # NOTE: there is a bug here, the plugin
        # we're using returns full urls not relative
        # so we will always reject these.
        unless ( $return_url =~ m|^/| ) {
            $return_url = '/';
        }
        session user => params->{user};
        return redirect $return_url;
    }
    else {
        template 'login' => {
            csrf_token => get_csrf_token(),
            error      => "invalid username or password",
            return_url => params->{return_url},
        };
    }
};

get '/logout' => sub {
    session user => undef;
    return redirect '/';
};

sub _is_valid {
    my ( $user, $password ) = @_;

    my $users = service('AuthDB')->resultset('Users');
    if ( my $user = $users->find( { email => $user } ) ) {
        return $user->check_password($password);
    }
    return 0;
}

get '/feedback' => needs login => sub {
    my $previous_feedback = cookie('test');
    my $feedback          = '';
    if ($previous_feedback) {
        $feedback = service('Encryption')->decrypt( $previous_feedback->value );
    }
    template 'feedback' => {
        csrf_token => get_csrf_token(),
        feedback   => $feedback,
    };
};

post '/feedback' => needs login => sub {
    my $csrf_token = param('csrf_token');
    if ( !$csrf_token || !validate_csrf_token($csrf_token) ) {
        redirect '/?error=invalid_csrf_token';
    }

    cookie 'test' =>
      service('Encryption')->encrypt( body_parameters->{feedback} );
    redirect '/feedback';
};

true;
