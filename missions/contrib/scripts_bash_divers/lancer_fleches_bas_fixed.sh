#!/bin/bash

# Couleurs ANSI
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Flèche vers le bas
symbol="↓"

# Dimensions du terminal
lines=$(tput lines)
cols=$(tput cols)

# Colonnes personnalisées pour les 3 flèches
col_red=$((cols / 4))
col_blue=$((cols / 2))
col_yellow=$((3 * cols / 4))

# S'assurer que les colonnes sont dans les limites
col_red=$((col_red < 0 ? 0 : col_red))
col_blue=$((col_blue < 0 ? 0 : col_blue))
col_yellow=$((col_yellow < 0 ? 0 : col_yellow))

# Fonction pour lancer une flèche verticalement
lancer_fleche_verticale() {
    local color=$1
    local col=$2
    local symbol="↓"

    for ((i=0; i<lines-2; i++)); do
        if (( i > 0 )); then
            tput cup $((i-1)) $col
            echo -ne " "
        fi

        tput cup $i $col
        echo -ne "${color}${symbol}${NC}"
        sleep 0.03
    done

    # Impact
    tput cup $((lines-2)) $((col-1))
    echo -e "${color}💥${NC}"
}

# Nettoyer l'écran
clear

# Lancer les flèches en décalé
lancer_fleche_verticale "$RED" "$col_red" &
sleep 1
lancer_fleche_verticale "$BLUE" "$col_blue" &
sleep 1
lancer_fleche_verticale "$YELLOW" "$col_yellow" &

# Attendre la fin
wait
tput cup "$((lines-1))" 0
echo -e "🏁 Toutes les flèches ont été tirées vers le bas !"

