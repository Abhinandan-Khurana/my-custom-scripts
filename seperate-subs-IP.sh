#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE=$1

# Extract subdomains and IPs and save them to their respective files
awk '{print $1}' "$INPUT_FILE" > move_subs.txt
awk '{print $2}' "$INPUT_FILE" > move_IPs.txt

echo "Subdomains saved to move_subs.txt"
echo "IP addresses saved to move_IPs.txt"
