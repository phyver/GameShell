#!/bin/bash

source gettext.sh
TEXTDOMAIN=$1

dir=$(eval_gettext '$GSH_HOME/Castle/Cellar')
logfile=$GSH_VAR/coals

"$GSH_VAR"/imp/$(gettext "spell") "$TEXTDOMAIN" 0 &
echo -n "$!," > "$GSH_VAR/imp_spell.pids"
disown
"$GSH_VAR"/imp/$(gettext "spell") "$TEXTDOMAIN" 1 &
echo -n "$!," >> "$GSH_VAR/imp_spell.pids"
disown
"$GSH_VAR"/imp/$(gettext "spell") "$TEXTDOMAIN" 2 &
echo -n "$!" >> "$GSH_VAR/imp_spell.pids"
disown

trap "" SIGTERM SIGINT
tail -f /dev/null
