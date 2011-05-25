package bbs2::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::RouterSimple;

connect '/'        => 'Root#list';
connect '/user/:user'  => 'Root#list_by_user';
connect '/post'    => 'Root#post';
connect '/login'   => 'Root#login';
connect '/logout'  => 'Root#logout';
connect '/json'    => 'Root#json';

1;
