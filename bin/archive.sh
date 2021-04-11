#!/bin/bash


export GASH_BASE="$(dirname "$0")/.."
source "$GASH_BASE"/lib/os_aliases.sh

GASH_BASE=$(CANONICAL_PATH "$(dirname "$0")"/..)

source "$GASH_BASE/lib/utils.sh"

display_help() {
cat <<EOH
$(basename $0): create a GameShell standalone archive

options:
  -h          this message
  -m ...      choose the missions to include (shell pattern)
              (default : "_*")
  -M          take list of missions to include from a file
  -p ...      choose password for admin commands
  -N ...      name of directory inside the GameShell archive (default: "GameShell")
  -a          keep 'auto.sh' scripts from missions that have one
  -P          use the "passport mode" by default when running GameShell
  -D          use the "discovery mode" by default when running GameShell
  -o ...      name of the archive (default: ../DIR_NAME.tgz, from -N option)
EOH
}

NAME="GameShell"
ADMIN_PASSWD=""
MISSIONS_PATTERNS="*"
KEEP_AUTO=0
DEFAULT_MODE="DEBUG"
OUTPUT=''

while getopts ":hm:M:p:N:aPDo:" opt
do
  case $opt in
    h)
      display_help
      exit 0;
      ;;
    p)
      ADMIN_PASSWD=$OPTARG
      ;;
    N)
      NAME=$OPTARG
      ;;
    m)
      MISSIONS_PATTERNS="$OPTARG"
      ;;
    M)
      MISSIONS_PATTERNS=$(cat "$OPTARG")
      ;;
    a)
      KEEP_AUTO=1
      ;;
    P)
      DEFAULT_MODE="PASSPORT"
      ;;
    D)
      DEFAULT_MODE="DEBUG"
      ;;
    o)
      OUTPUT=$OPTARG
      ;;
    *)
      echo "invalid option: '-\$OPTARG'" >&2
      exit 1
      ;;
  esac
done

[ -z "$OUTPUT" ] && OUTPUT="$(pwd)/$NAME.tgz"

TMP_DIR=$(mktemp -d)
mkdir "$TMP_DIR/$NAME"


# copy source files
cp --archive "$GASH_BASE/start.sh" "$GASH_BASE/bin/" "$GASH_BASE/lib/" "$GASH_BASE/i18n/" "$TMP_DIR/$NAME"

# copy missions
mkdir "$TMP_DIR/$NAME/missions"
# cd $GASH_BASE/missions
echo "copy missions"
N=0
GLOBIGNORE="*"
for pattern in $MISSIONS_PATTERNS
do
  GLOBIGNORE=""
  for m in $(find "$GASH_BASE/missions" -maxdepth 1 -name "*_$pattern" -type d | sort -n)
  do
    N=$((10#$N + 1))
    N=$(echo -n "000000$N" | tail -c 6)
    MISSION_DIR=$TMP_DIR/$NAME/missions/${N}_${m#*_}
    echo "    $m  -->  $(basename "$MISSION_DIR")"
    mkdir "$MISSION_DIR"
    cp --archive "$m"/* "$MISSION_DIR"
  done
done
#remove leading 0s
echo "removing leading 0s"
leading_zeros=$(echo $N | sed "s/[^0]//g")
cd "$TMP_DIR/$NAME/missions/"
for m in *_*
do
  mv "$m" "${m/$leading_zeros/}"
done


# remove auto.sh files
if [ "$KEEP_AUTO" -ne 1 ]
then
  echo "removing 'auto.sh' scripts"
  find "$TMP_DIR/$NAME/missions" -name auto.sh -print0 | xargs -0 rm -f
fi

# change admin password
if [ "$ADMIN_PASSWD" ]
then
  echo "changing admin password"
  ADMIN_HASH=$(checksum "$ADMIN_PASSWD")
  sed -i "s/^export ADMIN_HASH='[0-9a-f]*'$/export ADMIN_HASH='$ADMIN_HASH'/" "$TMP_DIR/$NAME/lib/utils.sh"
fi

# choose default mode
echo "setting default GameShell mode"
case $DEFAULT_MODE in
  DEBUG | PASSPORT)
    sed -i "s/^MODE=.*$/MODE='$DEFAULT_MODE'/" "$TMP_DIR/$NAME/start.sh"
    ;;
  *)
    echo "unknown mode: $MODE" >&2
    ;;
esac



# create archive
echo "creating archive"
cd "$TMP_DIR"
tar -zcf "$NAME.tgz" "$NAME"
mv "$NAME.tgz" "$OUTPUT"

echo "removing temporary directory"
rm -rf "$TMP_DIR"


# TODO
# generate archive with given missions
# generate archive with given admin passwd
# generate archive with / without "auto.sh" scripts

# vim: shiftwidth=2 tabstop=2 softtabstop=2
