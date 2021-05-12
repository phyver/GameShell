#!/bin/bash

# Print a progress bar as a flying bat: each character received on
# [stdin] makes the bat move forward. The animation stops when the
# end of file is reached.
progress_bat () {
  local PIPE="$1"
  local BAT1='\,/'
  local BAT2='/`\'
  local COUNT=0
  local I

  # Print initial message.
  printf "While you are waiting, a bat flies by...\n"

  # Make progress for each character read on [stdin].
  while read -rn1 C
  do
    printf "\r"

    for I in $(seq 0 "$COUNT")
    do
      printf " "
    done

    if ((COUNT % 8 < 4))
    then
      printf "%s" "$BAT1";
    else
      printf "%s" "$BAT2";
    fi

    COUNT=$((COUNT+1))

    # Slow down the animation a little bit.
    sleep 0.05
  done

  # Clear the line with the bat.
  printf "\r"
  for I in $(seq 0 "$((COUNT+4))")
  do
    printf " "
  done
  printf "\r"
}
