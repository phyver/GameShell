#!/bin/sh

. gsh_gettext.sh

trap spawn TERM

spawn() {
    echo "$(gettext "You'll need to do better than that to kill my spell!")"
    "$0" &
    echo $! >> "$GSH_TMP/spell.pids"
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
