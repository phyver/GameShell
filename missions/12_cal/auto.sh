day=$(date --date="$YYYY-$MM-$DD" +%A)

for i in $(seq 7)
do
    answer=$(date --date="2000-05-$i" +%A)
    if [ "$day" = "$answer" ]
    then
        n=$i
        break
    fi
done

echo "$n" | gash check

