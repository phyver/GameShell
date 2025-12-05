#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_init() (

  lvm_init "15" 

  # Display epilogue message
  parchment -B Twinkle "$(eval_gettext '$MISSION_DIR/msg/en.txt')"

  
  echo "$(eval_gettext "You can stay and explore the kingdom and the new USA republic a bit, and type gsh when you're done!")"

  cat $MISSION_DIR/msg/flag.txt > $GSH_HOME/USA/flag.txt

  return $?

)

_mission_init
