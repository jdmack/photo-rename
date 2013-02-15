Photo Rename
============

Author: James Mack  
Project Start Date: 2010-06-07  

Description
-----------

This script will rename all of the photos in a directory. It will rename the photos with a subject provided by the user and append the date and photo # (when multiple photos per date exist). It first scans all the files in the directory to look for previously renamed photos and lets the user choose between the found subjects or a new subject.

Uses Image::ExifTool to extra photo metadata to get the date taken.

To Do
-----

* Cleanup Code
* Recurse subdirectories so that script only needs to be run once at top level
