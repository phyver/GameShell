#!/bin/sh

. gettext.sh

dir=$(eval_gettext '$GSH_HOME/Castle/Cellar')
logfile=$GSH_VAR/snowflakes

"$GSH_VAR"/fairy/$(gettext "spell") 0 &
echo -n "$!," > "$GSH_VAR/fairy_spell.pids"

"$GSH_VAR"/fairy/$(gettext "spell") 1 &
echo -n "$!," >> "$GSH_VAR/fairy_spell.pids"

"$GSH_VAR"/fairy/$(gettext "spell") 2 &
echo -n "$!" >> "$GSH_VAR/fairy_spell.pids"


trap "" TERM INT
tail -f /dev/null
