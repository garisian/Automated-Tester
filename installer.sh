#!/bin/bash

# This file installs everything needed to run the automator
# Make sure you give this file permissions using the chmod 
# Run this file as "./installer.sh" (assuming you're in the directory containing the file)

clear

echo "Checking if perl is installed"
OUTPUT="$(perl -v)"
if [[ "${OUTPUT}" == *"command not found"* ]]
then
  # Installing Perl 
  echo "Perl is not installed on the computer.";
  echo "---Installing Perl";
  wget http://www.cpan.org/src/5.0/perl-5.16.2.tar.gz
  tar -xzf perl-5.16.2.tar.gz
  cd perl-5.16.2
  ./Configure -des -Dprefix=$HOME/localperl
  make
  make test
  make install  

  # Check if Perl was installed properly
  OUTPUT="$(perl -v)"
  if [[ "${OUTPUT}" == *"command not found"* ]]
  then
    echo "Failed to install Perl on computer"
    exit
  fi
  echo "Perl was successfully installed on the computer"
else
  echo "---Perl is already installed on this computer.";
fi

echo $PWD
echo "Installing Perl dependencies"
sudo apt-get install dtach

echo "Finished Installation"