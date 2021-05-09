#!/bin/bash

# shellcheck disable=SC2005

source gettext.sh

export GSH_ROOT="$(dirname "$0")"
source "$GSH_ROOT"/lib/common.sh

cd "$GSH_ROOT"


display_help() {
  cat "$(eval_gettext "\$GSH_ROOT/i18n/start-help/en.txt")"
}


export GSH_COLOR="OK"
GSH_MODE="ANONYMOUS"
RESET=""
FORCE="FALSE"
while getopts ":hcnPDACRFXvqL:" opt
do
  case $opt in
    h)
      display_help
      exit 0
      ;;
    n)
      GSH_COLOR=""
      ;;
    c)
      GSH_COLOR="OK"
      ;;
    P)
      GSH_MODE="PASSPORT"
      ;;
    D)
      GSH_MODE="DEBUG"
      ;;
    v)
      export GSH_VERBOSE_SOURCE="true"
      ;;
    q)
      export GSH_QUIET_INTRO="true"
      ;;
    A)
      GSH_MODE="ANONYMOUS"
      ;;
    C)
      RESET="FALSE"
      ;;
    R)
      RESET="TRUE"
      ;;
    F)
      FORCE="TRUE"
      ;;
    L)
      LANGUAGE=$OPTARG
      ;;
    X)
      echo "$(gettext "Error: this option is only available from an executable archive!")" >&2
      exit 1
      ;;
    *)
      echo "$(eval_gettext "Error: invalid option: '-\$OPTARG'")" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))


_passport() {
  local PASSPORT=$1
  NOM=""
  while [ -z "$NOM" ]
  do
    read -erp "$(gettext "Player's name:") " NOM
  done
  EMAIL=""
  while [ -z "$EMAIL" ]
  do
    read -erp "$(gettext "Player's email:") " EMAIL
  done
  echo "  $NOM <$EMAIL>" >> "$PASSPORT"
}

_confirm_passport() {
  local PASSPORT=$1
  echo "======================================================="
  cat "$PASSPORT"
  echo "======================================================="
  while true
  do
    read -erp "$(gettext "Is this information correct? [Y/n]") " OK
    echo
    if [ -z "$OK" ] || [ "$OK" = "$(gettext "y")" ] || [ "$OK" = "$(gettext "Y")" ]
    then
      return 0
    elif [ "$OK" = "$(gettext "n")" ] || [ "$OK" = "$(gettext "N")" ]
    then
      return 1
    fi
  done
}


init_gsh() {

  # these directories should not be modified during a game
  export GSH_LIB="$GSH_ROOT/lib"
  export GSH_MISSIONS="$GSH_ROOT/missions"
  export GSH_BIN="$GSH_ROOT/bin"

  # these directories should be erased when a new game is started, they only contain
  # dynamic data
  export GSH_HOME="$GSH_ROOT/World"
  export GSH_CONFIG="$GSH_ROOT/.config"
  export GSH_VAR="$GSH_ROOT/.var"
  export GSH_BASHRC="$GSH_ROOT/.bashrc"
  export GSH_MISSIONS_BIN="$GSH_ROOT/.bin"

  ADMIN_HASH='b88968dc60b003b9c188cc503a457101b4087109'    # default for 'gsh'

  # message when a new game is started from the developpment directory
  if [ -e "$GSH_ROOT/.git" ] && [ "$FORCE" != "TRUE" ]
  then
    local r
    while true
    do
      read -erp "$(gettext "You are trying to run GameShell inside the developpment directory.
Do you want to continue? [y/N]") " r
      if [ -z "$r" ] || [ "$r" = "$(gettext "n")" ] || [ "$r" = "$(gettext "N")" ]
      then
        exit 1
      elif [ "$r" = "$(gettext "y")" ] || [ "$r" = "$(gettext "Y")" ]
      then
        break
      fi
    done
  fi

  # message when data from a previous play is found. We can either
  #    - restart a new game
  #    - continue the previous game
  if [ -e "$GSH_CONFIG" ]
  then
    if [ -z "$RESET" ]
    then
      local r
      while true
      do
        read -erp "$(eval_gettext 'The directory $GSH_CONFIG contains meta-data from a previous game.
Do you want to remove it and start a new game? [y/N]') " r
        if [ -z "$r" ] || [ "$r" = "$(gettext "n")" ] || [ "$r" = "$(gettext "N")" ]
        then
          return 1
        elif [ "$r" = "$(gettext "y")" ] || [ "$r" = "$(gettext "Y")" ]
        then
          break
        fi
      done
    elif [ "$RESET" = "FALSE" ]
    then
      return 1
    fi
  fi

  ### if we're here, we need to reset a new game

  # remove all the game data
  rm -rf "$GSH_HOME"
  rm -rf "$GSH_CONFIG"
  rm -rf "$GSH_VAR"
  rm -rf "$GSH_BASHRC"
  rm -rf "$GSH_MISSIONS_BIN"

  # recreate them
  mkdir -p "$GSH_HOME"

  mkdir -p "$GSH_CONFIG"
  echo "# mission action date checksum" >> "$GSH_CONFIG/missions.log"

  mkdir -p "$GSH_BASHRC"
  cp "$GSH_LIB/bashrc" "$GSH_BASHRC"

  # save current locale
  locale | sed "s/^/export /" > "$GSH_BASHRC"/config.sh
  echo "export GSH_MODE=$GSH_MODE" >> "$GSH_BASHRC"/config.sh
  # TODO save other config (color ?)

  # save hash for admin password
  [ -n "$ADMIN_HASH" ] && echo "$ADMIN_HASH" > "$GSH_CONFIG/admin_hash"

  mkdir -p "$GSH_MISSIONS_BIN"

  mkdir -p "$GSH_VAR"


  # id of player
  PASSPORT="$GSH_CONFIG/passport.txt"

  while true
  do
    # Reading the player name (if in passport mode).
    case "$GSH_MODE" in
      DEBUG)
        echo "DEBUG MODE" >> "$PASSPORT"
        break
        ;;
      ANONYMOUS)
        echo "ANONYMOUS MODE" >> "$PASSPORT"
        break
        ;;
      PASSPORT)
        _passport "$PASSPORT"
        ;;
      *)
        echo "$(eval_gettext "Error: unknown mode '\$MODE'.")" >&2
        ;;
    esac

    # Check that the information is correct.
    _confirm_passport "$PASSPORT" && break
  done


  # Generation of a unique identifier for the the player.
  export GSH_UID="$(sha1sum "$PASSPORT" | cut -c 1-40)"
  echo "GSH_UID=$GSH_UID" >> "$PASSPORT"
  echo "$GSH_UID" > "$GSH_CONFIG/uid"


  # Clear the screen.
  [ "$GSH_MODE" = "DEBUG" ] || clear

  [ "$GSH_MODE" = "DEBUG" ] && printf "Mission initialisation: "

  make_index "$@" 2> /dev/null | sed "s;$GSH_MISSIONS;.;" > "$GSH_CONFIG/index.txt"

  # Installing all missions.
  local MISSION_NB=1      # current mission number
  local MISSION_SUB_NB="" # when a dummy mission is found, as a "sub-number" as well
  local FULL_NB           # the 2 together
  while read MISSION_DIR
  do
    case $MISSION_DIR in
      "" | "#"* )
        continue
        ;;
      "!"*)
        MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
        if [ -z "$MISSION_SUB_NB" ]
        then
          MISSION_SUB_NB=1
        else
          MISSION_SUB_NB=$((MISSION_SUB_NB + 1))
        fi
        ;;
      *)
          MISSION_SUB_NB=""
        ;;
    esac
    FULL_NB=$(printf "%04d" $MISSION_NB)
    [ -n "$MISSION_SUB_NB" ] && FULL_NB="$FULL_NB-$(printf "%04d" "$MISSION_SUB_NB")"

    export MISSION_DIR
    MISSION_DIR=$GSH_MISSIONS/$MISSION_DIR

    # To be used as TEXTDOMAIN environment variable for the mission.
    export DOMAIN=$(textdomainname "$MISSION_DIR")

    # Preparing the locales
    if [ -d "$MISSION_DIR/i18n" ]
    then
      shopt -s nullglob
      for PO_FILE in "$MISSION_DIR"/i18n/*.po; do
        PO_LANG=$(basename "$PO_FILE" .po)
        if ! [ -f "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" ]
        then
          mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
          msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" "$PO_FILE"
        fi
      done
      shopt -u nullglob
    fi

    # Setting up the binaries
    if [ -d "$MISSION_DIR/bin" ]
    then
      shopt -s nullglob
      for BIN_FILE in "$MISSION_DIR"/bin/*; do
        if ! [ -f "$BIN_FILE" ] || ! [ -x "$BIN_FILE" ]
        then
          continue
        fi
        BIN_NAME=$(basename "$BIN_FILE")
        cat > "$GSH_MISSIONS_BIN/$BIN_NAME" <<EOH
#!/bin/bash
export MISSION_DIR=$MISSION_DIR
export TEXTDOMAIN=$DOMAIN
exec $BIN_FILE "\$@"
EOH
        chmod +x "$GSH_MISSIONS_BIN/$BIN_NAME"
        unset BIN_NAME
      done
      shopt -u nullglob
    fi

    # source the static part of the mission
    if [ -f "$MISSION_DIR/static.sh" ]
    then
      mission_source "$MISSION_DIR/static.sh"
    fi

    # copy all the shell config files of the mission
    if [ -f "$MISSION_DIR/bashrc" ]
    then
      FILENAME=$GSH_BASHRC/bashrc_${FULL_NB}_$(basename "$MISSION_DIR").sh
      echo "export TEXTDOMAIN=$DOMAIN" > "$FILENAME"
      cat "$MISSION_DIR/bashrc" >> $FILENAME
      echo "export TEXTDOMAIN=gsh" >> "$FILENAME"
      unset FILENAME
    fi

    [ "$GSH_MODE" = "DEBUG" ] && printf "."

    [ -z "$MISSION_SUB_NB" ] && MISSION_NB=$((MISSION_NB+1))

  done < "$GSH_CONFIG/index.txt"
  if [ "$MISSION_NB" -eq 1 ]
  then
    echo "$(gettext "Error: no mission was found!
Aborting")"
    exit 1
  fi
  [ "$GSH_MODE" = "DEBUG" ] && echo " [DONE]"
  unset MISSION_DIR MISSION_NB
}


start_gsh() {
  # Starting the game.
  cd "$GSH_HOME"
  export GSH_UID=$(cat "$GSH_CONFIG/uid")
  bash --rcfile "$GSH_LIB/bashrc"
}


#######################################################################
init_gsh "$@"
start_gsh

# vim: shiftwidth=2 tabstop=2 softtabstop=2
