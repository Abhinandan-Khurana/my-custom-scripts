#!/bin/bash

# Colors
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Check if input file is provided
if [ $# -eq 0 ]; then
  echo -e "${RED}Usage: $0 <url_file>${NC}"
  exit 1
fi

url_file=$1

if [ ! -f "$url_file" ]; then
  echo -e "${RED}Error: File $url_file not found!${NC}"
  exit 1
fi

while IFS= read -r url; do
  echo -e "${YELLOW}Checking URL: $url${NC}"

  # Make a HEAD request and capture response code
  response_code=$(curl -o /dev/null -s -w "%{http_code}\n" -I "$url")

  # Check response code and color code the output
  if [[ $response_code -ge 200 && $response_code -lt 300 ]]; then
    echo -e "${GREEN}Response Code: $response_code (Success)${NC}"
  elif [[ $response_code -ge 300 && $response_code -lt 400 ]]; then
    echo -e "${YELLOW}Response Code: $response_code (Redirect)${NC}"
  elif [[ $response_code -ge 400 && $response_code -lt 600 ]]; then
    echo -e "${RED}Response Code: $response_code (Error)${NC}"
  else
    echo -e "${RED}Unknown Response Code: $response_code${NC}"
  fi

  echo
done <"$url_file"
