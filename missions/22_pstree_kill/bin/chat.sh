#!/bin/bash

cave=$GASH_HOME/Chateau/Cave

while true; do
    name=.$(checksum $RANDOM)_$NATURE
    touch $cave/$name
    sleep 1
done
