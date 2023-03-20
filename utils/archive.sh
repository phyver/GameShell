#!/usr/bin/env sh

export GSH_ROOT=$(dirname "$0")/..
. $GSH_ROOT/lib/profile.sh

display_help() {
cat <<EOH
$(basename "$0") [OPTIONS] [MISSIONS]
create a GameShell standalone archive

options:
  -h              this message

  --password=...  choose password for admin commands
  -P              use the "passport mode" by default when running GameShell
  -A              use the "anonymous mode" by default when running GameShell
  -L LANGS        only keep the given languages (ex: -L 'en*,fr')
  -E              only keep english as a language, not generating any ".mo" file
                  and not using gettext

  -N ...          name of the archive / top directory (default: "gameshell")

  --simple-savefiles
  --index-savefiles
  --overwrite-savefiles
                  choose default savefile mode

  -a              keep 'auto.sh' scripts for missions that have one
  -t              keep 'test.sh' scripts for missions that have one
  -z              keep tgz archive

  -v              show the list of mission directories as they are being processed
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
KEEP_PO=0     # this is set to 1 if we generate .mo files. Setting it to 1 here
# (or before generating .mo files) will keep the .po files
LANGUAGES=""
VERBOSE=

# hack to parse long option --password
# cf https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options
_long_option=0
while getopts ":hp:N:atPzL:Ev-:" opt
do
  if [ "$opt" = "-" ]
  then
    opt="${OPTARG%%=*}"       # extract long option name
    OPTARG="${OPTARG#$opt}"   # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
    _long_option=1
  fi

  case $opt in
    h)
      display_help
      exit 0;
      ;;
    password)
      ADMIN_PASSWD=$OPTARG
      ;;
    N)
      NAME=$OPTARG
      ;;
    index-savefiles)
      GSH_SAVEFILE_MODE=index
      ;;
    simple-savefiles)
      GSH_SAVEFILE_MODE=simple
      ;;
    overwrite-savefiles)
      GSH_SAVEFILE_MODE=overwrite
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
    E)
      LANGUAGES=
      KEEP_PO=0
      GENERATE_MO=0
      GSH_NO_GETTEXT=1
      ;;
    v)
      VERBOSE=1
      ;;
    *)
      if [ "$_long_option" = "1" ]
      then
        OPTARG="-$opt"
      fi
      echo "invalid option: '-$OPTARG'" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

OUTPUT_DIR=$(dirname "$NAME")
NAME=$(basename "$NAME")

# don't use mktemp -d, which might not exist
for _ in $(seq 100)
do
  n=$((n+1))
  TMP_DIR="$OUTPUT_DIR/tmp-$(printf "%03d" $n)"
  [ -e "$TMP_DIR" ] || break
done
if [ -e "$TMP_DIR" ]
then
  echo "Problem with generation of random dirname!" >&2
  return 1
fi
mkdir "$TMP_DIR"
mkdir "$TMP_DIR/$NAME"


# copy source files
# NOTE: macOS' cp doesn't have '--archive', and '-a' is not POSIX.
# use POSIX options to make sure it is portable
cp -RPp "$GSH_ROOT/start.sh" "$GSH_ROOT/scripts" "$GSH_ROOT/utils" "$GSH_ROOT/lib" "$GSH_ROOT/i18n" "$TMP_DIR/$NAME"

# copy missions
mkdir "$TMP_DIR/$NAME/missions"
if [ -z "$VERBOSE" ]
then
  printf "copying missions: "
else
  echo "copying missions"
fi

if ! make_index "$@" > "$TMP_DIR/$NAME/missions/index.txt"
then
  echo "Error: archive.sh, couldn't make index.txt"
  # --system makes GameShell use the standard rm utility instead of the "safe"
  # rm implemented in scripts/rm
  rm --system -rf "$TMP_DIR"
  exit 1
fi

NB_MISSIONS=0
NB_DUMMY=0
cat "$TMP_DIR/$NAME/missions/index.txt" | while read MISSION_DIR
do
  DUMMY=
  case $MISSION_DIR in
    "" | "#"* )
      continue
      ;;
    "!"*)
      MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
      NB_DUMMY=$((NB_DUMMY + 1))
      DUMMY=1
      ;;
  esac
  NB_MISSIONS=$((NB_MISSIONS + 1))
  if [ -z "$VERBOSE" ]
  then
    if [ -z "$DUMMY" ]
    then
      printf "."
    else
      printf "!"
    fi
  else
    if [ -z "$DUMMY" ]
    then
      echo "  - $MISSION_DIR"
    else
      echo "  ! $MISSION_DIR (dummy)"
    fi
  fi
  mkdir -p "$TMP_DIR/$NAME/missions/$MISSION_DIR"
  ARCHIVE_MISSION_DIR=$TMP_DIR/$NAME/missions/$MISSION_DIR
  # NOTE: macOS' cp doesn't have '--archive', and '-a' is not POSIX.
  # use POSIX options to make sure it is portable
  cp -RPp "$GSH_MISSIONS/$MISSION_DIR"/* "$ARCHIVE_MISSION_DIR"
done
[ -n "$VERBOSE" ] || echo

# define new GSH_ROOT
export GSH_ROOT="$TMP_DIR/$NAME"
. "$GSH_ROOT/lib/profile.sh"
export GSH_MISSIONS="$GSH_ROOT/missions"


# default GSH_NO_GETTEXT to 1 if -E was used
if [ -n "$GSH_NO_GETTEXT" ]
then
  sed-i "s/^# export GSH_NO_GETTEXT=./export GSH_NO_GETTEXT=1/" "$GSH_ROOT/start.sh"
fi

# remove unwanted languages
if [ -n "$LANGUAGES" ]
then
  echo "removing unwanted languages"
  find "$GSH_ROOT" -path "*/i18n/*.po" | while read po_file
  do
    if ! keep_language "${po_file%.po}" "$LANGUAGES"
    then
      # --system makes GameShell use the standard rm utility instead of the "safe"
      # rm implemented in scripts/rm
      rm --system -f "$po_file"
    fi
  done
fi

# generate .mo files
if [ "$GENERATE_MO" -eq 1 ] && command -v msgfmt >/dev/null
then
  KEEP_PO=${KEEP_PO:-0}
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
          done
          printf "."
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
  # --system makes GameShell use the standard rm utility instead of the "safe"
  # rm implemented in scripts/rm
  find . -name "a.out" | xargs rm --system -f
  find . -name "*~" | xargs rm --system -f
  find . -name "_*.sh" | xargs rm --system -f
  find . -name "Makefile" | xargs rm --system -f
  find . -name "template.pot" | xargs rm --system -f
  [ "$KEEP_PO" -eq 0 ] && find . -name "*.po" | xargs rm --system -f
  [ "$KEEP_TEST" -ne 1 ] && find ./missions -name "test.sh" | xargs rm --system -f
  [ "$KEEP_AUTO" -ne 1 ] && find ./missions -name auto.sh | xargs rm --system -f

  # rm --system -f "$GSH_ROOT/scripts/boxes-data.awk" "$GSH_ROOT/utils/archive.sh"
)

# change admin password
echo "setting admin password"
ADMIN_SALT=$($GSH_ROOT/scripts/random_string)
ADMIN_HASH=$(checksum "$ADMIN_SALT $ADMIN_PASSWD")
sed-i "s/^\\([[:blank:]]*\\)ADMIN_SALT=.*/\\1ADMIN_SALT='$ADMIN_SALT'/" "$GSH_ROOT/start.sh"
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

# choose default savefile mode
if [ -n "$GSH_SAVEFILE_MODE" ]
then
  sed-i "s/^export GSH_SAVEFILE_MODE=.*$/export GSH_SAVEFILE_MODE='$GSH_SAVEFILE_MODE'/" "$GSH_ROOT/start.sh"
fi

# record version
if git rev-parse --is-inside-work-tree >/dev/null 2>&1
then
  GSH_VERSION=$(git describe --always --dirty)
  sed-i "s/^GSH_VERSION=.*/GSH_VERSION='$GSH_VERSION'/" "$GSH_ROOT/scripts/_gsh_version"
  sed-i "s/^GSH_VERSION=.*/GSH_VERSION='$GSH_VERSION'/" "$GSH_ROOT/lib/header.sh"
  sed-i "s/^GSH_LAST_CHECKED_MISSION=.*/GSH_LAST_CHECKED_MISSION=''/" "$GSH_ROOT/lib/header.sh"
fi

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
  # --system makes GameShell use the standard rm utility instead of the "safe"
  # rm implemented in scripts/rm
  rm --system "$OUTPUT_DIR/$NAME.tgz"
fi

echo "removing temporary directory"
# --system makes GameShell use the standard rm utility instead of the "safe"
# rm implemented in scripts/rm
rm --system -rf "$TMP_DIR"

# vim: shiftwidth=2 tabstop=2 softtabstop=2
