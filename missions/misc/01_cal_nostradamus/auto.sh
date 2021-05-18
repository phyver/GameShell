export YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
export MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
export DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

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

day=$(DOW "$YYYY-$MM-$DD")

for I in $(seq 7)
do
    answer=$(DOW "2000-05-$I")
    if [ "$day" = "$answer" ]
    then
        n_day=$I
        break
    fi
done

unset day I answer YYYY MM DD
gsh check < <(echo "$n_day")
unset n_day
unset -f DOW

