#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my %opts = 
(
    d => "\t",
    c => "#",
);
GetOptions
(
    \%opts,
    'd|delimiter=s',
    'c|comment=s',
    'n|no_header',
    'i|ignore_case',
    'h|help',
) or usage("Syntax error in option spec\n");
usage() if $opts{h};
usage("File and at least one column ID must be given on the commandline\n") if @ARGV < 2;
my $f = shift;
my @colnames =  @ARGV;
my %header = (); 
open (my $INPUT, "<", $f) or die "Can't open $f for reading: $!\n";
while (my $line = <$INPUT>){
    if ($opts{c}){
        next if $line =~ /^$opts{c}/;
    }
    chomp $line;
    my @split = split(/$opts{d}/, $line);
    if (not %header){
        no warnings 'uninitialized';
        foreach my $col (@colnames){
            my $i = 0;
            if ($opts{i}){
                $i++ until uc($split[$i]) eq uc($col) or $i > $#split;
            }else{
                $i++ until $split[$i] eq $col or $i > $#split;
            }
            if ($i > $#split){
                die "Could not identify column '$col' in header. Header was:\n" . 
                    join($opts{d}, @split) . "\n";
            }
            $header{$col} = $i;
        }
        if ($opts{n}){
            next;
        }
    }
    my @out = ();
    foreach my $col (@colnames){
        push @out, $split[$header{$col}];
    }
    print join($opts{d}, @out) . "\n";
}
             


##################################################
sub usage{
    my $msg = shift;
    print STDERR "\n$msg\n" if $msg;
    print <<EOT

Extracts columns with given names from a delmited text file.

Usage: $0 input.tsv column1 [column2 column3 ... columnN] [options]

Options:
    
    -d,--delimiter STRING
        Column delimiter to use. Default = tab ('\\t').
    
    -c,--comment STRING
        Comment character - i.e. skip lines beginning like this. Default = '#'. Set to '' to disable.
    
    -n,--no_header
        Do not print header with output.
    
    -i,--ignore_case
        Ignore case of column names.

    -h,--help
        Show this message and exit

Examples:

    ./columnsSelector.pl input.tsv NAME ADDRESS TELEPHONE
    
    ./columnsSelector.pl input.csv NAME ADDRESS TELEPHONE -c ',' 

    ./columnsSelector.pl input.csv name address telephone -c ',' -i


Author

    David A. Parry

=cut

EOT
    ;
    exit 1 if $msg;
    exit;
}

