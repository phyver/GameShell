#!/usr/bin/env sh

_mission_check() {
    # Vérifier Ouskelcoule
    if [ ! -d "$GSH_HOME/Esdea/Ouskelcoule" ]; then
        echo "$(eval_gettext "Create the village Ouskelcoule in Esdea")"
        return 1
    fi

    if ! mountpoint -q "$GSH_HOME/Esdea/Ouskelcoule" ; then
        echo "$(eval_gettext "Connect the kingdom to the village of Ouskelcoule")"
        return 1
    fi

    # Vérifier Douskelpar
    if [ ! -d "$GSH_HOME/Esdea/Douskelpar" ]; then
        echo "$(eval_gettext "Create the village Douskelpar in Esdea")"
        return 1
    fi

    if ! mountpoint -q "$GSH_HOME/Esdea/Douskelpar" ; then
        echo "$(eval_gettext "Connect the kingdom to the village of Douskelpar")"
        return 1
    fi

    # Vérifier Grandflac
    if [ ! -d "$GSH_HOME/Esdebe/Grandflac" ]; then
        echo "$(eval_gettext "Create the village Grandflac in Esdebe")"
        return 1
    fi

    if ! mountpoint -q "$GSH_HOME/Esdebe/Grandflac" ; then
        echo "$(eval_gettext "Connect the kingdom to the village of Grandflac")"
        return 1
    fi

    # Vérifications détaillées
    if [ ! -d "$GSH_HOME/Esdea/Ouskelcoule/Maison Commune" ] || [ ! -d "$GSH_HOME/Esdea/Douskelpar/Maison Commune" ] || [ ! -d "$GSH_HOME/Esdebe/Grandflac/Maison Commune" ]; then
        echo "$(eval_gettext "Create the 'Maison Commune' directory in each village")"
        return 1
    fi

    if [ "$(cat "$GSH_HOME/Esdea/Ouskelcoule/Maison Commune/population.txt" 2>/dev/null)" != "40" ] ; then
        echo "$(eval_gettext "Correctly fill in the Ouskelcoule register")"
        return 1
    fi

    if [ "$(cat "$GSH_HOME/Esdea/Douskelpar/Maison Commune/population.txt" 2>/dev/null)" != "20" ]; then
        echo "$(eval_gettext "Correctly fill in the Douskelpar register")"
        return 1
    fi

    if [ "$(cat "$GSH_HOME/Esdebe/Grandflac/Maison Commune/population.txt" 2>/dev/null)" != "50" ]; then
        echo "$(eval_gettext "Correctly fill in the Grandflac register")"
        return 1
    fi

    echo "$(eval_gettext "Bravo! Ouskelcoule, Douskelpar and Grandflac are well connected to the Esdea kingdom and their registers are up to date!")"
    return 0
}

_mission_check
