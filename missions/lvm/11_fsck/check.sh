#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    if ! danger sudo e2fsck -n /dev/esdea/douskelpar >/dev/null 2>&1; then
        echo "$(eval_gettext "Aidez à réparer le village d'Ouskelpar...")"
        return 1
    fi

    if [ ! -e "$GSH_HOME/Esdea/Douskelpar/Maison Commune/population.txt" ] ||\
     [ ! -e "$GSH_HOME/Esdea/Douskelpar/Maison Commune/registre_decisions.txt" ] ||\
     [ ! -e "$GSH_HOME/Esdea/Douskelpar/Maison Commune/registre_proprietes.txt" ]; then
        echo "$(eval_gettext "Il semblerait que des fichiers administratifs importants pour la gestion du village soient manquants...")"
        echo "$(eval_gettext "Vous pouvez probablement les retrouver en restaurant mieux le village.")"
        return 1
    fi

    return 0
)

_mission_check
