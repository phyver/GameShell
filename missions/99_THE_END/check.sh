#!/bin/bash

change_password() {
  local PASSWORD=$1
  local ADMIN_HASH=$(checksum "$PASSWORD")
  echo "$ADMIN_HASH" > "$GASH_DATA/admin_hash"
  echo""
  echo "$(eval_gettext "The admin password is now '\$PASSWORD'. Use
    \$ gash HELP
for a list including admin commands.")"
  echo""
  read -p "$(gettext "Press Enter to continue.")"
  echo""
}


while true
do
    echo "$(gettext "What do you want to do?
    (q)         quit
    (c)         continue
    (number)    restart from this mission")"
    read -erp "$(gettext "Your choice [qC] or a number:") " CHOICE

    case $CHOICE in
        "$(gettext "q")" | "$(gettext "Q")")
            gash exit
            ;;
        "$(gettext "c")" | "$(gettext "C")" | "")
            break;
            ;;
        *[!0-9]*)
            echo "$(eval_gettext 'unknown choice: $CHOICE')" >&2
            ;;
        *)
            NB_MISSIONS=$(sed -e '/^$/d' -e '/^#/d' "$GASH_DATA/index.txt" | wc -l)
            if  [ 0 -lt "$CHOICE" ] && [ "$CHOICE" -le "$NB_MISSIONS" ]
            then
                change_password "$(gettext "qwerty")"
                _gash_start -quiet $CHOICE
                unset CHOICE
                gash reset
            else
                echo "$(eval_gettext 'Error: invalid mission number: $CHOICE.
Please choose a number between 1 and $NB_MISSIONS')" >&2
                echo "" >&2
            fi
            ;;
    esac
done
false
