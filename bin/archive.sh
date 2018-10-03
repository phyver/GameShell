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

GASH_BASE=$($READLINK -f "$(dirname "$0")"/..)

source "$GASH_BASE/lib/utils.sh"

display_help() {
cat <<EOH
$(basename $0) [options] : crée une archive GameShell

options :
  -h          ce message
  -M ...      choisit les missions à inclure dans l'archive (motif shell)
              (défaut : "_*")
  -P ...      choisit le "mot de passe" pour les commande administrateur
  -N ...      nom du répertoire contenu dans l'archive (défaut : "GameShell")
  -a          conserve les scripts 'auto.sh' des missions qui en ont
  -L          utilise le mode local par défaut
  -U          utilise le LDAP de l'université par défaut
  -D          utilise le mode debug par défaut
  -o ...      choisit le nom de l'archive (défaut: ../NOM_REPERTOIRE.tar)
EOH
}

NAME="GameShell"
ADMIN_PASSWD=""
MISSIONS="*"
KEEP_AUTO=0
DEFAULT_MODE="DEBUG"
OUTPUT=''

while getopts ":hM:P:N:aLUDo:" opt
do
  case $opt in
    h)
      display_help
      exit 0;
      ;;
    P)
      ADMIN_PASSWD=$OPTARG
      ;;
    N)
      NAME=$OPTARG
      ;;
    M)
      MISSIONS="$OPTARG"
      ;;
    a)
      KEEP_AUTO=1
      ;;
    U)
      DEFAULT_MODE="USMB"
      ;;
    L)
      DEFAULT_MODE="LOCAL"
      ;;
    D)
      DEFAULT_MODE="DEBUG"
      ;;
    o)
      OUTPUT=$OPTARG
      ;;
    *)
      echo "option invalide : -$OPTARG" >&2
      exit 1
      ;;
  esac
done

[ -z "$OUTPUT" ] && OUTPUT="$(pwd)/$NAME.tar"

TMP_DIR=$(mktemp -d)
mkdir "$TMP_DIR/$NAME"


# copy source files
cp --archive "$GASH_BASE/start.sh" "$GASH_BASE/bin" "$GASH_BASE/lib" "$TMP_DIR/$NAME"

# copy missions
mkdir "$TMP_DIR/$NAME/missions"
# cd $GASH_BASE/missions
echo "copie des missions choisies"
N=1
GLOBIGNORE="*"
for pattern in $MISSIONS
do
  GLOBIGNORE=""
  for m in $(find "$GASH_BASE/missions" -maxdepth 1 -name "*_$pattern" -type d | sort)
  do
    N=$(echo -n "0000$N" | tail -c 2)
    MISSION_DIR=$TMP_DIR/$NAME/missions/${N}_${m#*_}
    echo "    $m  -->  $(basename "$MISSION_DIR")"
    mkdir "$MISSION_DIR"
    cp --archive "$m"/* "$MISSION_DIR"
    N=$((10#$N + 1))
  done
done

# remove auto.sh files
if [ "$KEEP_AUTO" -ne 1 ]
then
  echo "suppression des script 'auto.sh' des missions"
  find "$TMP_DIR/$NAME/missions" -name auto.sh -print0 | xargs -0 rm -f
fi

# change admin password
if [ "$ADMIN_PASSWD" ]
then
  echo "changement du mot de passe pour les commandes administrateur"
  ADMIN_HASH=$(checksum "$ADMIN_PASSWD")
  sed -i "s/^export ADMIN_HASH='[0-9a-f]*'$/export ADMIN_HASH='$ADMIN_HASH'/" "$TMP_DIR/$NAME/lib/utils.sh"
fi

# choose default mode
echo "choix du mode de lancement"
case $DEFAULT_MODE in
  DEBUG | LOCAL | USMB)
    sed -i "s/^MODE=.*$/MODE='$DEFAULT_MODE'/" "$TMP_DIR/$NAME/start.sh"
    ;;
  *)
    echo "mode inconnu : '$DEFAULT_MODE'" >&2
esac




# create archive
echo "création de l'archive"
cd "$TMP_DIR"
tar --create --file "$NAME.tar" "$NAME"
mv "$NAME.tar" "$OUTPUT"

echo "suppression du répertoire temporaire"
rm -rf "$TMP_DIR"


# TODO
# generate archive with given missions
# generate archive with given admin passwd
# generate archive with / without "auto.sh" scripts

# vim: shiftwidth=2 tabstop=2 softtabstop=2
