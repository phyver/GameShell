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
export GASH_BASE=$(CANONICAL_PATH "$(dirname "$0")"/)
export TEXTDOMAINDIR="$GASH_BASE/locale"
export TEXTDOMAIN="gash"

for PO_FILE in "$GASH_BASE"/i18n/*.po; do
  PO_LANG=$(basename "$PO_FILE" .po)
  mkdir -p "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES"
  msgfmt -o "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" "$PO_FILE"
done

source $GASH_BASE/lib/utils.sh

cd "$GASH_BASE"

display_help() {
  cat "$(eval_gettext "\$GASH_BASE/i18n/start-help/en.txt")"
}


export GASH_COLOR="OK"
export GASH_DEBUG_MISSION=""
MODE="DEBUG"
RESET=""
FORCE="FALSE"
while getopts ":hcnPD:CRF" opt
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
      MODE="PASSPORT"
      ;;
    D)
      MODE="DEBUG"
      GASH_DEBUG_MISSION=$OPTARG
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
    *)
      echo "$(eval_gettext "invalid option: '-\$OPTARG'")" >&2
      exit 1
      ;;
  esac
done


local_passport() {
  local PASSPORT=$1
  local NB
  while true
  do
    read -erp "Combien de membres dans le groupe ? (1) " NB
    case "$NB" in
      "" )          NB=1; break             ;;
      *[!0-9]* )    echo $(gettext "invalid number") ;;
      *[1-9]*)      break                   ;;
      *)            echo $(gettext "invalid number")  ;;
    esac
  done
  for I in $(seq "$NB"); do
    NOM=""
    while [ -z "$NOM" ]
    do
      read -erp "Membre $I, nom complet : " NOM
    done
    EMAIL=""
    while [ -z "$EMAIL" ]
    do
      read -erp "Membre $I, email : " EMAIL
    done
    echo "  $NOM <$EMAIL>" >> "$PASSPORT"
  done
}

confirm_passport() {
  local PASSPORT=$1
  echo "======================================================="
  cat "$PASSPORT"
  echo "======================================================="
  color_echo yellow $(gettext "You won't be able to change this information.")
  read -erp "$(gettext "Is this information correct? [Y/n] ")" OK
  echo
  [ "$OK" = "" ] || [ "$OK" = $(gettext "y") ] || [ "$OK" = $(gettext "Y") ]
}


init_gash() {
  # dossiers d'installation

  # ces répertoires ne doivent pas être modifiés (statiques)
  export GASH_LIB="$GASH_BASE/lib"
  export GASH_MISSIONS="$GASH_BASE/missions"
  export GASH_BIN="$GASH_BASE/bin"

  # ces répertoires doivent être effacés en cas de réinitialisation du jeu
  export GASH_HOME="$GASH_BASE/World"
  export GASH_DATA="$GASH_BASE/.session_data"
  export GASH_TMP="$GASH_BASE/.tmp"
  export GASH_CONFIG="$GASH_BASE/.config"
  export GASH_LOCAL_BIN="$GASH_BASE/.bin"

  if [ -e "$GASH_BASE/.git" ] && [ "$FORCE" != "TRUE" ]
  then
    read -erp "$(gettext "You are trying to run GameShell inside the developpment directory.
Do you want to continue? [y/N] ")" x
    [ "$x" != "$(gettext "y")" ] && [ "$x" != "$(gettext "Y")" ] && exit 1
  fi

  if [ -e "$GASH_DATA" ]
  then
    if [ -z "$RESET" ]
    then
      read -erp "$(eval_gettext 'The directory $GASH_DATA contains meta-data from a previous game.
Do you want to continue this game? [Y/n]')" x
      echo "$x"
      if [ "$x" = "$(gettext "y")" ] || [ "$x" = "$(gettext "Y")" ] || [ "$x" = "" ]
      then
        return 1
      fi
    elif [ "$RESET" = "FALSE" ]
    then
      return 1
    fi
  fi

  rm -rf "$GASH_HOME"
  rm -rf "$GASH_DATA"
  rm -rf "$GASH_TMP"
  rm -rf "$GASH_CONFIG"
  rm -rf "$GASH_LOCAL_BIN"

  mkdir -p "$GASH_HOME"

  mkdir -p "$GASH_DATA"
  echo "# mission action date checksum" >> "$GASH_DATA/missions.log"

  mkdir -p "$GASH_CONFIG"
  cp "$GASH_LIB/bashrc" "$GASH_CONFIG"
  # save current locale
  locale | sed "s/^/export /" > "$GASH_CONFIG"/locale.sh

  mkdir -p "$GASH_LOCAL_BIN"

  mkdir -p "$GASH_TMP"


  # Configuration pour la génération de la fiche étudiant.
  PASSPORT="$GASH_DATA/passport.txt"

  while true
  do
    # Lecture du login des étudiants.
    case "$MODE" in
      DEBUG)
        echo "DISCOVERY MODE" >> "$PASSPORT"
        break
        ;;
      PASSPORT)
        local_passport "$PASSPORT"
        ;;
      *)
        echo "$(eval_gettext 'unknown mode: $MODE')" >&2
        ;;
    esac

    # Confirmation des informations
    if confirm_passport "$PASSPORT"
    then
      break
    else
      rm -f "$PASSPORT"
      color_echo yellow "$(gettext "Start again!")"
      echo
      fi
    done


  # Génération de l'UID du groupe.
  export GASH_UID="$(sha1sum "$PASSPORT" | cut -c 1-40)"
  echo "GASH_UID=$GASH_UID" >> "$PASSPORT"
  echo "$GASH_UID" > "$GASH_DATA/uid"


  # Message d'accueil.
  clear
  echo "$(gettext "======== Initialisation of GameShell ========")"


  # Installation des missions.
  for MISSION_DIR in "$GASH_BASE"/missions/[0-9]*; do
    export MISSION_DIR

    # To be used as TEXTDOMAIN environment variable for the mission.
    export DOMAIN=$(basename "$MISSION_DIR")

    # Preparing the locales
    if [ -d "$MISSION_DIR/i18n" ]
    then
      shopt -s nullglob
      for PO_FILE in "$MISSION_DIR"/i18n/*.po; do
        PO_LANG=$(basename "$PO_FILE" .po)
        mkdir -p "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES"
        msgfmt -o "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" "$PO_FILE"
      done
      shopt -u nullglob
    fi

    # Setting up the binaries
    if [ -d "$MISSION_DIR/bin" ]
    then
      for BIN_FILE in "$MISSION_DIR"/bin/*; do
        BIN_NAME=$(basename "$BIN_FILE")
        cat > "$GASH_LOCAL_BIN/$BIN_NAME" <<EOH
#!/bin/bash
export TEXTDOMAIN="$DOMAIN"
$BIN_FILE "\$@"
EOH
        chmod +x "$GASH_LOCAL_BIN/$BIN_NAME"
      done
    fi

    if [ -f "$MISSION_DIR/static.sh" ]
    then
      export TEXTDOMAIN="$DOMAIN"
      # shellcheck source=/dev/null
      source "$MISSION_DIR/static.sh"
      export TEXTDOMAIN="gash"
    fi

    if [ -f "$MISSION_DIR/bashrc" ]
    then
      cp "$MISSION_DIR/bashrc" "$GASH_CONFIG/$(basename "$MISSION_DIR" /)-bashrc.sh"
    fi
    printf "."
  done
  echo
  unset MISSION_DIR
}


start_gash() {
  # Lancement du jeu.
  cd "$GASH_HOME"
  export GASH_UID=$(cat "$GASH_DATA/uid")
  bash --rcfile "$GASH_LIB/bashrc"
}


#######################################################################
init_gash
start_gash

# vim: shiftwidth=2 tabstop=2 softtabstop=2
