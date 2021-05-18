ps -e | awk -v spell=$(gettext "spell") '$0 ~ spell {print $1}' | xargs kill -9 2> /dev/null
rm -f "$GSH_VAR/spell.pid" "$GSH_VAR/$(gettext "spell")"
ps | awk '/sleep|tail/ {print $1}' | xargs kill -9 2> /dev/null
