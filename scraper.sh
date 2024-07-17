#!/bin/bash

# Set colors for output
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Get input file from user
read -p "$(echo -e "${YELLOW}[+] Enter the name of the input file:${NC} ")" inputFile

# Read file line by line and extract domains
while read -r line; do
	# Extract domain from line
	domain=$(echo "$line" | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | awk -F/ '{print $3}')

	# Check if domain is valid and unique
	if [[ -n "$domain" ]] && ! grep -q "^$domain$" domains.txt; then
		echo "$domain" >>domains.txt
	fi
done <"$inputFile"

# Loop through domains and make HTTP requests
while read -r domain; do
	echo -e "${YELLOW}[+] Testing domain: $domain${NC}"

	# Make HTTP request and output response code
	response=$(curl -sL -w "%{http_code}" "$domain" -o /dev/null)

	# Output result of test
	if [[ "$response" -ge 200 ]] && [[ "$response" -lt 400 ]]; then
		echo -e "${GREEN}[+] Domain $domain is UP!${NC}"
	else
		echo -e "${YELLOW}[+] Domain $domain is DOWN!${NC}"
	fi
done <domains.txt
