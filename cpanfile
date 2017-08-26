requires "Dancer2" => "0.205001";
requires "Crypt::CBC" => "0";
requires "Crypt::OpenSSL::AES" => "0";

recommends "YAML"             => "0";
recommends "URL::Encode::XS"  => "0";
recommends "CGI::Deurl::XS"   => "0";
recommends "HTTP::Parser::XS" => "0";

on "test" => sub {
    requires "Test2::V0"             => "0";
    requires "HTTP::Request::Common" => "0";
};
