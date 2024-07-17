#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <ip_list_file>"
	exit 1
fi

IP_LIST_FILE=$1

# Create results directory if it doesn't exist
mkdir -p results

echo "THIS MAY TAKE A WHILE, PLEASE BE PATIENT WHILE whois IS RUNNING..."
printf "["

# While process is running...
while true; do
	printf "▓"
	sleep 1
done &

# Store the background process ID
PID=$!

# Process the IP list file
while IFS= read -r ip; do
	whois "$ip" | grep -E "NetName|Country|Organization|RegDate|Updated|OrgTechName" >"results/whois_result_$(basename $ip).txt" 2>/dev/null
done <"$IP_LIST_FILE"

# Kill the background process
kill $PID

printf "] done!\n"
