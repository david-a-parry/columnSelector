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
        Defaults to "
    
    -i,--ignore_case
        Ignore case of column names.

    -h,--help
        Show this message and exit


##Examples

    ./columnSelector.pl input.tsv NAME ADDRESS TELEPHONE
    
    ./columnSelector.pl input.csv NAME ADDRESS TELEPHONE -d ',' 

    ./columnSelector.pl input.csv name address telephone -d ',' -i

    ./columnSelector.pl input.vcf '#CHROM' POS ID INFO  -c '##'

##Author

David A. Parry

 
