#!/bin/sh
# Copyright Mat X 2025 - All Rights Reserved
# Create TSV inventory file from volume list of type "Archive" and "ReadOnly"
# If Archive but not read only mode then mark with mode and time stmap

# Change the path in case P5 is installed elsewhere
chatcmd="/usr/local/aw/bin/nsdchat -c"
output_directory="/Users/Shared/AW/TSV"

list=$($chatcmd Volume names)

for i in $list
do
    # Get the type, barcode, and mode of the volume
    volume_type=$($chatcmd Volume "$i" usage)
    #volume_barcode=$($chatcmd Volume "$i" barcode)
    volume_mode=$($chatcmd Volume "$i" mode)

    # Check if the volume type is "Archive"
    if [ "$volume_type" = "Archive" ]; then

        # Base name for output
        if [ "$volume_mode" = "Readonly" ]; then
            tsv_file="$output_directory/${i}_ReadOnly.tsv"
        else
            timestamp=$(date +"%Y%m%d-%H%M%S")
            tsv_file="$output_directory/${i}_${volume_mode}_${timestamp}.tsv"
        fi

        # Check if the TSV file already exists
        if [ -e "$tsv_file" ]; then
            echo "TSV file $tsv_file already exists. Skipping..."
        else
            # Create the TSV file
            $chatcmd Volume "$i" inventory "localhost:$tsv_file" ppath size handle btime mtime
            echo "Created TSV file for Volume $i , Mode: $volume_mode) at $tsv_file"
        fi
    else
        echo "Skipping Volume $i as it is not of type 'Archive'"
    fi
done