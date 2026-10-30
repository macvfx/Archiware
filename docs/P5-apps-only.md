# Archiware P5 Apps: Quick Reference

A short guide to the Mac apps that work with your **Archiware P5** server. All are free, signed Mac apps; downloads and full guides are at **[code.matx.ca](https://code.matx.ca)**.

> Some apps are **beta**. Anything that restores or deletes asks before it acts. Keep your own verified backup.

## Find, check, and restore archived files

**P5 Archive Manager** — *"Is this folder archived? Can I delete it?"*
Drop a folder and see which files are safely in P5, with archive date and tape barcode. It can also archive what's missing, delete local copies only after P5 proves they're archived, and restore a whole project from an editor's timeline file (FCPXML, Premiere/Resolve XML, Resolve .drt). Comes in two editions: **CLI** (stable, needs P5's command-line tool on the Mac) and **API** (newer, works over the network, beta).

**P5 Archive Search** — *"Find a file I archived and bring it back."*
Browse the archive like a Finder window, search by name or path, and restore a single file or a whole folder. Before restoring, it tells you which tape is needed and whether it's loaded.

**P5 Archive Browser** — *"Which LTO tape is this on?"*
Search across every tape using imported tape inventory lists, even when the server is offline. Organise tapes into groups with shelf locations and notes, and restore a folder or project from the tape that holds it. Restore is off until you turn it on. *(Beta)*

## Watch the P5 server

**P5 Health Check** — *"Is P5 OK right now?"*
Monitor one or more P5 servers: running and failed jobs, drives that need cleaning, tape status, and licences. Available as a Mac window, a menu bar icon, and an iPhone app. Watch-only; it never changes anything on the server.

**P5 Archive Overview** — *"What has been archived lately, and how full are the pools?"*
Lists current and past archive jobs and storage pool usage, keeps a history on your Mac, and exports to CSV. Watch-only.

## Reports and backups of P5 itself

**P5 Archive Export** — *"How much did we archive this year? Save a copy of P5's settings."*
Exports archive history to CSV with charts (growth, throughput per week/month/year), creates a contents list for each tape, and backs up P5's own settings and logs. Can run on a schedule. Comes as a full window app and a small menu bar version.

## Which one do I open?

| Question | App |
|---|---|
| Can I safely delete this folder? | P5 Archive Manager |
| Restore the media for this edit | P5 Archive Manager (Restore from Project File) |
| Find and restore a file or folder | P5 Archive Search |
| Which tape do I need to load? | P5 Archive Browser |
| Is the server healthy? Any failed jobs? | P5 Health Check |
| Recent archive jobs and pool space | P5 Archive Overview |
| Yearly totals, tape contents lists, P5 settings backup | P5 Archive Export |

*For administrators:* Bash scripts for P5 (job lists, tape inventories, marking full tapes read-only) are in the [Archiware scripts repo](https://github.com/macvfx/Archiware).
