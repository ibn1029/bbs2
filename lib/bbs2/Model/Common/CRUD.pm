package bbs2::Model::Common::CRUD;
use strict;
use warnings;
use Encode;
use Time::Piece;
use Time::Seconds;

#
# CRUD
#
sub select_in_arryref {
	my ( $class, $db, $table_name, $condition, $attribute, $format ) = @_;
	my $itr = $db->search( $table_name, $condition, $attribute );
	my @list;
	while (my $row = $itr->next) {
		for my $col_name qw/created_at updated_at deleted_at/ {
			if ( eval { $row->get_column($col_name) } ) {
				$row->set_column( $col_name => __PACKAGE__->$format($row, $col_name) );
			}
		}
		push (@list, $row->get_columns);
	}
	return \@list;
}

#
# Format
#
sub jp_format {
	my ( $class, $row, $col_name ) = @_;
	return decode_utf8( $row->${col_name}->strftime('%Y年%m月%d日 %H時%M分%S秒') );
}

sub time_passage {
	my ( $class, $row, $col_name ) = @_;
=tab
Time::Piece::MySQLのタイムゾーンについて
http://d.hatena.ne.jp/ZIGOROu/20101105/1288927369
http://d.hatena.ne.jp/holidays-l/20101106/p1
http://digit.que.ne.jp/work/wiki.cgi?Perl%E3%83%A1%E3%83%A2%2FTime%3A%3APiece%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB
=cut
	my $t_jst = Time::Piece->strptime(
		$row->${col_name}->ymd.' '.$row->${col_name}->hms.' +0900',
		'%Y-%m-%d %H:%M:%S %z'
	);
	my $now = Time::Piece->localtime();
	my $s = $now  - $t_jst;
	if ( $s < 60 ) {
		my $sec = $s->seconds;
		$sec++ if $sec == 0;
		$sec =~ s/\.\d+$//;
		return decode_utf8( $sec.'秒前' );

	} elsif ( $s < 60 * 60 ) {
		my $min = $s->minutes;
		$min =~ s/\.\d+$//;
		return decode_utf8( $min.'分前' );

	} elsif ( $s < 60 * 60 * 24) {
		my $hour = $s->hours;
		$hour =~ s/\.\d+$//;
		return decode_utf8( $hour.'時間前' );

	} elsif ( $s < 60 * 60 * 24 * 7 ) {
		my $day = $s->days;
		$day =~ s/\.\d+$//;
		return decode_utf8( $day.'日前' );

	} elsif ( $s < 60 * 60 * 24 * 7 * 4) {
		my $week = $s->weeks;
		$week =~ s/\.\d+$//;
		return decode_utf8( $week.'週間前' );

	} else {
		return __PACKAGE__->jp_time_format ( $row, $col_name );
	}
}


1;
