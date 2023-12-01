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
  trimmed_line=$(echo "$line" | xargs) # Trim whitespace
  if [[ -z "$trimmed_line" ]] || [[ "$trimmed_line" == \#* ]]; then
    continue # Skip empty lines and comments
  fi
  if ping -c 1 "$trimmed_line" &> /dev/null; then
    echo "$trimmed_line : \e[32mUP"
  else
    echo "$trimmed_line : \e[31mDOWN"
  fi
done < "$input_file"
