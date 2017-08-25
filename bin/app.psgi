#!/usr/bin/env perl

# PODNAME: app.psgi

use strict;
use warnings;
use FindBin;
use Insecure::FeedBack;
use lib "$FindBin::Bin/../lib";

use Plack::Builder;

builder {
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

