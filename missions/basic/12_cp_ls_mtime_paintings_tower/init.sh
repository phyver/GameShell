#!/bin/sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_init() (
  find "$GSH_HOME" -iname "$(gettext "painting")_*" -print0 | xargs -0 rm -rf

  cd "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"

  while true
  do
    filename="$(gettext "painting")_$(random_string 8)"
    [ -e "$filename" ] || break
  done
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-pipe" > "$filename"
  Y=$((1980 + $(RANDOM)%10))
  M=$(printf "%02d" $((1 + $(RANDOM)%12)))
  D=$(printf "%02d" $((1 + $(RANDOM)%28)))
  h=$(printf "%02d" $(($(RANDOM)%24)))
  m=$(printf "%02d" $(($(RANDOM)%60)))
  s=$(printf "%02d" $(($(RANDOM)%60)))
  echo "$(basename "$filename")" > "$GSH_TMP/painting"
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"

  while true
  do
    filename="$(gettext "painting")_$(random_string 8)"
    [ -e "$filename" ] || break
  done
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-star_wars" > "$filename"
  sign_file "$filename"
  touch "$filename"

  while true
  do
    filename="$(gettext "painting")_$(random_string 8)"
    [ -e "$filename" ] || break
  done
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-joconde" > "$filename"
  Y=$(date +%Y)
  Y=$((Y + 1 + $(RANDOM)%10))
  M=$(printf "%02d" $((1 + $(RANDOM)%12)))
  D=$(printf "%02d" $((1 + $(RANDOM)%28)))
  h=$(printf "%02d" $(($(RANDOM)%24)))
  m=$(printf "%02d" $(($(RANDOM)%60)))
  s=$(printf "%02d" $(($(RANDOM)%60)))
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"
)

_mission_init
