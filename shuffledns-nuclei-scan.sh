#!/bin/bash

echo "ENTER DOMAIN HERE:"
read domain

xargs -a $domain -I@ -P500 sh -c 'shuffledns -d "@" -silent -w words.txt -r resolvers.txt' | httpx -silent -threads 100 | nuclei -t /root/nuclei-templates/ -o re1
