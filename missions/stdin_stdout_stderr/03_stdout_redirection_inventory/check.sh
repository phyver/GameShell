#!/bin/bash

_mission_check() {
    local office
    office="$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
    local inventory_file="$(gettext "inventory.txt")"

    if [ ! -f "$office/$(gettext "Drawer")/$inventory_file" ]
    then
        echo "$(eval_gettext 'There is no $inventory_file in the drawer...')"
        return 1
    fi

    if ! cmp -s <(sort "$office/$(gettext "Drawer")/$inventory_file") "$GSH_VAR/inventory_grimoires"
    then
        echo "$(eval_gettext 'The content of $inventory_file is invalid.
You can check its content with the command
    $ less $inventory_file')"
        return 1
    fi

    return 0
}


_mission_check
