#!/bin/bash

OK=1
LIMIT=$(( $(date +%s) + 10 ))

exec 3< "$GSH_VAR/arith.txt"
while IFS='' read -r -u 3 l
do
    q="$(echo "$l" | cut -d"|" -f1)"
    c="$(echo "$l" | cut -d"|" -f2)"

    read -erp "$q" r
    if [ "$LIMIT" -le "$(date +%s)" ]
    then
        echo "$(gettext "Too slow! You need to give the answers in less than 10 seconds...")"
        OK=""
        break
    fi

    case "$r" in
        "" | *[!0-9]*)
            echo "$(gettext "That's not even a number!")"
            OK=""
            break
            ;;
        *)
            if [ "$c" -ne "$r" ]
            then
                echo "$(eval_gettext 'Too bad! The expected answer was $c...')"
                OK=""
                break
            fi
            ;;
    esac
done

if [ -n "$OK" ]
then
    unset OK LIMIT l q c r
    true
else
    unset OK LIMIT l q c r
    false
fi

