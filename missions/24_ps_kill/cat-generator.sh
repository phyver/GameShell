#!/bin/bash

dir=$1
nature=$2
n=0

while true; do
    n=$((1-n))
    name=$(checksum $RANDOM)_$nature
    [ "$n" -eq 0 ] && name=.$name
    touch "$dir/$name"
    sleep 1
done
