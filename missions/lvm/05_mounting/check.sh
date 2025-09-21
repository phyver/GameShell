#!/usr/bin/env sh

_mission_check() {
    # Vérifier Ouskelcoule
    if [ ! -d "$GSH_HOME/Esdea/Ouskelcoule" ]; then
        echo "Créez le village Ouskelcoule dans Esdea"
        return 1
    fi

    if ! mountpoint -q "$GSH_HOME/Esdea/Ouskelcoule" ; then
        echo "Reliez le royaume au village d'Ouskelcoule"
        return 1
    fi

    # Vérifier Douskelpar
    if [ ! -d "$GSH_HOME/Esdea/Douskelpar" ]; then
        echo "Créez le village Douskelpar dans Esdea"
        return 1
    fi

    if ! mountpoint -q "$GSH_HOME/Esdea/Douskelpar" ; then
        echo "Reliez le royaume au village de Douskelpar"
        return 1
    fi

    # Vérifier Grandflac
    if [ ! -d "$GSH_HOME/Esdebe/Grandflac" ]; then
        echo "Créez le village Grandflac dans Esdebe"
        return 1
    fi

    if ! mountpoint -q "$GSH_HOME/Esdebe/Grandflac" ; then
        echo "Reliez le royaume au village de Grandflac"
        return 1
    fi

    # Vérifications détaillées
    if [ ! -d "$GSH_HOME/Esdea/Ouskelcoule/Maison Commune" ] || [ ! -d "$GSH_HOME/Esdea/Douskelpar/Maison Commune" ] || [ ! -d "$GSH_HOME/Esdebe/Grandflac/Maison Commune" ]; then
        echo "Créez le répertoire 'Maison Commune' dans chaque village"
        return 1
    fi

    if [ "$(cat "$GSH_HOME/Esdea/Ouskelcoule/Maison Commune/population.txt" 2>/dev/null)" != "40" ] ; then
        echo "Remplissez correctement le registre d'Ouskelcoule"
        return 1
    fi

    if [ "$(cat "$GSH_HOME/Esdea/Douskelpar/Maison Commune/population.txt" 2>/dev/null)" != "20" ]; then
        echo "Remplissez correctement le registre de Douskelpar"
        return 1
    fi

    if [ "$(cat "$GSH_HOME/Esdebe/Grandflac/Maison Commune/population.txt" 2>/dev/null)" != "50" ]; then
        echo "Remplissez correctement le registre de Grandflac"
        return 1
    fi

    echo "Bravo ! Ouskelcoule, Douskelpar et Grandflac sont bien reliés au royaume Esdea et leurs registres sont à jour !"
    return 0
}

_mission_check
