# columnSelector.pl

Outputs columns by name from a delmimted text file.

## Why?

You frequently encounter data presented in .tsv or .csv files with a **lot** of 
columns and you want to process data from a subset of columns at the 
commandline. You could use the 'cut' unix utility if you are willing to count 
the index numbers of the relevant columns and are sure you won't get confused 
by spaces within a tab delimited file etc.. Alternatively, you could write a 
custom awk expression to process your file. However, either of these options is 
likely to get tiresome if you frequently encounter such files.

This program allows you to easily select data from one or a subset of columns 
from a delimited file by specifying the column names of interest. For example, 
the sequence index files from the 1000 genomes project contain 26 columns but 
you may only be interested in the location of each file, the sample name and 
the analysis group. You can easily retrieve just those columns as follows:

    # get the file (alternatively substitute the filename in the second command with 
    # '<(curl //ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/20130502.phase3.analysis.sequence.index)'
    wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/20130502.phase3.analysis.sequence.index
    
    # retrieve our columns of interest 
    columnSelector.pl 20130502.phase3.analysis.sequence.index SAMPLE_ID FASTQ_FILE PAIRED_FASTQ ANALYSIS_GROUP


## Usage 

    ./columnSelector.pl input.tsv column1 [column2 column3 ... columnN] [options]

## Options
 
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
        Show help information and exit



## Examples

    ./columnSelector.pl input.tsv NAME ADDRESS TELEPHONE
    
    ./columnSelector.pl input.csv NAME ADDRESS TELEPHONE -d ',' 

    ./columnSelector.pl input.csv NAME ADDRESS TELEPHONE -d ',' -r '\\t' > output.tsv

    ./columnSelector.pl input.csv name address telephone -d ',' -i

    ./columnSelector.pl input.vcf '#CHROM' POS ID INFO  -c '##'

## Tests

These scripts have been tested on Linux systems only (to date). To test on your
system type 'prove' from within your installation directory in order to run the 
tests provided.

## Author

David A. Parry

## COPYRIGHT AND LICENSE

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

