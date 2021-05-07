get_answer() {
    local offset=$1

    local YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
    local MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
    local DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

    local day=$(date --date="$YYYY-$MM-$DD" +%A)
    local i
    for i in $(seq 7)
    do
        local answer=$(date --date="2000-05-$i" +%A)
        if [ "$day" = "$answer" ]
        then
            echo $((1+(i + offset - 1) % 7))
            break
        fi
    done
}

gsh assert check true  < <(get_answer 0) > /dev/null
echo -n "."
gsh assert check false < <(get_answer 1) > /dev/null
echo -n "."
gsh assert check false < <(get_answer 2) > /dev/null
echo -n "."
gsh assert check false < <(get_answer 3) > /dev/null
echo -n "."
gsh assert check false < <(get_answer 4) > /dev/null
echo -n "."
gsh assert check false < <(get_answer 5) > /dev/null
echo -n "."
gsh assert check false < <(get_answer 6) > /dev/null
echo -n "."
gsh assert check true  < <(get_answer 7) > /dev/null

unset -f get_answer
