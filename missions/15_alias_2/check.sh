#!/bin/bash

check() {

    local cmd=$(alias journal 2> /dev/null | cut -f2 -d"=" | tr -d "'")
    if [ -z "$cmd" ]
    then
        echo "L'alias 'journal' n'existe pas..."
        return 1
    fi

    case "$cmd" in
        *nano*)
            # "cd /" permet d'éviter de valider si les étudiants ont utilisé
            # alias journal="nano journal.txt" et que le gash check est fait
            # depuis le coffre
            # local f="$(cd / ; eval $(echo "$cmd" | sed 's/nano/$READLINK -f/'))"
            local f="$(cd / ; eval "${cmd//nano/$READLINK -f}")"
            if [ "$f" = "$($READLINK -f "$GASH_COFFRE/journal.txt")" ]
            then
                return 0
            else
                # echo "Votre alias utilise le fichier '~${f#$HOME}' qui n'est pas correct."
                # f="$(echo "$cmd" | sed 's/ *nano *//')"
                f="${cmd// *nano */}"
                echo "Votre alias semble ne pas utiliser le bon fichier ($f)."
                echo "Vérifiez que vous donnez un chemin absolu..."
                unalias journal
                find "$GASH_HOME" -iname "*journal*" -print0 | xargs -0 rm -rf
                return 1
            fi

            ;;
        *)
            echo "Votre alias n'utilise pas la commande nano !"
            unalias journal
            find "$GASH_HOME" -iname "*journal*" -print 0 | xargs -0 rm -rf
            return 1
            ;;
    esac
}

check
