use Test2::V0;

use MIME::Base64;
use Insecure::FeedBack::Service::Encryption;

my $service   = Insecure::FeedBack::Service::Encryption->new();
my $test_text = 'this is a fine bit of text to encrypt';
my $ct        = $service->encrypt($test_text);
note $ct;
is $service->decrypt($ct), $test_text, 'Able to round trip';

# checking the same thing encrypted with the same
# key doesn't get encrypted to the same thing again.
isnt $service->encrypt($test_text), $ct, 'IV probably working as intended';

like $service->hex_key, qr/^[a-f0-9]+$/, 'hex key produced';

$service   = Insecure::FeedBack::Service::Encryption->new({hex_key => 'c0d1b2956465d9737f8b8b55cc62d8470df2ee89faee5cb3115fe110ea9c31b6'});
is $service->key, D(), 'Key produced okay';

# FIXME: check corrupt message padding results in
# an exception.

done_testing;

