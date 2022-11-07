#!/usr/bin/env sh

. gsh_gettext.sh

"$GSH_TMP/imp/$(gettext "spell")" 0 &
printf "$!," > "$GSH_TMP/imp_spell.pids"

"$GSH_TMP/imp/$(gettext "spell")" 1 &
printf "$!," >> "$GSH_TMP/imp_spell.pids"

"$GSH_TMP/imp/$(gettext "spell")" 2 &
printf "$!" >> "$GSH_TMP/imp_spell.pids"


trap "" TERM INT
tail -f /dev/null
