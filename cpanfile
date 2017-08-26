requires "Crypt::CBC" => "0";
requires "Crypt::GeneratePassword" => "0";
requires "Crypt::OpenSSL::AES" => "0";
requires "Crypt::OpenSSL::AES" => "0";
requires "Dancer2" => "0.205001";
requires "Moo" => "0";
requires "strictures" => "2";

recommends "CGI::Deurl::XS"   => "0";
recommends "HTTP::Parser::XS" => "0";
recommends "URL::Encode::XS"  => "0";
recommends "YAML"             => "0";

on "test" => sub {
    requires "HTTP::Request::Common" => "0";
    requires "Test2::V0"             => "0";
};
