#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use Insecure::FeedBack;

Insecure::FeedBack->to_app;

use Plack::Builder;

builder {
    enable 'Deflater';
    Insecure::FeedBack->to_app;
}



=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use Insecure::FeedBack;
use Plack::Builder;

builder {
    enable 'Deflater';
    Insecure::FeedBack->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use Insecure::FeedBack;
use Insecure::FeedBack_admin;

builder {
    mount '/'      => Insecure::FeedBack->to_app;
    mount '/admin'      => Insecure::FeedBack_admin->to_app;
}

=end comment

=cut

