#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <domain list> <output format (txt|csv)>"
  echo "Example: $0 domain_list.txt csv"
  exit 1
fi

domain_list=$1
output_format=$2

if [ ! -f "$domain_list" ]; then
  echo "Error: File '$domain_list' not found."
  exit 1
fi

if [ ! -r "$domain_list" ]; then
  echo "Error: File '$domain_list' is not readable."
  exit 1
fi

if [[ "$output_format" != "txt" && "$output_format" != "csv" ]]; then
  echo "Error: Output format must be either 'txt' or 'csv'."
  exit 1
fi

get_ssl_expiry_date() {
  local domain=$1
  expiry_date=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter=' | cut -d= -f2)
  if [ -z "$expiry_date" ]; then
    expiry_date="No SSL expiry date found"
  fi
  echo "$expiry_date"
}

output_file="ssl_expiry_results.$output_format"
: >"$output_file"

if [ "$output_format" == "csv" ]; then
  echo "Domain,Expiry Date" >"$output_file"
fi

while IFS= read -r domain; do
  if [[ ! $domain =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Invalid domain: $domain"
    continue
  fi

  echo "Checking SSL expiry date for $domain..."
  expiry_date=$(get_ssl_expiry_date "$domain")

  if [ "$output_format" == "txt" ]; then
    echo "SSL expiry date for $domain: $expiry_date" >>"$output_file"
  else
    echo "$domain,$expiry_date" >>"$output_file"
  fi
done <"$domain_list"

echo "Results have been saved to $output_file"
