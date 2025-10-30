#!/bin/sh
# Copyright Mat X 2025 - All Rights Reserved
# This script identifies all archive tapes marked as "Full" and changes their mode to "Readonly".
# It logs the changes and displays a summary upon completion with swiftDialog or applescript notification.

# Path to nsdchat, adjust if P5 is installed elsewhere
chatcmd="/usr/local/aw/bin/nsdchat -c"
output_directory="/private/tmp/log"
log_file="$output_directory/change_tape_modes_$(date +'%Y%m%d_%H%M%S').log"
dialog="/usr/local/bin/dialog"

# Ensure the output directory exists
mkdir -p "$output_directory"

# Start logging
echo "Tape Mode Change Script - $(date)" > "$log_file"
echo "========================================" >> "$log_file"

# Check for swiftDialog binary
if [ ! -x "$dialog" ]; then
    echo "swiftDialog not found at $dialog — will use macOS notification fallback." >> "$log_file"
    use_dialog=false
else
    use_dialog=true
fi

# Get the list of all volumes
all_volumes=$($chatcmd Volume names)

# Initialize result variables
updated_volumes=""
skipped_volumes=""

# Loop through each volume
for volume in $all_volumes; do
    # Get the type and mode of the volume
    volume_type=$($chatcmd Volume "$volume" usage)
    volume_status=$($chatcmd Volume "$volume" mode)

    # Log the check
    echo "Checking Volume: $volume (Type: $volume_type, Status: $volume_status)" >> "$log_file"

    # Check if the volume is of type "Archive" and mode is "Full"
    if [ "$volume_type" = "Archive" ] && [ "$volume_status" = "Full" ]; then
        # Change the mode to "Readonly"
        $chatcmd Volume "$volume" mode Readonly
        new_status=$($chatcmd Volume "$volume" mode)

        if [ "$new_status" = "Readonly" ]; then
            echo "Updated Volume: $volume from Full to Readonly" >> "$log_file"
            updated_volumes="$updated_volumes\n$volume,Readonly"
        else
            echo "Failed to update Volume: $volume" >> "$log_file"
        fi
    else
        echo "Skipping Volume: $volume (Type: $volume_type, Status: $volume_status)" >> "$log_file"
        skipped_volumes="$skipped_volumes\n$volume,$volume_status"
    fi
done

# Summarize results
{
    echo
    echo "Updated Volumes:"
    echo -e "$updated_volumes"
    echo
    echo "Skipped Volumes:"
    echo -e "$skipped_volumes"
    echo
} >> "$log_file"

# Display results
if [ "$use_dialog" = true ]; then
    "$dialog" -s --title "P5 Volume Mode Update" \
        --message "Script completed.<br>Log file saved at:<br>$log_file"
else
    echo "swiftDialog not found — showing macOS notification instead." >> "$log_file"
    /usr/bin/osascript -e "display notification \"Log file saved at: $log_file\" with title \"P5 Volume Mode Update\" subtitle \"Script completed\""
fi

# Finish logging
echo "Script completed on $(date)" >> "$log_file"

# Open the log file in default text viewer
open "$log_file"
