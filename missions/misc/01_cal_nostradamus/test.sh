_DOW() {
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

get_answer() {
    local offset=$1

    local YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
    local MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
    local DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

    local day=$(_DOW "$YYYY-$MM-$DD")
    local i
    for i in $(seq 7)
    do
        local answer=$(_DOW "2000-05-$i")
        if [ "$day" = "$answer" ]
        then
            echo $((1+(i + offset - 1) % 7))
            break
        fi
    done
}

gsh assert check true  < <(get_answer 0) > /dev/null
printf "."
gsh assert check false < <(get_answer 1) > /dev/null
printf "."
gsh assert check false < <(get_answer 2) > /dev/null
printf "."
gsh assert check false < <(get_answer 3) > /dev/null
printf "."
gsh assert check false < <(get_answer 4) > /dev/null
printf "."
gsh assert check false < <(get_answer 5) > /dev/null
printf "."
gsh assert check false < <(get_answer 6) > /dev/null
printf "."
gsh assert check true  < <(get_answer 7) > /dev/null

unset -f get_answer _DOW
