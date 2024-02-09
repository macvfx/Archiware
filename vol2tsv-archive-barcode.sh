#!/bin/sh
# Create TSV from volume list of type "Archive"
#
# Change the path in case P5 is installed elsewhere
chatcmd="/usr/local/aw/bin/nsdchat -c"
output_directory="/Volumes/Backup/AW/TSV"

list=$($chatcmd Volume names)

for i in $list
do
    # Get the type and barcode of the volume
    volume_type=$($chatcmd Volume "$i" usage)
    volume_barcode=$($chatcmd Volume "$i" barcode)

    # Check if the volume type is "Archive"
    if [ "$volume_type" = "Archive" ]; then
        # Generate the modified output file name
        tsv_file="$output_directory/${i}_${volume_barcode}.tsv"

        # Check if the TSV file already exists
        if [ -e "$tsv_file" ]; then
            # Add your comparison logic here if needed
            echo "TSV file $tsv_file already exists. Skipping..."
        else
            # Create the TSV file if it doesn't exist
            $($chatcmd Volume $i inventory localhost:$tsv_file ppath size handle btime mtime)
            echo "Created TSV file for Volume $i (Barcode: $volume_barcode) at $tsv_file"
        fi
    else
        echo "Skipping Volume $i as it is not of type 'Archive'"
    fi
done
