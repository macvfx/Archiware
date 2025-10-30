#!/bin/sh
# Copyright Mat X. 2025. All rights Reserved
# Check tapes in the jukebox and categorize them:
# 1. Full/Readonly tapes
# 2. Appendable tapes with used size in TiB
# Results are displayed, logged, and exported to CSV.

# Change the path if P5 is installed elsewhere
chatcmd="/usr/local/aw/bin/nsdchat -c"
# Jukebox name, adjust as necessary
jukebox="awjb0"  
output_directory="/private/tmp/jukebox_check"
log_file="$output_directory/jukebox_tapes_check_$(date +'%Y%m%d_%H%M%S').log"
csv_file_full="$output_directory/jukebox_tapes_full_or_readonly_$(date +'%Y%m%d_%H%M%S').csv"
csv_file_appendable="$output_directory/jukebox_tapes_appendable_$(date +'%Y%m%d_%H%M%S').csv"
dialog="/usr/local/bin/dialog"

# Ensure the output directory exists
mkdir -p "$output_directory"

# Start logging
echo "Jukebox Tapes Check - $(date)" > "$log_file"
echo "========================================" >> "$log_file"

# Check for swiftDialog binary
if [ ! -x "$dialog" ]; then
    echo "swiftDialog not found at $dialog — will use macOS notification fallback." >> "$log_file"
    use_dialog=false
else
    use_dialog=true
fi

# Initialize CSV files with headers
echo "Volume,Barcode,Status" > "$csv_file_full"
echo "Volume,Barcode,Status,Used Size (TiB)" > "$csv_file_appendable"

# Get the list of volumes in the jukebox
jukebox_volumes=$($chatcmd Jukebox "$jukebox" volumes)

# Initialize result variables
result_list_full=""
result_list_appendable=""

# Loop through each volume in the jukebox
for i in $jukebox_volumes; do
    # Get the type, mode, and barcode of the volume
    volume_type=$($chatcmd Volume "$i" usage)
    volume_status=$($chatcmd Volume "$i" mode)
    volume_barcode=$($chatcmd Volume "$i" barcode)

    # Log the check
    echo "Checking Volume: $i (Type: $volume_type, Status: $volume_status, Barcode: $volume_barcode)" >> "$log_file"

    # Check if the volume type is "Archive"
    if [ "$volume_type" = "Archive" ]; then
        if [ "$volume_status" = "Full" ] || [ "$volume_status" = "Readonly" ]; then
            result_list_full="$result_list_full\n$i (Barcode: $volume_barcode, Status: $volume_status)"
            echo "$i,$volume_barcode,$volume_status" >> "$csv_file_full"
        elif [ "$volume_status" = "Appendable" ]; then
            used_size_kb=$($chatcmd Volume "$i" usedsize)
            used_size_tib=$(echo "scale=3; $used_size_kb / (1024*1024*1024)" | bc)
            result_list_appendable="$result_list_appendable\n$i (Barcode: $volume_barcode, Status: $volume_status, Used: ${used_size_tib} TiB)"
            echo "$i,$volume_barcode,$volume_status,$used_size_tib" >> "$csv_file_appendable"
        fi
    else
        echo "Skipping Volume $i as it is not of type 'Archive'" >> "$log_file"
    fi
done

# Display results in Terminal and swiftDialog, and log the outcomes
if [ -n "$result_list_full" ]; then
    echo "The following Archive tapes in the jukebox are Full or Readonly:"
    echo -e "$result_list_full"
    echo -e "\nResult List (Full/Readonly):" >> "$log_file"
    echo -e "$result_list_full" >> "$log_file"

    if [ "$use_dialog" = true ]; then
    $dialog -s --title "P5 Jukebox Check" \
            --message "Archive tapes in the jukebox that are Full or Readonly:<br>$result_list_full"
    else
    echo "swiftDialog not found — showing macOS notification instead." >> "$log_file"
    /usr/bin/osascript -e "display notification \"Archive tapes in the jukebox that are Full or Readonly: $result_list_full\" with title \"P5 Jukebox Check\""
    fi
else
    echo "No Archive tapes in the jukebox are set to Full or Readonly."
    echo "No Archive tapes in the jukebox are set to Full or Readonly." >> "$log_file"
fi

if [ -n "$result_list_appendable" ]; then
    echo "The following Archive tapes in the jukebox are Appendable with their used sizes in TiB:"
    echo -e "$result_list_appendable"
    echo -e "\nResult List (Appendable):" >> "$log_file"
    echo -e "$result_list_appendable" >> "$log_file"
     if [ "$use_dialog" = true ]; then
    $dialog -s --title "P5 Jukebox Check" \
            --message "Appendable Archive tapes in the jukebox with used size in TiB:<br>$result_list_appendable"
    else
    echo "swiftDialog not found — showing macOS notification instead." >> "$log_file"
    /usr/bin/osascript -e "display notification \"Appendable Archive tapes in the jukebox with used size in TiB:$result_list_appendable\" with title \"P5 Jukebox Check\""
    fi
else
    echo "No Archive tapes in the jukebox are Appendable."
    echo "No Archive tapes in the jukebox are Appendable." >> "$log_file"
fi

# Finish logging
echo "Check completed on $(date)" >> "$log_file"
echo "Log file saved to $log_file"
echo "CSV file for Full/Readonly tapes saved to $csv_file_full"
echo "CSV file for Appendable tapes saved to $csv_file_appendable"
open "$csv_file_full"
open "$csv_file_appendable"
