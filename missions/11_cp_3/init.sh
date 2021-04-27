#!/bin/bash

[ -z "$GASH_CHEST" ] && GASH_CHEST="$(eval_gettext '$GASH_HOME/Forest/Cabin/Chest')"
mkdir -p "$GASH_CHEST"

find "$GASH_HOME" -iname "$(gettext "painting")_*" -print0 | xargs -0 rm -rf

filename=$(mktemp "$(eval_gettext '$GASH_HOME/Castle/Dungeon/First_floor')"/$(gettext "painting")_XXXXXX)
parchment "$MISSION_DIR/painting-pipe" Diamond > "$filename"
Y=$((1980 + RANDOM%10))
M=$(echo 0$((1 + RANDOM%12)) | cut -c 1-2)
D=$(echo 0$((1 + RANDOM%28)) | cut -c 1-2)
h=$(echo 0$((RANDOM%24)) | cut -c 1-2)
m=$(echo 0$((RANDOM%60)) | cut -c 1-2)
s=$(echo 0$((RANDOM%60)) | cut -c 1-2)
touch -t "$Y$M$D$h$m.$s" "$filename"
echo "$(basename "$filename")" > "$GASH_MISSION_DATA/painting"
checksum < "$filename" >> "$GASH_MISSION_DATA/painting"

filename=$(mktemp "$(eval_gettext '$GASH_HOME/Castle/Dungeon/First_floor')"/$(gettext "painting")_XXXXXX)
parchment "$MISSION_DIR/painting-star_wars" Diamond > "$filename"
touch "$filename"

filename=$(mktemp "$(eval_gettext '$GASH_HOME/Castle/Dungeon/First_floor')"/$(gettext "painting")_XXXXXX)
parchment "$MISSION_DIR/painting-joconde" Diamond  > "$filename"
Y=$(date +%Y)
Y=$((Y + 1 + RANDOM%10))
M=$(echo 0$((1 + RANDOM%12)) | cut -c 1-2)
D=$(echo 0$((1 + RANDOM%28)) | cut -c 1-2)
h=$(echo 0$((RANDOM%24)) | cut -c 1-2)
m=$(echo 0$((RANDOM%60)) | cut -c 1-2)
s=$(echo 0$((RANDOM%60)) | cut -c 1-2)
touch -t "$Y$M$D$h$m.$s" "$filename"

unset filename Y M D h m s
