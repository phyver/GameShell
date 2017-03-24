#!/bin/bash

rm -f $GASH_VAR/argent
find $GASH_HOME/Chateau/Cave/ -name "labyrinthe" -type d -print0 | xargs -0 rm -rf
find $GASH_HOME -iname "*argent*" | xargs rm -f
