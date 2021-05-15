#!/usr/bin/env bash

YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

DOW() {
    case $OSTYPE in
        linux|linux-gnu|linux-gnueabihf)
            date --date="$1" +%A
            ;;
        darwin*)
            date -jf "%Y-%m-%d" "$1" +%A
            ;;
        freebsd*|netbsd*|openbsd*)
            date -jf "%Y-%m-%d" "$1" +%A
            ;;
        *)
            date --date="$1" +%A
            ;;
    esac
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
    unset -f DOW
    true
else
    unset t s DD MM YYYY i n DOW
    unset -f DOW
    false
fi



