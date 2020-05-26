#!/bin/perl

use strict;
use warnings;
use v5.30;

use English;

our $local_dir      = '/home/dennis/googledrive/Sicherheit';
our $remote_dir     = 'googledrive:/Sicherheit';
our $rclonesync_exe = '/home/dennis/rclonesync/rclonesync.py';
our $inotify_opts   = 
    "--event " .
    join(' --event ', qw(modify attrib close_write moved_to create delete)) .
    " --recursive $local_dir";

sub wait_until_file_silent
    {
    while (1)
        {
        my $rc = system( "inotifywait --timeout 5 $inotify_opts" );
        # Return code 0 shows us that there was another event triggered
        return if $rc;
        }
    }

sub watch_folder_and_sync_on_sched
    {
    # see https://perldoc.perl.org/perlvar.html#CHILD_ERROR regarding the bitwise shift
    if ( (system( "inotifywait --timeout 300 $inotify_opts" ) >> 8) != 1 )
        {
        wait_until_file_silent();
        say qx( python3 $rclonesync_exe --verbose $local_dir $remote_dir 2>&1 );
        }
    else
        {
        say 'An unexpected event or error in \'inotifywait\' occurred.';
        }
    return;
    }

say '[rclone] Watching locally.';

if (-d $local_dir)
    {
    say 'Sync on startup';
    say qx( python3 $rclonesync_exe --verbose $local_dir $remote_dir 2>&1 );
    while (1)
        {
        watch_folder_and_sync_on_sched();
        }
    }
else
    {
    say "$local_dir isn't a valid directory!";
    }
