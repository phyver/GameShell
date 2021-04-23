export YYYY=$(cut -d"-" -f1 "$GASH_MISSION_DATA"/date)
export MM=$(cut -d"-" -f2 "$GASH_MISSION_DATA"/date)
export DD=$(cut -d"-" -f3 "$GASH_MISSION_DATA"/date)

day=$(date --date="$YYYY-$MM-$DD" +%A)

for i in $(seq 7)
do
    answer=$(date --date="2000-05-$i" +%A)
    if [ "$day" = "$answer" ]
    then
        n_day=$i
        break
    fi
done

unset day i answer YYYY MM DD

echo "$n_day" | gash check

unset n_day

