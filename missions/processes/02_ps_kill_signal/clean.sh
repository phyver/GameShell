#!/bin/sh

kill -9 $(cat "$GSH_VAR/spell-term.pids" 2>/dev/null) 2>/dev/null
kill -9 $(cat "$GSH_VAR/spell.pids" 2>/dev/null) 2>/dev/null
ps -cA | awk '/sleep|tail/ {print $1}' | xargs kill -9 2>/dev/null
rm -f "$GSH_VAR/spell-term.pids" "$GSH_VAR/spell.pids" "$GSH_VAR/$(gettext "spell")"

set -o monitor  # monitor background processes (default)
