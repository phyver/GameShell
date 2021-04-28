#!/bin/bash

[ -z "$GASH_CHEST" ] && GASH_CHEST="$(eval_gettext '$GASH_HOME/Forest/Cabin/Chest')"
mkdir -p "$GASH_CHEST"

maze="$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')"
rm -rf "$maze"/?*

gen_maze_sh(){
    echo -n "$(gettext "maze generation:")"
    local t=$(date +%s)

    local N=10
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
                K="$t$i$j$k"
                if [ "$r1" = "$i,$j,$k" ]
                then
                    local sum=$(checksum "$K $(gettext "diamond")")
                    echo "$K $(gettext "diamond") $sum" > "$maze/$I/$J/$K"
                    echo "$K $(gettext "diamond") $sum" > "$GASH_MISSION_DATA/diamond"
                else
                    local sum=$(checksum "$K $(gettext "stone")")
                    echo "$K $(gettext "stone") $K $sum" > "$maze/$I/$J/$K"
                fi
            done
            echo -n "."
        done
    done
    echo
}

gen_maze_py(){
    mkdir -p "$maze"
    local f=$(python3 "$MISSION_DIR"/init.py "$maze" 3 10 1)
    local K=$(basename "$f")
    local sum=$(checksum "$K $(gettext "diamond")")
    echo "$K $(gettext "diamond") $sum" > "$maze/$f"
    echo "$K $(gettext "diamond") $sum" > "$GASH_MISSION_DATA/diamond"
}

if ! command -v python3 > /dev/null
then
    gen_maze_sh
else
    gen_maze_py
fi

unset maze
unset -f gen_maze_sh gen_maze_py
