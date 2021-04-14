_local_check() {
    local forest
    forest="$(eval_gettext "\$GASH_HOME/Forest")"

    # Check that there is only one cabin.
    local nb_cabins
    nb_cabins=$(find "$forest" -iname "$(gettext "Cabin")" -type d | wc -l)
    if [ "$nb_cabins" -ge 2 ]
    then
        echo "$(gettext "You built too many cabins in the forest!")"
        return 1
    fi
    if [ "$nb_cabins" -lt 1 ]
    then
        echo "$(gettext "You did not build a cabin in the forest!")"
        return 1
    fi

    # Check that the cabin is at the root of the forest.
    local cabin
    cabin=$(find "$forest" -maxdepth 1 -iname "$(gettext "Cabin")" -type d)
    if [ -z "$cabin" ]
    then
        echo "$(gettext "Your built your cabin too far in the forest...")"
        return 1
    fi

    # Check the name of the cabin.
    cabin="$forest/$(gettext "Cabin")"
    if [ ! -d "$cabin" ]
    then
        echo "$(eval_gettext "The \$cabin directory does not exist!")"
        return 1
    fi

    # Check that there is only one chest.
    local nb_chests
    nb_chests=$(find "$cabin" -iname "$(gettext "Chest")" -type d | wc -l)
    if [ "$nb_chests" -ge 2 ]
    then
        echo "$(gettext "You built too many chests in your cabin!")"
        return 1
    fi
    if [ "$nb_chests" -lt 1 ]
    then
        echo "$(gettext "You did not build a chest in your cabin!")"
        return 1
    fi

    # Check that there are no chests in the forest that are not in the cabin.
    local nb_in_forest
    nb_in_forest=$(find "$forest" -iname "$(gettext "Chest")" -type d | wc -l)
    if [ "$nb_in_forest" -gt "$nb_chests" ]
    then
        echo "$(gettext "You built a chest in the forest!")"
        return 1
    fi

    # Check that the chest is at the root of the cabin.
    local chest
    chest=$(find "$cabin" -maxdepth 1 -iname "$(gettext "Chest")" -type d)
    if [ -z "$chest" ]
    then
        echo "$(gettext "The chest is not in the right place in your cabin.")"
        return 1
    fi

    # Check the name of the chest.
    chest="$cabin/$(gettext "Chest")"
    if [ ! -d "$chest" ]
    then
        echo "$(eval_gettext "The \$chest directory does not exist!")"
        return 1
    fi
    return 0
}

if _local_check
then
    true
else
    find "$GASH_HOME" -iname "*$(gettext "Cabin")*" -print0 | xargs -0 rm -rf
    find "$GASH_HOME" -iname "*$(gettext "Chest")*" -print0 | xargs -0 rm -rf
    cd "$GASH_HOME"
    echo "$(eval_gettext "You are back at the starting point: start over.")"
    false
fi
