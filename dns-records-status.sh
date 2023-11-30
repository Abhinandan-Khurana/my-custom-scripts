#!/bin/bash

# Check if a file name is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Read the file line by line
while IFS= read -r line
do
    # Check if the line is not empty
    if [ -n "$line" ]; then
        # Perform nslookup and check the result
        if nslookup "$line" &> /dev/null; then
            echo "$line : RECORDS cleared"
        else
            echo "$line : RECORDS exist"
        fi
    fi
done < "$1"
