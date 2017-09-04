requires "Bread::Board"               => "0";
requires "Crypt::CBC"                 => "0";
requires "Crypt::Eksblowfish::Bcrypt" => "0";
requires "Crypt::GeneratePassword"    => "0";
requires "Crypt::OpenSSL::AES"        => "0";
requires "Crypt::OpenSSL::AES"        => "0";
requires "Dancer2"                    => "0.205001";
requires "Dancer2::Plugin::CSRF"      => "0";
requires "DBIx::Class"                => "0";
requires "DBIx::Class::Candy"         => "0";
requires "DBIx::Class::EncodedColumn" => "0";
requires "DBIx::Class::TimeStamp"     => "0";
requires "Moo"                        => "0";
requires "strictures"                 => "2";
requires "Template::Alloy"            => "0";

recommends "CGI::Deurl::XS"   => "0";
recommends "HTTP::Parser::XS" => "0";
recommends "URL::Encode::XS"  => "0";
recommends "YAML"             => "0";

on "test" => sub {
    requires "HTTP::Request::Common"      => "0";
    requires "Test2::V0"                  => "0";
    requires "Test::WWW::Mechanize::PSGI" => "0";
    requires "Test::DBIx::Class"          => "0";
};
