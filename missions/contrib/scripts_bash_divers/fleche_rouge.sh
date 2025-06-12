#!/bin/bash

# Couleur rouge
RED='\033[0;31m'
NC='\033[0m' # Pas de couleur

# Flèche ASCII
arrow="--->>>"

# Longueur du terminal
cols=$(tput cols)

# Lancement de la flèche
for ((i=0; i<cols-10; i++)); do
    # Efface la ligne
    printf "\r"
    # Espace avant la flèche
    printf "%*s" $i ""
    # Affiche la flèche rouge
    echo -ne "${RED}${arrow}${NC}"
    sleep 0.02
done

# Fin
echo -e "\n${RED}💥 La flèche atteint sa cible !${NC}"

