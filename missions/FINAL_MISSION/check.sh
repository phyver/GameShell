#!/bin/bash

change_password() {
  local password=$1
  local ADMIN_HASH=$(checksum "$password")
  echo "$ADMIN_HASH" > "$GSH_CONFIG/admin_hash"
  echo
  echo "$(eval_gettext "The admin password is now '\$password'. Use
    \$ gsh HELP
for a list including admin commands.")"
  echo
  read -sern1 -p "$(gettext "Press any key to continue.")"
  echo
}


while true
do
    echo "$(gettext "What do you want to do?
    (q)         quit
    (number)    restart from this mission")"
    read -erp "$(gettext "Your choice [q] or a number:") " choice

    case $choice in
        "$(gettext "q")" | "$(gettext "Q")")
            gsh exit
            ;;
        "")
            gsh hardreset
            ;;
        *[!0-9]*)
            echo "$(eval_gettext 'unknown choice: $choice')" >&2
            ;;
        *)
            NB_MISSIONS=$(sed -e '/^$/d' -e '/^#/d' "$GSH_CONFIG/index.txt" | wc -l)
            if  [ 0 -lt "$choice" ] && [ "$choice" -le "$NB_MISSIONS" ]
            then
                change_password "$(gettext "qwerty")"
                _gsh_start -quiet $choice
                gsh hardreset
            else
                echo "$(eval_gettext 'Error: invalid mission number: $choice.
Please choose a number between 1 and $NB_MISSIONS')" >&2
                echo >&2
            fi
            ;;
    esac
done
false
