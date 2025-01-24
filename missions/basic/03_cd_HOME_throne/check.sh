#!/usr/bin/env sh

# this should be POSIX compliant, but debian's sh (dash) doesn't have fc!

_mission_check() {
  goal=$(readlink-f "$(eval_gettext "\$GSH_HOME/Castle/Main_building/Throne_room")")
  current=$(readlink-f "$PWD")

  ppc=$(. fc-lnr.sh | sed -n '2p;3q')

  # Accepts only "cd" and "cd ~". "cd ../../../../" and variants are not valid.
  if [ "$ppc" != "cd" ] && [ "$ppc" != "cd ~" ]; then
    if [ "$ppc" =~ "cd ../*" ]; then
      echo "$(gettext "The command to go to the starting point is too complicated.")"
    else
      echo "$(gettext "The previous to last command must take you to the starting point.")"
    fi
    return 1
  fi

  # Verify the current location
  if [ "$goal" != "$current" ]; then
    echo "$(gettext "You are not in the throne room.")"
    return 1
  fi

  return 0
}

_mission_check
