#!/bin/bash

# This script will make an API call with Basic Auth to the P5 Server to get Pool Usage
# and save the JSON response to a .csv file
# 
# Original script made by Mat X in collaboration with Cristian Niculescu

# Define variables
now=$(date +"%Y-%m-%d_%H%M%S")
newdir="Archive-Overview_API-response_${now}"

mkdir "$newdir" 

# Set the API endpoint URL
p5address="127.0.0.1:8000"
version="v1"
API_URL="http://${p5address}/rest/${version}/archive/overview"

# Set the Basic Auth credentials
USERNAME="admin"
PASSWORD="pass"

# OUTPUT_FILE1="Archive-Overview_${now}.csv"
OUTPUT_FILE2="Pool-Usage_${now}.csv"

# Make the API call and retrieve the JSON response 
JSON_RESPONSE=$(curl -s -u "$USERNAME:$PASSWORD" "$API_URL")

# Add headers to "Archive Overview" CSV
# echo "Archive Plan,Start Time,Finish Time,Status,Size (KB),Client,Directories" > $newdir/$OUTPUT_FILE1

# Add headers to "Pool Usage" CSV
echo "name,usedBytes,totalBytes,freeBytes,usedPercent,summary" > $newdir/$OUTPUT_FILE2

# Process the "Pool Usage" section
echo $JSON_RESPONSE | jq -r '.["Pool Usage"][] | [.name, .usedBytes, .totalBytes, .freeBytes, .usedPercent, .summary] | @csv' >> $newdir/$OUTPUT_FILE2

# Process the "Archive Overview" section
# echo $JSON_RESPONSE | jq -r '.["Archive Overview"][] | [.pool, .["start time"], .["finish time"], .status, .sizeKbytes, .client, ( .directories | join("\n") )] | @csv' >> $newdir/$OUTPUT_FILE1
