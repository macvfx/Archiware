# Archiware
Archiware P5 scripts

## API access scripts
- Get the overview of recent archive jobs via the API
- Or check archive pool usage via the API

## Random scripts
- *jobs-sql2csv* Output all system, backup, and archive jobs ever into a CSV,
- **jobs-archive-only-sql2csv** Output only all archive jobs ever into a CSV,
- See [P5 Archive Export](https://github.com/macvfx/p5ArchiveExport) **repo** for a SQL to CSV script which analyses all the data. And there's now a Mac app too. 
- *volt2tsv* create a TSV (tab separated value) file with inventory contents for each P5 volume,
- **volt2tsv-archive-barcode** Only create a TSV inventory file of archive volumes with P5 volume and LTO barcode in the name
- **volt2tsv-check-archive-mode-VolName** Only create a TSV inventory file of archive volumes with P5 volume and mode (full, appendable) in the name
- *volume-archive-full2readonly* Identifies all archive tapes marked as "Full" and changes their mode to "Readonly"
- **volume-full-vs-appendable** Check tapes in the jukebox and categorize them: Full/Readonly tapes vs Appendable with used size in TiB
- *volume-list* Create a P5 volume list as CSV from Archiware P5 and save it to /private/tmp/ (Note: Original script form Archiware cli manual. Modified by Mat X to add volume and file output directly).

## P5 Archive Check
- The P5 Archive check scripts is in [P5 Archive Check](https://github.com/macvfx/p5ArchiveCheck)

## P5 Health Check
The P5 Health Check script and API based app is in [P5 Health Check](https://github.com/macvfx/p5HealthCheck)

## P5 Archive Manager
- The P5 Archive *Manager* app is in [P5 Archive Manager](https://github.com/macvfx/p5ArchiveManager)

## P5 Archive Overview
- The *P5 Archive Overview app* based on the archive overview REST API script is in [P5 Archive Overview](https://github.com/macvfx/p5ArchiveOverview)

## P5 Archive Search
- The *P5 Archive Search app* lets you crawl through your entire archive index via REST API. [P5 Archive Search](https://github.com/macvfx/p5ArchiveSearch)
  
## P5 Archive Export
- P5 Archive Export (mac and menu bar apps) are based on advanced version of **jobs-archive-only-sql2csv**. See [P5 Archive Export repo](https://github.com/macvfx/p5ArchiveExport)

## 2026 code.matx.ca - P5 Archive Tools for macOS & iOS
[For feedback, reach out via GitHub](https://github.com/macvfx) and [Support this project by optional donation](https://www.paypal.com/ncp/payment/ZX52VNS49SRZA)
  
## License

Apache 2.0 License - See LICENSE file for details.

## Acknowledgments

Built for use with [Archiware P5](https://www.archiware.com/)
