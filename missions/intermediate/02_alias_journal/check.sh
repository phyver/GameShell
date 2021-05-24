#!/bin/bash

_mission_check() {
    local cmd
    cmd=$(alias $(gettext "journal") 2> /dev/null | cut -f2 -d"=" | tr -d "'")
    if [ -z "$cmd" ]
    then
        local alias_name=$(gettext "journal")
        echo "$(eval_gettext "No alias '\$alias_name' has been found...")"
        return 1
    fi

    case "$cmd" in
        *nano*)
            # "cd /" permet d'éviter de valider si les étudiants ont utilisé
            # alias journal="nano journal.txt" et que le gsh check est fait
            # depuis le coffre
            local target_path
            target_path="$(cd / ; eval "${cmd/nano/realpath}")"
            if [ "$target_path" = "$(realpath "$GSH_CHEST/$(gettext "journal").txt")" ]
            then
                return 0
            else
                # echo "Votre alias utilise le fichier '~${target_path#$HOME}' qui n'est pas correct."
                # target_path="$(echo "$cmd" | sed 's/ *nano *//')"
                target_path="${cmd// *nano */}"
                echo "$(eval_gettext "It seems you alias doesn't refer to the appropriate file (\$target_path).
Make sure to use an absolute path...")"
                unalias $(gettext "journal")
                find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -rf
                return 1
            fi

            ;;
        *)
            echo "$(gettext "Your alias doesn't use the command 'nano'...")"
            unalias $(gettext "journal")
            find "$GSH_HOME" -iname "*$(gettext "journal")*" -print 0 | xargs -0 rm -rf
            return 1
            ;;
    esac
}

_mission_check
