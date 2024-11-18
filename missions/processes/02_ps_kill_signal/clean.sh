#!/usr/bin/env sh

kill -9 $(cat "$GSH_TMP/spell-term.pids" 2>/dev/null) 2>/dev/null
kill -9 $(cat "$GSH_TMP/spell.pids" 2>/dev/null) 2>/dev/null
my_ps | awk '/sleep|tail/ {print $1}' | xargs kill -9 2>/dev/null
rm -f "$GSH_TMP/spell-term.pids" "$GSH_TMP/spell.pids" "$GSH_TMP/$(gettext "spell")"
rm --system -f /dev/shm/"sem.writing_sem_${USER}"
rm --system -f /dev/shm/"sem.printing_sem_${USER}"
[ -n "$GSH_NON_INTERACTIVE" ] || set -o monitor  # monitor background processes (default)
