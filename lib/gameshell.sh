#!/usr/bin/bash

# shellcheck disable=SC2005

# shellcheck source=/dev/null
source gettext.sh

# shellcheck source=./lib/utils.sh
source "$GASH_LIB/utils.sh"

trap "_gash_exit EXIT" EXIT
trap "_gash_exit TERM" SIGTERM
# trap "_gash_exit INT" SIGINT


# log an action to the missions.log file
_log_action() {
  local nb action
  nb=$1
  action=$2
  D="$(date +%s)"
  S="$(checksum "$GASH_UID#$nb#$action#$D")"
  echo "$nb $action $D $S" >> "$GASH_DATA/missions.log"
}


# get the last started mission
_get_current_mission() {
  awk '/^#/ {next}   $2=="START" {m=$1}  END {print (m)}' "$GASH_DATA/missions.log"
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
  echo "$nb"
}


# get the complete mission number by appending leading '0's
_get_mission_nb() {
  local nb=000000$1
  while [ -n "$nb" ]
  do
    # hackish, but faster than using find
    # shellcheck disable=SC2144
    [ -d "$GASH_MISSIONS"/"${nb}"_* ] && break
    nb="${nb:1}"
  done
  if [ -n "$nb" ]
  then
    echo "$nb"
    return 0
  else
    return 1
  fi
}


# get the mission directory
_get_mission_dir() {
  local nb=$1
  # shellcheck disable=SC2144
  [ -d "$GASH_MISSIONS"/"${nb}"_* ] && echo "$GASH_MISSIONS"/"${nb}"_*
}

# reset the bash configuration
_gash_reset() {
  if [ "$BASHPID" != $$ ]
  then
    echo "$(gettext "The command 'gash reset' is useless when run inside a subshell!")" >&2
    return 1
  fi
  # on relance bash, histoire de recharcher la config
  exec bash --rcfile "$GASH_LIB/bashrc"
}


# called when gash exits
_gash_exit() {
  local nb=$(_get_current_mission)
  local signal=$1
  _log_action "$nb" "$signal"
  _gash_clean "$nb"
  # jobs -p | xargs kill -sSIGHUP     # ??? est-ce qu'il faut le garder ???
}


# display the goal of a mission given by its number
_gash_show() {
  local nb="$(_get_mission_nb "$1")"
  if [ -z "$nb" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$nb' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$nb")"

  if [ -f "$MISSION_DIR/goal.txt" ]
  then
    parchment "$MISSION_DIR/goal.txt"
  elif [ -f "$MISSION_DIR/goal.sh" ]
  then
    export TEXTDOMAIN="$(basename "$MISSION_DIR")"
    parchment <(source "$MISSION_DIR/goal.sh")
    export TEXTDOMAIN="gash"
  else
    export TEXTDOMAIN="$(basename "$MISSION_DIR")"
    parchment "$(echo "$(eval_gettext '$MISSION_DIR/goal/en.txt')")"
    export TEXTDOMAIN="gash"
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
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$nb' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$nb")"

  ### tester le fichier deps.sh
  if [ -f "$MISSION_DIR/deps.sh" ]
  then
    if ! bash "$MISSION_DIR/deps.sh"
    then
      echo "$(gettext "The mission is cancelled because some dependencies are not met.")" >&2
      _log_action "$nb" "CANCEL_DEP_PB"
      _gash_start "$((nb + 1))"
      return
    fi
  fi

  if [ -f "$MISSION_DIR/init.sh" ]
  then
    # attention, si l'initialisation a lieu dans un sous-shell et qu'elle
    # définit des variables d'environnement, elles ne seront pas définies dans
    # la session bash.
    # je sauvegarde l'environnement avant / après l'initialisation pour
    # afficher un message dans ce cas
    [ "$BASHPID" = $$ ] || compgen -v | sort > "$GASH_TMP"/env-before
    export TEXTDOMAIN="$(basename "$MISSION_DIR")"
    source "$MISSION_DIR/init.sh"
    export TEXTDOMAIN="gash"
    [ "$BASHPID" = $$ ] || compgen -v | sort > "$GASH_TMP"/env-after

    if [ "$BASHPID" != $$ ]
    then
      if ! cmp --quiet "$GASH_TMP"/env-before "$GASH_TMP"/env-after
      then
        echo "$(gettext "NOTE: this mission was initialized in a sub-shell.
You should run the command
    gash reset
to make sure the mission is initialized properly.")" >&2
        rm -f "$GASH_TMP"/env-{before,after}
      fi
    fi
  fi

  _log_action "$nb" "START"

  if [ -f "$MISSION_DIR/init.sh" ]
  then
    export TEXTDOMAIN="$(basename "$MISSION_DIR")"
    source "$MISSION_DIR/init.sh"
    export TEXTDOMAIN="gash"
  fi

  if [ "$nb" -eq 1 ]
  then
    parchment "$(echo "$(gettext "gameshell-init-msg")" | envsubst)" Inverted
  else
    parchment "$(echo "$(gettext "gameshell-init-msg-short")" | envsubst)" Inverted
  fi
}

# stop a mission given by its number
_gash_pass() {
  local nb="$(_get_current_mission)"
  if [ -z "$nb" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$nb' (\$fn_name)")" >&2
    return 1
  fi
  admin_mode
  if [ "$GASH_ADMIN" != "OK" ]
  then
    echo "$(gettext "wrong password")" >&2
    return 1
  fi
  _log_action "$nb" "PASS"
  _gash_clean "$nb"
  color_echo yellow "$(eval_gettext 'Mission $nb has been cancelled.')" >&2

  nb=$(_get_next_mission "$nb")
  _gash_start "$nb"
}

# applies auto.sh script, if it exists
_gash_auto() {
  local nb=$1

  nb="$(_get_mission_nb "$nb")"
  if [ -z "$nb" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$nb' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$nb")"

  if ! [ -f "$MISSION_DIR/auto.sh" ]
  then
    echo "$(eval_gettext "Mission \$nb doesn't have an auto script.")" >&2
    return 1
  fi

  admin_mode
  if [ "$GASH_ADMIN" != "OK" ]
  then
    echo "$(gettext "wrong password")" >&2
    return 1
  fi

  export TEXTDOMAIN="$(basename "$MISSION_DIR")"
  source "$MISSION_DIR/auto.sh"
  export TEXTDOMAIN="gash"
  _log_action "$nb" "AUTO"
  return 0
}


# check completion of a mission given by its number
_gash_check() {
  local nb=$1

  nb="$(_get_mission_nb "$nb")"
  if [ -z "$nb" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$nb' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$nb")"

  if [ -f "$MISSION_DIR/check.sh" ]
  then
    check_prg="$MISSION_DIR/check.sh"
  else
    echo "$(eval_gettext "Error: mission \$nb doesn't have a check script.")" >&2
    return 1
  fi

  if grep -q "^$nb OK" "$GASH_DATA/missions.log"
  then
    echo
    color_echo yellow "$(eval_gettext "Mission \$nb has already been succesfully checked!")"
    echo
  else
    export TEXTDOMAIN="$(basename "$MISSION_DIR")"
    source "$check_prg"
    local exit_status=$?
    export TEXTDOMAIN="gash"
    unset -f check
    # compare environment before / after?

    if [ "$exit_status" -eq 0 ]
    then
      echo
      color_echo green "$(eval_gettext 'Mission $nb has been successfully completed!')"
      echo

      _log_action "$nb" "CHECK_OK"

      _gash_clean "$nb"

      # récupération de la mission suivante
      nb=$(_get_next_mission "$nb")

      if [ -f "$MISSION_DIR/treasure.sh" ]
      then
        # Record the treasure to be loaded by GameShell's bashrc.
        cp "$MISSION_DIR/treasure.sh" "$GASH_CONFIG/$(basename "$MISSION_DIR" /)-treasure.sh"

        # Display the text message (if it exists).
        if [ -f "$MISSION_DIR/treasure.txt" ]
        then
          cat "$MISSION_DIR/treasure.txt"
        fi

        # Run the treasure message script (if it exists).
        if [ -f "$MISSION_DIR/treasure-msg.sh" ]
        then
          export TEXTDOMAIN="$(basename "$MISSION_DIR")"
          source "$MISSION_DIR/treasure-msg.sh"
          export TEXTDOMAIN="gash"
        fi

        # Load the treasure in the current shell.
        export TEXTDOMAIN="$(basename "$MISSION_DIR")"
        source "$MISSION_DIR/treasure.sh"
        export TEXTDOMAIN="gash"

        #sourcing the file isn't very robust as the "gash check" may happen in a subshell!
        if [ "$BASHPID" != $$ ]
        then
          echo "$(gettext "Note: the file 'treasure.sh' was sourced from a subshell.
You are advised to use the command
    $ gash reset")"
        fi
      fi
      _gash_start "$nb"
    else
      echo
      color_echo red "$(eval_gettext "Mission \$nb hasn't been completed.")"
      echo

      _log_action "$nb" "CHECK_OOPS"

      _gash_clean "$nb"
      _gash_reset
    fi
  fi
}

_gash_clean() {
  local nb="$(_get_mission_nb "$1")"
  if [ -z "$nb" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$nb' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$nb")"

  if [ -f "$MISSION_DIR/clean.sh" ]
  then
    export TEXTDOMAIN="$(basename "$MISSION_DIR")"
    source "$MISSION_DIR/clean.sh"
    export TEXTDOMAIN="gash"
  fi
}

_gash_help() {
  parchment "$GASH_LIB"/help.txt
}

_gash_HELP() {
  parchment "$GASH_LIB"/HELP.txt
}


_gash_save() {
  if jobs | grep -iq stopped
  then
    cat <<EOM
ATTENTION, vous avez des tâches en pause...
Ces processus vont être stoppés.
(Vous pouvez obtenir la liste de ces tâches avec
$ jobs -s
)
Les changements non enregistrés ne seront pas sauvés.

Êtes-vous sûr de vouloir sauver ? [o/N]

EOM
    read -er r
    if [ "$r" != "o" ] &&  [ "$r" != "O" ]
    then
      return
    fi
  fi

  _log_action "$nb" "SAVE"

  tarfile=$REAL_HOME/GameShell_$(whoami)-SAVE.tgz
  tar -zcf "$tarfile" --exclude=".git*" -C "$GASH_BASE/.." "$(basename "$GASH_BASE")"
  cat <<EOM
******************************************************
******************************************************

Une archive contenant l'état courant a été créée dans
votre répertoire personnel. Le fichier se trouve ici :

$tarfile

Vous pouvez transférer ce fichier sur un autre
ordinateur, à la racine de votre répertoire personnel,
et rétablir votre sauvegarde avec la commande

$ tar -zxvf $(basename "$tarfile")

******************************************************
******************************************************
EOM
  exit 0
}



gash() {
  local cmd=$1
  if [ -z "$cmd" ]
  then
    cat <<EOH
gash <commande>
commandes possibles : help, show, check, reset, save
EOH
  fi

  local nb="$(_get_current_mission)"

  case $cmd in
    "c" | "ch" | "che" | "chec" | "check")
      _gash_check "$nb"
      ;;
    "h" | "he" | "hel" | "help")
      _gash_help
      ;;
    "H" | "HE" | "HEL" | "HELP")
      _gash_HELP
      ;;
    "r" | "re" | "res" | "rese" | "reset")
      _gash_clean "$nb"
      _gash_reset
      ;;
    "sa" | "sav" | "save")
      _gash_save
      ;;
    "sh" | "sho" | "show")
      _gash_clean "$nb"
      _gash_show "$nb"
      ;;
    "stat")
      awk -v GASH_UID="$GASH_UID" -f "$GASH_BIN/stat.awk" < "$GASH_DATA/missions.log"
      ;;
    "exit")
      exit 0
      ;;

    # admin stuff
    # TODO: something to regenerate static world
    "pass")
        _gash_pass
      ;;
    "auto")
      _gash_auto "$nb"
      ;;
    "clean")
      admin_mode
      if [ "$GASH_ADMIN" = "OK" ]
      then
        _gash_clean "$nb"
      else
        echo "$(gettext "wrong password")" >&2
      fi
      ;;
    "goto")
      if [ -z "$2" ]
      then
        echo "$(gettext "command 'goto' requires a mission number as argument")" >&2
        return 1
      fi

      admin_mode
      if [ "$GASH_ADMIN" != "OK" ]
      then
        echo "$(gettext "wrong password")" >&2
        return 1
      fi

      _gash_clean "$nb"
      _gash_start "$2"
      ;;
    *)
      echo "$(eval_gettext "unkwnown command: \$cmd")" >&2
      return 1
      ;;
  esac
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
