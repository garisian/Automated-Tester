#!/usr/bin/perl

#########################################
# Include all packages that we're using #
#########################################

#use RuggedCom::LogToFile;



###################################################
# Make sure multiple tests aren't running at once #
###################################################

my $lock_file = "lock";
if(-e $lock_file)
{
    print "Script is terminated. Another test is currently running under same directory\n";
    exit 0;
}
