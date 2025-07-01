#!/bin/bash

# === COULEURS ANSI ===
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

# === EXPLOSION ANIMÉE ===
explosion_ascii() {
    local row=$1
    local col=$2
    local colors=('\033[0;31m' '\033[0;34m' '\033[1;33m' '\033[0;35m' '\033[1;32m')
    local symbols=("*" "+" "x" "X" "o" "@")

    for frame in {1..5}; do
        tput cup $((row - 1)) $col
        echo -ne "${colors[frame % ${#colors[@]}]}${symbols[frame % ${#symbols[@]}]}${NC}"

        tput cup $((row + 1)) $col
        echo -ne "${colors[(frame+1) % ${#colors[@]}]}${symbols[(frame+1) % ${#symbols[@]}]}${NC}"

        tput cup $row $((col - 1))
        echo -ne "${colors[(frame+2) % ${#colors[@]}]}${symbols[(frame+2) % ${#symbols[@]}]}${NC}"

        tput cup $row $((col + 1))
        echo -ne "${colors[(frame+3) % ${#colors[@]}]}${symbols[(frame+3) % ${#symbols[@]}]}${NC}"

        tput cup $row $col
        echo -ne "${colors[(frame+4) % ${#colors[@]}]}*${NC}"

        sleep 0.1

        # Effacer
        tput cup $((row - 1)) $col; echo -ne " "
        tput cup $((row + 1)) $col; echo -ne " "
        tput cup $row $((col - 1)); echo -ne " "
        tput cup $row $((col + 1)); echo -ne " "
        tput cup $row $col; echo -ne " "
    done
}

# === FLÈCHE VERS LE BAS + EXPLOSION ===
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

    local impact_row=$((lines - 5))
    explosion_ascii "$impact_row" "$col"

    # Réduction de PV
    if [[ -f "$PV_FILE" ]]; then
        pv=$(<"$PV_FILE")
        ((pv--))
	((pv--))
	((pv--))
	((pv--))
        ((pv--))
        echo "$pv" > "$PV_FILE"
    fi
}

# === AFFICHAGE BARRE DE VIE ===
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

# === LANCER LES FLÈCHES EXPLOSIVES ===
lancer_fleche_verticale "$RED" "$col_red" &
sleep 1
lancer_fleche_verticale "$BLUE" "$col_blue" &
sleep 1
lancer_fleche_verticale "$YELLOW" "$col_yellow" &
wait &> /dev/null

sleep 1
clear

# === AFFICHAGE BARRE DE VIE ===
#afficher_barre_vie
#echo

# === DRAGON MÉDIÉVAL ASCII ===
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
echo -e "\n${RED}⚔️  Fight is not over...${NC}"

