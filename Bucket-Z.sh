#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE=$1

# Iterate over each URL in the input file
while IFS= read -r URL; do
    curl -s "$URL" | grep -E -q '<Code>NoSuchBucket</Code>|<li>Code: NoSuchBucket</li>' && echo "Subdomain takeover may be possible for $URL" || echo "Subdomain takeover is not possible for $URL"
done < "$INPUT_FILE"


#Simple Bucket Takeover Checker for S3 Bucket
