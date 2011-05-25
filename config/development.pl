+{
	'MyApp' => 'bbs2',
    'DB' => [
        'dbi:mysql:dbname=bbs;host=localhost',
        'bbs',
        'bbs00',
		{
			'mysql_enable_utf8' => 1,
			'on_connect_do'    => [
				"SET NAMES 'utf8'",
				"SET CHARACTER SET 'utf8'",
			],
			RaiseError => 1,
			Callbacks  => {
			    ChildCallbacks => {
			        execute => sub {
			            my ($obj, @binds) = @_;
			            my $stmt = $obj->{Database}->{Statement};
			            $stmt =~ s/\?/'$_'/ for @binds;
			            print STDERR $stmt, "\n";
			            return;
			        },
			    },
			},
		},
    ],
    'Text::Xslate' => {
    },
};
