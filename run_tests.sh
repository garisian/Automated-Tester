#!/bin/bash

# Running run_tests.pl requires for the terminal to be active until tests are done.
# Running this file cuts the program from the terminal so the tests will run in the
# background and the log will be updated as each testcase finishes executing

echo 'Starting to run test cases...'
dtach -n -z ./run_tests.pl

echo 'Detaching from the terminal...'
exit
