# Archiware
Archiware P5 scripts

## API access scripts
- Get the overview of recent archive jobs via the API
- Or check archive pool usage via the API

## Random scripts
- *jobs-sql2csv* Output all system, backup, and archive jobs ever into a CSV,
- **jobs-archive-only-sql2csv** Output only all archive jobs ever into a CSV, 
- *volt2tsv* create a TSV (tab separated value) file with inventory contents for each P5 volume,
- **volt2tsv-archive-barcode** Only create a TSV inventory file of archive volumes with P5 volume and LTO barcode in the name
- *volume-archive-full2readonly* Identifies all archive tapes marked as "Full" and changes their mode to "Readonly"
- **volume-full-vs-appendable** Check tapes in the jukebox and categorize them: Full/Readonly tapes vs Appendable tapes with used size in TiB
- *volume-list* Create a P5 volume list as CSV from Archiware P5 and save it to /private/tmp/ (Note: Original script form Archiware cli manual. Modified by Mat X to add volume and file output directly).
