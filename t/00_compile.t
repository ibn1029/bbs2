use strict;
use warnings;
use Test::More;

use_ok $_ for qw(
    bbs2
    bbs2::Web
    bbs2::Web::Dispatcher
	bbs2::DB
	bbs2::DB::Schema
	bbs2::Model::Entry
	bbs2::Model::Common::CRUD
);

done_testing;
