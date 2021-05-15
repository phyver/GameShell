export YYYY=$(cut -d"-" -f1 "$GSH_VAR"/date)
export MM=$(cut -d"-" -f2 "$GSH_VAR"/date)
export DD=$(cut -d"-" -f3 "$GSH_VAR"/date)

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


day=$(DOW "$YYYY-$MM-$DD")

for i in $(seq 7)
do
    answer=$(DOW "2000-05-$i")
    if [ "$day" = "$answer" ]
    then
        n_day=$i
        break
    fi
done

unset day i answer YYYY MM DD

gsh check < <(echo "$n_day")

unset n_day
unset -f DOW

