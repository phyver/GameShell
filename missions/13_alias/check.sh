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
            local coffre=$(_coffre)
            local f="$(eval $(echo $cmd | sed 's/nano/readlink -f/'))"
            if [ "$f" = "$(readlink -f $coffre/journal.txt)" ]
            then
                return 0
            else
                echo "Votre alias utilise le fichier '~${f#$HOME}' qui n'est pas correct."
                unalias journal
                return 1
            fi

            ;;
        *)
            echo "Votre alias n'utilise pas la commande ``nano`` !"
            unalias journal
            return 1
            ;;
    esac
}

check
