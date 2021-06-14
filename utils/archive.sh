#!/bin/sh

export GSH_ROOT=$(dirname "$0")/..
. $GSH_ROOT/lib/profile.sh

display_help() {
cat <<EOH
$(basename "$0") [OPTIONS] [MISSIONS]
create a GameShell standalone archive

options:
  -h          this message

  -p ...      choose password for admin commands
  -P          use the "passport mode" by default when running GameShell
  -A          use the "anonymous mode" by default when running GameShell
  -L LANGS    only keep the given languages (ex: -L 'en*,fr')

  -N ...      name of the archive / top directory (default: "gameshell")

  -a          keep 'auto.sh' scripts for missions that have one
  -t          keep 'test.sh' scripts for missions that have one
  -z          keep tgz archive
EOH
}

keep_language() {
  filename=$(basename "$1")
  languages=$2
  set -f    # disable globing
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

NAME="gameshell"
ADMIN_PASSWD="gsh"
KEEP_AUTO=0
KEEP_TEST=0
DEFAULT_MODE="ANONYMOUS"
KEEP_TGZ=0
GENERATE_MO=1
KEEP_PO=0
LANGUAGES=""

while getopts ":hp:N:atPzL:" opt
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
    t)
      KEEP_TEST=1
      ;;
    P)
      DEFAULT_MODE="PASSPORT"
      ;;
    z)
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
shift $((OPTIND - 1))

OUTPUT_DIR=$(dirname "$NAME")
NAME=$(basename "$NAME")

TMP_DIR=$(mktemp -d)
mkdir "$TMP_DIR/$NAME"


# copy source files
# NOTE: macOS' cp doesn't have '--archive', and '-a' is not POSIX.
# use POSIX options to make sure it is portable
cp -RPp "$GSH_ROOT/start.sh" "$GSH_ROOT/bin" "$GSH_ROOT/utils" "$GSH_ROOT/lib" "$GSH_ROOT/i18n" "$TMP_DIR/$NAME"

# copy missions
mkdir "$TMP_DIR/$NAME/missions"
echo "copy missions"
if ! make_index "$@" > "$TMP_DIR/$NAME/missions/index.txt"
then
  echo "Error: archive.sh, couldn't make index.txt"
  rm -rf "$TMP_DIR"
  exit 1
fi

cat "$TMP_DIR/$NAME/missions/index.txt" | while read MISSION_DIR
do
  case $MISSION_DIR in
    "" | "#"* )
      continue
      ;;
    "!"*)
      MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
      ;;
  esac
  echo "  -> copy $MISSION_DIR"
  mkdir -p "$TMP_DIR/$NAME/missions/$MISSION_DIR"
  ARCHIVE_MISSION_DIR=$TMP_DIR/$NAME/missions/$MISSION_DIR
  # NOTE: macOS' cp doesn't have '--archive', and '-a' is not POSIX.
  # use POSIX options to make sure it is portable
  cp -RPp "$GSH_MISSIONS/$MISSION_DIR"/* "$ARCHIVE_MISSION_DIR"
done

# define new GSH_ROOT
export GSH_ROOT="$TMP_DIR/$NAME"
. "$GSH_ROOT/lib/profile.sh"
export GSH_MISSIONS="$GSH_ROOT/missions"


# remove unwanted languages
if [ -n "$LANGUAGES" ]
then
  echo "removing unwanted languages"
  find "$GSH_ROOT" -path "*/i18n/*.po" | while read po_file
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
  printf "generating '.mo' files: "
  {
    # gameshell
    export TEXTDOMAINDIR="$GSH_ROOT/locale"
    export TEXTDOMAIN="gsh"
    for PO_FILE in "$GSH_ROOT"/i18n/*.po; do
      PO_LANG=$(basename "$PO_FILE" .po)
      mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
      msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" "$PO_FILE"
    done
    printf "."

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
        # NOTE: nullglob don't expand in POSIX sh and there is no equivalent to
        # shopt -s nullglob as in bash
        if [ -n "$(find "$MISSION_DIR/i18n" -maxdepth 1 -name '*.po' | head -n1)" ]
        then
          for PO_FILE in "$MISSION_DIR"/i18n/*.po; do
            PO_LANG=$(basename "$PO_FILE" .po)
            mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
            msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" "$PO_FILE"
            printf "."
          done
        fi
      fi
    done < "$GSH_ROOT/missions/index.txt"
    echo
  }
fi

# remove "_" files
echo "removing unnecessary files"
(
  cd "$GSH_ROOT"
  # no need to use find -print0 / xargs -0 because GameShell won't have strange filenames.
  find . -name "a.out" | xargs rm -f
  find . -name "*~" | xargs rm -f
  find . -name "_*.sh" | xargs rm -f
  find . -name "Makefile" | xargs rm -f
  find . -name "template.pot" | xargs rm -f
  [ "$KEEP_PO" -ne 1 ] && [ "$GENERATE_MO" -eq 1 ] && find . -name "*.po" | xargs rm -f

  [ "$KEEP_TEST" -ne 1 ] && echo "remove tests" && find ./missions -name "test.sh" | xargs rm -f
  [ "$KEEP_AUTO" -ne 1 ] && find ./missions -name auto.sh | xargs rm -f

  # rm -f "$GSH_ROOT/bin/boxes-data.awk" "$GSH_ROOT/utils/archive.sh"
)

# change admin password
echo "setting admin password"
ADMIN_HASH=$(checksum "$ADMIN_PASSWD")
sed-i "s/^\\([[:blank:]]*\\)ADMIN_HASH=.*/\\1ADMIN_HASH='$ADMIN_HASH'/" "$GSH_ROOT/start.sh"

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
