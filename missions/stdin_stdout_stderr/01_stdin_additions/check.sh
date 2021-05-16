#!/bin/bash

exec 3< "$GSH_VAR/arith.txt"
OK="OK"
while IFS='' read -r -u 3 l
do
    q="$(echo "$l" | cut -d"|" -f1)"
    c="$(echo "$l" | cut -d"|" -f2)"

    read -erp "$q" r
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

