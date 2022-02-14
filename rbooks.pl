#!/usr/bin/perl

use strict;
use warnings;

print "Content-type: text/plain\n\n";


my $auth = "";
if($ENV{"QUERY_STRING"}) {
	$auth=$ENV{"QUERY_STRING"};
	$auth =~ s/%20/ /g;
	$auth = "'$auth'";
}

system("../dispbooks.pl $auth < ../RBooksByAuthor.csv");



exit;

