#!/usr/bin/perl

use strict;
use warnings;
use Text::CSV;

my $csv = Text::CSV->new({empty_is_undef=>1});

my $sauthor = shift;
my $acount = 0;
my $bcount = 0;

while(<>) {

	$csv->parse($_);
	my ($author,@books) = $csv->fields();
	if(!defined $sauthor || (lc $sauthor eq lc $author)) {
		++$acount;
		print "$author\n";
		foreach(@books) {
			++$bcount;
			print "\t$_\n";
		}
		print "\n";
	}
}

print "Total Authors: $acount\n";
print "Total Books:   $bcount\n";
print "\n";
exit;

