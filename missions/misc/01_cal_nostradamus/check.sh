#!/bin/sh

_mission_check() (
  DOW() (
    if dow=$(date --date="$1" +%A 2> /dev/null)
    then
      # with gnu "date" command
      echo "$dow"
      return 0
    elif dow=$(date -jf "%Y-%m-%d" "$1" +%A 2> /dev/null)
    then
      # with freebsd "date" command
      echo "$dow"
      return 0
    else
      echo "$(gettext "Error: can not get day of week with 'date' command.")" >&2
      return 1
    fi
  )

  YYYY=$(cut -d"-" -f1 "$GSH_TMP"/date)
  MM=$(cut -d"-" -f2 "$GSH_TMP"/date)
  DD=$(cut -d"-" -f3 "$GSH_TMP"/date)

    echo "$(eval_gettext 'What was the day of the week for the $MM-$DD-$YYYY?')"

    for i in $(seq 7)
    do
      printf "  %d : " "$i"
      DOW "2000-05-$i"
    done
    printf "%s " "$(gettext "Your answer:")"
    read -r n

    case "$n" in
      *[!0-9]* | "")
        echo "$(gettext "That's not even a valid answer!")"
        return 1
        ;;
      *)
        if [ "$n" -gt 7 ] ||  [ "$n" -lt 1 ]
        then
          echo "$(gettext "That's not even a valid answer!")"
          return 1
        fi
        s=$(DOW "2000-05-$n")
        t=$(DOW "$YYYY-$MM-$DD")
        unset -f DOW
        [ "$t" = "$s" ]
    esac
)

_mission_check
