package bbs2::DB;
use parent 'Teng';
use bbs2;
use File::Spec;
use Class::Method::Modifiers;
use Time::Piece::MySQL;

sub connect_info {
	my $c = bbs2->bootstrap;
	my $fname = File::Spec->catdir($c->base_dir, 'config', 'development.pl');
	my $conf = do $fname or die "Cannot load configuration file: $fname";
	return $conf->{DB};
}

before insert => sub {
    my ( $self, $table_name, $row_data ) = @_;
	$row_data->{created_at} = Time::Piece::localtime();
	#$row_data->{updated_at} = Time::Piece::localtime();
};

before fast_insert => sub {
    my ( $self, $table_name, $row_data ) = @_;
	$row_data->{created_at} = Time::Piece::localtime();
	#$row_data->{updated_at} = Time::Piece::localtime();
};

#before update => sub {
#    my ( $self, $table_name, $row_data, $condition ) = @_;
#	if ( ! $row_data->{deleted_at} ) {
#		$row_data->{updated_at} = Time::Piece::localtime();
#	}
#};


1;
