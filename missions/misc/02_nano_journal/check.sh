#!/usr/bin/env sh

_mission_check() (
    journal_file="$GSH_CHEST/$(gettext "journal").txt"
    if [ -d "$journal_file" ]
    then
        journal=\~${journal_file#$GSH_ROOT}
        echo "$(eval_gettext "'\$journal' is a directory!")"
        find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -rf
        return 1
    elif [ ! -f "$journal_file" ]
    then
        journal=\~${journal_file#$GSH_ROOT}
        echo "$(eval_gettext "The file '\$journal' doesn't exist...")"
        find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -rf
        return 1
    elif [ ! -s "$journal_file" ]
    then
        journal=\~${journal_file#$GSH_ROOT}
        echo "$(eval_gettext "The file '\$journal' is empty...")"
        find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -rf
        return 1
    else
        return 0
    fi
)

_mission_check
