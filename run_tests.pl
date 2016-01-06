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


############################################
# Initialization of all required variables #
############################################

# Indicate where the initialization variables for the main testframe iscoming from
my %test_config = (
	config_dir => "configuration_files"
	config_file => "run_tests.cfg"
);

create_testFrame_hash();
##########################################
# Extraction and Execution of Test Cases #
##########################################

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

sub create_testFrame_hash
{
	populate_hash($test_config{config_dir} . "/" . $test_config{config_file}, my %config_in) or die "Couldn't read declared config file: $test_config{config_dir} or $test_config{config_file}\n";
	foreach my $key (keys %{$config_in{''}})
	{
		$test_config{$key} = $config_in{''}{$key};
	}
}
