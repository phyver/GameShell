#!/bin/bash


# la version de "readlink" de macOS n'a pas l'option "-f", il faut utiliser
# "greadlink" qui fait partie de "coreutils"
# Attention, l'executable "readlink" existe sous macOS
if [ "$(which greadlink)" ]
then
  export READLINK=greadlink
elif [ "$(which readlink)" ]
then
  export READLINK=readlink
else
  echo "La commande 'readlink' (linux) ou 'greadlink' (macOS) n'a pas été trouvée..."
  echo "Pour macOS, n'oubliez pas d'installer 'coreutil' (et 'md5sha1sum')"
  echo "   $ brew install coreutils"
  echo "   $ brew install md5sha1sum"
  exit
fi

if $READLINK -f / 2&> /dev/null
then
  :
else
  echo "La commande 'readlink' (linux) ou 'greadlink' (macOS) ne supporte pas l'argument '-f'..."
  echo "Pour macOS, n'oubliez pas d'installer 'coreutil' (et 'md5sha1sum')"
  echo "   $ brew install coreutils"
  echo "   $ brew install md5sha1sum"
  exit
fi

export GASH_BASE=$($READLINK -f "$(dirname "$0")"/)
cd "$GASH_BASE"

source lib/utils.sh


display_help() {
cat <<EOH
options :
  -h      ce message
  -n      mode noir et blanc : n'utilise pas les séquences ANSI pour la couleur
  -L      local : n'essaie pas d'utiliser le serveur LDAP de l'université
  -U      université : utilise le serveur LDAP de l'université Savoie Mont Blanc
  -D <n>  mode debug / découverte en partant de la mission <n>
EOH
}


export GASH_COLOR="OK"
export GASH_DEBUG_MISSION=""
MODE="DEBUG"
while getopts ":hcnULD:" opt
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
    L)
      MODE="LOCAL"
      ;;
    U)
      MODE="USMB"
      ;;
    D)
      MODE="DEBUG"
      GASH_DEBUG_MISSION=$OPTARG
      ;;
    *)
      echo "option invalide : -$OPTARG" >&2
      exit 1
      ;;
  esac
done



ldap_passeport() {
  local PASSEPORT=$1
  local LDAP_SRV="ldap-bourget.univ-savoie.fr"
  local LDAP="ldapsearch -h $LDAP_SRV -p 389 -xLLL -b dc=agalan,dc=org"

  local LOGINS=""
  echo -n "Logins du portail (séparés par des espaces) : "
  read LOGINS
  echo

  for LOGIN in $LOGINS; do
    NOM="$($LDAP uid="$LOGIN" cn | grep ^cn | colrm 1 4)"
    EMAIL="$($LDAP uid="$LOGIN" mail | grep ^mail | colrm 1 6)"
    if [ -z "$NOM" ]; then
      color_echo red "Le login « $LOGIN » est introuvable..."
    else
      echo " - $NOM <$EMAIL>" >> "$PASSEPORT"
    fi
  done
}

local_passeport() {
  local PASSEPORT=$1
  local NB
  while true
  do
    echo -n "Combien de membres dans le groupe ? (1) "
    read NB
    case "$NB" in
      "" )          NB=1; break             ;;
      *[!0-9]* )    echo "nombre invalide"  ;;
      *[1-9]*)      break                   ;;
      *)            echo "nombre invalide"  ;;
    esac
  done
  for I in $(seq "$NB"); do
    NOM=""
    while [ -z "$NOM" ]
    do
      echo -n "Membre $I, nom complet : "
      read NOM
    done
    EMAIL=""
    while [ -z "$EMAIL" ]
    do
      echo -n "Membre $I, email : "
      read EMAIL
    done
    echo "  $NOM <$EMAIL>" >> "$PASSEPORT"
  done
}

debug_passeport() {
  local PASSEPORT=$1
  echo "MODE DÉCOUVERTE (DEBUG)" >> "$PASSEPORT"
}


confirm_passeport() {
  local PASSEPORT=$1
  echo "======================================================="
  cat "$PASSEPORT"
  echo "======================================================="
  color_echo yellow "Les informations données ici ne pourront plus être modifiées."
  echo -n "Ces informations sont elles correctes ? (O / n) "
  local OK=""
  read OK
  echo
  [ "$OK" = "" -o "$OK" = "o" -o "$OK" = "O" ]
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

  if [ -d "$GASH_HOME" ]
  then
    export GASH_CABANE=$(find "$GASH_HOME" -iname cabane)
    export GASH_COFFRE=$(find "$GASH_HOME" -iname coffre)
  else
    export GASH_CABANE=""
    export GASH_COFFRE=""
  fi

  if [ -e "$GASH_BASE/.git" ]
  then
    echo "Attention, vous êtes en train d'exécuter"
    echo "GameShell dans la version de développement."
    echo -n "Faut-il le continuer ? [o/N] "
    read x
    [ "$x" != "o"  -a  "$x" != "O" ] && exit 1
    [ -z "$GASH_DEBUG_MISSION" ] && GASH_DEBUG_MISSION="1"
  fi

  if [ -e "$GASH_DATA" ]
  then
    echo -n "'$GASH_DATA' existe déjà... Faut-il le conserver ? [O/n] "
    read x
    [ "$x" = "o"  -o  "$x" = "O"  -o "$x" = "" ] && return 1
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

  mkdir -p "$GASH_LOCAL_BIN"

  mkdir -p "$GASH_TMP"

  # Installation des missions.
  for MISSION in $GASH_BASE/missions/[0-9]*; do
    if [ -f "$MISSION/static.sh" ]
    then
      source "$MISSION/static.sh"
    fi
    if [ -d "$MISSION/bin" ]
    then
      cp "$MISSION/bin/"* "$GASH_LOCAL_BIN"
    fi
  done



  # Configuration pour la génération de la fiche étudiant.
  PASSEPORT="$GASH_DATA/passeport.txt"

  # Message d'accueil.
  clear
  echo "============================ Initialisation de GameShell ============================"

  while true
  do
    # Lecture du login des étudiants.
    case "$MODE" in
      DEBUG)
        debug_passeport "$PASSEPORT"
        break
        ;;
      LOCAL)
        local_passeport "$PASSEPORT"
        ;;
      USMB)
        ldap_passeport "$PASSEPORT"
        ;;
      *)
        echo "mode de lancement inconnu: '$MODE'" >&2
        ;;
    esac


    # Confirmation des informations
    if confirm_passeport "$PASSEPORT"
    then
      break
    else
      rm -f "$PASSEPORT"
      color_echo yellow "Recommencez du début, sans vous tromper."
      echo
    fi
  done

  # Génération de l'UID du groupe.
  export GASH_UID="$(sha1sum "$PASSEPORT" | cut -c 1-40)"
  echo "GASH_UID=$GASH_UID" >> "$PASSEPORT"
  echo "$GASH_UID" > "$GASH_DATA/uid"
}


start_gash() {

  # Lancement du jeu.
  cd "$GASH_HOME"

  export GASH_UID=$(cat "$GASH_DATA/uid")

  # if [ -x "$(command -v ttyrec)" ]
  # then
  #   ttyrec -a -e "bash --rcfile \"$GASH_CONFIG/bashrc\"" "$GASH_DATA/script"
  # else
  bash --rcfile "$GASH_LIB/bashrc"
  # fi

}


#######################################################################
init_gash
start_gash

# vim: shiftwidth=2 tabstop=2 softtabstop=2
