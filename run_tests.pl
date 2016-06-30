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
use POSIX qw(strftime);                       # Used to get time stamps for log files
use modules::Common::Com_utilities;           # Has common features that are predefined  


############################################
# Initialization of all required variables #
############################################

# Indicate where the initialization variables for the main testframe is coming from
my %test_config = (
    log_dir => "log_files",
    test_dir => "test_files",
	config_dir => "configuration_files",
	config_file => "run_tests.cfg"
);
my $logfile_name = '';

#make_hash(%test_config,$test_config{config_dir}."/".$test_config{config_file}) or die "Couldn't make proper hash. Wrong format\n";

##########################################
# Extraction and Execution of Test Cases #
##########################################
# Make the log files 
make_logs();

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

# Create log files and store them in log_files directory1
sub make_logs
{
    $date_string = strftime "%a_%b_%e_%H:%M:%S_%Y", localtime;
    $logfile_name =  "$test_config{log_dir}/$date_string.txt";
    `touch $logfile_name`;
}

# Takes the path to a file and updates the hash with all variables in the file name 
sub make_hash
{
}

# The function that extracts the variables in configuration_files/test_list.pl and runs each tests
sub run_tests
{
    # Keep track of the status' of the tests for final report
    my $successfully_run = 0;
    my $skipped_tests = 0;
    my $tests_failed = 0;
    my $tests_success = 0;
    my $total_tests = 0;

    # Attempt to open the main test configuration file or send error message
    open(my $fh, "<",$test_config{config_dir}."/test_list.cfg" ) or die "cannot open test_list.cfg file";
    
    my $testNum = 1;
    while(my $row = <$fh>)
    {
        # Go through every line (test feature) that is not commented out or has only whitespace
        chomp $row;
        if ($row !~ '^#.' and $row !~ /^\s*$/)
        {
            # Split the line by white spaces or tabs
            my @split_elements = split ' ', $row;
            my $test_script = @split_elements[0];
            my $config_script = @split_elements[1];
            my $num_of_tests = @split_elements[2];
            my $time_interval = @split_elements[3];

            # Check if test script and configuration file is valid
            if(! -e $test_config{test_dir}."/".$test_script)
            {
                print_to_log("Test script is not valid in row: $row\n", $logfile_name);
                $skipped_tests += 1;
                $total_tests += 1;
                next;
            }
            if(! -e $test_config{config_dir}."/".$config_script)
            {
                print_to_log("Config script is not valid in row: $row\n", $logfile_name);
                $skipped_tests += 1;
                $total_tests += 1;
                next;
            }

            # Execute the file $num_of_test number of times
            for(my $test_counter = 0;$test_counter < $num_of_tests; $test_counter++)
            {
                my $current_test = $testNum + $test_counter;
                print_to_log("\nNow Starting Test $current_test",$logfile_name);
                print_to_log("--------------------------------------", $logfile_name);
                `perl $test_config{test_dir}/$test_script $test_config{test_dir}$config_dir $logfile_name`;
                
                # Check if a success statement was printed, implying htat the test was successful
                my $success = `cat $logfile_name | tail -1`;
                if (index($success, "SUCCESSED") != -1) {
                    $tests_success += 1;
                } 
                else
                {
                    $tests_failed += 1;
                }

                # Check if testcase pass' and update respective elements
                print_to_log("Finished Executing Test $current_test\n\n",$logfile_name);   
                $total_tests += 1;   
                $successfully_run += 1;
                if($test_counter+1 < $num_of_tests)
                { 
                    # If there are multiple scripts, then have the program sleep for the requested time
                    print_to_log("sleeping for $time_interval seconds\n\n",$logfile_name);  
                    sleep($time_interval);                    
                }        
            }
            $testNum += 1;
        }
    }

    # Log the final statistics of all the tests that have been run/skipped
    print_to_log("\n======================================",$logfile_name);
    print_to_log("All tests are finished.",$logfile_name);
    print_to_log("A total of $total_tests testcases were in the test list.",$logfile_name); 
    print_to_log("A total of $skipped_tests were skipped.",$logfile_name); 
    print_to_log("A total of $successfully_run were run",$logfile_name);   
    print_to_log("        -- $tests_success passed",$logfile_name);   
    print_to_log("        -- $tests_failed failed",$logfile_name);   
}

