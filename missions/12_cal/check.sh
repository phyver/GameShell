#!/bin/bash

while true
do
    echo "Quel était le jours de la semaine pour le $DD-$MM-$YYYY ?"

    for i in $(seq 7)
    do
        echo -n "  $i : "
        date --date="2000-05-$i" +%A
    done
    echo -n "Réponse : "
    read n

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
    unset t s DD MM YYYY
    true
else
    unset t s DD MM YYYY
    false
fi



