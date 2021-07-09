#!/bin/sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_init() (
  find "$GSH_HOME" -iname "$(gettext "painting")_*" -print0 | xargs -0 rm -rf

  cd "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"

  i=$(RANDOM)
  i=$((1+i%3))

  for _ in $(seq 100)
  do
    filename="$(gettext "painting")_$(random_string 8)"
    [ -e "$filename" ] || break
  done
  if [ -e "$filename" ]
  then
    echo "$(gettext "Problem with generation of random filename!")" >&2
    return 1
  fi
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-$i" > "$filename"
  Y=$((1980 + $(RANDOM)%10))
  M=$(printf "%02d" $((1 + $(RANDOM)%12)))
  D=$(printf "%02d" $((1 + $(RANDOM)%28)))
  h=$(printf "%02d" $(($(RANDOM)%24)))
  m=$(printf "%02d" $(($(RANDOM)%60)))
  s=$(printf "%02d" $(($(RANDOM)%60)))
  basename "$filename" > "$GSH_TMP/painting"
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"

  i=$((1+i%3))
  for _ in $(seq 100)
  do
    filename="$(gettext "painting")_$(random_string 8)"
    [ -e "$filename" ] || break
  done
  if [ -e "$filename" ]
  then
    echo "$(gettext "Problem with generation of random filename!")" >&2
    return 1
  fi
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-$i" > "$filename"
  Y=$((1995 + $(RANDOM)%10))
  M=$(printf "%02d" $((1 + $(RANDOM)%12)))
  D=$(printf "%02d" $((1 + $(RANDOM)%28)))
  h=$(printf "%02d" $(($(RANDOM)%24)))
  m=$(printf "%02d" $(($(RANDOM)%60)))
  s=$(printf "%02d" $(($(RANDOM)%60)))
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"

  i=$((1+i%3))
  for _ in $(seq 100)
  do
    filename="$(gettext "painting")_$(random_string 8)"
    [ -e "$filename" ] || break
  done
  if [ -e "$filename" ]
  then
    echo "$(gettext "Problem with generation of random filename!")" >&2
    return 1
  fi
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-$i" > "$filename"
  Y=$((2010 + $(RANDOM)%10))
  M=$(printf "%02d" $((1 + $(RANDOM)%12)))
  D=$(printf "%02d" $((1 + $(RANDOM)%28)))
  h=$(printf "%02d" $(($(RANDOM)%24)))
  m=$(printf "%02d" $(($(RANDOM)%60)))
  s=$(printf "%02d" $(($(RANDOM)%60)))
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"
)

_mission_init
