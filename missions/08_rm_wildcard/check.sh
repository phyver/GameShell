#!/bin/bash

_local_check() {
    local CELLAR="$(eval_gettext "\$GASH_HOME/Castle/Cellar")"

    local nb_spiders=$(find "$CELLAR" -maxdepth 1 -name "*$(gettext "spider")" | wc -l)
    if [ "$nb_spiders" -ne 0 ]
    then
        echo "$(eval_gettext "There still are some spiders (\$nb_spiders) in the cellar!")"
        return 1
    fi

    local S1=$(find "$CELLAR" -maxdepth 1 -name ".*$(gettext "salamander")" | sort | checksum)
    local S2=$(cat "$GASH_MISSION_DATA/salamanders")

    if [ "$S1" != "$S2" ]
    then
        echo "$(eval_gettext "Some salamanders have been modified!")"
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
