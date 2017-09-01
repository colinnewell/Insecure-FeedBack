package Insecure::FeedBack;

# ABSTRACT: A site to demonstrate various security issues.

use Dancer2;
use Insecure::FeedBack::Container 'service';

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'Insecure::FeedBack' };
};

get '/feedback' => sub {
    my $previous_feedback = cookie('feedback');
    my $feedback = '';
    if($previous_feedback) {
        $feedback = service('Encryption')->decrypt($previous_feedback->value);
    }
    template 'feedback' => {
        feedback => $feedback,
    };
};

post '/feedback' => sub {
    cookie 'feedback' => service('Encryption')->encrypt(body_parameters->{feedback});
    redirect '/feedback';
};

true;
