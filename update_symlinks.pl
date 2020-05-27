#!/usr/bin/perl

use strict;
use warnings;
use v5.30;

sub update_symlink {
    my ($arg_ref) = @_;

    my $target  = $arg_ref -> {'target'} or die 'named argument "target" missing';
    my $link    = $arg_ref -> {'link'} or die 'named argument "link" missing';

    if (($target . $link) =~ /\~/) {
        say "'~' can't be expanded by perl's file tests. Check the constant SYMLINKS.";
        return 1;
    }

    if (-l $link && -e $link) {
        say 'Link exists and is valid';
        return 0;
    }
    elsif (-l $link && !(-e $link)) {
        say 'Link exists but is invalid, removing bad link: ' . $link;
        say qx(/usr/bin/rm $link);
    }
    
    if (!(-e $target)) {
        say "Can't create link for non existing target: $target";
        return 1;
    }

    say qx(/usr/bin/ln -s $target $link);
    return;
}

#   TARGET (actual file)                            SYMLINK (where it should appear)
use constant SYMLINKS => {
    '/home/dennis/ecos/ecos_start_vpn.pl'       =>  '/home/dennis/.local/bin/ecos_mos',
    '/home/dennis/scripts/extended_history.sh'  =>  '/etc/profile.d/extended_history.sh',
    '/home/dennis/scripts/.vimrc'               =>  '/home/dennis/.vimrc',
    '/home/dennis/scripts/.bash_aliases'        =>  '/home/dennis/.bash_aliases',
};

foreach my $target (keys %{ SYMLINKS() }) {
    my $link = SYMLINKS() -> {$target}; 
    say "Update symlink $link pointing to $target";
    update_symlink({
        'target' => $target,
        'link' => $link,
    });
}

