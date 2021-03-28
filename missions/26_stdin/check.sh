

OK=1

for _ in $(seq 5)
do
    a=$((1 + RANDOM % 50))
    b=$((1 + RANDOM % 50))
    c=$((a + b))
    read -erp "$a + $b = ?? " r
    case "$r" in
        "" | *[!0-9]*)
            echo "Dommage ! Le résultat est $c..."
            OK=""
            break
            ;;
        *)
            if [ "$c" -ne "$r" ]
            then
                echo "Dommage ! Le résultat est $c..."
                OK=""
                break
            fi
            ;;
    esac
done

if [ -n "$OK" ]
then
    unset OK _ a b c r
    true
else
    unset OK _ a b c r
    false
fi

