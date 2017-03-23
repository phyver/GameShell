#!/bin/bash

find $GASH_HOME/Chateau/Cave/ -name labyrinthe -type d -print0 | xargs -0 rm -rf
find $GASH_HOME -type f | xargs grep -l "rubis" | xargs rm -f
