#!/bin/bash

trap spawn TERM

spawn() {
    echo "$(gettext "You'll need to do better than that to kill my spell!")"
    "$0" &
    local PID=$!
    disown $PID
    echo $PID >> "$GSH_VAR/spell.pids"
}

DELAY=5

while true
do
    sleep $DELAY & wait $!
    r=$(RANDOM)
    INDENT=$(echo "                       " | cut -c1-$((2+r%15)))
    cat <<'EOS' | sed "s/^/$INDENT/g"

      *#@*
     $@%#\4
     &"_'%<@
      +8^@j
       #!v@

EOS
done
