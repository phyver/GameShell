ps -e | awk -v spell=$(gettext "spell") '$0 ~ spell {print $1}' | xargs kill -9 2> /dev/null
rm -f "$GSH_VAR/spell.pids" "$GSH_VAR/spell-term.pids"
ps | awk '/sleep/ {print $1}' | xargs kill -9 2> /dev/null
