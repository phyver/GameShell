#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

maze="$(eval_gettext '$GSH_HOME/Garden/.Maze')"
rm -rf "$maze"/?*

gen_maze_sh(){
    echo -n "$(gettext "maze generation:")"
    local t=$(date +%s)
    local N=2
    local r1="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

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
                    echo "$I $J $K" > "$maze/$I/$J/$K/OOOOO_$(gettext "silver_coin")_OOOOO"
                    echo "$I $J $K" > "$GSH_VAR/silver_coin"
                fi
            done
            echo -n "."
        done
    done
    echo
}

gen_maze_py(){
    mkdir -p "$maze"
    local d=$(python3 "$MISSION_DIR"/init.py "$maze" 3 3 1)
    echo "$(checksum "$d")" > "$maze/$d/OOOOO_$(gettext "silver_coin")_OOOOO"
    echo "$(checksum "$d")" > "$GSH_VAR/silver_coin"
}

if ! command -v python3 > /dev/null
then
    gen_maze_sh
else
    gen_maze_py
fi

unset maze
unset -f gen_maze_sh gen_maze_py

