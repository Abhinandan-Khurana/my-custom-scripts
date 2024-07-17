#!/bin/bash

# Check if the file path is provided as an argument
if [ "$#" -lt 1 ]; then
	echo "Usage: $0 <file_with_urls>"
	exit 1
fi

file_with_urls=$1

# Function to scan a single URL
scan_url() {
	local url=$1
	echo "------ Scanning $url -------"

	start_time=$(date +%s)
	~/go/bin/gap -api "$url" -poc
	end_time=$(date +%s)

	elapsed_time=$((end_time - start_time))
	echo "------ Done scanning $url (Time taken: ${elapsed_time}s) ------"
}

# Read each line (URL) from the file and scan it
while IFS= read -r url; do
	scan_url "$url"
done <"$file_with_urls"

echo "All scans completed."
