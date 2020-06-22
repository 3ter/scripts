#!/bin/perl

use strict;
use warnings;
use v5.30;

use English;
use Getopt::Long;

my $is_first_sync = 0;
GetOptions ('first-sync' => \$is_first_sync) or die("Error in command line arguments\n");

our $local_dir      = '/home/dennis/googledrive/Sicherheit';
our $remote_dir     = 'googledrive:/Sicherheit';
our $rclonesync_exe = '/home/dennis/rclonesync/rclonesync.py';
our $inotify_opts   = 
    "--event " .
    join(' --event ', qw(modify attrib close_write moved_to create delete)) .
    " --recursive $local_dir";

sub run_sync {
    my ($is_first_sync) = @_;

    if ($is_first_sync) {
        say "You've specified '--first-sync'. This will overwrite files in $remote_dir ".
        "with file from $local_dir. Is this what you want? (y/n): ";
        
        my $answer = '';
        while (1) {
            $answer = <STDIN>;
            chomp $answer;
            last if ($answer =~ /^(?:y|n)$/);
            say "Please only type 'y' or 'n' and press <Enter>.";
        }

        if ($answer eq 'y') {
            say qx( python3 $rclonesync_exe --first-sync --verbose $local_dir $remote_dir 2>&1 );        
        }
    }

    my $rclonesync_rc = (system("python3 $rclonesync_exe --verbose $local_dir $remote_dir 2>&1") >> 8);
    system("/usr/bin/notify-send --urgency critical 'Error in rclone-sync' 'Ended with return code $rclonesync_rc'") if ($rclonesync_rc);

    return;
}

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
        run_sync(); 
        }
    else
        {
        say 'An unexpected event or error in \'inotifywait\' occurred.';
        }
    return;
    }

if ($is_first_sync) {
    run_sync($is_first_sync);
    exit;
}

say '[rclone] Watching locally.';

if (-d $local_dir)
    {
    say 'Sync on startup';
    run_sync();
    while (1)
        {
        watch_folder_and_sync_on_sched();
        }
    }
else
    {
    say "$local_dir isn't a valid directory!";
    }

