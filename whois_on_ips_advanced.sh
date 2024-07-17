#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <ip_list_file>"
	exit 1
fi

IP_LIST_FILE=$1

# Create results directory if it doesn't exist
mkdir -p results

# Read the total number of lines (IPs) in the file
TOTAL_LINES=$(wc -l <"$IP_LIST_FILE")
CURRENT_LINE=0

# Function to update progress
update_progress() {
	local current=$1
	local total=$2
	local percent=$((current * 100 / total))
	local bar_size=50
	local filled_size=$((bar_size * percent / 100))
	local empty_size=$((bar_size - filled_size))

	# Build the progress bar
	local bar=""
	for ((i = 0; i < filled_size; i++)); do bar+="▓"; done
	for ((i = 0; i < empty_size; i++)); do bar+="░"; done

	printf "\r[%s] %d%%" "$bar" "$percent"
}

echo "THIS MAY TAKE A WHILE, PLEASE BE PATIENT WHILE whois IS RUNNING..."

# Process the IP list file
while IFS= read -r ip; do
	whois "$ip" | grep -E "NetName|Country|Organization|RegDate|Updated|OrgTechName" >"results/whois_result_$(basename $ip).txt" 2>/dev/null
	CURRENT_LINE=$((CURRENT_LINE + 1))
	update_progress $CURRENT_LINE $TOTAL_LINES
done <"$IP_LIST_FILE"

echo -e "\nDone!"
