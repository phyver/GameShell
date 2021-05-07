#!/bin/bash

checksum() {
    local n=$((8 + RANDOM % 24))
    echo $1 | md5sum | cut -c1-$n
}

gen_maze() {
    cd $DIR
    local width=$1
    local nb_path=$2

    echo -n "$(gettext "maze generation:")" >&2
    local t=$(date +%s)

    local i I j J k K
    for i in $(seq $width)
    do
        I=$(checksum "$t$i")
        for j in $(seq $width)
        do
            J=$(checksum "$t$i$j")
            for k in $(seq $width)
            do
                K=$(checksum "$t$i$j$k")
                mkdir -p "$DIR/$I/$J/$K"
            done
            echo -n "." >&2
        done
    done
    echo >&2
    find . | grep -E "(/.*){3}" | sort -R | head -n $nb_path
}

DIR=$1
shift
gen_maze "$@"
