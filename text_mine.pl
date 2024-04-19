#!/usr/bin/perl -w

##############################################################################
# Text miner on *nix words file.
#
# Copyright 2024 Frank Staszak / License: GNU GPL v.3
##############################################################################

use strict;
use warnings;

my $words_file = "/usr/share/dict/words";
my $line = "";
my $total_words = 0;
my $aeiou_words = 0;
my $total_in_order_vowels = 0;

&all_vowels;
&missing_vowels;
&ordered_vowels;

sub all_vowels {
    open my $words, '<', $words_file;
    while ($line = <$words>) {
        chomp $line;
        foreach my $word (split(/\s/, $line)) {
            if (($word =~ /a/i) and
                ($word =~ /e/i) and
                ($word =~ /i/i) and
                ($word =~ /o/i) and
                ($word =~ /u/i)) {
                $aeiou_words++;
                print "$line \n";
            }
            $total_words++;
        }
    }

    print "$aeiou_words words contain aeiou out of $total_words total words.\n";
    close($words);
}

sub missing_vowels {
    open my $words, '<', $words_file;
    my %freq = ();
    while ($line = <$words>) {
        chomp $line;
        foreach my $word (split(/\s/, $line)) {
            if ($word !~ /a/i) {
                $freq{'a'}++;
            }
            if ($word !~ /e/i) {
                $freq{'e'}++;
            }
            if ($word !~ /i/i) {
                $freq{'i'}++;
            }
            if ($word !~ /o/i) {
                $freq{'o'}++;
            }
            if ($word !~ /u/i) {
                $freq{'u'}++;
            }
        }
    }

    foreach my $key (sort { $freq{$b} <=> $freq{$a} } keys %freq) {
        print "$freq{$key} words do not have an '",${key}, "'\n";
    }

    close($words);
}

sub ordered_vowels {
    open my $words, '<', $words_file;
    while ($line = <$words>) {
        if ($line =~ /(a.*)(e.*)(i.*)(o.*)(u.*)/) {
            print $line;
            $total_in_order_vowels++;
        }
    }

    print "$total_in_order_vowels\n";
    close($words);
}
