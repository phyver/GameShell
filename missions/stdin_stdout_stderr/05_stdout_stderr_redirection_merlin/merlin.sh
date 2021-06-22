#!/bin/sh

. gsh_gettext.sh


main() {
    if [ -n "$*" ]
    then
        cmd_name=$(basename "$0")
        msg=$(gettext 'Error: %s takes no argument.')
        printf "$msg\n" "$cmd_name" >&2
        return 1
    fi

    msg=$(gettext "THESECRETKEYISONSTDERR")
    key=$(cat "$GSH_TMP/secret_key")

    I=${#msg}
    J=${#key}
    L=$((I+J))
    i=0
    j=0
    while [ "$((i+j))" -lt "$L" ]
    do
      r=$(RANDOM)
      if [ "$((r % (L-i-j)))" -lt "$((I-i))" ]
        then
            i=$((i+1))
            c=$(echo "$msg" | cut -c "$i")
            printf "%s" "$c"
        else
            j=$((j+1))
            c=$(echo "$key" | cut -c "$j")
            printf "%s" "$c" >&2
        fi
    done
    echo
    echo >&2
}
main "$@"
