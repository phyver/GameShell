#!/bin/bash

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

find "$GSH_HOME" -iname "$(gettext "painting")_*" -print0 | xargs -0 rm -rf

filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
parchment "$MISSION_DIR/painting-pipe" Diamond > "$filename"
Y=$((1980 + RANDOM%10))
M=$(echo 0$((1 + RANDOM%12)) | cut -c 1-2)
D=$(echo 0$((1 + RANDOM%28)) | cut -c 1-2)
h=$(echo 0$((RANDOM%24)) | cut -c 1-2)
m=$(echo 0$((RANDOM%60)) | cut -c 1-2)
s=$(echo 0$((RANDOM%60)) | cut -c 1-2)
touch -t "$Y$M$D$h$m.$s" "$filename"
echo "$(basename "$filename")" > "$GSH_VAR/painting"
checksum < "$filename" >> "$GSH_VAR/painting"

filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
parchment "$MISSION_DIR/painting-star_wars" Diamond > "$filename"
touch "$filename"

filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
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
