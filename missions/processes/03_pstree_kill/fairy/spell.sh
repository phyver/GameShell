#!/bin/bash

source gettext.sh
export TEXTDOMAIN=$1

DELAY=3
OFFSET=$2

sleep $OFFSET
while true
do
    INDENT=$(echo "                       " | cut -c1-$((2+RANDOM%15)))
    filename="$(eval_gettext '$GSH_HOME/Castle/Cellar')/.${RANDOM}_$(gettext "snowflake")"
    case "$((RANDOM % 4))" in
        0)
            cat <<'EOS' | sed "s/^/$INDENT/g" > "$filename"
       .
       :
 '.___/*\___.'
   \* \ / */
    >--X--<
   /*_/ \_*\
 .'   \*/   '.
       :
       '
EOS
            ;;
        1)
            cat <<'EOS' | sed "s/^/$INDENT/g" > "$filename"
    _    _
   /_/  \_\
     \\//
 /\_\\><//_/\
 \/ //><\\ \/
    _//\\_
   \_\  /_/
EOS
            ;;
        2)
            cat <<'EOS' | sed "s/^/$INDENT/g" > "$filename"
    .      .
    _\/  \/_
     _\/\/_
 _\_\_\/\/_/_/_
  / /_/\/\_\ \
     _/\/\_
     /\  /\
    '      '
EOS
            ;;
        3)
            cat <<'EOS' | sed "s/^/$INDENT/g" > "$filename"
    *  .  *
  . _\/ \/_ .
   \  \ /  /
 -==>: X :<==-
   / _/ \_ \
  '  /\ /\  '
    *  '  *
EOS
            ;;
    esac
    echo "${filename#$(eval_gettext '$GSH_HOME/Castle/Cellar')/}" >> "$GSH_VAR/snowflakes-$OFFSET.list"
    sleep $DELAY & wait $!
done

