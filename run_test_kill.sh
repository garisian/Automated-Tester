#! /bin/bash

# If you run a script and you lost control of it (using run_tests.sh), find
# the pid using "ps aux | grep run_tests" and terminate it using "./run_test_kill.sh ####"
# where #### is the pid of the job


kill_it ()
{
	cpids=$(ps -o pid --no-headers --ppid $1)
	echo "Killing $1"
	sudo kill -TERM $1 > /dev/null 2>&1

	for cpid in $cpids
	do
		kill_it $cpid
	done
}

if [[ $# -ne 1 ]]; then
	echo "Usage: $(basename $0) <pid>"
	exit 1;
fi

if [ $1 -ne 0 -o $1 -eq 0 2>/dev/null ]
then
	echo "Preparing to kill"
	kill_it $1
	sudo rm -f ./lock
	echo "Successfully killed"
else 
	echo "Invalid input: $1"
	exit 1;
fi
exit 0;
