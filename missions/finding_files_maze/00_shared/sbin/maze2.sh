#!/usr/bin/env bash

checksum_r() {
    local n=$((8 + RANDOM % 24))
    checksum "$1" | cut -c1-$n
}

gen_maze(){
    cd $DIR
    local width=$1
    local nb_path=$2
    local stone=$3

    echo -n "$(gettext "maze generation:")" >&2
    local t=$(date +%s)

    local i I j J k K
    for i in $(seq $width)
    do
        I=$(checksum_r "$t$i")
        for j in $(seq $width)
        do
            J=$(checksum_r "$t$i$j")
            mkdir -p "$DIR/$I/$J"
            for k in $(seq $width)
            do
                K="$t$i$j$k"
                local sum=$(checksum "$K $(gettext "stone")")
                local n1=$((4 + RANDOM % 12))
                local n2=$((20 + RANDOM % 12))
                echo $sum | cut -c1-$n1 | tr -d '\n'>  "$DIR/$I/$J/$K"
                echo -n " $stone "                  >> "$DIR/$I/$J/$K"
                echo $sum | cut -c16-$n2            >> "$DIR/$I/$J/$K"
            done
            echo -n "." >&2
        done
    done
    echo >&2
    find . -type f | sort -R | head -n $nb_path
}

DIR=$1
shift
gen_maze "$@"
