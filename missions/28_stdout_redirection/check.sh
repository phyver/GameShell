#!/bin/bash

_local_check() {
    local office
    office="$(eval_gettext '$GASH_HOME/Castle/Main_building/Library/Merlin_s_office')"
    list="$(gettext "list.txt")"

    if [ ! -f "$office/$(gettext "Drawer")/$list" ]
    then
        echo "$(eval_gettext 'There is no $list in the drawer...')"
        return 1
    fi

    if ! diff -q <(sort "$office/$(gettext "Drawer")/$list") "$GASH_MISSION_DATA/list_grimoires" > /dev/null
    then
        echo "$(eval_gettext 'The content of $list is invalid.
You can check its content with the command
    $ less $list')"
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
