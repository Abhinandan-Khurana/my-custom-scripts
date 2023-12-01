#!/bin/bash

# Check if a file name is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# The file to read from, provided as the first argument
FILENAME=$1

# Regular expression for matching IP addresses
IP_REGEX='([0-9]{1,3}\.){3}[0-9]{1,3}'

# Use grep to find all matches in the file
grep -oP $IP_REGEX $FILENAME
