#!/bin/bash

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
  fi
done


TMP_DIR=$(mktemp -d "$DIR/GameShell-XXXXXX")

tail -n+"$NB_LINES" "$FILENAME" | tar -zx -C "$TMP_DIR"

ROOT_DIR=$(ls "$TMP_DIR" | head -n1)

bash "$TMP_DIR/$ROOT_DIR"/start.sh "$@"

tar -zcf "$TMP_DIR/$ROOT_DIR.tgz" -C "$TMP_DIR" ./"$ROOT_DIR"

# get extension
EXT=${FILENAME##*.}
# remove extension
FILENAME=${FILENAME%.*}
# remove "-save" suffix (if present), and add it again, with the extension
FILENAME=${FILENAME%-save}-save.$EXT

cat "$TMP_DIR/$ROOT_DIR/lib/init.sh" "$TMP_DIR/$ROOT_DIR.tgz" > "$FILENAME"
chmod +x "$FILENAME"

chmod -R 777 "$TMP_DIR"
rm -rf "$TMP_DIR"

exit 0

##START_OF_GAMESHELL_ARCHIVE##
