#!/usr/bin/perl

use strict;
use warnings;

use Image::ExifTool qw(:Public);

my $jpg = "picture.jpg";
my $tag = "DateTimeOriginal";

my $exifTool = new Image::ExifTool;

$exifTool->ExtractInfo($jpg);

my @taglist = $exifTool->GetFoundTags($jpg);

foreach(@taglist) {
    # print "$_\n";
}

my $date = $exifTool->GetValue($tag);

print "\"$date\"\n";
