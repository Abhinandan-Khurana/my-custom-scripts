#!/bin/bash
dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 20 -o resolvers.txt
