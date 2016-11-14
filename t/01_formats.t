#!/use/bin/env perl
use strict;
use warnings;
use Test::More tests => 158;
use FindBin qw($RealBin);

BEGIN 
{ 
    use_ok("Getopt::Long");
    use_ok("IO::Uncompress::Gunzip");
}
my $n_tests = 2;
my $script_prefix = "perl $RealBin/..";

testFormat("\t", "tab separated",   "tsv");
testFormat(",",  "comma separated", "csv");
testFormat(" ",  "space separated", "ssv");

done_testing($n_tests);

##################################################
sub testFormat{
    my $delimiter = shift;
    my $format = shift;
    my $ext = shift;
    
    my @cols = qw/ Foo Bar Rhubarb Etc /;
    my %data = map { $_ => getData($_, $delimiter) } @cols;
    #one col at a time...
    my $base_cmd =  "$script_prefix/columnSelector.pl $RealBin/test_data/test.$ext ";
    if ($delimiter ne "\t"){
        $base_cmd .= " -d '$delimiter'";
    }
    for my $k (keys %data){
        my $cmd = "$base_cmd $k";
        testCmd($cmd, $data{$k}, "get '$k' column from $format data");
    }
    my %base_args = 
    (
        format     => $format,
        cmd        => $base_cmd,
        data       => \%data, 
        delimiter  => $delimiter, 
    );
    doColCombinations
    (
        %base_args,
        all_cols => \@cols, 
    );
    @cols = reverse(@cols);
    doColCombinations
    (
        %base_args,
        all_cols => \@cols, 
    );
    @cols = map { $cols[$_] } 1, 2, 0, 3;
    doColCombinations
    (
        %base_args,
        all_cols => \@cols, 
    );
    @cols = map { $cols[$_] } 1, 2, 0, 3;
    doColCombinations
    (
        %base_args,
        all_cols => \@cols, 
    );
}

##################################################
sub doColCombinations{
    my %args = @_;
    for (my $i = 0; $i < @{$args{all_cols}}; $i++){
        my @cols_to_test = ($args{all_cols}->[$i]);
        for (my $j = 0; $j < @{$args{all_cols}}; $j++){
            next if $j == $i;
            push @cols_to_test, $args{all_cols}->[$j];
            testTheseCols(%args, cols => \@cols_to_test);
        }
    }
}

##################################################
sub testTheseCols{
    my %args = @_;
    my $exp = dataToCols($args{data}, $args{delimiter}, $args{cols} ); 
    my $desc = "get '". 
               (join(", ", @{$args{cols}})) . 
               "' columns from $args{format} data";
    my $cmd = "$args{cmd} " . join(" ", @{$args{cols}});
    testCmd($cmd, $exp, $desc);
}

##################################################
sub dataToCols{
    my $h = shift;
    my $d = shift;
    my $c = shift;
    my @twod = (); 
    (my $dd = $d) =~ s/((?:\\[a-zA-Z\\])+)/qq[qq[$1]]/ee;
    foreach my $col (@{$c}){
        my @lines = split("\n",  $h->{$col});
        for (my $i = 0; $i < @lines; $i++){
            push @{$twod[$i]}, $lines[$i];
        }
    }
    my $data = '';
    foreach my $row (@twod){
        $data .= join($dd, @{$row}) . "\n";
    }
    return $data;
}
        
        
##################################################
sub getData{
    my $f = shift;
    my $d = shift;
    $f = "$RealBin/test_data/$f.txt";
    open (my $IN, $f) or die "Could not open test data $f: $!\n";
    my $all = '';
    while (my $data = <$IN>){
        chomp $data;
        if ($data =~ /$d/ and $data !~ /^".+"$/){
            $data = "\"$data\"";
        }
        $all .= "$data\n";
    }
    close $IN;
    return $all;
}

##################################################
sub testCmd{
    my ($cmd, $expected, $description) = @_;
    my $output = `$cmd`;
    is
    (
        $output,
        $expected,
        $description,
    );
    $n_tests++; 
}

