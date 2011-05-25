#!/usr/bin/env perl
use strict;
use warnings;
use DBI;
use FindBin;
use File::Spec;
#use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');
#use lib File::Spec->catdir($FindBin::Bin, '..', 'extlib', 'lib', 'perl5');
#use BBS;
use Teng::Schema::Dumper;

#my $c = BBS->bootstrap;
#my $conf = $c->config->{'Teng'};

my $fname = File::Spec->catdir($FindBin::Bin, '..', 'config', 'development.pl');
my $conf = do $fname or die "Cannot load configuration file: $fname";

my $dbh = DBI->connect(@{$conf->{DB}}) or die "Cannot connect to DB:: " . $DBI::errstr;

my $schema = Teng::Schema::Dumper->dump(
	dbh => $dbh,
	namespace => $conf->{MyApp} . '::Model',
);

my $dest = File::Spec->catfile($FindBin::Bin, '..', 'lib', $conf->{MyApp}, 'DB', 'Schema.pm');

open my $fh, '>', $dest or die "Cannot open file '$dest': $!";
print {$fh} $schema;
close;

__END__
