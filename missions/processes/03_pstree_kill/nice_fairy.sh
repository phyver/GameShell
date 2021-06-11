#!/bin/sh

. gettext.sh

"$GSH_TMP/fairy/$(gettext "spell")" 0 &
printf "$!," > "$GSH_TMP/fairy_spell.pids"

"$GSH_TMP/fairy/$(gettext "spell")" 1 &
printf "$!," >> "$GSH_TMP/fairy_spell.pids"

"$GSH_TMP/fairy/$(gettext "spell")" 2 &
printf "$!" >> "$GSH_TMP/fairy_spell.pids"


trap "" TERM INT
tail -f /dev/null
