#!/bin/sh

trap spawn TERM

spawn() {
    echo "$(gettext "You'll need to do better than that to kill my spell!")"

    "$0" &
    echo "$!" >> "$GSH_VAR/spell.pids"
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
