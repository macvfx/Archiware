#!/bin/bash

# Export Archiware P5 Jobs Db as CSV file
# Created by Mat X

sqlite3 /usr/local/aw/config/joblog/resources.db <<EOF
.header on
.mode csv
.output p5JobListExportSelectFields.csv
SELECT label, timeCompleted, volumeList, driveList, savedFiles, numKbytes, planName, indexName FROM Job;
.quit
EOF
