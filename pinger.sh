#!/bin/bash

# Check if the input file is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 input_file"
  exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: Input file '$input_file' does not exist."
  exit 1
fi

# Read hosts from the input file and check their status
while IFS= read -r line; do
  trimmed_line=$(echo "$line" | xargs) # Trim whitespace
  if [[ -z "$trimmed_line" ]] || [[ "$trimmed_line" == \#* ]]; then
    continue # Skip empty lines and comments
  fi

  # Extract the domain name by removing protocol (http:// or https://)
  domain=$(echo "$trimmed_line" | sed -E 's|https?://||')

  if ping -c 1 "$domain" &>/dev/null; then
    echo -e "\033[36m$trimmed_line : \033[32mUP\033[0m"
  else
    echo -e "\033[37m$trimmed_line : \033[31mDOWN\033[0m"
  fi
done <"$input_file"
