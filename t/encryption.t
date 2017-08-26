use Test2::V0;

use MIME::Base64;
use Insecure::FeedBack::Service::Encryption;

my $service = Insecure::FeedBack::Service::Encryption->new();
my $test_text = 'this is a fine bit of text to encrypt';
my $ct = $service->encrypt($test_text);
note $ct;
is $service->decrypt($ct), $test_text, 'Able to round trip';

# checking the same thing encrypted with the same
# key doesn't get encrypted to the same thing again.
isnt $service->encrypt($test_text), $ct, 'IV probably working as intended';

# FIXME: check corrupt message padding results in
# an exception.

done_testing;

