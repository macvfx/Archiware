#!/bin/sh

# Original script form Archiware cli manual. Modified by Mat X to add volume and file output directly
# volume-list.sh
# Create a P5 volume list as CSV from Archiware P5 and save it to /private/tmp/

# Path to nsdchat — change if P5 is installed elsewhere
chatcmd="/usr/local/aw/bin/nsdchat -c"

# Generate output filename with date and time
date_str=$(date +"%Y-%m-%d_%H%M")
outfile="/private/tmp/p5-volumes-list_${date_str}.csv"

# Create CSV header
echo "Volume,Label,Barcode,State,Mode,Type,Used Size,Last Used,Location" > "$outfile"

# Get list of all volume names
list=$($chatcmd Volume names)

# Loop through each volume and collect info
for i in $list; do
    c1=$($chatcmd Volume "$i" label)
    c2=$($chatcmd Volume "$i" barcode)
    c3=$($chatcmd Volume "$i" state)
    c4=$($chatcmd Volume "$i" mode)
    c5=$($chatcmd Volume "$i" mediatype)
    c6=$($chatcmd Volume "$i" usedsize)
    c7=$($chatcmd Volume "$i" dateused)
    c8=$($chatcmd Volume "$i" location)
    
    # Write to CSV, quoting each field safely
    printf "'%s','%s','%s','%s','%s','%s','%s','%s','%s'\n" \
        "$i" "$c1" "$c2" "$c3" "$c4" "$c5" "$c6" "$c7" "$c8" >> "$outfile"
done

echo "CSV file created: $outfile"
