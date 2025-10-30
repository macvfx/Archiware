#!/bin/bash

# Export Archiware P5 Jobs Db as CSV file
# Created by Mat X

timestamp=$(date +%Y%m%d-%H%M%S)
outfile="/private/tmp/p5-all-Jobs-ExportSelectFields-${timestamp}.csv"

sqlite3 /usr/local/aw/config/joblog/resources.db <<EOF
.header on
.mode csv
.output $outfile
SELECT label, timeCompleted, volumeList, driveList, savedFiles, numKbytes, planName, indexName FROM Job;
.quit
EOF

open "$outfile"
