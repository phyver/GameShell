#!/bin/bash

_local_check() {
    local cmd f
    cmd=$(alias $(gettext "journal") 2> /dev/null | cut -f2 -d"=" | tr -d "'")
    if [ -z "$cmd" ]
    then
        local _alias=$(gettext "journal")
        echo "$(eval_gettext "No alias '\$_alias' has been found...")"
        return 1
    fi

    case "$cmd" in
        *nano*)
            # "cd /" permet d'éviter de valider si les étudiants ont utilisé
            # alias journal="nano journal.txt" et que le gash check est fait
            # depuis le coffre
            local f
            # f="$(cd / ; eval $(echo "$cmd" | sed 's/nano/$REALPATH/'))"
            f="$(cd / ; eval "${cmd//nano/REALPATH}")"
            if [ "$f" = "$(REALPATH "$GASH_CHEST/$(gettext "journal").txt")" ]
            then
                unset f
                return 0
            else
                # echo "Votre alias utilise le fichier '~${f#$HOME}' qui n'est pas correct."
                # f="$(echo "$cmd" | sed 's/ *nano *//')"
                f="${cmd// *nano */}"
                echo "$(eval_gettext "It seems you alias doesn't refer to the appropriate file (\$f).
Make sure to use an absolute path...")"
                unalias $(gettext "journal")
                find "$GASH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -rf
                unset f
                return 1
            fi

            ;;
        *)
            echo "$(gettext "Your alias doesn't use the command 'nano'...")"
            unalias $(gettext "journal")
            find "$GASH_HOME" -iname "*$(gettext "journal")*" -print 0 | xargs -0 rm -rf
            unset f
            return 1
            ;;
    esac
}

if _local_check
then
    unset -f _local_check
    true
else
    unset -f _local_check
    false
fi

