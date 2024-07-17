#!/bin/bash

# Check if domain is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1

# Use puredns to resolve subdomains
puredns resolve <(cat output.txt) | puredns filter --wildcards > resolved_subdomains.txt

# Use dnsx to further validate the resolved subdomains
cat resolved_subdomains.txt | dnsx -silent -a -cname -resp-only > final_subdomains.txt

# Display the final list of subdomains
cat final_subdomains.txt
