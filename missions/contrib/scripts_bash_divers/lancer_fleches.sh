#!/bin/bash

# Couleurs
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Définir le terminal
cols=$(tput cols)

# Positions verticales (lignes)
line_red=3
line_blue=6
line_yellow=9

# Afficher une flèche animée à une ligne donnée
lancer_fleche() {
    local color="$1"
    local line="$2"
    local arrow="--->>>"

    for ((i=0; i<cols-10; i++)); do
        tput cup "$line" 0         # Aller à la ligne spécifiée
        printf "%*s" $i ""         # Espace horizontale
        echo -ne "${color}${arrow}${NC}"
        sleep 0.01
    done
    tput cup $((line+1)) 0
    echo -e "${color}💥 Flèche lancée !${NC}"
}

# Nettoyer l'écran
clear

# Lancer les flèches avec un décalage de temps
lancer_fleche "$RED" "$line_red" &
sleep 1
lancer_fleche "$BLUE" "$line_blue" &
sleep 1
lancer_fleche "$YELLOW" "$line_yellow" &

# Attendre la fin des flèches
wait
tput cup $((line_yellow + 3)) 0
echo "🏁 Toutes les flèches ont été tirées !"

