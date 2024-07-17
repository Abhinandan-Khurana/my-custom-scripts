#!/bin/bash

echo "ENTER YOUR DOMAIN: "
read domain
amass intel -org $domain -max-dns-queries 2500 | awk -F, '{print $1}' ORS=',' | sed 's/,$//' | xargs -P3 -I@ -d ',' amass intel -asn @ -max-dns-queries 2500'' > amass-intel.txt
