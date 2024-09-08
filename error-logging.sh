#!/bin/bash
# Usage in your script.
# source /path/to/error-logging.sh

# log_file="/path/to/logfile.log"
# log_verbose=2  # Set global verbose level

# log_write 1 "This is an ERROR message"
# log_write 2 "This is a NORMAL message"
# log_write 3 "This is an INFO message"  # This won't be logged if verbose level is 2

# Default settings
log_verbose=1  # Only ERROR messages by default
log_file="./default.log"

# Function to check and create log file path
log_create_path() {
    local log_file=$1
    local dir=$(dirname "$log_file")
    [[ ! -d "$dir" ]] && mkdir -p "$dir"
}

# Function to write log
log_write() {
    local level=$1
    local message=$2
    local datetime=$(date +'%Y-%m-%d %H:%M:%S')
    
    # Define log level names
    declare -A level_names
    level_names=(
        [1]="ERROR"
        [2]="NORMAL"
        [3]="INFO"
        [4]="DEBUG"
    )
    
    local log_level_name="${level_names[$level]}"
    local formatted_message="$datetime - $log_level_name: $message"

    # Write log if current level is within the verbosity level
    if [[ $level -le $log_verbose ]]; then
        log_create_path "$log_file"
        echo "$formatted_message" >> "$log_file"
        # Optionally echo to console as well
        echo "$formatted_message"
        return 0
    fi
    return 1
}

# Export log functions for sourcing
export -f log_write log_create_path
