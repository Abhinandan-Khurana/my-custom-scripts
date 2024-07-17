#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <file> <keyword>"
	exit 1
fi

# Assign input arguments to variables
input_file="$1"
keyword="$2"
temp_file=$(mktemp)

# Process the input file line by line
while IFS= read -r line; do
	# Check if the line contains the keyword
	if [[ "$line" == *"$keyword"* ]]; then
		echo "$line" >>"$temp_file"
	fi
done <"$input_file"

# Move the temp file to the original file
mv "$temp_file" "$input_file"

echo "Lines not containing the keyword '$keyword' have been removed from $input_file."
