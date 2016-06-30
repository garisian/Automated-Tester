#!/usr/bin/perl

###################################
# Include all packages being used #
###################################
use modules::Common::Com_utilities;           # Has common features that are predefined  
use strict;
use warnings;
use Net::Ping;

# Extract config file and log file from commandline
my ($config_file, $log_file) = @ARGV;


# Check if pinging to several websites works
my @hostList = ( "www.google.com", "www.github.com", "www.youtube.com");

my $ping = Net::Ping->new("tcp", 2);
for my $host (@hostList) {
	$ping->{'port_num'} = (getservbyname("http", "tcp") || 80);
	if ($ping->ping($host)) {
	    print_to_log("Successfully pinged $host\n", $log_file);
	} 
	else {
	    print_to_log("Failed to ping $host\n", $log_file);
	}

	# Check to see if any of the pings fails so we can quit the testcase immediately
    my $failures = `cat $log_file | grep "Failed to ping"| wc -l`;
    if($failures != 0)
    {
	    print_to_log("Error in pinging to known host. Testcase is exiting\n", $log_file);
		$ping->close();
		status_print(0, $log_file);
	    exit;	
    }
}
$ping->close();


# Downloading 2 images from the internet to see if file transfer is proper
print_to_log("Attempting to download Penguin Image using curl", $log_file);
`curl -vsO https://s-media-cache-ak0.pinimg.com/736x/56/84/89/5684890dba8b457cc0d04c6726ae6abf.jpg 2&>1 >/dev/null | less`;

print_to_log("Attempting to download Penguin Image using wget\n", $log_file);
`wget https://thumbs.dreamstime.com/x/angry-penguin-5095477.jpg 2&>1 >/dev/null`;

# Checking to see if the images were successfully downloaded. If not, error has occured.
if(-e "5684890dba8b457cc0d04c6726ae6abf.jpg")
{
    print_to_log("Image was successfully downloaded using curl. Removing file", $log_file);
    `rm 5684890dba8b457cc0d04c6726ae6abf.jpg`;
    print_to_log("Image was successfully removed.", $log_file);
}
else
{
	print_to_log("Image was unsuccessfully downloaded using curl. Error occured. Exiting Testcase", $log_file);
	status_print(0, $log_file);
	exit;
}
if(-e "angry-penguin-5095477.jpg")
{
    print_to_log("Image was successfully downloaded using wget. Removing file", $log_file);
    `rm angry-penguin-5095477.jpg`;
    print_to_log("Image was successfully removed.", $log_file);
}
else
{
	print_to_log("Image was unsuccessfully downloaded using wget. Error occured. Exiting Testcase\n", $log_file);
	status_print(0, $log_file);
	exit;
}

print_to_log("All images were successfully transfered and removed\n", $log_file);



status_print(1, $log_file);