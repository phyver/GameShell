#!/bin/bash

# === COULEURS ANSI ===
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# === TERMINAL ===
lines=$(tput lines)
cols=$(tput cols)
col_red=$((cols / 5))
col_blue=$((2 * cols / 5))
col_yellow=$((3 * cols / 5))
col_magenta=$((4 * cols / 5))

# === INITIALISER PV DRAGON ===
PV_FILE="pv_dragon.txt"
if [[ ! -f $PV_FILE ]]; then
    echo 1000 > "$PV_FILE"
fi

# === EXPLOSION LARGE ET COLORÉE ===
explosion_ascii() {
    local row=$1
    local col=$2
    local colors=('\033[0;31m' '\033[0;34m' '\033[1;33m' '\033[0;35m' '\033[1;32m')
    local symbols=("*" "+" "x" "X" "o" "@")

    for frame in {1..7}; do
        # Zone 5x5 autour du centre
        for dr in {-2..2}; do
            for dc in {-2..2}; do
                local r=$((row + dr))
                local c=$((col + dc))
                local color_index=$(((frame + dr + dc) % ${#colors[@]}))
                local symbol_index=$(((frame + dr + dc) % ${#symbols[@]}))
                tput cup $r $c
                echo -ne "${colors[color_index]}${symbols[symbol_index]}${NC}"
            done
        done
        sleep 0.12
        # Effacer zone 5x5
        for dr in {-2..2}; do
            for dc in {-2..2}; do
                local r=$((row + dr))
                local c=$((col + dc))
                tput cup $r $c
                echo -ne " "
            done
        done
    done
}

# === ATTAQUE FLÈCHE ===
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

    # Réduction de PV - 1 par flèche
    if [[ -f "$PV_FILE" ]]; then
        pv=$(<"$PV_FILE")
        ((pv-=1))
        ((pv<0)) && pv=0
        echo "$pv" > "$PV_FILE"
    fi
}

# === ATTAQUE BOULET DE CANON ===
lancer_boulet_canon() {
    local color=$1
    local col=$2
    local symbol="O"

    for ((i=0; i<lines-5; i++)); do
        if (( i > 0 )); then
            tput cup $((i-1)) $col
            echo -ne " "
        fi
        tput cup $i $col
        echo -ne "${color}${symbol}${NC}"
        sleep 0.03
    done

    local impact_row=$((lines - 5))
    explosion_ascii "$impact_row" "$col"
    dammage=50
    # Réduction de PV - 10 par boulet
    if [[ -f "$PV_FILE" ]]; then
        pv=$(<"$PV_FILE")
        ((pv-=$dammage))
        ((pv<0)) && pv=0
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

# === ATTAQUES ===
# Lancer flèches (3)
#lancer_fleche_verticale "$RED" "$col_red" &
#sleep 1
#lancer_fleche_verticale "$BLUE" "$col_blue" &
#sleep 1
#lancer_fleche_verticale "$YELLOW" "$col_yellow" &
#wait

# Lancer boulets de canon (2)
sleep 1
lancer_boulet_canon "$MAGENTA" "$col_magenta" &
sleep 1
lancer_boulet_canon "$RED" "$col_red" &
wait

sleep 1
clear

# === AFFICHAGE BARRE DE VIE ===
afficher_barre_vie
echo

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
echo -e "\n${RED}⚔️  Le combat continue...${NC}"

