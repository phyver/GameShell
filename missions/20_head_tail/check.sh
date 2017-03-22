#!/bin/bash

# turn history on (off by default for non-interactive shells
HISTFILE=$GASH_DATA/history

pc=$(fc -nl -2 -2 | grep 'head' | grep 'tail' | xargs)

goal=$(readlink -f $GASH_HOME/Montagne/Grotte)
current=$(pwd | xargs readlink -f)

expected=$(head -n 11 $GASH_HOME/Montagne/Grotte/recette_potion | tail -n 3)
res=$(eval $pc)

if [ "$goal" = "$current"  -a  \
     -n "$pc"  -a  \
     "$res" = "$expected" ]
then
    unset pc goal current expected res
    true
else
    unset pc goal current expected res
    false
fi
