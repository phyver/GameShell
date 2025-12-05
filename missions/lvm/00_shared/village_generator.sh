#!/usr/bin/env bash
set -e

if [ "$GSH_HOME" != "" ]; then
    BASE="$GSH_HOME"
else
    BASE="/var/www/html/GameShell/World"
fi

# Définition des industries par village
declare -A colonies
colonies["Ouskelcoule"]="Esdea"
colonies["Douskelpar"]="Esdea"
colonies["Grandflac"]="Esdebe"

declare -A industries
industries["Ouskelcoule"]="Port De Peche"
industries["Douskelpar"]="Scierie"
industries["Grandflac"]="Moulin"

for v in "${!industries[@]}"; do
    VILLAGE="$BASE/${colonies[$v]}/$v"
    INDUSTRY="${industries[$v]}"

    # Dossiers
    mkdir -p "$VILLAGE/$INDUSTRY"
    mkdir -p "$VILLAGE/Maison Commune"

    # Industrie spécifique
    case "$v" in
      Ouskelcoule)
        echo "$(eval_gettext "Fishing boat")" > "$VILLAGE/$INDUSTRY/barque.txt"
        echo "$(eval_gettext "Fish crates")" > "$VILLAGE/$INDUSTRY/caisses.txt"
        echo "$(eval_gettext "Arsène the master fisherman")" > "$VILLAGE/$INDUSTRY/habitant_arsene.txt"
        ;;
      Douskelpar)
        echo "$(eval_gettext "Stacked logs")" > "$VILLAGE/$INDUSTRY/troncs.txt"
        echo "$(eval_gettext "Giant saw")" > "$VILLAGE/$INDUSTRY/scie.txt"
        echo "$(eval_gettext "Milo the sawyer")" > "$VILLAGE/$INDUSTRY/habitant_milo.txt"
        ;;
      Grandflac)
        echo "$(eval_gettext "Grain millstone")" > "$VILLAGE/$INDUSTRY/meule.txt"
        echo "$(eval_gettext "Bag of flour")" > "$VILLAGE/$INDUSTRY/farine.txt"
        echo "$(eval_gettext "Jeanne the miller")" > "$VILLAGE/$INDUSTRY/habitant_jeanne.txt"
        ;;
    esac

    # Maison Commune (population.txt déjà existant)
    echo "$(eval_gettext "Bailiff of \$v")" > "$VILLAGE/Maison Commune/habitant_bailli.txt"
    echo "$(eval_gettext "Property register:
- \$INDUSTRY : collective property")" > "$VILLAGE/Maison Commune/registre_proprietes.txt"
    echo "$(eval_gettext "Decisions register:
- Friday = fish day
- Quota of 1000 Ko in the Common Granary")" > "$VILLAGE/Maison Commune/registre_decisions.txt"
done
