#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use IO::Uncompress::Gunzip qw/ gunzip $GunzipError /;

my %opts = 
(
    d => "\t",
    c => "#",
    q => '"',
);
GetOptions
(
    \%opts,
    'd|delimiter=s',
    'r|replace_delimiter=s',
    'c|comment=s',
    'n|no_header',
    'q|quotes=s',
    'i|ignore_case',
    'g|get_col_nums',
    'h|help',
) or usage("Syntax error in option spec\n");
usage() if $opts{h};
usage("File and at least one column ID must be given on the commandline\n") if @ARGV < 2;
my $f = shift;
my @colnames =  @ARGV;
my %header = (); 
my $INPUT;
if ($f =~ /\.gz$/){
    $INPUT = new IO::Uncompress::Gunzip $f, MultiStream => 1
          or die "IO::Uncompress::Gunzip failed while opening $f for reading:".
          "\n$GunzipError";
}else{
    open ($INPUT, "<", $f) or die "Failed to open $f for reading: $! ";
}
(my $delimiter = $opts{d}) =~ s/((?:\\[a-zA-Z\\])+)/qq[qq[$1]]/ee;
    #reverse quotemeta
my $out_delimiter = defined $opts{r} ? $opts{r} : $opts{d};
$out_delimiter =~ s/((?:\\[a-zA-Z\\])+)/qq[qq[$1]]/ee;
    #reverse quotemeta
my $n = 0;
while (my $line = <$INPUT>){
    $n++;
    if ($opts{c}){
        next if $line =~ /^$opts{c}/;
    }
    chomp $line;
    my @split = split(/$opts{d}/, $line);   
    @split = rejoinQuotes(@split);
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
                    join($delimiter, @split) . "\n";
            }
            $header{$col} = $i;
        }
        if ($opts{n}){
            next;
        }
    }
    if ($opts{g}){
        foreach my $col (@colnames){
            print "$col: " . ($header{$col} + 1 ) . "\n";
        }
        exit;
    }
    my @out = ();
    foreach my $col (@colnames){
	my $f = $split[$header{$col}];
        if ($f =~ /$out_delimiter/){#enclose in quotes if contains our delimiter
            if ($f !~ /^".+"$/){
                $f = "\"$f\"";
            }
        }
        push @out, $f;
    }
    print join($out_delimiter, @out) . "\n";
}
             

##################################################
sub rejoinQuotes{
    my @joined = ();
    my $quote_open = 0;
    my @to_join = ();
    foreach my $s (@_){
        my $sq = () = $s =~ /$opts{q}/g;   
        if ($sq % 2 ){ #odd no. quotes in string
            $quote_open = $quote_open ? 0 : 1;
        }
        if ($quote_open){
            push @to_join, $s;
        }else{
            push @joined, join($delimiter, @to_join, $s);
            @to_join = ();
        }
    }
    if ($quote_open){
        warn "WARNING: Unclosed quotations after processing line $n\n";
        push @joined, join($delimiter, @to_join);
    }
    return @joined;
    
}

##################################################
sub usage{
    my $msg = shift;
    print STDERR "\n$msg\n" if $msg;
    print <<EOT

Extracts columns with given names from a delmited text file.

USAGE: $0 input.tsv column1 [column2 column3 ... columnN] [options]

OPTIONS:
    
    -d,--delimiter STRING
        Column delimiter to use. Default = tab ('\\t').
    
    -c,--comment STRING
        Comment character - i.e. skip lines beginning like this. Default = '#'. 
        Set to '' to disable.
    
    -n,--no_header
        Do not print header with output.
    
    -q,--quotes STRING
        Character to interpret as a quote mark, wherein text enclosed by this 
        character will not be split.
        Defaults to '"'
    
    -i,--ignore_case
        Ignore case of column names.

    -g,--get_col_nums
        Do not output columns but instead print a list of specified columns and 
        their respective order in the header.

    -r,--replace_delimiter STRING
        Use this delimiter in output instead of input delimiter.

    -h,--help
        Show this message and exit

EXAMPLES:

    ./columnSelector.pl input.tsv NAME ADDRESS TELEPHONE
    
    ./columnSelector.pl input.csv NAME ADDRESS TELEPHONE -d ',' 

    ./columnSelector.pl input.csv NAME ADDRESS TELEPHONE -d ',' -r '\\t' > output.tsv

    ./columnSelector.pl input.csv name address telephone -d ',' -i
    
    ./columnSelector.pl input.vcf '#CHROM' POS ID INFO  -c '##'
    
   

AUTHOR

    David A. Parry

COPYRIGHT AND LICENSE

    Copyright 2016  David A. Parry

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


EOT
    ;
    exit 1 if $msg;
    exit;
}

