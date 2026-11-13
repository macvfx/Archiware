#!/bin/bash

# p5-version.sh
# Print the installed Archiware P5 version, starting P5 first if it is off.
#
# Output is one word:
#   8.0.6    the P5 version (P5 is running, whether or not it had to be started)
#   failed   P5 was off and did not start (exit 1)
#   missing  P5 is not installed (exit 2)
#
# Starting P5 needs root, so run with sudo if P5 may be off.

# Path to the P5 install — change if P5 is installed elsewhere
AW=/usr/local/aw

[ -x "$AW/ping-server" ] || { echo missing; exit 2; }
cd "$AW" || exit 2

# ping-server checks the pid file first, so it returns at once when P5 is off.
# nsdchat on its own hangs with no server, so only ask it for the version once up.
up() { ./ping-server 2>/dev/null | grep -q 'version ".*" running'; }

if ! up; then
  ./start-server >/dev/null 2>&1 || { echo failed; exit 1; }
  for _ in {1..15}; do
    up && break
    sleep 2
  done
  up || { echo failed; exit 1; }
fi

bin/nsdchat -c srvinfo lexxvers
