#!/bin/bash


export GASH_BASE="$(dirname "$0")/.."
source "$GASH_BASE"/lib/os_aliases.sh

GASH_BASE=$(CANONICAL_PATH "$(dirname "$0")"/..)

source "$GASH_BASE/lib/utils.sh"

display_help() {
cat <<EOH
$(basename $0) [options] : crée une archive GameShell

options :
  -h          ce message
  -M ...      choisit les missions à inclure dans l'archive (motif shell)
              (défaut : "_*")
  -P ...      choisit le "mot de passe" pour les commandes administrateur
  -N ...      nom du répertoire contenu dans l'archive (défaut : "GameShell")
  -a          conserve les scripts 'auto.sh' des missions qui en ont
  -P          utilise le mode "passeport" par défaut
  -D          utilise le mode debug par défaut
  -o ...      choisit le nom de l'archive (défaut: ../NOM_REPERTOIRE.tgz)
EOH
}

NAME="GameShell"
ADMIN_PASSWD=""
MISSIONS="*"
KEEP_AUTO=0
DEFAULT_MODE="DEBUG"
OUTPUT=''

while getopts ":hM:P:N:aPDo:" opt
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
    P)
      DEFAULT_MODE="PASSEPORT"
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

[ -z "$OUTPUT" ] && OUTPUT="$(pwd)/$NAME.tgz"

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
  echo "suppression des scripts 'auto.sh' des missions"
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
  DEBUG | PASSEPORT)
    sed -i "s/^MODE=.*$/MODE='$DEFAULT_MODE'/" "$TMP_DIR/$NAME/start.sh"
    ;;
  *)
    echo "mode inconnu : '$DEFAULT_MODE'" >&2
esac



# create archive
echo "création de l'archive"
cd "$TMP_DIR"
tar -zcf "$NAME.tgz" "$NAME"
mv "$NAME.tgz" "$OUTPUT"

echo "suppression du répertoire temporaire"
rm -rf "$TMP_DIR"


# TODO
# generate archive with given missions
# generate archive with given admin passwd
# generate archive with / without "auto.sh" scripts

# vim: shiftwidth=2 tabstop=2 softtabstop=2
