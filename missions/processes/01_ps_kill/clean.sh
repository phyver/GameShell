#!/bin/sh

echo $GSH_LAST_ACTION
kill -9 "$(cat "$GSH_TMP/spell.pid")" 2>/dev/null
rm -f "$GSH_TMP/spell.pid" "$GSH_TMP/$(gettext "spell")"
my_ps | awk '/sleep|tail/ {print $1}' | xargs kill -9 2>/dev/null

set -o monitor  # monitor background processes (default)
