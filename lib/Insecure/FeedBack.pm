package Insecure::FeedBack;

# ABSTRACT: A site to demonstrate various security issues.

use Dancer2;

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'Insecure::FeedBack' };
};

true;
