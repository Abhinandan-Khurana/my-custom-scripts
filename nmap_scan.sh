#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ip_list_file>"
    exit 1
fi

IP_LIST=$1

# Scan IPs using nmap with vulnerability scripts
while IFS= read -r ip; do
    nmap -sV --script=vuln "$ip" -oN "nmap_scan_$ip.txt"
done < "$IP_LIST"

echo "nmap scans completed."
