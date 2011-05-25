package bbs2::Web::C::Root;
use strict;
use warnings;
use bbs2::Model::Entry;
use Data::Dumper;

sub list {
    my ( $class, $c ) = @_;
	my $entry = bbs2::Model::Entry->new;
	my $entries = $entry->get_list;
    return $c->render( 'index.tt' => { entries => $entries } );
}

sub list_by_user {
	my ( $class, $c, $p ) = @_;
	if ( my $user = $p->{user} ) {
		my $entry = bbs2::Model::Entry->new;
		$entry->user($user);
		my $entries = $entry->get_list_by_user;
    	return $c->render( 'index.tt' => { entries => $entries } );
	}
	return $c->redirect('/');
}

sub post {
	my ( $class, $c ) = @_;
	if ( my $body = $c->req->param('body') ) {
		my $entry = bbs2::Model::Entry->new;
		$entry->user($c->session->get('user'));
		$entry->body($body);
		$entry->post;
	}
	return $c->redirect('/');
}

my %accounts = (
	test => '1111',
	user => '1111',
);
sub login {
	my ( $class, $c ) = @_;
	if ( $c->req->param('login') && $c->req->param('passwd') ) {
		if ( $accounts{$c->req->param('login')} eq $c->req->param('passwd') ) {
			$c->session->regenerate_session_id;
			$c->session->set('verified', 1);
			$c->session->set('user', $c->req->param('login'));
			return $c->redirect('/');
		} else {
			return $c->redirect('/login');
		}
	}
	return $c->render( 'login.tt' );
}

sub logout {
	my ( $class, $c ) = @_;
	$c->session->expire;
	return $c->redirect('/login');
}

sub json {
	my ( $class, $c ) = @_;
	my $entry = bbs2::Model::Entry->new;
	my @entries = $entry->get_list;
	warn Dumper @entries;
    return $c->render_json( +{ entries => \@entries, } );
}
1;

