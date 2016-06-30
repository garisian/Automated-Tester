# Automator


Below are the instructions to start installing/running the code

Run "./installer.sh" in order to install all required elements required to run Automator

Update configuration_files/test_list.cfg file with the perl files you wish to test
(note: you must make the perl scripts yourselves)

To run the script, you can either use "perl run_tests.pl" or "./run_tests.sh"
The former forces you to have the terminal open while the job is being run, while the latter disconnects it and runs in the background. The benefit of the former is that the job can be killed easily. In order to kill the latter, run "./run_test_kill.sh ####" where #### is the job id extracted from "ps aux | grep 'run_tests'"

For every test run, a log file with the date will be created, and it contains the info of every test, the number skipped, passed, failed, as well as the low level details of the tests. A sample test "test_1" is shown.

modules/Common/Com_utilities.pm are common functions contain functions that are used in almost every testcase. 

*Still in Development Phase*
