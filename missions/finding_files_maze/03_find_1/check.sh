#!/bin/sh

_mission_check_p() (
    coin_name=$1
    COIN_NB=$2
    coin=$(find "$GSH_CHEST" -name "*$(gettext "$coin_name")_$COIN_NB" -type f)

    if [ -z "$coin" ]
    then
        echo "$(gettext "Alcune delle monete non sono nella tua cassa!")"
        return 1
    fi
    if ! cmp -s "$coin" "$GSH_TMP/${coin_name}_$COIN_NB"
    then
        echo "$(eval_gettext "La moneta '\$coin_name' nella tua cassa è invalida!")"
        return 1
    fi
)

_mission_check() (
    maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"

    nb=$(find "$maze" -iname "$(gettext "gold_coin")" -type f | wc -l)
    if [ "$nb" -gt 2 ]
    then
        echo "$(gettext "Ci sono troppe monete d'oro nel labirinto!")"
        return 1
    fi
    if [ "$nb" -ne 0 ]
    then
        echo "$(gettext "Ci sono ancora delle monete d'oro nel labirinto!")"
        return 1
    fi

    _mission_check_p "gold_coin" 1 && _mission_check_p "GolD_CoiN" 2
)

if _mission_check
then
    unset -f _mission_check_p
    true
else
    unset -f _mission_check_p
    find "$GSH_HOME" -iname piece_d_or -not -iname "*journal*" -print0 | xargs -0 rm -f
    false
fi


