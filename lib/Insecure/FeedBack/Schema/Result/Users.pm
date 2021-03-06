package Insecure::FeedBack::Schema::Result::Users;

use DBIx::Class::Candy
  -autotable  => v1,
  -components => [
    qw/
      EncodedColumn
      InflateColumn::DateTime
      TimeStamp
      /
  ];

primary_column id => {
    data_type         => 'int',
    is_auto_increment => 1,
};

unique_column email => {
    data_type   => 'varchar',
    is_nullable => 0,
    size        => 255,
};

column name => {
    data_type   => 'varchar',
    is_nullable => 1,
    size        => 255,
};

column password => {
    data_type           => 'varchar',
    is_nullable         => 1,
    size                => 255,
    encode_column       => 1,
    encode_class        => 'Crypt::Eksblowfish::Bcrypt',
    encode_args         => { key_nul => 0, cost => 12 },
    encode_check_method => 'check_password',
};

column created => {
    data_type        => 'datetime',
    inflate_datetime => 1,
    is_nullable      => 0,
    set_on_create    => 1,
};

column modified => {
    data_type        => 'datetime',
    inflate_datetime => 1,
    is_nullable      => 1,
    set_on_update    => 1,
};

column last_login => {
    data_type        => 'datetime',
    inflate_datetime => 1,
    is_nullable      => 1,
};

1;
