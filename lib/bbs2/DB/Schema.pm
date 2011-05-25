package bbs2::DB::Schema;
use Teng::Schema::Declare;
use Time::Piece::MySQL;
table {
    name 'entry';
    pk 'entry_id';
    columns (
        {name => 'body', type => 12},
        {name => 'created_at', type => 11},
        {name => 'user', type => 12},
        {name => 'entry_id', type => 4},
    );
	inflate qr/^created_at$/ => sub { Time::Piece->from_mysql_datetime(shift) };
	deflate qr/^created_at$/ => sub { shift->mysql_datetime };
};

1;
