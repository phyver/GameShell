#!/bin/sh

if command ls --color >/dev/null 2>/dev/null
then
  # standard linux
  cat "$(eval_gettext '$MISSION_DIR/treasure-msg/it.txt')"
elif command ls -G >/dev/null 2>/dev/null
then
  # freebsd, macOS use another flag for colors: -G
  cat "$(eval_gettext '$MISSION_DIR/treasure-msg/it.txt')"
else
  # openbsd doesn't use colors at all
  :
fi


