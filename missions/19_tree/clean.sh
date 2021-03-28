#!/bin/bash

# mise à jour du répertoire courant, qui pourrait être supprimé lors du ménage
case $PWD in
    *labyrinthe*)
        cd "$(find "$GASH_HOME/Chateau/Cave/" -type d -name '.Long*Couloir*')" &&
            echo "Vous voila de retour par téléportation à l'entrée du labyrinthe..."
        ;;
esac

rm -f "$GASH_TMP/argent"
find "$GASH_HOME/Chateau/Cave/" -name "labyrinthe" -type d -print0 | xargs -0 rm -rf
find "$GASH_HOME" -iname "*argent*" -not -iname "*journal*" -print0 | xargs -0 rm -f
