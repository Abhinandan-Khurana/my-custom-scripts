#!/bin/bash

# Check if the input file is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 input_file"
  exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' does not exist."
  exit 1
fi

# Read hosts from the input file and check their status
while IFS= read -r line; do
  if ping -c 1 "$line" &> /dev/null; then
    echo "$line : UP"
  else
    echo "$line : DOWN"
  fi
done < "$input_file"
