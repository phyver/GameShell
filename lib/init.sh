#!/bin/bash

if [ -z "$BASH_SOURCE" ]
then
    echo "GameShell must be run with Bash from a file."
    exit 1
fi

EXE=$(basename "$0")
DIR=$(dirname "$0")

TMPDIR=$(mktemp -d "$DIR/GameShell-XXXXXX")

NB_LINES=$(awk '/^##START_OF_GAMESHELL_ARCHIVE##/ {print NR + 1; exit 0; }' $0)

tail -n+$NB_LINES $0 | tar -zx -C $TMPDIR

bash "$TMPDIR"/GameShell/start.sh "$@"

OLDDIR="$PWD"
cd "$TMPDIR"
tar -zcf "GameShell.tgz" "./GameShell/"
cd "$OLDDIR"

filename=${EXE%.sh}
filename=${filename%-save*}
filename="$DIR/$filename-save"
suffix=""
# while [ -f "$filename$suffix.sh" ]
# do
#     suffix=${suffix#_}
#     suffix="_$(echo -n "00$((suffix + 1))" | tail -c3)"
# done

cat "$TMPDIR/GameShell/lib/init.sh" "$TMPDIR/GameShell.tgz" > "$filename$suffix.sh"
chmod +x "$filename$suffix.sh"

rm -rf $TMPDIR

exit 0

##START_OF_GAMESHELL_ARCHIVE##
