#!/bin/sh

kill -9 "$(cat "$GSH_VAR/spell.pid")" 2>/dev/null
rm -f "$GSH_VAR/spell.pid" "$GSH_VAR/$(gettext "spell")"
my_ps | awk '/sleep|tail/ {print $1}' | xargs kill -9 2>/dev/null

set -o monitor  # monitor background processes (default)
