#!/bin/bash

# Check if the input file is provided
if [ $# -eq 0 ]; then
	echo "Usage: $0 input_file"
	exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
	echo "Input file '$input_file' does not exist."
	exit 1
fi

# Spinner function
spinner() {
<<<<<<< HEAD
  local delay=0.1
  local spinstr='|/-\'
  while true; do
    local active=0
    for pid in "$@"; do
      if [ -d "/proc/$pid" ]; then
        active=1
        break
      fi
    done
    if [ $active -eq 0 ]; then
      break
    fi
    local temp=${spinstr#?}
    printf " \033[0;33m[%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\r"
  done
  echo -e "\n" # Add a newline after spinner
=======
	local delay=0.1
	local spinstr='|/-\'
	while true; do
		local active=0
		for pid in "$@"; do
			if [ -d "/proc/$pid" ]; then
				active=1
				break
			fi
		done
		if [ $active -eq 0 ]; then
			break
		fi
		local temp=${spinstr#?}
		printf " \033[0;33m[%c]  " "$spinstr"
		local spinstr=$temp${spinstr%"$temp"}
		sleep $delay
		printf "\r"
	done
	echo -e "\n" # Add a newline after spinner
>>>>>>> 3e2cdec (added keyword file filter and domain scrapper from a file)
}

# Function to check host status
check_host() {
<<<<<<< HEAD
  host=$1
  if ping -c 1 "$host" &> /dev/null; then
    echo -e "\033[0;36m$host : \033[0;32mUP" >> "$results_file"
  else
    echo -e "\033[0;37m$host : \033[0;31mDOWN" >> "$results_file"
  fi
=======
	host=$1
	if ping -c 1 "$host" &>/dev/null; then
		echo -e "\033[0;36m$host : \033[0;32mUP" >>"$results_file"
	else
		echo -e "\033[0;37m$host : \033[0;31mDOWN" >>"$results_file"
	fi
>>>>>>> 3e2cdec (added keyword file filter and domain scrapper from a file)
}

# Temporary file to store results
results_file=$(mktemp)

# Array to hold process IDs of background tasks
bg_pids=()

# Read hosts from the input file and check their status
while IFS= read -r line; do
	# Trim whitespace and skip empty lines and comments
	trimmed_line="${line#"${line%%[![:space:]]*}"}"                 # Left trim
	trimmed_line="${trimmed_line%"${trimmed_line##*[![:space:]]}"}" # Right trim
	if [[ -z "$trimmed_line" ]] || [[ "$trimmed_line" == \#* ]]; then
		continue
	fi
	check_host "$trimmed_line" &
	bg_pids+=($!)
done <"$input_file"

# Start the spinner
spinner "${bg_pids[@]}" &

wait # Wait for all background processes to finish

# Print the results
cat "$results_file"
rm "$results_file" # Clean up temporary file
