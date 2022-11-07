#!/usr/bin/env sh

_DOW() (
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

get_answer() (
    offset=$1

    YYYY=$(cut -d"-" -f1 "$GSH_TMP"/date)
    MM=$(cut -d"-" -f2 "$GSH_TMP"/date)
    DD=$(cut -d"-" -f3 "$GSH_TMP"/date)

    day=$(_DOW "$YYYY-$MM-$DD")
    for i in $(seq 7)
    do
        answer=$(_DOW "2000-05-$i")
        if [ "$day" = "$answer" ]
        then
            echo $((1+(i + offset - 1) % 7))
            break
        fi
    done
)

get_answer 0 | gsh assert check true
get_answer 1 | gsh assert check false
get_answer 2 | gsh assert check false
get_answer 3 | gsh assert check false
get_answer 4 | gsh assert check false
get_answer 5 | gsh assert check false
get_answer 6 | gsh assert check false
get_answer 7 | gsh assert check true

unset -f get_answer _DOW
