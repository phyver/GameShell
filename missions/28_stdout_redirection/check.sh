#!/bin/bash

_local_check() {
    local office
    office="$(eval_gettext '$GASH_HOME/Castle/Main_building/Library/Merlin_s_office')"
    inventory="$(gettext "inventory.txt")"

    if [ ! -f "$office/$(gettext "Drawer")/$inventory" ]
    then
        echo "$(eval_gettext 'There is no $inventory in the drawer...')"
        return 1
    fi

    if ! cmp -s <(sort "$office/$(gettext "Drawer")/$inventory") "$GASH_MISSION_DATA/inventory_grimoires"
    then
        echo "$(eval_gettext 'The content of $inventory is invalid.
You can check its content with the command
    $ less $inventory')"
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
