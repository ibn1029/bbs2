package bbs2::Web;
use strict;
use warnings;
use parent qw/bbs2 Amon2::Web/;
use File::Spec;
use Time::Piece; 
use Time::Seconds;
use Data::Dumper;

# load all controller classes
use Module::Find ();
Module::Find::useall("bbs2::Web::C");

# dispatcher
use bbs2::Web::Dispatcher;
sub dispatch {
	return bbs2::Web::Dispatcher->dispatch($_[0]) or die "response is not generated";
}

# setup view class
use Text::Xslate;
{
	my $view_conf = __PACKAGE__->config->{'Text::Xslate'} || +{};
	unless (exists $view_conf->{path}) {
		$view_conf->{path} = [ File::Spec->catdir(__PACKAGE__->base_dir(), 'tmpl') ];
	}
	my $view = Text::Xslate->new(+{
		'syntax'   => 'TTerse',
		'module'   => [ 'Text::Xslate::Bridge::TT2Like' ],
		'function' => {
			c => sub { Amon2->context() },
			uri_with => sub { Amon2->context()->req->uri_with(@_) },
			uri_for  => sub { Amon2->context()->uri_for(@_) },
		},
		%$view_conf
	});
	sub create_view { $view }
}


# load plugins
use HTTP::Session::Store::File;
__PACKAGE__->load_plugins(
	'Web::FillInFormLite',
	'Web::NoCache', # do not cache the dynamic content by default
	'Web::CSRFDefender',
	'Web::HTTPSession' => {
		state => 'Cookie',
		store => HTTP::Session::Store::File->new(
			dir => File::Spec->tmpdir(),
		)
	},
	'Web::JSON',
);

my ( $t_in, $t_out );
# for your security
__PACKAGE__->add_trigger(
	BEFORE_DISPATCH => sub {
		my ( $c ) = @_;
		# for development
		warn "==========================================================\n";
		my $t = Time::Piece::localtime;
		warn "[Access time : ".$t->ymd.' '.$t->hms."]\n";
		$t_in = times;
		warn "[Http Request]\n";
		warn "\turi = ".$c->req->request_uri."\n";
		warn "[Session Data]\n";
		warn "\tsession id = ".$c->session->session_id."\n";
		for my $key ( $c->session->keys ) {
			warn "\t".$key.' = '.$c->session->get($key)."\n";
		}
		warn "----\n";

		if ( $c->req->request_uri ne '/login') {
			$c->redirect('/login') if ! $c->session->get('verified');
		}
	},
);

__PACKAGE__->add_trigger(
	AFTER_DISPATCH => sub {
		my ( $c, $res ) = @_;
		$res->header( 'X-Content-Type-Options' => 'nosniff' );

		# for development
		warn "----\n";
		my $controller = delete $c->{args}{controller} || '';
		my $action     = delete $c->{args}{action} || '';
		warn "[Dispatched]\n";
		warn "\tcontroller = $controller\n";
		warn "\taction = $action\n";
		if ( my $num = keys %{$c->{args}} >= 1 ) {
			warn "[Captured Variables]\n";
			for my $key ( keys %{$c->{args}} ) {
				warn "\t".$key.' = '. $c->{args}{$key}."\n";
			}
		}
		if ( eval { $c->req->param } ) {
			warn "[Parameters]\n";
			map { warn "\t".$_.' = '.$c->req->param($_)."\n" } sort $c->req->param;
		}
		warn "[Http Response]\n";
		warn "\tstatus = ".$res->status."\n";
		warn "\tlocation = ".$res->headers->header('location')."\n" if $res->headers->header('location');
		$t_out = times;
		warn "[Elapsed time : ".( $t_out - $t_in )."sec]\n";
		warn "----------------------------------------------------------\n";
	},
);

1;
