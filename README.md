#columnSelector.pl

Outputs columns by name from a delmimted text file.


##Usage 

    ./columnSelector.pl input.tsv column1 [column2 column3 ... columnN] [options]

##Options

    -d,--delimiter STRING
        Column delimiter to use. Default = tab ('\t').
    
    -c,--comment STRING
        Comment character - i.e. skip lines beginning like this. Default = '#'. Set to '' to disable.
    
    -n,--no_header
        Do not print header with output.
    
    -q,--quotes STRING
        Character to interpret as a quote mark, wherein text enclosed by this character will not be split.
        Defaults to '"'
    
    -i,--ignore_case
        Ignore case of column names.

    -r,--replace_delimiter STRING
        Use this delimiter in output instead of input delimiter.

    -h,--help
        Show this message and exit


##Examples

    ./columnSelector.pl input.tsv NAME ADDRESS TELEPHONE
    
    ./columnSelector.pl input.csv NAME ADDRESS TELEPHONE -d ',' 

    ./columnSelector.pl input.csv NAME ADDRESS TELEPHONE -d ',' -r '\\t' > output.tsv

    ./columnSelector.pl input.csv name address telephone -d ',' -i

    ./columnSelector.pl input.vcf '#CHROM' POS ID INFO  -c '##'

##Tests

These scripts have been tested on Linux systems only (to date). To test on your
system type 'prove' from within your installation directory in order to run the 
tests provided.

##Author

David A. Parry

##COPYRIGHT AND LICENSE

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

