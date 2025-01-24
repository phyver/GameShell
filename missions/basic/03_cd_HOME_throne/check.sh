#!/usr/bin/env sh

# this should be POSIX compliant, but debian's sh (dash) doesn't have fc!

_mission_check() {
  goal=$(readlink-f "$(eval_gettext "\$GSH_HOME/Castle/Main_building/Throne_room")")
  current=$(readlink-f "$PWD")


  # Verify the current location
  if [ "$goal" != "$current" ]; then
    echo "$(gettext "You are not in the throne room.")"
    return 1
  fi


  ppc=$(. fc-lnr.sh | grep -v '^[[:blank:]]*gsh' | sed -n '2p;3q')

  if echo "$ppc" | grep -q "^[[:blank:]]*\(cd\|cd[[:blank:]][[:blank:]]*\~\)[[:blank:]]*$"; then
      # Accepts only "cd" and "cd ~"
      return 0
  fi

  # "cd ../../../../" and variants are not valid.
  if echo "$ppc" | grep -q "^[[:blank:]]*cd[[:blank:]][[:blank:]]*\.\..*$"; then
      echo "$(gettext "The previous to last command is too complex.")"
  else
     echo "$(gettext "The previous to last command must take you to the starting point.")"
  fi

  return 1
}

_mission_check
