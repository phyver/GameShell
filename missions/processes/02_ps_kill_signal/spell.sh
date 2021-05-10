#!/bin/bash

export TEXTDOMAIN=TODO

trap spawn TERM

spawn() {
    echo "$(gettext "You'll need to do better than that!")"
    "$0" &
    echo "$!" >> "$GSH_VAR/spell.pids"
    echo "$$" >> "$GSH_VAR/spell-term.pids"
    disown
}

DELAY=5

while true
do
    sleep $DELAY & wait $!
    INDENT=$(echo "                       " | cut -c1-$((2+RANDOM%15)))
    cat <<'EOS' | sed "s/^/$INDENT/g"

      *#@*
     $@%#\4
     &"_'%<@
      +8^@j
       #!v@

EOS
done
