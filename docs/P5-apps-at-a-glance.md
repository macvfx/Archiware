# P5 Archive Apps at a Glance

A quick reference for the macOS tools that work alongside **Archiware P5**. All are free, signed Mac apps; downloads and full guides are at **[code.matx.ca](https://code.matx.ca)**.

> Several apps are **beta**. Anything that restores or deletes asks before it acts. Keep your own verified backup.

## "Is it archived? Where is it? Get it back."

| App | Use it when you want to… |
|---|---|
| **P5 Archive Manager** | Drop a folder and see which files are safely archived in P5 (with tape barcode and date). Can archive what's missing, delete local copies only once P5 proves they're archived, and restore a whole project from an editor's timeline (FCPXML, Premiere/Resolve XML, Resolve .drt). Two editions: **CLI** (stable, runs on/near the P5 server) and **API** (newer, works over the network, beta). |
| **P5 Archive Search** | Browse the archive like a Finder window, search it by name or path, and restore a file or folder. Tells you which tape it needs and whether that tape is loaded. |
| **P5 Archive Browser** | Answer "which LTO tape is this on?" Search across every tape from imported inventory lists, even offline, organise tapes into groups with shelf locations, and restore a folder or project. *(Beta)* |
| **P5 Search Jumper** | Find a shot by what's on screen or said (using a Jumper analysis cache), then restore just that clip from P5 if it's no longer on disk. *(Beta)* |

## "Is P5 healthy? What has it been doing?"

| App | Use it when you want to… |
|---|---|
| **P5 Health Check** | Keep an eye on one or more P5 servers: running and failed jobs, drives needing cleaning, tape status, licences. Mac window, menu bar, and iPhone apps. Watch-only; it never changes anything. |
| **P5 Archive Overview** | See current and past archive jobs and how full each storage pool is, with a saved history you can export to CSV. Watch-only. |
| **P5 Archive Export** | Pull reports and backups off the P5 server: archive history to CSV with charts (growth, throughput), a per-tape contents list, and a backup of P5's own settings and logs. Can run on a schedule. Window app plus a menu bar version. |

## Getting media into the archive safely

| App | Use it when you want to… |
|---|---|
| **CopyTrust** | Offload camera cards to several drives at once, verify every file, produce a manifest (MHL), contact sheet PDF and receipt, make proxies, and send the verified copy to P5. *(Beta)* |
| **Folder Copy Compare** | Check that two folders are truly identical, file by file. Also clears leftover P5 stub files from restored folders. |
| **Drop Verify / MHL Verify** | Drop Verify: make a manifest and contact sheet for one folder. MHL Verify: later, re-check media against any manifest (also reads Silverstack, OffShoot, ShotPut Pro, YoYotta). |
| **Project Folder Creator** | Create the same numbered project folder on edit, archive, and cloud storage in one step. *(Beta)* |

## Keeping storage under control

| App | Use it when you want to… |
|---|---|
| **Find File Type** | See what is filling an edit drive, NAS, or LucidLink share, broken down by file type (camera originals, proxies, renders, exports). Tracks growth over time, so you can tell what is safe to archive with P5 and clear. |

## Which one do I open?

- **"Can I delete this folder?"** → P5 Archive Manager
- **"Find a file I archived last year."** → P5 Archive Search (or P5 Archive Browser if you need the tape)
- **"Restore this edit's media."** → P5 Archive Manager (Restore from Project File)
- **"Is the P5 server OK?"** → P5 Health Check
- **"How much did we archive this year?"** → P5 Archive Export or P5 Archive Overview
- **"Did that copy finish correctly?"** → Folder Copy Compare or MHL Verify
- **"Why is this drive full?"** → Find File Type

*For administrators:* a set of Bash scripts for P5 (job lists, tape inventories, marking full tapes read-only) lives in the [Archiware scripts repo](https://github.com/macvfx/Archiware).
