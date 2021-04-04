exec 3< "$GASH_TMP/arith.txt"
OK="OK"
while IFS='' read -r -u 3 l
do
    q="$(echo "$l" | cut -d"|" -f1)"
    c="$(echo "$l" | cut -d"|" -f2)"

    read -erp "$q" r
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
    unset OK LIMIT l q c r
    true
else
    unset OK LIMIT l q c r
    false
fi

