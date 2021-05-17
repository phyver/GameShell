#!/usr/bin/env bash

if [ -z "$BASH_SOURCE" ] || ! [ -f "$BASH_SOURCE" ]
then
  echo "GameShell must be run with Bash from a file."
  exit 1
fi

FILENAME="$0"
DIR=$(dirname "$FILENAME")

NB_LINES=$(awk '/^##START_OF_GAMESHELL_ARCHIVE##/ {print NR + 1; exit 0; }' "$FILENAME")

for arg in "$@"
do
  if [ "$arg" = "-X" ]
  then
    tail -n+"$NB_LINES" "$FILENAME" > "${FILENAME%.*}.tgz"
    echo "Archive saved in ${FILENAME%.*}.tgz"
    exit 0
  elif [ "$arg" = "-K" ]
  then
    KEEP_DIR="true"
  fi
done


TMP_DIR=$(mktemp -d "$DIR/GameShell-XXXXXX")

tail -n+"$NB_LINES" "$FILENAME" > "$TMP_DIR/gameshell.tgz"
tar -zx -C "$TMP_DIR" -f "$TMP_DIR/gameshell.tgz"
rm "$TMP_DIR/gameshell.tgz"

ROOT_DIR=$(ls "$TMP_DIR" | head -n1)

bash "$TMP_DIR/$ROOT_DIR"/start.sh "$@"

tar -zcf "$TMP_DIR/$ROOT_DIR.tgz" -C "$TMP_DIR" ./"$ROOT_DIR"

# get extension
EXT=${FILENAME##*.}
# remove extension
FILENAME=${FILENAME%.*}
# remove "-save" suffix (if present), and add it again, with the extension
FILENAME=${FILENAME%-save}-save.$EXT

cat "$TMP_DIR/$ROOT_DIR/lib/header.sh" "$TMP_DIR/$ROOT_DIR.tgz" > "$FILENAME"
chmod +x "$FILENAME"

chmod -R 777 "$TMP_DIR"
if [ "$KEEP_DIR" = "true" ]
then
  rm -f "$TMP_DIR/$ROOT_DIR.tgz"
else
  rm -rf "$TMP_DIR"
fi

exit 0

##START_OF_GAMESHELL_ARCHIVE##
