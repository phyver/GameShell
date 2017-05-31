#!/bin/bash

# turn history on (off by default for non-interactive shells
HISTFILE=$GASH_DATA/history

if ! (fc -nl -4 | grep -qx "[[:blank:]]*xeyes[[:blank:]]*")
then
    echo "Vous n'avez pas lancé la commande xeyes directement..."
    killall -q -9 xeyes
    false
elif ! LANG=C jobs | grep "xeyes.*&" | grep -qi running
then
    echo "Il n'y a pas de commande xeyes actuellement en exécution..."
    killall -q -9 xeyes
    false
else
    true
fi


