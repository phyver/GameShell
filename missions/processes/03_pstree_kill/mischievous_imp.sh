#!/bin/sh

. gettext.sh

dir=$(eval_gettext '$GSH_HOME/Castle/Cellar')
logfile=$GSH_VAR/coals

"$GSH_VAR"/imp/$(gettext "spell") 0 &
echo -n "$!," > "$GSH_VAR/imp_spell.pids"

"$GSH_VAR"/imp/$(gettext "spell") 1 &
echo -n "$!," >> "$GSH_VAR/imp_spell.pids"

"$GSH_VAR"/imp/$(gettext "spell") 2 &
echo -n "$!" >> "$GSH_VAR/imp_spell.pids"


trap "" TERM INT
tail -f /dev/null
