#!/bin/bash

#TODO

_local_check_p() {
    local file=$1
    local path
    path=$(find "$GASH_CHEST" -name "*$file*" -type f)

    if [ -z "$path" ]
    then
        echo "$(gettext "Some of the coins are not in your chest!")"
        echo $file
        return 1
    fi
    if ! cmp -s "$path" "$GASH_MISSION_DATA/$file"
    then
        echo "$(eval_gettext 'Coin '$file' in your chest is invalid!')"
        return 1
    fi
}

_local_check() {
    local lab
    lab=$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name "$(gettext "maze")" -type d)
    local nb
    nb=$(find "$lab" -iname "$(gettext "gold_coin")" -type f | wc -l)
    if [ "$nb" -gt 2 ]
    then
        echo "$(gettext "There are too many gold coins in the  maze!")"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "$(gettext "There still are some gold coins in the  maze!")"
        return 1
        return 1
    fi

    _local_check_p "$(gettext "gold_coin")" && _local_check_p "$(gettext "GolD_CoiN")"
}

if _local_check
then
    unset -f _local_check _local_check_p
    true
else
    unset -f _local_check _local_check_p
    find "$GASH_HOME" -iname piece_d_or -not -iname "*journal*" -print0 | xargs -0 rm -f
    false
fi


