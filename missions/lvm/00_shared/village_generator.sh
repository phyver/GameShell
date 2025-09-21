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
        echo "Barque de pêche" > "$VILLAGE/$INDUSTRY/barque.txt"
        echo "Caisses de poissons" > "$VILLAGE/$INDUSTRY/caisses.txt"
        echo "Arsène le maître pêcheur" > "$VILLAGE/$INDUSTRY/habitant_arsene.txt"
        ;;
      Douskelpar)
        echo "Troncs empilés" > "$VILLAGE/$INDUSTRY/troncs.txt"
        echo "Scie géante" > "$VILLAGE/$INDUSTRY/scie.txt"
        echo "Milo le scieur" > "$VILLAGE/$INDUSTRY/habitant_milo.txt"
        ;;
      Grandflac)
        echo "Meule à grain" > "$VILLAGE/$INDUSTRY/meule.txt"
        echo "Sac de farine" > "$VILLAGE/$INDUSTRY/farine.txt"
        echo "Jeanne la meunière" > "$VILLAGE/$INDUSTRY/habitant_jeanne.txt"
        ;;
    esac

    # Maison Commune (population.txt déjà existant)
    echo "Bailli de $v" > "$VILLAGE/Maison Commune/habitant_bailli.txt"
    echo "Registre des propriétés :
- $INDUSTRY : propriété collective" > "$VILLAGE/Maison Commune/registre_proprietes.txt"
    echo "Registre des décisions :
- Vendredi = jour du poisson
- Quota de 1000 Ko dans le Grenier Banal" > "$VILLAGE/Maison Commune/registre_decisions.txt"
done
