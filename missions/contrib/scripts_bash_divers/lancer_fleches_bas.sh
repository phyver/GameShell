#!/bin/bash

# Couleurs ANSI
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Symboles des flèches vers le bas
arrow="  |  \n  |  \n  v  "

# Dimensions du terminal
lines=$(tput lines)
cols=$(tput cols)

# Colonnes personnalisées pour les 3 flèches
col_red=$((cols / 4))
col_blue=$((cols / 2))
col_yellow=$((3 * cols / 4))

# Fonction pour lancer une flèche verticalement
lancer_fleche_verticale() {
    local color=$1
    local col=$2
    local symbol="↓"

    for ((i=0; i<lines-3; i++)); do
        # Effacer le caractère précédent
        tput cup "$((i-1))" "$col"
        echo -ne " "

        # Afficher la flèche à la nouvelle position
        tput cup "$i" "$col"
        echo -ne "${color}${symbol}${NC}"
        sleep 0.03
    done

    # Effet à la fin
    tput cup "$i" "$((col-1))"
    echo -e "${color}💥${NC}"
}

# Nettoyer l'écran
clear

# Lancer les 3 flèches avec un intervalle
lancer_fleche_verticale "$RED" "$col_red" &
sleep 1 &
lancer_fleche_verticale "$BLUE" "$col_blue" &
sleep 1 &
lancer_fleche_verticale "$YELLOW" "$col_yellow" &

# Attendre la fin
wait
tput cup "$lines" 0
echo -e "🏁 Toutes les flèches sont tirées vers le bas !"

