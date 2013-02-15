#!/usr/bin/perl

# Cwd gets the current working directory of the user who ran the script.
# The script can be in a different directory, it will return whatever directory
# the user is in.

use strict;
use warnings;

use Cwd;
my $dir = cwd;

print "cwd: $dir\n";
