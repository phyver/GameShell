#!/usr/bin/env bash

export GSH_ROOT=$(dirname "$0")/..
source $GSH_ROOT/lib/common.sh
export GSH_MISSIONS="$GSH_ROOT/missions"

display_help() {
cat <<EOH
$(basename $0) [OPTIONS] [MISSIONS]
create a GameShell standalone archive

options:
  -h          this message

  -p ...      choose password for admin commands
  -P          use the "passport mode" by default when running GameShell
  -A          use the "anonymous mode" by default when running GameShell
  -L LANGS    only keep the given languages (ex: -L 'en*,fr')

  -a          keep 'auto.sh' scripts for missions that have one
  -A          keep 'test.sh' scripts for missions that have one
  -N ...      name of the archive / top directory (default: "GameShell")
  -k          keep tgz archive
EOH
}

keep_language() {
  local filename=$(basename "$1")
  local languages=$2
  set -f    # disable globing
  local g
  for g in $(echo "$languages" | tr ',' ' ')
  do
    set +f  # enable globing
    case $filename in
      $g )
        return 0
        ;;
    esac
  done
  set +f  # enable globing, in case the loop was empty
  return 1
}

NAME="GameShell"
ADMIN_PASSWD="gsh"
KEEP_AUTO=0
KEEP_TEST=0
DEFAULT_MODE="ANONYMOUS"
KEEP_TGZ=0
GENERATE_MO=1
KEEP_PO=0
LANGUAGES=""

while getopts ":hp:N:aAPkL:" opt
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
    A)
      KEEP_TEST=1
      ;;
    P)
      DEFAULT_MODE="PASSPORT"
      ;;
    k)
      KEEP_TGZ=1
      ;;
    L)
      LANGUAGES=$OPTARG
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
cp --archive "$GSH_ROOT/start.sh" "$GSH_ROOT/bin" "$GSH_ROOT/utils/" "$GSH_ROOT/lib/" "$GSH_ROOT/i18n/" "$TMP_DIR/$NAME"

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
  echo "  -> copy $MISSION_DIR"
  mkdir -p "$TMP_DIR/$NAME/missions/$MISSION_DIR"
  ARCHIVE_MISSION_DIR=$TMP_DIR/$NAME/missions/$MISSION_DIR
  cp --archive "$GSH_MISSIONS/$MISSION_DIR"/* "$ARCHIVE_MISSION_DIR/"
  echo "$DUMMY$MISSION_DIR" >> "$TMP_DIR/$NAME/missions/index.txt"
done

export GSH_ROOT=$TMP_DIR/$NAME
source $GSH_ROOT/lib/common.sh
export GSH_MISSIONS="$GSH_ROOT/missions"


# remove unwanted languages
if [ -n "$LANGUAGES" ]
then
  echo "removing unwanted languages"
  find $GSH_ROOT -path "*/i18n/*.po" | while read po_file
  do
    if ! keep_language "${po_file%.po}" "$LANGUAGES"
    then
      rm -f "$po_file"
    fi
  done
fi

# generate .mo files
if [ "$GENERATE_MO" -eq 1 ]
then
  echo -n "generating '.mo' files: "
  {
    # gameshell
    export TEXTDOMAINDIR="$GSH_ROOT/locale"
    export TEXTDOMAIN="gsh"
    for PO_FILE in "$GSH_ROOT"/i18n/*.po; do
      PO_LANG=$(basename "$PO_FILE" .po)
      mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
      msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" "$PO_FILE"
    done
    echo -n "."

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
      MISSION_DIR=$GSH_ROOT/missions/$MISSION_DIR
      export DOMAIN=$(textdomainname "$MISSION_DIR")

      if [ -d "$MISSION_DIR/i18n" ]
      then
        shopt -s nullglob
        for PO_FILE in "$MISSION_DIR"/i18n/*.po; do
          PO_LANG=$(basename "$PO_FILE" .po)
          mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
          msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" "$PO_FILE"
          echo -n "."
        done
        shopt -u nullglob
      fi
    done < "$GSH_ROOT/missions/index.txt"
    echo
  }
fi

# remove "_" files
echo "removing unnecessary files"
find "$GSH_ROOT" -name "*~" -print0 | xargs -0 rm -f
find "$GSH_ROOT" -name "_*.sh" -print0 | xargs -0 rm -f
find "$GSH_ROOT" -name "Makefile" -print0 | xargs -0 rm -f
find "$GSH_ROOT" -name "template.pot" -print0 | xargs -0 rm -f
[ "$KEEP_TEST" -ne 1 ] && echo "remove tests" && find "$GSH_MISSIONS" -name "test.sh" -print0 | xargs -0 rm -f
[ "$KEEP_PO" -ne 1 ] && [ "$GENERATE_MO" -eq 1 ] && find "$GSH_ROOT" -name "*.po" -print0 | xargs -0 rm -f
[ "$KEEP_AUTO" -ne 1 ] && find "$GSH_MISSIONS" -name auto.sh -print0 | xargs -0 rm -f

# change admin password
echo "setting admin password"
ADMIN_HASH=$(checksum "$ADMIN_PASSWD")
sed-i "s/^\([[:blank:]]*\)ADMIN_HASH=.*/\1ADMIN_HASH='$ADMIN_HASH'/" "$GSH_ROOT/start.sh"

# choose default mode
echo "setting default GameShell mode"
case $DEFAULT_MODE in
  DEBUG | PASSPORT | ANONYMOUS )
    sed-i "s/^GSH_MODE=.*$/GSH_MODE='$DEFAULT_MODE'/" "$GSH_ROOT/start.sh"
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
cat "$GSH_ROOT/lib/header.sh" "$OUTPUT_DIR/$NAME.tgz" > "$OUTPUT_DIR/$NAME.sh"
chmod +x "$OUTPUT_DIR/$NAME.sh"

if [ "$KEEP_TGZ" = 0 ]
then
  echo "removing tgz archive"
  rm "$OUTPUT_DIR/$NAME.tgz"
fi

echo "removing temporary directory"
rm -rf "$TMP_DIR"

# vim: shiftwidth=2 tabstop=2 softtabstop=2
