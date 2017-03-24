

OK=1

for i in $(seq 5)
do
    a=$((1 + $RANDOM % 50))
    b=$((1 + $RANDOM % 50))
    c=$(($a + $b))
    read -p "$a + $b = ?? " r
    case "$r" in
        "" | *[!0-9]*)
            echo "Trop nul ! Le résultat est $c..."
            OK=""
            break
            ;;
        *)
            if [ "$c" -ne "$r" ]
            then
                echo "Trop nul ! Le résultat est $c..."
                OK=""
                break
            fi
            ;;
    esac
done

if [ -n "$OK" ]
then
    unset OK i a b c r
    true
else
    unset OK i a b c r
    false
fi

