#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ip_list_file>"
  exit 1
fi

IP_LIST=$1

# Scan IPs using rustscan and then pass to nmap for vulnerability scripts
while IFS= read -r ip; do
  echo "SSL Expiry Date for $ip: "
  curl -Iv --stderr - $ip | grep "expire date:" | cut -d":" -f 2-
done <"$IP_LIST"

echo "RustScan and nmap scans completed."
