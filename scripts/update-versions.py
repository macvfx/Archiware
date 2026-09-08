#!/usr/bin/env python3
"""Refresh every version number on code.matx.ca from GitHub Releases.

The site is a hand-written index.html. Version numbers used to be typed into it
by hand, and by 2026-09 every single one had drifted -- CopyTrust was showing
2.1.7 against a published 2.8.1, and the P5 Archive Manager download was a
hard-pinned tag link to a two-major-versions-old beta.

Version strings and download links now come from `gh release list` at build time
and are written into marked slots in index.html:

    <span data-version="copytrust">v2.8.2 build 23</span>
    <a data-release="copytrust" href="...">Download Release</a>

apps.json maps each slot key to a public repo, an optional release-title regex
(macvfx/MHL ships five apps from one repo), and a channel. Nothing else in
index.html is touched.

Usage:
    scripts/update-versions.py            rewrite index.html in place
    scripts/update-versions.py --check    exit 1 if index.html is stale
    scripts/update-versions.py --report   print the resolved table, write nothing
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MANIFEST = ROOT / "apps.json"
INDEX = ROOT / "index.html"
LOCKFILE = ROOT / "versions.json"

# Tags in the wild: 2.8.2+23, 4.0.0+25, 1.5+4, 2.6.0, 0.2.1-beta+4,
# mhl-tool-2.7.7, project-folder-creator-0.3.1+12, v0.1.0-pre
TAG_RE = re.compile(
    r"^(?:[A-Za-z][A-Za-z0-9]*(?:-[A-Za-z][A-Za-z0-9]*)*-)?"   # slug- prefix
    r"v?"                                                       # optional v
    r"(?P<ver>[0-9]+(?:\.[0-9]+)*(?:-[A-Za-z0-9.]+)?)"          # 2.8.2, 0.2.1-beta
    r"(?:\+(?P<build>[0-9]+))?$"                                # +23
)

# `2.0.2 (Build 10)` / `build 4` -- some repos put the build only in the title.
BUILD_IN_TITLE_RE = re.compile(r"\(?\bbuild\s*(?P<build>[0-9]+)\)?", re.I)

# Fall back to the release title when the tag is unparseable.
TITLE_RE = re.compile(
    r"(?P<ver>[0-9]+(?:\.[0-9]+)+)"
    r"(?:\s*\(?[Bb]uild\s*(?P<build>[0-9]+)\)?)?"
)


class ResolveError(RuntimeError):
    pass


def gh_releases(repo: str) -> list[dict]:
    """Every release in a repo, newest first."""
    try:
        out = subprocess.run(
            ["gh", "release", "list", "-R", repo, "-L", "100",
             "--json", "tagName,name,isPrerelease,isLatest,publishedAt"],
            capture_output=True, text=True, check=True,
        ).stdout
    except FileNotFoundError:
        raise ResolveError("the `gh` CLI is not installed") from None
    except subprocess.CalledProcessError as exc:
        raise ResolveError(f"gh failed for {repo}: {exc.stderr.strip()}") from None

    releases = json.loads(out or "[]")
    releases.sort(key=lambda r: r["publishedAt"], reverse=True)
    return releases


def parse_version(release: dict) -> tuple[str, str | None]:
    """(version, build) from the tag, falling back to the release title.

    Some repos carry the build only in the tag (`2.8.2+23`) and others only in
    the title (`2.0.2 (Build 10)`), so a tag without a build is topped up from
    the title rather than reported as build-less.
    """
    title = release.get("name") or ""
    m = TAG_RE.match(release["tagName"])
    if m:
        build = m.group("build")
        if build is None:
            build = BUILD_IN_TITLE_RE.search(title)
            build = build.group("build") if build else None
        return m.group("ver"), build

    m = TITLE_RE.search(title)
    if m:
        return m.group("ver"), m.group("build")
    raise ResolveError(
        f"cannot read a version from tag {release['tagName']!r} "
        f"or title {title!r}"
    )


def resolve(key: str, spec: dict, releases: list[dict]) -> dict:
    pattern = spec.get("title_match")
    if pattern:
        rx = re.compile(pattern)
        candidates = [r for r in releases if rx.search(r.get("name") or "")]
    else:
        candidates = list(releases)

    if not candidates:
        raise ResolveError(
            f"no release in {spec['repo']} matches {pattern!r}"
            if pattern else f"{spec['repo']} has no releases"
        )

    channel = spec.get("channel", "stable")
    if channel == "stable":
        stable = [r for r in candidates if not r["isPrerelease"]]
        chosen = stable[0] if stable else candidates[0]
    elif channel == "latest":
        chosen = candidates[0]
    else:
        raise ResolveError(f"{key}: unknown channel {channel!r}")

    version, build = parse_version(chosen)
    display = f"v{version}" + (f" build {build}" if build else "")

    return {
        "label": spec.get("label", key),
        "repo": spec["repo"],
        "version": version,
        "build": build,
        "display": display,
        "prerelease": chosen["isPrerelease"],
        "tag": chosen["tagName"],
        "title": chosen.get("name") or "",
        "published": chosen["publishedAt"][:10],
        # Always the releases page, never a pinned tag -- a pinned link is how
        # the site ended up serving a two-major-versions-old Archive Manager.
        "url": f"https://github.com/{spec['repo']}/releases",
    }


def resolve_all(manifest: dict) -> dict[str, dict]:
    cache: dict[str, list[dict]] = {}
    resolved: dict[str, dict] = {}
    errors: list[str] = []

    for key, spec in manifest["apps"].items():
        repo = spec["repo"]
        try:
            if repo not in cache:
                cache[repo] = gh_releases(repo)
            resolved[key] = resolve(key, spec, cache[repo])
        except ResolveError as exc:
            errors.append(f"  {key}: {exc}")

    if errors:
        raise ResolveError("could not resolve every app:\n" + "\n".join(errors))
    return resolved


def rewrite(html: str, resolved: dict[str, dict]) -> tuple[str, list[str]]:
    """Fill every data-version slot and repoint every data-release link."""
    changes: list[str] = []
    seen: set[str] = set()

    def version_slot(m: re.Match) -> str:
        key = m.group("key")
        seen.add(key)
        if key not in resolved:
            changes.append(f"UNKNOWN data-version=\"{key}\" -- not in apps.json")
            return m.group(0)
        new = resolved[key]["display"]
        if m.group("body") != new:
            changes.append(f"{key}: {m.group('body') or '(empty)'} -> {new}")
        return f'{m.group("open")}{new}</span>'

    html = re.sub(
        r'(?P<open><span[^>]*\bdata-version="(?P<key>[^"]+)"[^>]*>)'
        r'(?P<body>.*?)</span>',
        version_slot, html, flags=re.S,
    )

    def release_link(m: re.Match) -> str:
        key = m.group("key")
        seen.add(key)
        if key not in resolved:
            changes.append(f"UNKNOWN data-release=\"{key}\" -- not in apps.json")
            return m.group(0)
        new = resolved[key]["url"]
        if m.group("href") != new:
            changes.append(f"{key} link: {m.group('href')} -> {new}")
        return f'{m.group("pre")}href="{new}"{m.group("post")}'

    html = re.sub(
        r'(?P<pre><a[^>]*?\bdata-release="(?P<key>[^"]+)"[^>]*?\s)'
        r'href="(?P<href>[^"]*)"(?P<post>[^>]*>)',
        release_link, html,
    )

    for key in resolved:
        if key not in seen:
            changes.append(f"NOTE {key}: resolved but no slot in index.html")

    # Dating the page from the newest release, not from "now", keeps this file
    # byte-stable between runs -- otherwise --check would fail every single day.
    newest = max(v["published"] for v in resolved.values())

    def generated_slot(m: re.Match) -> str:
        if m.group("body") != newest:
            changes.append(f"footer date: {m.group('body') or '(empty)'} -> {newest}")
        return f'{m.group("open")}{newest}</span>'

    html = re.sub(
        r'(?P<open><span[^>]*\bdata-generated\b[^>]*>)(?P<body>.*?)</span>',
        generated_slot, html, flags=re.S,
    )

    return html, changes


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--check", action="store_true",
                    help="exit 1 if index.html is out of date; change nothing")
    ap.add_argument("--report", action="store_true",
                    help="print the resolved versions and stop")
    args = ap.parse_args()

    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))

    try:
        resolved = resolve_all(manifest)
    except ResolveError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    if args.report:
        width = max(len(v["label"]) for v in resolved.values())
        for key in sorted(resolved, key=lambda k: resolved[k]["label"]):
            v = resolved[key]
            flag = "beta" if v["prerelease"] else "    "
            print(f"{v['label']:<{width}}  {v['display']:<18} {flag}  "
                  f"{v['published']}  {v['repo']}")
        return 0

    html = INDEX.read_text(encoding="utf-8")
    updated, changes = rewrite(html, resolved)
    stale = updated != html

    lock = {
        "generated_by": "scripts/update-versions.py",
        "source": "GitHub Releases via the gh CLI",
        "apps": resolved,
    }
    lock_text = json.dumps(lock, indent=2, ensure_ascii=False) + "\n"
    lock_stale = (not LOCKFILE.exists()) or LOCKFILE.read_text(encoding="utf-8") != lock_text

    if args.check:
        if stale or lock_stale:
            print("index.html is out of date. Run scripts/update-versions.py\n")
            for c in changes:
                print(f"  {c}")
            return 1
        print("index.html versions match GitHub Releases.")
        return 0

    INDEX.write_text(updated, encoding="utf-8")
    LOCKFILE.write_text(lock_text, encoding="utf-8")

    if changes:
        print(f"Updated index.html ({len(changes)} change(s)):\n")
        for c in changes:
            print(f"  {c}")
    else:
        print("index.html already matched GitHub Releases.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
