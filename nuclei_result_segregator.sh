#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input-file>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FOLDER="final_nuclei_result_segregated"

# Create the output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Read the input file line by line
while IFS= read -r line
do
    # Extract the issue title (type) using awk
    issue_title=$(echo "$line" | awk -F '[][]' '{print $2}')

    # Replace spaces with underscores in the issue title for the filename
    file_name=$(echo "$issue_title" | tr '[:space:]' '_')

    # Append the line to the respective output file
    echo "$line" >> "$OUTPUT_FOLDER/$file_name.txt"
done < "$INPUT_FILE"

echo "Issues segregated into separate files in the '$OUTPUT_FOLDER' folder."
