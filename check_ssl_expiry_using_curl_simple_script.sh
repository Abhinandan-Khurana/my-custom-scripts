#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <domain_url_list_file>"
  exit 1
fi

DOMAIN_URL_LIST=$1

while IFS= read -r domain_url; do
  echo "SSL Expiry Date for $domain_url: "
  curl -Iv --stderr - $domain_url | grep "expire date:" | cut -d":" -f 2-
done <"$DOMAIN_URL_LIST"

echo "Scan complete!"
