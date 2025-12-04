#!/usr/bin/env sh
source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    DIR="$GSH_HOME/Esdea/Ouskelcoule/Grenier Banal"
    EXPECT_SIZE=1000

    # Get project ID for the dir
    PROJ=$(danger sudo lsattr -p -d "$DIR" 2>/dev/null | awk '{print $1}')

    if [[ -z "$PROJ" ]]; then
    echo "$(eval_gettext "Vous devez définir un numéro de dossier (project ID) pour les quotas douaniers.")"
    exit 1
    fi

    # Get quota line for this project
    LINE=$(danger sudo repquota -P "$(df --output=target "$DIR" | tail -1)" 2>/dev/null | awk -v id="$PROJ" '$1=="#"(id){print}')

    if [[ -z "$LINE" ]]; then
    echo "$(eval_gettext "Vous devez appliquer les quotas douaniers sur le grenier.")"
    exit 1
    fi

    # Extract soft/hard limits
    USED=$(echo "$LINE" | awk '{print $3}')
    SOFT=$(echo "$LINE" | awk '{print $4}')
    HARD=$(echo "$LINE" | awk '{print $5}')

    if [[ "$SOFT" != "$EXPECT_SIZE" ]]; then
        echo "$(eval_gettext "Les quotas douaniers ne sont pas correctement appliqués sur le grenier, les quotas doivent êtres de 1000 Kroutons.")"
        exit 1
    fi

    echo "$(eval_gettext "Bravo, les quotas douaniers sont correctement appliqués sur le grenier ! L'économie du royaume et les frites du vendredi sont sauvées !")"
    exit 0
)

_mission_check
