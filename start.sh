#!/bin/bash

# shellcheck disable=SC2005

# shellcheck source=./lib/os_aliases.sh
source gettext.sh

# shellcheck source=./lib/os_aliases.sh
export GASH_BASE="$(dirname "$0")"
export TEXTDOMAINDIR="$GASH_BASE/locale"
export TEXTDOMAIN="gash"

source "$GASH_BASE"/lib/os_aliases.sh
# we can now normalize GASH_BASE
export GASH_BASE=$(REALPATH "$(dirname "$0")"/)
export TEXTDOMAINDIR="$GASH_BASE/locale"
export TEXTDOMAIN="gash"

# generate GameShell translation files for gettext
for PO_FILE in "$GASH_BASE"/i18n/*.po; do
  PO_LANG=$(basename "$PO_FILE" .po)
  if ! [ -f "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" ]
  then
    mkdir -p "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES"
    msgfmt -o "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" "$PO_FILE"
  fi
done

source $GASH_BASE/lib/utils.sh
source $GASH_BASE/lib/make_index.sh

cd "$GASH_BASE"


display_help() {
  cat "$(eval_gettext "\$GASH_BASE/i18n/start-help/en.txt")"
}


export GASH_COLOR="OK"
GASH_MODE="ANONYMOUS"
RESET=""
FORCE="FALSE"
while getopts ":hcnPDACRFXv" opt
do
  case $opt in
    h)
      display_help
      exit 0
      ;;
    n)
      GASH_COLOR=""
      ;;
    c)
      GASH_COLOR="OK"
      ;;
    P)
      GASH_MODE="PASSPORT"
      ;;
    D)
      GASH_MODE="DEBUG"
      ;;
    v)
      export GASH_VERBOSE_SOURCE="true"
      ;;
    A)
      GASH_MODE="ANONYMOUS"
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
  local NB
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


init_gash() {

  # these directories should not be modified during a game
  export GASH_LIB="$GASH_BASE/lib"
  export GASH_MISSIONS="$GASH_BASE/missions"
  export GASH_BIN="$GASH_BASE/bin"

  # these directories should be erased when a new game is started, they only contain
  # dynamic data
  export GASH_HOME="$GASH_BASE/World"
  export GASH_DATA="$GASH_BASE/.session_data"
  export GASH_MISSION_DATA="$GASH_BASE/.mission_data"
  export GASH_CONFIG="$GASH_BASE/.config"
  export GASH_LOCAL_BIN="$GASH_BASE/.bin"

  ADMIN_HASH='b88968dc60b003b9c188cc503a457101b4087109'    # default for 'gsh'

  # message when a new game is started from the developpment directory
  if [ -e "$GASH_BASE/.git" ] && [ "$FORCE" != "TRUE" ]
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
  if [ -e "$GASH_DATA" ]
  then
    if [ -z "$RESET" ]
    then
      local r
      while true
      do
        read -erp "$(eval_gettext 'The directory $GASH_DATA contains meta-data from a previous game.
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
  rm -rf "$GASH_HOME"
  rm -rf "$GASH_DATA"
  rm -rf "$GASH_MISSION_DATA"
  rm -rf "$GASH_CONFIG"
  rm -rf "$GASH_LOCAL_BIN"

  # recreate them
  mkdir -p "$GASH_HOME"

  mkdir -p "$GASH_DATA"
  echo "# mission action date checksum" >> "$GASH_DATA/missions.log"

  mkdir -p "$GASH_CONFIG"
  cp "$GASH_LIB/bashrc" "$GASH_CONFIG"

  # save current locale
  locale | sed "s/^/export /" > "$GASH_CONFIG"/config.sh
  echo "export GASH_MODE=$GASH_MODE" >> "$GASH_CONFIG"/config.sh
  # TODO save other config (color ?)

  # save hash for admin password
  [ -n "$ADMIN_HASH" ] && echo "$ADMIN_HASH" > "$GASH_DATA/admin_hash"

  mkdir -p "$GASH_LOCAL_BIN"

  mkdir -p "$GASH_MISSION_DATA"


  # id of player
  PASSPORT="$GASH_DATA/passport.txt"

  while true
  do
    # Lecture du login des étudiants.
    case "$GASH_MODE" in
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

    # check information is correct
    _confirm_passport "$PASSPORT" && break
  done


  # Génération de l'UID du groupe.
  export GASH_UID="$(sha1sum "$PASSPORT" | cut -c 1-40)"
  echo "GASH_UID=$GASH_UID" >> "$PASSPORT"
  echo "$GASH_UID" > "$GASH_DATA/uid"


  # Message d'accueil.
  [ "$GASH_MODE" = "DEBUG" ] || clear
  echo "$(gettext "======== Initialisation of GameShell ========")"

  make_index "$@" 2> /dev/null | sed "s;$GASH_MISSIONS;.;" > "$GASH_DATA/index.txt"

  # Installing all missions.
  local MISSION_NB=1
  while read MISSION_DIR
  do
    case $MISSION_DIR in
      "" | "#"* )
        continue
        ;;
      "!"*)
        MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
        ;;
    esac
    export MISSION_DIR
    MISSION_DIR=$GASH_MISSIONS/$MISSION_DIR

    # To be used as TEXTDOMAIN environment variable for the mission.
    export DOMAIN=$(basename "$MISSION_DIR")

    # Preparing the locales
    if [ -d "$MISSION_DIR/i18n" ]
    then
      shopt -s nullglob
      for PO_FILE in "$MISSION_DIR"/i18n/*.po; do
        PO_LANG=$(basename "$PO_FILE" .po)
        if ! [ -f "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" ]
        then
          mkdir -p "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES"
          msgfmt -o "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" "$PO_FILE"
        fi
      done
      shopt -u nullglob
    fi

    # Setting up the binaries
    if [ -d "$MISSION_DIR/bin" ]
    then
      shopt -s nullglob
      for BIN_FILE in "$MISSION_DIR"/bin/*; do
        BIN_NAME=$(basename "$BIN_FILE")
        cat > "$GASH_LOCAL_BIN/$BIN_NAME" <<EOH
#!/bin/bash
export MISSION_DIR="$MISSION_DIR"
export TEXTDOMAIN="$DOMAIN"
exec $BIN_FILE "\$@"
EOH
        chmod +x "$GASH_LOCAL_BIN/$BIN_NAME"
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
      cp "$MISSION_DIR/bashrc" "$GASH_CONFIG/$(basename "$MISSION_DIR" /).bashrc.sh"
    fi
    printf "."
    MISSION_NB=$((MISSION_NB+1))
  done < "$GASH_DATA/index.txt"
  if [ "$MISSION_NB" -eq 0 ]
  then
    echo "$(gettext "Error: no mission was found!
Aborting")"
    exit 1
  fi
  echo
  unset MISSION_DIR MISSION_NB
}


start_gash() {
  # Lancement du jeu.
  cd "$GASH_HOME"
  export GASH_UID=$(cat "$GASH_DATA/uid")
  bash --rcfile "$GASH_LIB/bashrc"
}


#######################################################################
init_gash "$@"
start_gash

# vim: shiftwidth=2 tabstop=2 softtabstop=2
