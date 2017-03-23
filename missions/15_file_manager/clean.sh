#!/bin/bash

rm -f $GASH_VAR/bronze
find $GASH_HOME -iname bronze | xargs rm -f
find $GASH_HOME/Chateau/Cave/ -name labyrinthe -type d -print0 | xargs -0 rm -rf

