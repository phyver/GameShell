#!/bin/bash

change_password() {
  local password=$1
  local ADMIN_HASH=$(checksum "$password")
  echo "$ADMIN_HASH" > "$GASH_DATA/admin_hash"
  echo""
  echo "$(eval_gettext "The admin password is now '\$password'. Use
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
    read -erp "$(gettext "Your choice [qC] or a number:") " choice

    case $choice in
        "$(gettext "q")" | "$(gettext "Q")")
            gash exit
            ;;
        "$(gettext "c")" | "$(gettext "C")" | "")
            break;
            ;;
        *[!0-9]*)
            echo "$(eval_gettext 'unknown choice: $choice')" >&2
            ;;
        *)
            nb_missions=$(sed -e '/^$/d' -e '/^#/d' "$GASH_DATA/index.txt" | wc -l)
            if  [ 0 -lt "$choice" ] && [ "$choice" -le "$nb_missions" ]
            then
                change_password "$(gettext "qwerty")"
                _gash_start -quiet $choice
                gash reset
            else
                echo "$(eval_gettext 'invalid mission number: $choice')" >&2
                echo "$(eval_gettext 'Please choose a number between 1 and $nb_missions')" >&2
                echo "" >&2
            fi
            ;;
    esac
done
false
