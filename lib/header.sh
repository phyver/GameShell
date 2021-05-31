#!/usr/bin/env bash

if [ -z "$BASH_SOURCE" ] || ! [ -f "$BASH_SOURCE" ]
then
  echo "GameShell must be run with Bash from a file."
  exit 1
fi

ORIGINAL_FILENAME="$0"
ORIGINAL_DIR=$(dirname "$ORIGINAL_FILENAME")

NB_LINES=$(awk '/^##START_OF_GAMESHELL_ARCHIVE##/ {print NR + 1; exit 0; }' "$ORIGINAL_FILENAME")

for arg in "$@"
do
  if [ "$arg" = "-X" ]
  then
    tail -n+"$NB_LINES" "$ORIGINAL_FILENAME" > "${ORIGINAL_FILENAME%.*}.tgz"
    echo "Archive saved in ${ORIGINAL_FILENAME%.*}.tgz"
    exit 0
  elif [ "$arg" = "-K" ]
  then
    KEEP_DIR="true"
  fi
done


# remove extension (if present)
GSH_NAME=${ORIGINAL_FILENAME%.*}
# remove "-save" suffix (if present)
GSH_NAME=${GSH_NAME%-save}
GSH_NAME=$(basename "$GSH_NAME")

GSH_ROOT=$ORIGINAL_DIR/$GSH_NAME
N=0
while [ -e "$GSH_ROOT" ]
do
  N=$((N+1))
  GSH_ROOT=$(echo "$GSH_ROOT" | sed "s/\.[0-9]*$//")
  GSH_ROOT="$GSH_ROOT.$N"
done
mkdir -p "$GSH_ROOT"

tail -n+"$NB_LINES" "$ORIGINAL_FILENAME" > "$GSH_ROOT/gameshell.tgz"
tar -zx -C "$GSH_ROOT" -f "$GSH_ROOT/gameshell.tgz"
rm "$GSH_ROOT/gameshell.tgz"

# the archive should extract into a directory, move everything to GSH_ROOT
TMP_ROOT=$(find "$GSH_ROOT" -maxdepth 1 -path "$GSH_ROOT/*" -print -quit)
mv "$TMP_ROOT"/* "$GSH_ROOT"
mv "$TMP_ROOT"/.[!.]* "$GSH_ROOT" 2>/dev/null
rmdir "$TMP_ROOT"

###
# start GameShell
bash "$GSH_ROOT/start.sh" -C "$@"


tar -zcf "$GSH_ROOT.tgz" -C "$ORIGINAL_DIR" ./"$GSH_ROOT"

# get extension
EXT=${ORIGINAL_FILENAME##*.}
# remove extension
ORIGINAL_FILENAME=${ORIGINAL_FILENAME%.*}
# remove "-save" suffix (if present), and add it again, with the extension
ORIGINAL_FILENAME=${ORIGINAL_FILENAME%-save}-save.$EXT

cat "$GSH_ROOT/lib/header.sh" "$GSH_ROOT.tgz" > "$ORIGINAL_FILENAME"
chmod +x "$ORIGINAL_FILENAME"

# remove archive
rm -f "$GSH_ROOT.tgz"

if [ "$KEEP_DIR" != "true" ]
then
  chmod -R 777 "$GSH_ROOT"
  rm -rf "$GSH_ROOT"
fi

exit 0

##START_OF_GAMESHELL_ARCHIVE##
