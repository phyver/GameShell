#!/bin/bash

# mise à jour du répertoire courant, qui pourrait être supprimé lors du ménage
case $PWD in
    *$(gettext "maze")*)
        cd "$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -type d -name "$(gettext ".Long*Corridor*")")" &&
            echo "$(gettext "Pffft... You are back to the entrance of the maze...")"
        ;;
    *)
        echo "$PWD"
        ;;
esac

find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name "$(gettext "maze")" -type d -print0 | xargs -0 rm -rf
find "$GASH_HOME" -type f -readable -not -iname "*journal*" -print0 | xargs -0 grep -l "$(gettext "diamond")" | xargs rm -f
