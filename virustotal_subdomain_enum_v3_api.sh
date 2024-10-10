#!/bin/bash

target=$1
url="https://www.virustotal.com/api/v3/domains/$target/subdomains"
api_key="YOUR_API_KEY" # Change this

if [[ $# -eq 0 ]]; then
  echo "[-] Usage: ./virus-scrape.sh <target.com>"
  exit 1
fi

# Calculating the total no of results associated to the target
count=$(curl -s -X GET "$url" --header "x-apikey: $api_key" | jq -r .meta.count)
check=$(expr $count / 40)
check_2=$(expr $count % 40)
if [ "$check_2" -gt 0 ]; then
  iters=$(expr $check + 1)
else
  iters=$check
fi

# Iterating as api limit is just 40
cursor="?cursor=&limit=40"
for ((i = 1; i <= "$iters"; i++)); do
  curl -s -X GET "$url$cursor" --header "x-apikey: $api_key" | jq -r .data[].id | tee -a virus-total-api-subs.txt
  next=$(curl -s -X GET "$url$cursor" --header "x-apikey: $api_key" | jq -r .links.next)
  name=$(basename $next | grep -oE "\?.*")
  if [[ ! -z "$name" ]]; then
    cursor=$name
  fi
done
