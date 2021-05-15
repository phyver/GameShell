#!/usr/bin/env bash

trap clean TERM

clean() {
    jobs -p | xargs kill
    exit 0
}

DELAY=5

while true
do
    INDENT=$(echo "                       " | cut -c1-$((2+RANDOM%15)))
    cat <<'EOS' | sed "s/^/$INDENT/g"

      *#@*
     &_**/~
       !$-#

EOS
    sleep $DELAY & wait $!
done
