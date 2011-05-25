package bbs2::Model::Entry;
use strict;
use warnings;
use parent qw/Class::Accessor::Fast/;
use bbs2::DB;
use bbs2::Model::Common::CRUD;

__PACKAGE__->mk_accessors(qw/entry_id user body/);

sub new {
	my $class = shift;
	my $self = { db => bbs2::DB->new( connect_info => bbs2::DB->connect_info ) };
	bless $self, $class;
}

sub get_list {
	my $self = shift;
	my $entries = bbs2::Model::Common::CRUD->select_in_arryref(
		$self->{db},
		'entry',
		{},
		{
			limit    => 10,
			offest   => 0,
			order_by => { created_at => 'DESC' },
		},
		'time_passage'
	);
	return [ reverse @$entries ];
}

sub get_list_by_user {
	my $self = shift;
	my $entries = bbs2::Model::Common::CRUD->select_in_arryref(
		$self->{db},
		'entry',
		{ user => $self->user },
		{
			limit    => 10,
			offest   => 0,
			order_by => { created_at => 'DESC' },
		},
		'time_passage'
	);
	return [ reverse @$entries ];
}

sub post {
	my $self = shift;
	my $rs = $self->{db}->insert(
		'entry',
		{
			user => $self->user,
			body => $self->body,
			#created_at => \'now()',
		},
	);
	return 1;
}

1;

