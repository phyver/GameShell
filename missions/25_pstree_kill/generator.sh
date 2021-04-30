#!/bin/bash

delay=$1
logfile=$2
dir=$3
nature=$4
n=0

rm "$log"

sleep "$delay"
while true; do
    n=$((1-n))
    name=${RANDOM}_$nature
    [ "$n" -eq 0 ] && name=.$name
    touch "$dir/$name"
    echo "$name" >> "$log"
    sleep 3
done
