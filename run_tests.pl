#!/usr/bin/perl

###################################################
# Make sure multiple tests aren't running at once #
###################################################

# If lock already exists, that means another test set is currently being run
my $lock_file = "lock";
if(-e $lock_file)
{
    print "Script is terminated. Another test is currently running under same directory\n";
    exit 0;
}

# Get the current time so we can update the lock file
$datestring =localtime();

# Update lock file with current time so in case of a program crash, we know when the set was run
open(my $concurrency_lock, ">", $lock_file);
print $concurrency_lock "Test initiated at $datestring\n";
close($concurrency_lock);



###################################
# Include all packages being used #
###################################
use FindBin;
use lib "$FindBin::Bin/../lib";

use modules::Common::Com_utilities;


############################################
# Initialization of all required variables #
############################################

# Indicate where the initialization variables for the main testframe is coming from
my %test_config = (
	config_dir => "configuration_files",
	config_file => "run_tests.cfg"
);

#make_hash(%test_config,$test_config{config_dir}."/".$test_config{config_file}) or die "Couldn't make proper hash. Wrong format\n";

##########################################
# Extraction and Execution of Test Cases #
##########################################
run_tests();

# At this point test cases are finished, so we can remove lock and terminate script
remove_lock();

#########################
# Function Declarations #
#########################

# Remove the lock after test case finishes and before script terminates
sub remove_lock
{
    `rm -f $lock_file`;
}

# Takes the path to a file and updates the hash with all variables in the file name 
sub make_hash
{
}

# The function that extracts the variables in configuration_files/test_list.pl and runs each tests
sub run_tests
{
    #open a file called configuration_files/test_lists.cfg   
    #go through each line in the file that is not commented
    #example: test_1.pl   test_1.cfg    *4    (hello my name is candy)
    #inside the while loop, take each line and split in white space. 
    #find a way to put configuration files into the testing condition

    open(my $fh, "<",$test_config{config_dir}."/test_list.cfg" ) or die "cannot open test_list.cfg file";
    while(my $row = <$fh>)
    {
        chomp $row;
        print "$row\n";
    }
}

