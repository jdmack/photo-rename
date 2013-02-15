#!/usr/bin/perl

use strict;
use warnings;

my %hash;

$hash{'key'} = "value";

my $count = keys(%hash);
print "$hash{'key'}\n";
print "count: $count\n";
