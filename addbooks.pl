#!/usr/bin/perl

use strict;
use warnings;
use Text::CSV;

my $csv = Text::CSV->new({empty_is_undef=>1});

my $file = shift || die "ERROR: Needs a database .csv file to add to!\n";

my $authorbooks = {};

open IFIL, "<$file" or die "ERROR: Unable to open database file [$file] for reading!\n";
while(<IFIL>) {
	chomp;
	$csv->parse($_);
	my ($author, @books) = $csv->fields(); 
	if(!defined $authorbooks->{$author}) {
		$authorbooks->{$author} = [];
	}	
	push @{$authorbooks->{$author}}, @books;
}
close IFIL;

while(<>) {
	chomp;
	if(/^\s*([^\/]+?)\s*\/\s*(.+?)\s*$/) {
		my $author = $1;
		my $book = $2;
#		print "  You wanted me to add '$book' by '$author' to the database.\n";
		if(!defined $authorbooks->{$author}) {
			$authorbooks->{$author} = [];
			print STDERR "    NEW AUTHOR [$author]\n";
		}

		my $addit = 1;
		my $count = 1;
		foreach(@{$authorbooks->{$author}}) {
			if(lc $_ eq lc $book) {
				$addit= undef;
				last;
			}
			++$count;
		}

		if($addit) {
			push @{$authorbooks->{$author}}, $book;
			$count = scalar @{$authorbooks->{$author}};
			print STDERR "    Book $count by [$author]\n";
		} else {
			print STDERR "    DUP! [$book] ($count) by [$author]\n"
		}
	} else {
		print STDERR "  I don't understand what you wanted me to do with [$_]; Ignoring.\n";
	}
}

open OFIL, ">$file" or die "ERROR: Unable to open database file [$file] for writing!\n";
foreach(sort keys %{$authorbooks}) {
	print OFIL "\"$_\"";
	foreach(@{$authorbooks->{$_}}) {
		print OFIL ",\"$_\"";
	}
	print OFIL "\n";
}

close OFIL;

exit;

