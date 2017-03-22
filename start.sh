#!/bin/bash


cd $(dirname $0)

display_help() {
cat <<EOH
options :
  -h      ce message
  -l      local : n'essaie pas d'utiliser le serveur LDAP de l'université
  -n      mode noir et blanc : n'utilise pas les séquences ANSI pour la couleur
EOH
}


export GASH_COLOR="OK"
export GASH_DEBUG_MISSION=""
NO_LDAP=""
while getopts ":hcnlD:" opt
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
    l)
      NO_LDAP=1
      ;;
    D)
      GASH_DEBUG_MISSION=$OPTARG
      ;;
    *)
      echo "option invalide : -$OPTARG" >&2
      exit 1
      ;;
  esac
done






init_gash() {
  # dossiers d'installation
  export GASH_BASE="$HOME/GameShell-info202"
  export GASH_HOME="$GASH_BASE/World"
  export GASH_VAR="$GASH_BASE/var"
  export GASH_BIN="$GASH_BASE/bin"
  export GASH_TMP="$GASH_BASE/tmp"
  export GASH_MISSIONS="$GASH_VAR/missions"
  export GASH_CONFIG="$GASH_BASE/shell_config"
  export GASH_DATA="$GASH_VAR/session_data"

  PASSEPORT="$GASH_DATA/passeport.txt"

  if [ -e "$GASH_BASE" ]
  then
    echo -n "'$GASH_BASE' existe déjà... Faut-il le conserver ? [O/n] "
    read x
    if [ "$x" = "o"  -o  "$x" = "O"  -o "$x" = "" ]
    then
      return 0
    fi
  fi

  rm -rf $GASH_BASE
  mkdir -p $GASH_BASE
  mkdir -p $GASH_HOME
  mkdir -p $GASH_VAR
  mkdir -p $GASH_BIN
  mkdir -p $GASH_TMP
  mkdir -p $GASH_MISSIONS
  mkdir -p $GASH_CONFIG
  mkdir -p $GASH_DATA


  echo "# mission action date checksum" >> "$GASH_DATA/missions.log"

  cp -r shell_config/* "$GASH_CONFIG"
  cp -r bin/* "$GASH_BIN"


  # Configuration pour la génération de la fiche étudiant.
  LDAP_SRV="ldap-bourget.univ-savoie.fr"
  LDAP="ldapsearch -h $LDAP_SRV -p 389 -xLLL -b dc=agalan,dc=org"

  # Message d'accueil.
  clear
  echo "============================ Initialisation du TP ============================"

  # Obtention des membres du groupe

  echo "== Membres du groupe =========================================================" >> "$PASSEPORT"

  while true
  do
    # Lecture du login des étudiants.
    if [ -n "$GASH_DEBUG_MISSION" ]
    then
      echo " - TEST <EMAIL> (mission $GASH_DEBUG_MISSION)" >> "$PASSEPORT"
      break
    elif [ -z "$NO_LDAP" ]
    then
      local LOGINS=""
      echo -n "Logins du portail (séparés par des espaces) : "
      read LOGINS
      echo

      for LOGIN in $LOGINS; do
        NOM="$($LDAP uid=$LOGIN cn | grep ^cn | colrm 1 4)"
        EMAIL="$($LDAP uid=$LOGIN mail | grep ^mail | colrm 1 6)"
        if [ -z "$NOM" ]; then
          [ -z "$GASH_COLOR" ] || echo -ne "\e[31m"
          echo "Le login « $LOGIN » est introuvable..."
          [ -z "$GASH_COLOR" ] || echo -ne "\e[0m"
        else
          echo " - $NOM <$EMAIL>" >> "$PASSEPORT"
        fi
      done
    else
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
        echo "  $NOM <$EMAIL>" >> $PASSEPORT
      done
    fi

    echo "==============================================================================" >> "$PASSEPORT"


    # Confirmation des informations
    echo
    cat "$PASSEPORT"
    echo
    [ -z "$GASH_COLOR" ] || echo -ne "\e[33m"
    echo "Les informations données ici ne pourront plus être modifiées."
    [ -z "$GASH_COLOR" ] || echo -ne "\e[0m"
    echo -n "Ces informations sont elles correctes ? (O / n) "
    OK=""
    read OK
    echo

    if [ "$OK" = "" -o "$OK" = "o" -o "$OK" = "O" ]
    then
      break
    else
      rm -f "$PASSEPORT"
      [ -z "$GASH_COLOR" ] || echo -ne "\e[31m"
      echo "Recommencez du début, sans vous tromper."
      [ -z "$GASH_COLOR" ] || echo -ne "\e[0m"
      echo
    fi
  done

  # Génération de l'UID du groupe.
  export GROUP_UID="$(sha1sum $PASSEPORT | cut -c 1-40)"
  echo "GROUP_UID=$GROUP_UID" >> "$PASSEPORT"
  echo $GROUP_UID > "$GASH_DATA/uid"

  # Installation des missions.
  for MISSION in missions/[0-9]*; do
    cp -r "$MISSION" "$GASH_MISSIONS/"
    if [ -f "$MISSION/static.sh" ]
    then
      source "$MISSION/static.sh"
    fi
    if [ -d "$MISSION/bin" ]
    then
      cp "$MISSION/bin/"* $GASH_BIN
    fi
  done
}


start_gash() {

  # Lancement du jeu.
  cd "$GASH_HOME"

  export GROUP_UID=$(cat "$GASH_DATA/uid")

  if [ -x "$(which ttyrec)" ]
  then
    ttyrec -a -e "bash --rcfile \"$GASH_CONFIG/bashrc\"" "$GASH_DATA/script"
  else
     bash --rcfile "$GASH_CONFIG/bashrc"
  fi

}


#######################################################################
init_gash
start_gash

# vim: shiftwidth=2 tabstop=2 softtabstop=2
