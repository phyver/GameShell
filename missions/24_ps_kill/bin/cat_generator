#!/bin/bash

dir=$1
nature=$2

while true; do
    name=.$(checksum $RANDOM)_$nature
    touch "$dir/$name"
    sleep 1
done
