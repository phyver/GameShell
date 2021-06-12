#!/bin/sh

. gettext.sh

"$GSH_VAR/imp/$(gettext "spell")" 0 &
printf "$!," > "$GSH_VAR/imp_spell.pids"

"$GSH_VAR/imp/$(gettext "spell")" 1 &
printf "$!," >> "$GSH_VAR/imp_spell.pids"

"$GSH_VAR/imp/$(gettext "spell")" 2 &
printf "$!" >> "$GSH_VAR/imp_spell.pids"


trap "" TERM INT
tail -f /dev/null
