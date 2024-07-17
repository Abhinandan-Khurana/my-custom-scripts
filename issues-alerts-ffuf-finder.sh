#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

IP_LIST=$1
COUNTER=1
while IFS= read -r ip; do
  ffuf -w ./issues-alerts.wordlist -u $ip/FUZZ -s | grep -E "issues|alerts" && echo "Found: $ip" | grep -oE '([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' >>output.txt
  COUNTER=$((COUNTER + 1))
  echo "Progress: $COUNTER"
done <"$IP_LIST"
