#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    if ! danger sudo e2fsck -n /dev/esdea/douskelpar >/dev/null 2>&1; then
        echo "$(eval_gettext "Help repair the village of Ouskelpar...")"
        return 1
    fi

    if [ ! -e "$GSH_HOME/Esdea/Douskelpar/Maison Commune/population.txt" ] ||\
     [ ! -e "$GSH_HOME/Esdea/Douskelpar/Maison Commune/registre_decisions.txt" ] ||\
     [ ! -e "$GSH_HOME/Esdea/Douskelpar/Maison Commune/registre_proprietes.txt" ]; then
        echo "$(eval_gettext "It seems that important administrative files for village management are missing...")"
        echo "$(eval_gettext "You can probably find them by better restoring the village.")"
        return 1
    fi

    return 0
)

_mission_check
