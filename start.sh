#!/bin/bash

# shellcheck disable=SC2005

# shellcheck source=./lib/os_aliases.sh
source gettext.sh

# shellcheck source=./lib/os_aliases.sh
export GSH_BASE="$(dirname "$0")"
export TEXTDOMAINDIR="$GSH_BASE/locale"
export TEXTDOMAIN="gsh"

source "$GSH_BASE"/lib/os_aliases.sh
# we can now normalize GSH_BASE
export GSH_BASE=$(REALPATH "$(dirname "$0")"/)
export TEXTDOMAINDIR="$GSH_BASE/locale"
export TEXTDOMAIN="gsh"

# generate GameShell translation files for gettext
for PO_FILE in "$GSH_BASE"/i18n/*.po; do
  PO_LANG=$(basename "$PO_FILE" .po)
  if ! [ -f "$GSH_BASE/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" ]
  then
    mkdir -p "$GSH_BASE/locale/$PO_LANG/LC_MESSAGES"
    msgfmt -o "$GSH_BASE/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" "$PO_FILE"
  fi
done

source $GSH_BASE/lib/utils.sh
source $GSH_BASE/lib/make_index.sh

cd "$GSH_BASE"


display_help() {
  cat "$(eval_gettext "\$GSH_BASE/i18n/start-help/en.txt")"
}


export GSH_COLOR="OK"
GSH_MODE="ANONYMOUS"
RESET=""
FORCE="FALSE"
while getopts ":hcnPDACRFXvL:" opt
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


init_gsh() {

  # these directories should not be modified during a game
  export GSH_LIB="$GSH_BASE/lib"
  export GSH_MISSIONS="$GSH_BASE/missions"
  export GSH_BIN="$GSH_BASE/bin"

  # these directories should be erased when a new game is started, they only contain
  # dynamic data
  export GSH_HOME="$GSH_BASE/World"
  export GSH_DATA="$GSH_BASE/.session_data"
  export GSH_MISSION_DATA="$GSH_BASE/.mission_data"
  export GSH_CONFIG="$GSH_BASE/.config"
  export GSH_LOCAL_BIN="$GSH_BASE/.bin"

  ADMIN_HASH='b88968dc60b003b9c188cc503a457101b4087109'    # default for 'gsh'

  # message when a new game is started from the developpment directory
  if [ -e "$GSH_BASE/.git" ] && [ "$FORCE" != "TRUE" ]
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
  if [ -e "$GSH_DATA" ]
  then
    if [ -z "$RESET" ]
    then
      local r
      while true
      do
        read -erp "$(eval_gettext 'The directory $GSH_DATA contains meta-data from a previous game.
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
  rm -rf "$GSH_DATA"
  rm -rf "$GSH_MISSION_DATA"
  rm -rf "$GSH_CONFIG"
  rm -rf "$GSH_LOCAL_BIN"

  # recreate them
  mkdir -p "$GSH_HOME"

  mkdir -p "$GSH_DATA"
  echo "# mission action date checksum" >> "$GSH_DATA/missions.log"

  mkdir -p "$GSH_CONFIG"
  cp "$GSH_LIB/bashrc" "$GSH_CONFIG"

  # save current locale
  locale | sed "s/^/export /" > "$GSH_CONFIG"/config.sh
  echo "export GSH_MODE=$GSH_MODE" >> "$GSH_CONFIG"/config.sh
  # TODO save other config (color ?)

  # save hash for admin password
  [ -n "$ADMIN_HASH" ] && echo "$ADMIN_HASH" > "$GSH_DATA/admin_hash"

  mkdir -p "$GSH_LOCAL_BIN"

  mkdir -p "$GSH_MISSION_DATA"


  # id of player
  PASSPORT="$GSH_DATA/passport.txt"

  while true
  do
    # Lecture du login des étudiants.
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

    # check information is correct
    _confirm_passport "$PASSPORT" && break
  done


  # Génération de l'UID du groupe.
  export GSH_UID="$(sha1sum "$PASSPORT" | cut -c 1-40)"
  echo "GSH_UID=$GSH_UID" >> "$PASSPORT"
  echo "$GSH_UID" > "$GSH_DATA/uid"


  # Message d'accueil.
  [ "$GSH_MODE" = "DEBUG" ] || clear
  echo "$(gettext "======== Initialisation of GameShell ========")"

  make_index "$@" 2> /dev/null | sed "s;$GSH_MISSIONS;.;" > "$GSH_DATA/index.txt"

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
    MISSION_DIR=$GSH_MISSIONS/$MISSION_DIR

    # To be used as TEXTDOMAIN environment variable for the mission.
    export DOMAIN=$(basename "$MISSION_DIR")

    # Preparing the locales
    if [ -d "$MISSION_DIR/i18n" ]
    then
      shopt -s nullglob
      for PO_FILE in "$MISSION_DIR"/i18n/*.po; do
        PO_LANG=$(basename "$PO_FILE" .po)
        if ! [ -f "$GSH_BASE/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" ]
        then
          mkdir -p "$GSH_BASE/locale/$PO_LANG/LC_MESSAGES"
          msgfmt -o "$GSH_BASE/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" "$PO_FILE"
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
        cat > "$GSH_LOCAL_BIN/$BIN_NAME" <<EOH
#!/bin/bash
export MISSION_DIR="$MISSION_DIR"
export TEXTDOMAIN="$DOMAIN"
exec $BIN_FILE "\$@"
EOH
        chmod +x "$GSH_LOCAL_BIN/$BIN_NAME"
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
      cp "$MISSION_DIR/bashrc" "$GSH_CONFIG/$(basename "$MISSION_DIR" /).bashrc.sh"
    fi
    printf "."
    MISSION_NB=$((MISSION_NB+1))
  done < "$GSH_DATA/index.txt"
  if [ "$MISSION_NB" -eq 0 ]
  then
    echo "$(gettext "Error: no mission was found!
Aborting")"
    exit 1
  fi
  echo
  unset MISSION_DIR MISSION_NB
}


start_gsh() {
  # Lancement du jeu.
  cd "$GSH_HOME"
  export GSH_UID=$(cat "$GSH_DATA/uid")
  bash --rcfile "$GSH_LIB/bashrc"
}


#######################################################################
init_gsh "$@"
start_gsh

# vim: shiftwidth=2 tabstop=2 softtabstop=2
