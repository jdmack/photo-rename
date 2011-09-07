#!/usr/bin/perl

# Naming convention:
# $title-YEAR-MO-DA-#.jpg
# title can contain letters, numbers and underscore


use strict;
use warnings;

use Cwd;
use Image::ExifTool;

my $dir = cwd;
my $date_tag = "DateTimeOriginal";

opendir(DIR, $dir);
my @files = readdir(DIR);

# 1. Find out if any of the files follow the naming convention
my %named_files;
my @unnamed_files;
my %titles;

# GO THROUGH FILES AND COUNT THEM, PUT IN ARRAYS

foreach(@files)
{
    if(($_ eq ".") || ($_ eq "..")) {
        next;
    }
    
    my $jpg_flag = 0;
    if($_ =~ /.jpg$/i) {$jpg_flag = 1;}
    if(!$jpg_flag) { next; }

    if($_ =~ /^([a-zA-Z0-9_]+)-(\d{4})-(\d{2})-(\d{2})(-\d+)?.jpg$/i) {
        if(exists($named_files{"$2$3$4"})) {
            $named_files{"$2$3$4"}++;
        }
        else {
            $named_files{"$2$3$4"} = "1";
        }
        
        if(exists($titles{$1})) {
            $titles{$1}++;
        }
        else {
            $titles{$1} = "1";
        }

    }
    else {
        push(@unnamed_files, $_);     
    }
}

# Print file summary
print "\nNamed Files:\n";
foreach(keys(%named_files)) {
    print "$_\t$named_files{$_}\n";
}
print "\nUnnamed Files:\n";
foreach(@unnamed_files) {
    print "$_\n";
}
print "\n";

# Check titles
# EXPAND THIS TO WORK FOR MULTIPLE TITLES FOUND AND SELECT WHICH TITLE TO USE
my $titles_count = keys(%titles);
my $title;

if($titles_count == 1) {
    my @titles = keys(%titles);
    my $found_title = $titles[0];

    print "Found title \"$found_title\"\n";
    print "Use this titles? (y/n): ";

    my $use_title = <>;
    chomp($use_title);

    if(($use_title eq "y") || ($use_title eq "Y") || ($use_title eq "yes")) {
        $title = $found_title;
    }
    else {
        print "Enter title to use: ";
        $title = <>;
    }
}
else {
    print "Enter title to use: ";
    $title = <>;
}

chomp($title);
print "\nUsing title: $title\n";

# WE DON'T DO ANYTHING WITH THIS DECISION, WE RENAME OLD FILES REGARDLESS

print "Rename previous files? (y/n): ";
my $rename_old_answer = <>;
my $rename_old;

if(($rename_old_answer eq "y") || ($rename_old_answer eq "Y") || ($rename_old_answer eq "yes")) {
    $rename_old = 1;
}
else {
    $rename_old = 0;
}


# Rename files
foreach(@files)
{
    # Skip if file is . or ..
    if(($_ eq ".") || ($_ eq "..")) {
        next;
    }

    # Check if file has a jpg extension
    my $jpg_flag = 0;
    if($_ =~ /.jpg$/i)     {$jpg_flag = 1;}
    elsif($_ =~ /.jpeg$/i) {$jpg_flag = 1;}

    # Skip file if it doesn't have a jpg extension
    if(!$jpg_flag) { next; }
   
    # Check if it is already formatted properly
    if($_ =~ /^([a-zA-Z0-9_]+)-(\d{4})-(\d{2})-(\d{2})-?(\d+)?.jpg$/i) {
        if($1 eq $title) {
            next;
        }
        else {
            # STILL WORK TO DO HERE
            my $new_name;

            if($5 eq "") {
                $new_name = sprintf("%s-%04d-%02d-%02d.jpg", $title, $2, $3, $4);
            }
            else {
                $new_name = sprintf("%s-%04d-%02d-%02d-%03d.jpg", $title, $2, $3, $4, $5);
            }

            if(! -f $new_name) {
                rename($_, $new_name);
                print "Renaming $_ to $new_name.\n";
            }
            else {
                print "Error: Unable to rename $_: $new_name already exists.\n";
            }
            
        }

    }

    else {
        # Grab Date Taken
        my $exifTool = new Image::ExifTool;        
        
        $exifTool->ExtractInfo($_);
        my $this_date = $exifTool->GetValue($date_tag);
        
        if($this_date =~ /^(\d{4}):(\d{2}):(\d{2}) (\d{2}):(\d{2}):(\d{2})$/) {
            if(!exists($named_files{"$1$2$3"})) {
                $named_files{"$1$2$3"} = 1;
            }
            else {
                $named_files{"$1$2$3"}++;
            }

            my $new_name = sprintf("%s-%04d-%02d-%02d-%03d.jpg", $title, $1, $2, $3, $named_files{"$1$2$3"});

            if(! -f $new_name) {
                rename($_, $new_name);
                print "Renaming $_ to $new_name.\n";
            }
            else {
                print "Error: Unable to rename $_: $new_name already exists.\n";
            }
        }
        else {
            print "Error: Unable to extract DateTimeOriginal: $_\n";
            next;
        }

    }
}
























