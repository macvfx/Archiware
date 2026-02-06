#!/bin/sh
# Copyright Mat X 2025 - All Rights Reserved
# Create TSV from volume list of type "Archive"
#
# Usage:
#   ./vol2tsv-archive-barcode.sh [optional_output_directory]
#
# Example:
#   ./vol2tsv-archive-barcode.sh /private/tmp/tsv_output
#
# If no argument is given, it defaults to /Volumes/Backup/AW/TSV
# Change the path in case P5 is installed elsewhere
chatcmd="/usr/local/aw/bin/nsdchat -c"

# Use provided path or default
output_directory="${1:-/private/tmp/tsv}"

# Ensure output directory exists
mkdir -p "$output_directory"

list=$($chatcmd Volume names)

for i in $list
do
    # Get the type, barcode, and mode of the volume
    volume_type=$($chatcmd Volume "$i" usage)
    volume_barcode=$($chatcmd Volume "$i" barcode)
    volume_mode=$($chatcmd Volume "$i" mode)

    # Check if the volume type is "Archive"
    if [ "$volume_type" = "Archive" ]; then

        # Base name for output
        if [ "$volume_mode" = "Readonly" ]; then
            tsv_file="$output_directory/${i}_${volume_barcode}_ReadOnly.tsv"
        else
            timestamp=$(date +"%Y%m%d-%H%M%S")
            tsv_file="$output_directory/${i}_${volume_barcode}_${volume_mode}_${timestamp}.tsv"
        fi

        # Check if the TSV file already exists
        if [ -e "$tsv_file" ]; then
            echo "TSV file $tsv_file already exists. Skipping..."
        else
            # Create the TSV file
            $chatcmd Volume "$i" inventory "localhost:$tsv_file" ppath size handle btime mtime
            echo "Created TSV file for Volume $i (Barcode: $volume_barcode, Mode: $volume_mode) at $tsv_file"
        fi
    else
        echo "Skipping Volume $i as it is not of type 'Archive'"
    fi
done
