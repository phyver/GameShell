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
    local r3="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
    local r4="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
    local r5="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"
    local r6="$((1 + RANDOM%N)),$((1 + RANDOM%N)),$((1 + RANDOM%N))"

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
                if [ "$r1" = "$i,$j,$k" ]
                then
                    local sum=$(checksum "$K.$(gettext "ruby")")
                    echo "$K $(gettext "ruby") $sum" > "$maze/$I/$J/$K"
                    echo "$K $(gettext "ruby") $sum" > "$GSH_VAR/ruby"
                elif [ "$r2" = "$i,$j,$k" ] || \
                     [ "$r3" = "$i,$j,$k" ] || \
                     [ "$r4" = "$i,$j,$k" ] || \
                     [ "$r5" = "$i,$j,$k" ] || \
                     [ "$r6" = "$i,$j,$k" ]
                then
                    local sum=$(checksum "$K.$(gettext "stone")")
                    echo "$K $(gettext "stone") $sum" > "$maze/$I/$J/$K"
                fi
            done
            echo -n "."
        done
    done
    echo
}

gen_maze_py(){
    mkdir -p "$maze"
    local d=$(python3 "$MISSION_DIR"/init.py "$maze" 3 10 6)

    local d1=$(echo "$d" | head -n 1)
    local K=$RANDOM
    local sum=$(checksum "$K $(gettext "ruby")")
    echo "$K $(gettext "ruby") $sum" > "$maze/$d1/$K"
    echo "$K $(gettext "ruby") $sum" > "$GSH_VAR/ruby"

    echo "$d" | sed '1d' | while read d1
    do
        K=$RANDOM
        sum=$(checksum "$K $(gettext "stone")")
        echo "$$K (gettext "stone") $sum" > "$maze/$d1/$K"
    done
}

if ! command -v python3 > /dev/null
then
    gen_maze_sh
else
    gen_maze_py
fi

unset maze
unset -f gen_maze_sh gen_maze_py
