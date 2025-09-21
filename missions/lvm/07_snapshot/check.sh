#!/usr/bin/env sh

_mission_check() (
    if ! [ -e "/dev/esdea/ouskelcoule_snap" ]; then
        echo "$(eval_gettext "Il manque encore la sauvegarde du village d'Ouskelcoule.")"
        return 1
    fi

    if ! [ -e "/dev/esdea/douskelpar_snap" ]; then
        echo "$(eval_gettext "Il manque encore la sauvegarde du village de Douskelpar.")"
        return 1
    fi

    if ! [ -e "/dev/esdebe/grandflac_snap" ]; then
        echo "$(eval_gettext "Il manque encore la sauvegarde du village de Grandflac.")"
        return 1
    fi

    echo "$(eval_gettext "Bravo ! Ouskelcoule, Douskelpar et Grandflac sont bien archivés, prêts à être restaurés si nécessaire !")"
    return 0
)
    
_mission_check
