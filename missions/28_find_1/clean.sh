#!/bin/bash

find $GASH_VAR -iname piece_d_or | xargs rm -f
find $GASH_HOME/Chateau/Cave/ -name labyrinthe -type d -print0 | xargs -0 rm -rf
find $GASH_HOME -iname piece_d_or | xargs rm -f
