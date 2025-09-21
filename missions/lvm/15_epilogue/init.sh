#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_init() (

  lvm_init "15" > /dev/null 2>&1

  # Display epilogue message
  parchment -B Twinkle "$(eval_gettext '$MISSION_DIR/msg/en.txt')"

  
  echo "Vous pouvez rester explorer un peu le royaume et la nouvelle république des USA, et faire gsh quand vous avez fini !"

  cat $MISSION_DIR/msg/flag.txt > $GSH_HOME/USA/flag.txt

  return $?

)

_mission_init
