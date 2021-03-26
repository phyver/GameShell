

OK=1
LIMIT=$(( $(date +%s) + 10 ))

exec 3< "$GASH_TMP/arith.txt"
while IFS='' read -r -u 3 l
do
    q="$(echo "$l" | cut -d"|" -f1)"
    c="$(echo "$l" | cut -d"|" -f2)"

    read -erp "$q" r
    if [ "$LIMIT" -le "$(date +%s)" ]
    then
        echo "Trop lent ! Il faut donner les réponses en moins de 10 secondes..."
        OK=""
        break
    fi

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
    unset OK LIMIT l q c r
    true
else
    unset OK LIMIT l q c r
    false
fi

