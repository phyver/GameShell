#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

maze="$(eval_gettext '$GSH_HOME/Garden/.Maze')"
rm -rf "$maze"/?*

gen_maze_sh(){
    echo -n "$(gettext "maze generation:")"
    local t=$(date +%s)
    local N=10
    local r1="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
    local r2="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

    local i I j J k K
    for i in $(seq $N)
    do
        I=$(checksum "$t$i")
        mkdir -p "$maze/$I"
        for j in $(seq $N)
        do
            J=$(checksum "$t$i$j")
            mkdir -p "$maze/$I/$J"
            for k in $(seq $N)
            do
                K=$(checksum "$t$i$j$k")
                mkdir -p "$maze/$I/$J/$K"

                if [ "$r1" = "$i,$j,$k" ]
                then
                    echo "$I $J $K" > "$maze/$I/$J/$K/$(gettext "gold_coin")"
                    echo "$I $J $K" > "$GSH_MISSION_DATA/gold_coin"
                elif [ "$r2" = "$i,$j,$k" ]
                then
                    echo "$I $J $K" > "$maze/$I/$J/$K/$(gettext "GolD_CoiN")"
                    echo "$I $J $K" > "$GSH_MISSION_DATA/GolD_CoiN"
                fi
            done
            echo -n "."
        done
    done
    echo
}

gen_maze_py(){
    mkdir -p "$maze"
    local d=$(python3 "$MISSION_DIR"/init.py "$maze" 3 10 2)
    local d1=$(echo "$d" | head -n 1)
    local d2=$(echo "$d" | head -n 1)
    echo "$(checksum "$d1")" > "$maze/$d1/$(gettext "gold_coin")"
    echo "$(checksum "$d1")" > "$GSH_MISSION_DATA/gold_coin"
    echo "$(checksum "$d2")" > "$maze/$d2/$(gettext "GolD_CoiN")"
    echo "$(checksum "$d2")" > "$GSH_MISSION_DATA/GolD_CoiN"
}

if ! command -v python3 > /dev/null
then
    gen_maze_sh
else
    gen_maze_py
fi

unset maze
unset -f gen_maze_sh gen_maze_py
