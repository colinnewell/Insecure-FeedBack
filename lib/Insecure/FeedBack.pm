package Insecure::FeedBack;

# ABSTRACT: A site to demonstrate various security issues.

use Dancer2;
use Dancer2::Plugin::CSRF;
use Insecure::FeedBack::Container 'service';

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'Insecure::FeedBack' };
};

get '/feedback' => sub {
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

post '/feedback' => sub {
    my $csrf_token = param('csrf_token');
    if ( !$csrf_token || !validate_csrf_token($csrf_token) ) {
        redirect '/?error=invalid_csrf_token';
    }

    cookie 'test' =>
      service('Encryption')->encrypt( body_parameters->{feedback} );
    redirect '/feedback';
};

true;
