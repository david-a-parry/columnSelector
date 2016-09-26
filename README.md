#columnSelector.pl

Outputs columns by name from a delmimted text file.


##Usage## 

    ./columnSelector.pl input.tsv column1 [column2 column3 ... columnN] [options]

##Options##
    
    -d,--delimiter STRING
        Column delimiter to use. Default = tab ('\t').
    
    -c,--comment STRING
        Comment character - i.e. skip lines beginning like this. Default = '#'. Set to '' to disable.
    
    -n,--no_header
        Do not print header with output.
    
    -i,--ignore_case
        Ignore case of column names.

    -h,--help
        Show this message and exit


##Examples##

    ./columnsSelector.pl input.tsv NAME ADDRESS TELEPHONE
    
    ./columnsSelector.pl input.csv NAME ADDRESS TELEPHONE -c ',' 

    ./columnsSelector.pl input.csv name address telephone -c ',' -i


##Author##

David A. Parry

 
