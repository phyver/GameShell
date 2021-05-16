#!/bin/bash

YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

DOW() {
    local dow
    if dow=$(date --date="$1" +%A 2> /dev/null)
    then
        # with gnu "date" command
        echo $dow
        return 0
    elif dow=$(date -jf "%Y-%m-%d" "$1" +%A 2> /dev/null)
    then
        # with freebsd "date" command
        echo $dow
        return 0
    else
        echo "$(gettext "Error: can not get day of week with 'date' command.")" >&2
        return 1
    fi
}

while true
do
    echo "$(eval_gettext 'What was the day of the week for the $MM-$DD-$YYYY?')"

    for i in $(seq 7)
    do
        echo -n "  $i : "
        DOW "2000-05-$i"
    done
    read -erp "$(gettext "Your answer: ")" n

    case "$n" in
        *[!0-9]) ;;
        *)
            if [ "$n" -le 7 ] &&  [ "$n" -ge 1 ]
            then
                s=$(DOW "2000-05-$n")
                break
            fi
    esac
done

t=$(DOW "$YYYY-$MM-$DD")

if [ "$t" = "$s" ]
then
    unset t s DD MM YYYY i n
    # unset -f DOW
    true
else
    unset t s DD MM YYYY i n DOW
    # unset -f DOW
    false
fi



