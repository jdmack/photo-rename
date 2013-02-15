#!/usr/bin/perl

use strict;
use warnings;

use Cwd;
my $dir = cwd;

opendir(DIR, $dir);
my @files = readdir(DIR);

print "cwd: $dir\n";
print "Files: \n";
foreach(@files)
{
    if(($_ eq ".") || ($_ eq ".."))
    {
        next;
    }
    
    open(FILE, $_);
    my $mod_date = localtime( (stat FILE)[9] );

    print "$_\n";
}
