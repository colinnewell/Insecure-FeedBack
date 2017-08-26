package Insecure::FeedBack::Service::Encryption;

use Moo;
use Crypt::CBC;
use MIME::Base64;

has key => (is => 'ro', lazy => 1, builder => '_build_key');

sub _build_key
{
    Crypt::CBC->random_bytes(32);
}

sub encrypt
{
    my $self = shift;
    my $text = shift;
    my $iv = Crypt::CBC->random_bytes(16);
    my $cipher = Crypt::CBC->new(
            -key         => $self->key,
            -iv          => $iv,
            -cipher      => 'OpenSSL::AES',
            -literal_key => 1,
            -header      => "none",
            -padding     => "standard",
      );
    my $encrypted = $cipher->encrypt($text);
    return encode_base64($iv . $encrypted);
}

sub decrypt
{
    my ($self, $encrypted) = @_;
    my $bin = decode_base64($encrypted);
    my $iv = substr($bin, 0, 16);
    my $ct = substr($bin, 16);
    my $cipher = Crypt::CBC->new(
            -key         => $self->key,
            -iv          => $iv,
            -cipher      => 'OpenSSL::AES',
            -literal_key => 1,
            -header      => "none",
            -padding     => sub {
                my ($b,$bs,$decrypt) = @_;
                my $r = Crypt::CBC::_standard_padding($b, $bs, $decrypt);
                # if the padding is corrupt the message probably is,
                # may as well deal with that sooner rather than later
                die 'Bad padding' if $b eq $r;
                return $r;
            },
      );
    my $pt = $cipher->decrypt($ct);
    return $pt;
}


1;
