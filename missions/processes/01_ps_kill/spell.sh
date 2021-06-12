#!/bin/sh

trap clean TERM

clean() {
    jobs -p | xargs kill
    exit 0
}

DELAY=5

while true
do
    sleep $DELAY & wait $!
    INDENT=$(echo "                       " | cut -c1-$((2+$(RANDOM)%15)))
    cat <<'EOS' | sed "s/^/$INDENT/g"

      *#@*
     &_**/~
       !$-#

EOS
done
