#!/bin/sh
# Create TSV from volume list (checking if file exists already before writing a new one)
#
#
# Change the path in case P5 is installed elsewhere
chatcmd="/usr/local/aw/bin/nsdchat -c"

# Use provided path or default
output_directory="${1:-/private/tmp/tsv}"

# Ensure output directory exists
mkdir -p "$output_directory"

list=`$chatcmd Volume names`

for i in $list
do
    tsv_file="$output_directory/$i.tsv"

    # Check if the TSV file already exists
    if [ -e "$tsv_file" ]; then
        # Add your comparison logic here if needed
        echo "TSV file $tsv_file already exists. Skipping..."
    else
        # Create the TSV file if it doesn't exist
        `$chatcmd Volume $i inventory localhost:$tsv_file ppath size handle btime mtime`
        echo "Created TSV file for Volume $i at $tsv_file"
    fi
done
