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

## P5 Archive Browser
- P5 Archive Browser (mac app) exists to search the TSV files created by **P5 Archive Export** or the scripts provided here **volt2tsv-check-archive-mode-VolName**. Or even now in the P5 web GUI. See [P5 Archive Browser repo](https://github.com/macvfx/P5-Archive-Browser)

## P5 Archive Check
- The P5 Archive check scripts is in [P5 Archive Check](https://github.com/macvfx/p5ArchiveCheck)

## P5 Archive Export
- P5 Archive Export (mac and menu bar apps) are based on advanced version of **jobs-archive-only-sql2csv**. See [P5 Archive Export repo](https://github.com/macvfx/p5ArchiveExport)

## P5 Health Check
The P5 Health Check script and API based app is in [P5 Health Check](https://github.com/macvfx/p5HealthCheck)

## P5 Archive Manager
- The P5 Archive *Manager* app is in [P5 Archive Manager](https://github.com/macvfx/p5ArchiveManager)

## P5 Archive Overview
- The *P5 Archive Overview app* based on the archive overview REST API script is in [P5 Archive Overview](https://github.com/macvfx/p5ArchiveOverview)

## P5 Archive Search
- The *P5 Archive Search app* lets you crawl through your entire archive index via REST API. [P5 Archive Search](https://github.com/macvfx/p5ArchiveSearch)
  
## 2026 code.matx.ca - P5 Archive Tools for macOS & iOS
[For feedback, reach out via GitHub](https://github.com/macvfx) and [Support this project by optional donation](https://www.paypal.com/ncp/payment/ZX52VNS49SRZA)
  
## License

Apache 2.0 License - See LICENSE file for details.

## Acknowledgments

Built for use with [Archiware P5](https://www.archiware.com/)

## The code.matx.ca site

`index.html` in this repo is the site served at code.matx.ca (see `CNAME`).

**Never type a version number into `index.html` by hand.** Every version string and
every download link is generated from GitHub Releases:

```bash
scripts/update-versions.py            # rewrite index.html from GitHub Releases
scripts/update-versions.py --check    # exit 1 if index.html is stale (for CI)
scripts/update-versions.py --report    # print the resolved table, write nothing
```

`apps.json` maps each app to its public repo, an optional release-title regex (one
repo can ship several apps), and a channel — `stable` for the newest non-prerelease,
`latest` for apps on a beta track. `versions.json` is the generated lockfile and
records exactly which release each number came from.

The script fills two kinds of marked slot and touches nothing else:

```html
<span data-version="copytrust">v2.8.2 build 23</span>
<a data-release="copytrust" href="https://github.com/macvfx/MHL/releases">Download Release</a>
```

Adding an app: give it an entry in `apps.json`, add a card with those slots, run the
script. It reports any resolved app that has no slot yet, and any slot whose key is
not in `apps.json`.

**Download links always point at a repo's `/releases` page, never at a pinned tag.**
A pinned tag link is how this site once served a two-major-versions-old beta of
P5 Archive Manager while a current release sat one click away.
