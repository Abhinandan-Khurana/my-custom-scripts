#!/bin/bash

# Check if at least one file is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 file1.txt file2.txt ... output.txt"
    exit 1
fi

# Get the output file name from the last argument
OUTPUT_FILE="${!#}"

# Use cat to concatenate all files, sort them, and then use uniq to filter out duplicates
cat "$@" | sort | uniq > "$OUTPUT_FILE"

echo "Merged and deduplicated subdomains saved to $OUTPUT_FILE"
