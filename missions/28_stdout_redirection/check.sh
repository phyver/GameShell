#!/bin/bash

_mission_check() {
    local office
    office="$(eval_gettext '$GASH_HOME/Castle/Main_building/Library/Merlin_s_office')"
    INVENTORY_FILE="$(gettext "inventory.txt")"

    if [ ! -f "$office/$(gettext "Drawer")/$INVENTORY_FILE" ]
    then
        echo "$(eval_gettext 'There is no $INVENTORY_FILE in the drawer...')"
        return 1
    fi

    if ! cmp -s <(sort "$office/$(gettext "Drawer")/$INVENTORY_FILE") "$GASH_MISSION_DATA/inventory_grimoires"
    then
        echo "$(eval_gettext 'The content of $INVENTORY_FILE is invalid.
You can check its content with the command
    $ less $INVENTORY_FILE')"
        return 1
    fi

    return 0
}


_mission_check
