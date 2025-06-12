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

explosion_fragmentation_1() {
    local row=$1
    local col=$2
    local colors=('\033[0;31m' '\033[0;33m' '\033[0;34m' '\033[0;35m' '\033[1;32m')
    local symbols=("+" "*" "x" "o" "@")

    # Explosion centrale 5x5 (comme avant)
    for frame in {1..5}; do
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
        sleep 0.1
        # Effacer zone 5x5
        for dr in {-2..2}; do
            for dc in {-2..2}; do
                tput cup $((row + dr)) $((col + dc))
                echo -ne " "
            done
        done
    done

    # FRAGMENTS qui explosent en 8 directions
    local directions=(
        "-1 0"    # haut
        "-1 1"    # haut-droite
        "0 1"     # droite
        "1 1"     # bas-droite
        "1 0"     # bas
        "1 -1"    # bas-gauche
        "0 -1"    # gauche
        "-1 -1"   # haut-gauche
    )
    local frag_symbols=("${symbols[@]}")

    # Initial positions des fragments au centre
    local frag_pos=()
    for ((i=0; i<8; i++)); do
        frag_pos+=( "$row $col" )
    done

    # Animation fragments : 4 pas
    for step in {1..4}; do
        # Effacer anciens fragments
        if (( step > 1 )); then
            for ((i=0; i<8; i++)); do
                read -r r c <<< "${frag_pos[i]}"
                tput cup $r $c
                echo -ne " "
            done
        fi

        # Calculer nouvelles positions
        for ((i=0; i<8; i++)); do
            read -r r c <<< "${frag_pos[i]}"
            read -r dr dc <<< "${directions[i]}"
            r=$((r + dr))
            c=$((c + dc))
            frag_pos[i]="$r $c"
        done

        # Afficher fragments
        for ((i=0; i<8; i++)); do
            read -r r c <<< "${frag_pos[i]}"
            local color_index=$((i % ${#colors[@]}))
            local symbol=${frag_symbols[i % ${#frag_symbols[@]}]}
            # S'assurer qu'on est dans les bornes
            if (( r >= 0 && r < lines && c >= 0 && c < cols )); then
                tput cup $r $c
                echo -ne "${colors[color_index]}${symbol}${NC}"
            fi
        done

        sleep 0.12
    done

    # Effacer derniers fragments
    for ((i=0; i<8; i++)); do
        read -r r c <<< "${frag_pos[i]}"
        if (( r >= 0 && r < lines && c >= 0 && c < cols )); then
            tput cup $r $c
            echo -ne " "
        fi
    done
}

explosion_fragmentation() {
    local row=$1
    local col=$2
    local color=$3
    local symbols=("+" "*" "x" "o" "@")

    # Explosion centrale 5x5 en couleur du boulet
    for frame in {1..5}; do
        for dr in {-2..2}; do
            for dc in {-2..2}; do
                local r=$((row + dr))
                local c=$((col + dc))
                local symbol_index=$(((frame + dr + dc) % ${#symbols[@]}))
                tput cup $r $c
                echo -ne "${color}${symbols[symbol_index]}${NC}"
            done
        done
        sleep 0.1
        # Effacer zone 5x5
        for dr in {-2..2}; do
            for dc in {-2..2}; do
                tput cup $((row + dr)) $((col + dc))
                echo -ne " "
            done
        done
    done

    # Directions des fragments
    local directions=(
        "-1 0"    # haut
        "-1 1"    # haut-droite
        "0 1"     # droite
        "1 1"     # bas-droite
        "1 0"     # bas
        "1 -1"    # bas-gauche
        "0 -1"    # gauche
        "-1 -1"   # haut-gauche
    )
    local frag_symbols=("${symbols[@]}")

    local frag_pos=()
    for ((i=0; i<8; i++)); do
        frag_pos+=( "$row $col" )
    done

    for step in {1..4}; do
        if (( step > 1 )); then
            for ((i=0; i<8; i++)); do
                read -r r c <<< "${frag_pos[i]}"
                tput cup $r $c
                echo -ne " "
            done
        fi

        for ((i=0; i<8; i++)); do
            read -r r c <<< "${frag_pos[i]}"
            read -r dr dc <<< "${directions[i]}"
            r=$((r + dr))
            c=$((c + dc))
            frag_pos[i]="$r $c"
        done

        for ((i=0; i<8; i++)); do
            read -r r c <<< "${frag_pos[i]}"
            local symbol=${frag_symbols[i % ${#frag_symbols[@]}]}
            if (( r >= 0 && r < lines && c >= 0 && c < cols )); then
                tput cup $r $c
                echo -ne "${color}${symbol}${NC}"
            fi
        done

        sleep 0.12
    done

    for ((i=0; i<8; i++)); do
        read -r r c <<< "${frag_pos[i]}"
        if (( r >= 0 && r < lines && c >= 0 && c < cols )); then
            tput cup $r $c
            echo -ne " "
        fi
    done
}

explosion_fragmentation_gros_boulet() {
    local row=$1
    local col=$2
    local color=$3
    local symbols=("+" "*" "x" "o" "@" "#")

    # Explosion centrale 7x7
    for frame in {1..6}; do
        for dr in {-3..3}; do
            for dc in {-3..3}; do
                local r=$((row + dr))
                local c=$((col + dc))
                local idx=$(((frame + dr + dc) % ${#symbols[@]}))
                if (( r >=0 && r < lines && c >=0 && c < cols )); then
                    tput cup $r $c
                    echo -ne "${color}${symbols[idx]}${NC}"
                fi
            done
        done
        sleep 0.1
        # Effacer zone 7x7
        for dr in {-3..3}; do
            for dc in {-3..3}; do
                local r=$((row + dr))
                local c=$((col + dc))
                if (( r >=0 && r < lines && c >=0 && c < cols )); then
                    tput cup $r $c
                    echo -ne " "
                fi
            done
        done
    done


    # Directions des fragments (16 directions)
    local directions=(
        "-1 0"   "-1 1"   "0 1"   "1 1"   "1 0"   "1 -1"   "0 -1"   "-1 -1"
        "-2 1"   "2 1"    "1 2"   "-1 2"  "-2 -1" "2 -1"   "1 -2"   "-1 -2"
    )
    local frag_symbols=("${symbols[@]}")

    # Position initiale des fragments : au centre
    local frag_pos=()
    for ((i=0; i<16; i++)); do
        frag_pos+=( "$row $col" )
    done

    # Animation fragments : 5 pas
    for step in {1..5}; do
        if (( step > 1 )); then
            for ((i=0; i<16; i++)); do
                read -r r c <<< "${frag_pos[i]}"
                if (( r >=0 && r < lines && c >=0 && c < cols )); then
                    tput cup $r $c
                    echo -ne " "
                fi
            done
        fi

        for ((i=0; i<16; i++)); do
            read -r r c <<< "${frag_pos[i]}"
            read -r dr dc <<< "${directions[i]}"
            r=$((r + dr))
            c=$((c + dc))
            frag_pos[i]="$r $c"
        done

        for ((i=0; i<16; i++)); do
            read -r r c <<< "${frag_pos[i]}"
            local symbol=${frag_symbols[i % ${#frag_symbols[@]}]}
            if (( r >=0 && r < lines && c >=0 && c < cols )); then
                tput cup $r $c
                echo -ne "${color}${symbol}${NC}"
            fi
        done

        sleep 0.12
    done

    # Effacer derniers fragments
    for ((i=0; i<16; i++)); do
        read -r r c <<< "${frag_pos[i]}"
        if (( r >=0 && r < lines && c >=0 && c < cols )); then
            tput cup $r $c
            echo -ne " "
        fi
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
    #explosion_ascii "$impact_row" "$col"
    dammage=50
    # Réduction de PV - 10 par boulet
    if [[ -f "$PV_FILE" ]]; then
        pv=$(<"$PV_FILE")
        ((pv-=$dammage))
        ((pv<0)) && pv=0
        echo "$pv" > "$PV_FILE"
    fi
}

# Gros boulet de canon
boulet_grand=(
"  (@@@)  "
" ( @@@ ) "
"  (@@@)  "
)

# === ATTAQUE GROS BOULET DE CANON ===
lancer_boulet_canon_gros() {
    local color=$1
    local col=$2

    local height=${#boulet_grand[@]}
    local start_row=0
    local max_row=$((lines - height - 5))

    for ((i=start_row; i<=max_row; i++)); do
        # Effacer la position précédente
        if (( i > start_row )); then
            for ((j=0; j<height; j++)); do
                tput cup $((i - 1 + j)) $col
                echo -ne "         "  # même largeur que la ligne du boulet
            done
        fi
        # Afficher boulet à la position i
        for ((j=0; j<height; j++)); do
            tput cup $((i + j)) $col
            echo -ne "${color}${boulet_grand[j]}${NC}"
        done

        sleep 0.05
    done
    tput cup $row $col
    echo -ne " "
    local impact_row=$((max_row + height / 2))
    #explosion_ascii "$impact_row" "$col"
    #explosion_fragmentation "$impact_row" "$col"
    #explosion_fragmentation "$impact_row" "$col" "$color"
    explosion_fragmentation_gros_boulet "$impact_row" "$col" "$color"

    dammage=150
    # Réduction de PV - 20 par gros boulet
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
#sleep 1
#lancer_boulet_canon "$MAGENTA" "$col_magenta" &
#sleep 1
#lancer_boulet_canon "$RED" "$col_red" &
#wait
#
#sleep 1
#clear


# Lancer gros boulets de canon (2)
sleep 1
lancer_boulet_canon_gros "$MAGENTA" "$col_magenta";
clear;
sleep 1
lancer_boulet_canon_gros "$RED" "$col_red";
clear;
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

