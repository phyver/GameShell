#!/bin/bash

# === COULEURS ===
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# === TERMINAL ===
lines=$(tput lines)
cols=$(tput cols)
col_red=$((cols / 4))
col_blue=$((cols / 2))
col_yellow=$((3 * cols / 4))

# === INITIALISER PV DRAGON ===
PV_FILE="pv_dragon.txt"
if [[ ! -f $PV_FILE ]]; then
    echo 1000 > "$PV_FILE"
fi

# === FONCTION FLÈCHE VERS LE BAS ===
lancer_fleche_verticale() {
    local color=$1
    local col=$2
    local symbol="↓"

    for ((i=0; i<lines-5; i++)); do
        if (( i > 0 )); then
            tput cup $((i-1)) $col
            echo -ne " "
        fi
        tput cup $i $col
        echo -ne "${color}${symbol}${NC}"
        sleep 0.02
    done

    # Impact
    tput cup $((lines-5)) $((col-1))
    echo -e "${color}💥${NC}"

    # Réduction de PV
    if [[ -f "$PV_FILE" ]]; then
        pv=$(<"$PV_FILE")
        ((pv--))
        echo "$pv" > "$PV_FILE"
    fi
}

# === FONCTION AFFICHER BARRE DE VIE ===
afficher_barre_vie() {
    local pv=$(<"$PV_FILE")
    local max=1000
    local longueur=50
    local remplissage=$((pv * longueur / max))
    local barre=$(printf "%-${remplissage}s" "#" | tr ' ' '#')
    local vide=$((longueur - remplissage))
    local espaces=$(printf "%-${vide}s")

    echo -ne "${GREEN}PV DRAGON: [${barre}${espaces}] $pv / $max${NC}\n"
}

# === NETTOYAGE ===
clear

# === LANCER FLÈCHES EN DÉCALÉ ===
lancer_fleche_verticale "$RED" "$col_red" &
sleep 0.5 
lancer_fleche_verticale "$BLUE" "$col_blue" &
sleep 0.5
lancer_fleche_verticale "$YELLOW" "$col_yellow" &
wait &> /dev/null

sleep 1
clear

# === AFFICHAGE BARRE DE VIE ===
#afficher_barre_vie
#echo

# === AFFICHER DRAGON MÉDIÉVAL ===
echo -e "${YELLOW}"
cat << "EOF"
                          ___====-_  _-====___
                    _--^^^#####//      \\#####^^^--_
                 _-^##########// (    ) \\##########^-_
                -############//  |\^^/|  \\############-
              _/############//   (@::@)   \\############\_
             /#############((     \\//     ))#############\
            -###############\\    (oo)    //###############-
           -#################\\  / UUU \  //#################-
          -###################\\/  (_)  \//###################-
         _#/|##########/\######(   "-"   )######/\##########|\#_
         |/ |#/\#/\#/\/  \#/\##\  !   !  /##/\#/  \/\#/\#/\| \|
         ||/  V  V '     V  \\#\  \___/  /#/  V     '  V  V  \||
         ||| \ \|  |  |  |  |  |       |  |  |  |  |  |/ / / |||
         |||  |_|_|_|_|_|_|_|_|_______|_|_|_|_|_|_|_|_|_|  |||
EOF
echo -e "${NC}"

# === FIN ===
echo -e "\n${RED}⚔️  It works ! You managed to launch an attack on the dragon but it just gave him a litlle scratch. Fight is not over...${NC}"

