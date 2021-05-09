#!/bin/bash

YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

while true
do
    echo "$(eval_gettext 'What was the day of the week for the $MM-$DD-$YYYY?')"

    for i in $(seq 7)
    do
        echo -n "  $i : "
        date --date="2000-05-$i" +%A
    done
    read -erp "$(gettext "Your answer: ")" n

    case "$n" in
        *[!0-9]) ;;
        *)
            if [ "$n" -le 7 ] &&  [ "$n" -ge 1 ]
            then
                s=$(date --date="2000-05-$n" +%A)
                break
            fi
    esac
done

t=$(date --date="$YYYY-$MM-$DD" +%A)

if [ "$t" = "$s" ]
then
    unset t s DD MM YYYY i n
    true
else
    unset t s DD MM YYYY i n
    false
fi



