#!/bin/bash

_local_check() {
    if ! [ -f "$GASH_CHEST/$(gettext "crown")" ]
    then
        echo "$(gettext "There is no crown in your chest!")"
        return 1
    fi

    if ! [ -r "$GASH_CHEST/$(gettext "crown")" ]
    then
        echo "$(gettext "The crown in your chest is not readable!")"
        return 1
    fi

    if ! cmp -s "$GASH_CHEST/$(gettext "crown")" "$GASH_MISSION_DATA/crown"
    then
        echo "$(gettext "The crown in your chest is a fake!")"
        return 1
    fi

    local real_key=$(tail -n 1 "$GASH_MISSION_DATA/crown" | cut -c 4-6)

    local given_key
    read -erp "$(gettext "What are the 3 digits inscribed on the base of the crown?") " given_key
    if [ "$real_key" -ne "$given_key" ]
    then
        echo "$(gettext "Those digits are not right!")"
        return 1
    fi
    return 0
}

if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi
