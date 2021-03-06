#!/usr/bin/perl

use strict;
use warnings;
use v5.30;

use Term::ANSIColor;
use Try::Tiny;

sub update_symlink {
    my ($arg_ref) = @_;

    my $target = $arg_ref->{'target'} or die 'named argument "target" missing';
    my $link   = $arg_ref->{'link'}   or die 'named argument "link" missing';
    if ( ref $link eq 'ARRAY' ) {
        update_symlink(
            {
                'target' => $target,
                'link'   => $link->[$_],
            }
        ) foreach ( 0 .. $#{$link} );
        return;
    }

    say "Update symlink " . colored($link, 'yellow') . " pointing to " . colored($target, 'yellow');

    if ( ( $target . $link ) =~ /\~/ ) {
        say
"'~' can't be expanded by perl's file tests. Check the constant SYMLINKS.";
        return 1;
    }

    if ( -l $link && -e $link ) {
        say colored( 'Link exists and is valid', 'green' );
        return 0;
    }
    elsif ( -l $link && !( -e $link ) ) {
        say colored( 'Link exists but is invalid, removing bad link: ' . $link,
            'bright_red' );
        my $ln_output = qx(/usr/bin/rm $link);
        say colored( $ln_output, 'bright_red' ) if $ln_output;
    }

    if ( !( -e $target ) ) {
        say colored( "Can't create link for non existing target: $target",
            'red' );
        return 1;
    }

    say colored( "Try creating $link", 'bright_green' );
    try {
        my $ln_output = qx(/usr/bin/ln -s $target $link 2>&1);
        die $ln_output if ($ln_output);
    }
    catch {
        warn colored( "Caught error: $_", 'bright_red' );
    };
    return;
}

#<<<
# One day I have to think about how to use both the path completion and $ENV{"HOME"}
# https://stackoverflow.com/questions/1475357/how-do-i-find-a-users-home-directory-in-perl
#
#   TARGET (actual file)                            SYMLINK (where it should appear)
use constant SYMLINKS => {
    '/home/dennis/ecos/ecos_start_vpn.pl'       =>  '/home/dennis/.local/bin/ecos_mos',
    '/home/dennis/scripts/extended_history.sh'  =>  '/etc/profile.d/extended_history.sh',
    '/home/dennis/scripts/.vimrc'               =>  '/home/dennis/.vimrc',
    '/home/dennis/scripts/.bash_aliases'        =>  '/home/dennis/.bash_aliases',
    '/home/dennis/scripts/rclone_watch_local.pl'=>  '/home/dennis/.local/bin/rclone_watch_local',
    '/home/dennis/scripts/rclone-sync-gdrive.service' =>
        '/home/dennis/.config/systemd/user/rclone-sync-gdrive.service',
    '/home/dennis/scripts/joplin-userstyle.css' =>  [
        '/home/dennis/.config/joplin-desktop/userstyle.css',
        '/home/dennis/.config/joplin-private/userstyle.css'
    ],
    };
#>>>

foreach my $target ( keys %{ SYMLINKS() } ) {
    my $link = SYMLINKS()->{$target};
    update_symlink(
        {
            'target' => $target,
            'link'   => $link,
        }
    );
}

