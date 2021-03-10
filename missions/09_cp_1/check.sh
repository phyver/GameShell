#!/bin/bash

_local_check() {
    entree="$GASH_HOME/Chateau/Entree"

    for i in $(seq 4)
    do
        local etendard="etendard_$i"

        # _local_check that file exists
        if [ ! -f "$GASH_CABANE/$etendard" ]
        then
            echo "L'étendard $i ne se trouve pas dans la cabane."
            return 1
        fi
        if [ ! -f "$entree/$etendard" ]
        then
            echo "L'étendard $i ne se trouve plus dans l'entrée."
            return 1
        fi

        # _local_check that prefix of first line is the name of the file
        P=$(cut -f 1 -d' ' "$GASH_CABANE/$etendard")
        if [ "$(echo "$P" | cut -f1 -d'#')" != "$etendard" ]
        then
            echo "L'étendard $i de la cabane n'est pas le bon."
            return 1
        fi
        P=$(cut -f 1 -d' ' "$entree/$etendard")
        if [ "$(echo "$P" | cut -f1 -d'#')" != "$etendard" ]
        then
            echo "L'étendard $i de l'entrée n'est pas le bon."
            return 1
        fi

        # _local_check that suffix of file is the SHA1 of $etendard
        S=$(cut -f 2 -d' ' "$GASH_CABANE/etendard_$i")
        if [ "$S" != "$(checksum "$P")" ]
        then
            echo "Le fichier de l'étendard $i de la cabane est invalide."
            return 1
        fi
        S=$(cut -f 2 -d' ' "$entree/etendard_$i")
        if [ "$S" != "$(checksum "$P")" ]
        then
            echo "Le fichier de l'étendard $i de l'entrée est invalide."
            return 1
        fi
    done
    return 0
}


if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    find "$GASH_HOME" -name "etendard_?" -type f -print0 | xargs -0 rm -f
    false
fi


