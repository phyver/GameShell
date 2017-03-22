#misc functions

# fonction pour retrouver le coffre et la cabane...
# TODO : à mettre ailleurs
 _cabane() {
     find $GASH_HOME/Foret -maxdepth 1 -iname cabane
 }
 export -f _cabane

 _coffre() {
     find $(_cabane) -maxdepth 1 -iname coffre
 }
 export -f _coffre

_gash_exit() {
    local nb=$(_get_current_mission)
    local action=$1
    log_action $nb $action
    _gash_clean $nb
    exit
}
trap "_gash_exit EXIT" EXIT
trap "_gash_exit TERM" SIGTERM
# trap "_gash_exit INT" SIGINT


checksum() {
    if [ -z "$@" ]
    then
        cat - | sha1sum | cut -c 1-40
    else
        echo -n "$@" | sha1sum | cut -c 1-40
    fi
}
export -f checksum

color_echo() {
    case "$1" in
        black   | bk) color=0; shift;;
        red     |  r) color=1; shift;;
        green   |  g) color=2; shift;;
        yellow  |  y) color=3; shift;;
        blue    |  b) color=4; shift;;
        magenta |  m) color=5; shift;;
        cyan    |  c) color=6; shift;;
        white   |  w) color=7; shift;;
        *) color=7;;
    esac
    if [ -n "$GASH_COLOR" ]
    then
        tput setaf $color 2>/dev/null
        echo $@
        tput sgr0 2>/dev/null
    else
        echo $@
    fi
}

admin_mode() {
    # to use: call admin_mode and check GASH_ADMIN variable...
    local i mpd
    for i in $(seq 3)
    do
        read -s -p "mot de passe admin : " mdp
        echo ""
        #  replace string by sha1sum of password
        if [ "$(checksum $mdp)" = "39f70a1addd8031d5e68d75c1a4432ebf115cf85" ]
        then
            GASH_ADMIN="OK"
            return 0
        fi
    done
    GASH_ADMIN=""
    return 1
}


log_action() {
    local nb action
    nb=$1
    action=$2
    D="$(date +%s)"
    S="$(checksum "$GROUP_UID#$nb#$action#$D")"
    echo "$nb $action $D $S" >> "$GASH_DATA/missions.log"
}

parchment() {
    local file=$1
    [ ! -f $file ] && return 1
    if [ -x "$(which python3)" ]
    then
        local P=$(( 16#$(checksum $(readlink -f $file) | cut -c 10-13) % 4 ))
        case "$P" in
            0 | 1) P="Parchment";;
            2) P="Parchment2";;
            3) P="Parchment3";;
            *) P="Parchment";;
        esac
        echo ""
        python3 $GASH_BIN/box.py -b $P < "$mission/goal.txt"
        echo ""
    else
        echo
        cat "$mission/goal.txt"
        echo
    fi
}

# get the last started mission
_get_current_mission() {
    awk '$0 !~ /^#/ && $2 == "START" { m = $1 } END {print (m)}' $GASH_DATA/missions.log
}

# get next mission number
_get_next_mission() {
    local nb=$1
    [ -z "$nb" ] && nb="0"

    while true
    do
        nb=$((10#$nb + 1))
        if [ -n "$(_get_mission_nb $nb)" ]
        then
            break
        fi
    done
    echo $nb
}

# get the complete mission number by appending leading '0's
_get_mission_nb() {
    local nb=$1
    if [ -d $GASH_MISSIONS/${nb}_*/ ]
    then
        echo $nb
    elif [ -d $GASH_MISSIONS/0${nb}_*/ ]
    then
        echo 0$nb
    elif [ -d $GASH_MISSIONS/00${nb}_*/ ]
    then
        echo 00$nb
    else
        echo ""
    fi
}

# get the mission directory
_get_mission_dir() {
    local nb=$1
    if [ -d $GASH_MISSIONS/${nb}_*/ ]
    then
        echo $GASH_MISSIONS/${nb}_*/
    fi
}



# display the goal of a mission given by its number
_gash_show() {
    local nb="$(_get_mission_nb $1)"
    if [ -z "$nb" ]
    then
        echo "Problème : mauvaise mission '$nb' (_gash_show)"
        return 1
    fi

    local mission="$(_get_mission_dir $nb)"

    if [ -f "$mission/goal.txt" ]
    then
        parchment "$mission/goal.txt"
    fi
}

# start a mission given by its number
_gash_start() {
    local nb D S
    if [ -z "$1" ]
    then
        nb=$(_get_current_mission)
    else
        nb=$1
    fi

    [ -z "$nb" ] && nb=1
    nb="$(_get_mission_nb $nb)"

    if [ -z "$nb" ]
    then
        echo "Problème : mauvaise mission '$nb' (_gash_start)"
        return 1
    fi

    local mission="$(_get_mission_dir $nb)"

    if [ -f "$mission/init.sh" ]
    then
        # compgen -v | sort > /tmp/v1
        source "$mission/init.sh"
        # compgen -v | sort > /tmp/v2
        # comm -13 /tmp/v1 /tmp/v2 > /tmp/missions_var_$nb
        # rm -f /tmp/v1 /tmp/v2
    fi

    log_action $nb "START"

    # history -s "# START mission $nb"

    # if [ -x "$(which ttyrec)" ]
    # then

    #     [ "$(ps -o comm='' $PPID)" = "ttyrec" ] && exit

    #     n=1
    #     while [ -f "$GASH_DATA/mission_${nb}_$n.script" ]
    #     do
    #         n=$(($n+1))
    #     done
    #     echo ttyrec -a -e "bash --rcfile \"$GASH_CONFIG/bashrc\"" "$GASH_DATA/mission_${nb}_$n.script"
    #     ttyrec -a -e "bash --rcfile \"$GASH_CONFIG/bashrc\"" "$GASH_DATA/mission_${nb}_$n.script"
    # fi
}

# restart a mission given by its number
_gash_restart() {
    local nb="$(_get_mission_nb $1)"
    if [ -z "$nb" ]
    then
        echo "Problème : mauvaise mission '$nb' (_gash_restart)"
        return 1
    fi

    local mission="$(_get_mission_dir $nb)"

    if [ -f "$mission/init.sh" ]
    then
        source "$mission/init.sh"
    fi

    log_action $nb "RESTART"

    # history -s "# RESTART mission $nb"

    # if [ -x "$(which ttyrec)" ]
    # then

    #     [ "$(ps -o comm='' $PPID)" = "ttyrec" ] && exit

    #     n=1
    #     while [ -f "$GASH_DATA/mission_${nb}_$n.script" ]
    #     do
    #         n=$(($n+1))
    #     done
    #     echo ttyrec -a -e "bash --rcfile \"$GASH_CONFIG/bashrc\"" "$GASH_DATA/mission_${nb}_$n.script"
    #     ttyrec -a -e "bash --rcfile \"$GASH_CONFIG/bashrc\"" "$GASH_DATA/mission_${nb}_$n.script"
    # fi
}

# stop a mission given by its number
_gash_pass() {
    local nb="$(_get_mission_nb $1)"
    if [ -z "$nb" ]
    then
        echo "Problème : mauvaise mission '$nb' (_gash_pass)"
        return 1
    fi

    log_action $nb "PASS"

    _gash_clean $nb
    color_echo yellow "Vous avez abandonné la mission $nb..."

    nb=$(_get_next_mission $nb)

    _gash_start "$nb"
    cat <<EOM
****************************************
*  Tapez la commande                   *
*    $ gash show                      *
*  pour découvrir l'objectif suivant.  *
****************************************
EOM
}

# check completion of a mission given by its number
_gash_check() {
    local nb=$1

    nb="$(_get_mission_nb $nb)"
    if [ -z "$nb" ]
    then
        echo "Problème : mauvaise mission '$nb' (_gash_check)"
        return 1
    fi

    local mission="$(_get_mission_dir "$nb")"

    if [ -f "$mission/check.sh" ]
    then
        check_prg="$mission/check.sh"
    else
        echo "Problème : je ne sais pas tester la mission '$nb'"
        return 1
    fi

    if grep -q "^$nb OK" "$GASH_DATA/missions.log"
    then
        echo
        color_echo yellow "La mission $nb a déjà été validée"
        echo
    else
        if source "$check_prg"
        then
            echo
            color_echo green "La mission $nb est validée"
            echo

            log_action $nb "CHECK_OK"

            _gash_clean $nb

            # récupération de la mission suivante
            nb=$(_get_next_mission $nb)

            if [ -f "$mission/treasure.sh" ]
            then
                [ -f "$mission/treasure.txt" ] && cat "$mission/treasure.txt"
                source "$mission/treasure.sh"
                cp "$mission/treasure.sh" "$GASH_CONFIG/$(basename $mission /).sh"
            fi
            _gash_start "$nb"
            cat <<EOM
****************************************
*  Tapez la commande                   *
*    $ gash show                       *
*  pour découvrir l'objectif suivant.  *
****************************************
EOM
        else
            echo
            color_echo red "La mission $nb n'est **pas** validée."
            echo

            log_action $nb "CHECK_OOPS"

            _gash_clean $nb
            _gash_restart "$nb"
        fi
    fi
}

_gash_clean() {
    local nb="$(_get_mission_nb $1)"
    if [ -z "$nb" ]
    then
        echo "Problème : mauvaise mission '$nb' (_gash_show)"
        return 1
    fi

    local mission="$(_get_mission_dir $nb)"

    if [ -f "$mission/clean.sh" ]
    then
        # echo "cleaning mission '$mission'"
        source "$mission/clean.sh"
    fi
}

_gash_help() {
    cat <<EOM
 __^__                                                          __^__
( ___ )--------------------------------------------------------( ___ )
 | / | Commandes propres a GameShell                            | \ |
 | / | =============================                            | \ |
 | / |                                                          | \ |
 | / |   gash check                                             | \ |
 | / |     vérifie que la mission en cours est terminée         | \ |
 | / |     Si c'est le cas, passe automatiquement à la mission  | \ |
 | / |     suivante.                                            | \ |
 | / |                                                          | \ |
 | / |   gash finish                                            | \ |
 | / |     génère le fichier à rendre à votre encadrant         | \ |
 | / |                                                          | \ |
 | / |   gash help                                              | \ |
 | / |     affiche ce message                                   | \ |
 | / |                                                          | \ |
 | / |   gash restart                                           | \ |
 | / |     ré-initialise la mission courante                    | \ |
 | / |                                                          | \ |
 | / |   gash save                                              | \ |
 | / |     génère un fichier pour pouvoir transférer une partie | \ |
 | / |                                                          | \ |
 | / |   gash show                                              | \ |
 | / |     affiche l'objectif de la mission en cours            | \ |
 |___|                                                          |___|
(_____)--------------------------------------------------------(_____)
EOM
}

_gash_finish() {
    if $(jobs | grep -iq stopped)
    then
        cat <<EOM
ATTENTION, vous avez des tâches en pause...
Ces processus vont être stoppés.
(Vous pouvez obtenir la liste de ces tâches avec
$ jobs -s
)
Êtes vous sûr de vouloir finir le TP ? [o/N]

EOM
        read r
        if [ "$r" != "o" -a "$r" != "O" ]
        then
            return
        fi
    fi

    log_action $nb "FINISH"

    nb_journals=$(find $GASH_HOME -iname "*journal*" | wc -l)
    if [ $nb_journals -gt 1 ]
    then
        cat <<EOM
******************************************************
******************************************************

ATTENTION  ATTENTION  ATTENTION  ATTENTION  ATTENTION

Votre session contient plusieurs fichiers "journal"

EOM
        find $GASH_HOME -iname "*journal*"
        cat <<EOM

Il faut supprimer les fichiers en trop et ne conserver
que le "vrai" journal...
EOM
        read -p "Souhaitez vous générer votre soumission quand même ? [o/N] " r
        if [ "$r" != "o"  -a  "$r" != "O" ]
        then
            cat <<EOM

Aucun fichier de soumissions n'a été créé...

ATTENTION  ATTENTION  ATTENTION  ATTENTION  ATTENTION

******************************************************
******************************************************
EOM
            return 1
        fi
    fi
    if [ $nb_journals -lt 1 ]
    then
        cat <<EOM
******************************************************
******************************************************

ATTENTION  ATTENTION  ATTENTION  ATTENTION  ATTENTION

Votre session ne contient pas de fichier "journal"

Si vous continuez, votre soumissions ne contiendra pas
de fichier "journal".
EOM
    read -p "Souhaitez vous générer votre soumission quand même ? [o/N] " r
    if [ "$r" != "o"  -a  "$r" != "O" ]
    then
            cat <<EOM

Aucun fichier de soumissions n'a été créé...

ATTENTION  ATTENTION  ATTENTION  ATTENTION  ATTENTION

******************************************************
******************************************************
EOM
        return 1
    fi
fi

    find $GASH_DATA -iname "*journal*" | xargs rm -f
    find $GASH_HOME -iname "*journal*" | xargs -I JOURNAL cp --backup=numbered JOURNAL $GASH_DATA

    tarfile=$REAL_HOME/info_202_$(whoami).tgz
    if $(tar caf $tarfile -C $GASH_BASE ${GASH_DATA#$GASH_BASE/})
    then
        cat <<EOM
++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++

Une archive contenant les fichiers à envoyer à votre
encadrant à été créée dans votre répertoire personnel.
Le fichier se trouve ici :

  $tarfile

++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++
EOM
        exit 0
    else
        cat <<EOM
******************************************************
******************************************************

ATTENTION  ATTENTION  ATTENTION  ATTENTION  ATTENTION

Un problème a été rencontré pendant la création de
l'archive contenant les fichiers à envoyer à votre
encadrant.

Si le fichier

  $tarfile

existe, vous pouvez vérifier son contenu. Il doit y
avoir les fichiers suivants :
  - .../passeport.txt
  - .../missions.log
  - .../uid
  - .../journal.txt
  - .../history
  - .../script              (facultatif)

Si tous ces fichiers existent, vous pouvez l'envoyer.
Sinon, demandez à votre encadrant de TP...

ATTENTION  ATTENTION  ATTENTION  ATTENTION  ATTENTION

******************************************************
******************************************************
EOM
    fi
}


_gash_save() {
    if $(jobs | grep -iq stopped)
    then
        cat <<EOM
ATTENTION, vous avez des tâches en pause...
Ces processus vont être stoppés.
(Vous pouvez obtenir la liste de ces tâches avec
$ jobs -s
)
Les changements non enregistrés ne seront pas sauvés
avec le TP.

Êtes vous sûr de vouloir sauver le TP ? [o/N]

EOM
        read r
        if [ "$r" != "o" -a "$r" != "O" ]
        then
            return
        fi
    fi

    log_action $nb "SAVE"

    tarfile=$REAL_HOME/info_202_$(whoami)-SAVE.tgz
    tar caf $tarfile -C $REAL_HOME ${GASH_BASE#$REAL_HOME/}
    cat <<EOM
******************************************************
******************************************************

Une archive contenant l'état du TP à été créée dans
votre répertoire personnel. Le fichier se trouve ici :

  $tarfile

Vous pouvez transférer ce fichier sur un autre
ordinateur, à la racine de votre répertoire personnel,
et rétablir votre sauvegarde avec la commande

  $ tar xvf $(basename $tarfile)

******************************************************
******************************************************
EOM
    exit 0
}



gash() {
    local cmd=$1
    if [ -z $cmd ]
    then
        cat <<EOH
gash <commande>
commandes possibles : check, finish, help, restart, show, stop
EOH
    fi

    local nb="$(_get_current_mission)"

    case $cmd in
        c | ch | che | chec | check)
            _gash_check $nb
            ;;
        h | he | hel | help)
            _gash_help
            ;;
        f | fi | fin | fini | finis | finish)
            _gash_finish
            ;;
        sa | sav | save)
            _gash_save
            ;;
        r | re | res | rest | resta | restar | restart)
            _gash_clean $nb
            _gash_restart $nb
            ;;
        sh | sho | show)
            _gash_show $nb
            ;;
        stat)
            awk -v GROUP_UID="$GROUP_UID" -f $GASH_BIN/stat.awk < $GASH_DATA/missions.log
            ;;
# admin stuff
        # TODO: something to regenerate static world
        pass)
            admin_mode
            if [ "$GASH_ADMIN" = "OK" ]
            then
                _gash_pass $nb
            else
                echo "oups..."
            fi
            ;;
        clean)
            admin_mode
            if [ "$GASH_ADMIN" = "OK" ]
            then
                _gash_clean $nb
            else
                echo "oups..."
            fi
            ;;
        start)
            admin_mode
            if [ "$GASH_ADMIN" = "OK" ]
            then
                if [ -n "$2" ]
                then
                    _gash_clean $nb
                    _gash_start $2
                else
                    echo "Il faut donner un numero de mission"
                fi
            else
                echo "oups..."
            fi
            ;;
        *)
            echo "commande inconnue: '$cmd'"
            return 1
            ;;
    esac
}

# vim: filetype=sh
