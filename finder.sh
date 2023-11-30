#!/bin/bash

echo "FINDER:~"
read -p "Enter the path where you want find: " find_path
read -p "Enter the file name you want to find: " file_name

find $find_path -type f -name "$file_name" 2>/dev/null & pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}"
  sleep .1
done
