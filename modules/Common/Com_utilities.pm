#!/usr/bin/perl

# This file contains a set of utilites that can be used to help testscript during execution phase

# Takes the path to a file and updates the hash with all variables in the file name 
sub status_print
{	
    my ($pass, $logfile) = @_;
    if($pass)
    {
    	`echo "Test Case SUCCESSED" >> $logfile`;
    }
    else
    {
    	`echo "Test Case FAILED" >> $logfile`;
    }
}

sub print_to_log
{
    my ($message, $logfile) = @_;
    `echo "$message" >> $logfile`;
}


# Necessary for file to return 1
1
