#!/bin/bash

# Check if a file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_with_hosts>"
    exit 1
fi

file="$1"

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File not found: $file"
    exit 1
fi

# Function to check DNS record using dig
check_dns_with_dig() {
    host=$1
    output=$(dig +short "$host")
    if [[ -n "$output" && ! "$output" =~ ";;" ]]; then
        echo "$host - DNS record exists"
    else
        echo "$host - DNS record cleared or does not exist"
    fi
}

# Function to check DNS record using nslookup
check_dns_with_nslookup() {
    host=$1
    if nslookup "$host" 2>&1 | grep -v -e '^*' -e '^Server:' -e '^Address:' -e '^Non-authoritative' > /dev/null; then
        echo "$host - DNS record exists"
    else
        echo "$host - DNS record cleared or does not exist"
    fi
}

# Function to decide which DNS tool to use
check_dns() {
    host=$1
    if command -v nslookup > /dev/null; then
        check_dns_with_nslookup "$host"
    else
        check_dns_with_dig "$host"
    fi
}

# Read each line in the file and check DNS
while IFS= read -r host; do
    check_dns "$host"
done < "$file"
