#!/bin/bash

export GASH_BASE="$(dirname "$0")/.."
source $GASH_BASE/lib/os_aliases.sh
GASH_BASE=$(REALPATH "$GASH_BASE")
source $GASH_BASE/lib/utils.sh
source $GASH_BASE/lib/make_index.sh

export GASH_MISSIONS="$GASH_BASE/missions"

display_help() {
cat <<EOH
$(basename $0) [OPTIONS] [MISSIONS]
create a GameShell standalone archive

options:
  -h          this message

  -p ...      choose password for admin commands
  -P          use the "passport mode" by default when running GameShell
  -A          use the "anonymous mode" by default when running GameShell

  -a          keep 'auto.sh' scripts from missions that have one
  -N ...      name of the archive / top directory (default: "GameShell")
  -k          keep tgz archive
EOH
}

NAME="GameShell"
ADMIN_PASSWD="gsh"
KEEP_AUTO=0
DEFAULT_MODE="ANONYMOUS"
KEEP_TGZ='false'
GENERATE_MO='true'

while getopts ":hp:N:aPk" opt
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
    a)
      KEEP_AUTO=1
      ;;
    P)
      DEFAULT_MODE="PASSPORT"
      ;;
    k)
      KEEP_TGZ='true'
      ;;
    *)
      echo "invalid option: '-$OPTARG'" >&2
      exit 1
      ;;
  esac
done
shift $(($OPTIND - 1))

OUTPUT_DIR=$(dirname "$NAME")
NAME=$(basename "$NAME")

TMP_DIR=$(mktemp -d)
mkdir "$TMP_DIR/$NAME"


# copy source files
cp --archive "$GASH_BASE/start.sh" "$GASH_BASE/bin/" "$GASH_BASE/lib/" "$GASH_BASE/i18n/" "$TMP_DIR/$NAME"

# copy missions
mkdir "$TMP_DIR/$NAME/missions"
echo "copy missions"
N=0
make_index "$@" | while read MISSION_DIR
do
  case $MISSION_DIR in
    "" | "#"* )
      continue
      ;;
    "!"*)
      DUMMY="!"
      MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
      ;;
    *)
      DUMMY=""
      ;;
  esac
  N=$((10#$N + 1))
  N=$(echo -n "000000$N" | tail -c 6)
  ARCHIVE_MISSION_DIR=$TMP_DIR/$NAME/missions/${N}_${MISSION_DIR#*_}
  echo "    $(basename "$MISSION_DIR")  -->  $(basename "$ARCHIVE_MISSION_DIR")"
  mkdir "$ARCHIVE_MISSION_DIR"
  cp --archive "$GASH_MISSIONS/$MISSION_DIR"/* "$ARCHIVE_MISSION_DIR"
  echo "$DUMMY$(basename "$ARCHIVE_MISSION_DIR")" >> "$TMP_DIR/$NAME/missions/index.txt"
done

# generate .mo files
if [ "$GENERATE_MO" = 'true' ]
then
  echo "generating '.mo' files"
  {
    # gameshell
    GASH_BASE=$TMP_DIR/$NAME
    GASH_DATA="$GASH_BASE/.session_data"

    export TEXTDOMAINDIR="$GASH_BASE/locale"
    export TEXTDOMAIN="gash"
    for PO_FILE in "$GASH_BASE"/i18n/*.po; do
      PO_LANG=$(basename "$PO_FILE" .po)
      mkdir -p "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES"
      msgfmt -o "$GASH_BASE/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" "$PO_FILE"
    done

    # all missions
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
      export DOMAIN=$(basename "$MISSION_DIR")

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
    done < "$GASH_BASE/missions/index.txt"
  }
fi


# remove auto.sh files
if [ "$KEEP_AUTO" -ne 1 ]
then
  echo "removing 'auto.sh' scripts"
  find "$TMP_DIR/$NAME/missions" -name auto.sh -print0 | xargs -0 rm -f
fi

# remove "_" files
echo "removing unnecessary (_*.sh, Makefile) files"
find "$TMP_DIR/$NAME" -name "*~" -print0 | xargs -0 rm -f
find "$TMP_DIR/$NAME" -name "_*.sh" -print0 | xargs -0 rm -f
find "$TMP_DIR/$NAME" -name "test.sh" -print0 | xargs -0 rm -f
find "$TMP_DIR/$NAME" -name "Makefile" -print0 | xargs -0 rm -f
find "$TMP_DIR/$NAME" -name "template.pot" -print0 | xargs -0 rm -f
[ "$GENERATE_MO" = 'true' ] && find "$TMP_DIR/$NAME" -name "*.po" -print0 | xargs -0 rm -f

# change admin password
echo "setting admin password"
ADMIN_HASH=$(checksum "$ADMIN_PASSWD")
sed -i "s/^\(\s*\)ADMIN_HASH=.*/\1ADMIN_HASH='$ADMIN_HASH'/" "$TMP_DIR/$NAME/start.sh"

# choose default mode
echo "setting default GameShell mode"
case $DEFAULT_MODE in
  DEBUG | PASSPORT | ANONYMOUS )
    sed -i "s/^GASH_MODE=.*$/GASH_MODE='$DEFAULT_MODE'/" "$TMP_DIR/$NAME/start.sh"
    ;;
  *)
    echo "unknown mode: $MODE" >&2
    ;;
esac


# create archive
echo "creating archive"
tar -zcf "$OUTPUT_DIR/$NAME.tgz" -C "$TMP_DIR" "$NAME"

# create self-extracting archive
echo "creating self-extracting archive"
cat "$GASH_BASE/lib/init.sh" "$OUTPUT_DIR/$NAME.tgz" > "$OUTPUT_DIR/$NAME.sh"
chmod +x "$OUTPUT_DIR/$NAME.sh"

if [ "$KEEP_TGZ" = 'false' ]
then
  echo "removing tgz archive"
  rm "$OUTPUT_DIR/$NAME.tgz"
fi

echo "removing temporary directory"
rm -rf "$TMP_DIR"

# vim: shiftwidth=2 tabstop=2 softtabstop=2
