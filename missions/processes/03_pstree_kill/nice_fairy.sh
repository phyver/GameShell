#!/bin/sh

. gettext.sh

"$GSH_VAR/fairy/$(gettext "spell")" 0 &
printf "$!," > "$GSH_VAR/fairy_spell.pids"

"$GSH_VAR/fairy/$(gettext "spell")" 1 &
printf "$!," >> "$GSH_VAR/fairy_spell.pids"

"$GSH_VAR/fairy/$(gettext "spell")" 2 &
printf "$!" >> "$GSH_VAR/fairy_spell.pids"


trap "" TERM INT
tail -f /dev/null
