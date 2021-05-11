#!/bin/bash

new_progress () {
  # Get a temporary file name.
  local PIPE
  PIPE=$(mktemp gsh_progress_pipe.XXXX)

  # Create a named pipe and return the file name.
  rm -f "$PIPE"
  mkfifo "$PIPE"
  echo "$PIPE"
}

progress_step () {
  if [ "$#" -ne 1 ]
  then
    echo "Function [progress_step] expects exactly one argument."
    return 1
  fi

  local PIPE="$1"

  if [ ! -p "$PIPE" ]
  then
    echo "The file [$PIPE] does not exist."
    return 1
  fi

  echo "." > "$PIPE"
}

progress_done () {
  if [ "$#" -ne 1 ]
  then
    echo "Function [progress_done] expects exactly one argument."
    return 1
  fi

  local PIPE="$1"

  if [ ! -p "$PIPE" ]
  then
    echo "The file [$PIPE] does not exist."
    return 1
  fi

  echo "e" > "$PIPE"

  # Wait acknowledgment.
  while [ -p "$PIPE" ]
  do
    :
  done
}

_progress_start () {
  local PIPE="$1"
  local BAT1='\,/'
  local BAT2='/`\'
  local COUNT=0
  local I

  # Print initial message.
  printf "While you are waiting, a bat flies by...\n"

  # Interactive part.
  while read -rn1 C < "$PIPE"
  do
    if [ "$C" == "e" ]
    then
      break
    fi

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
  done

  # Clear the line with the bat.
  printf "\r"
  for I in $(seq 0 "$((COUNT+4))")
  do
    printf " "
  done
  printf "\r"

  # Remove the pipe.
  rm -f "$PIPE"
}

progress_start () {
  if [ "$#" -ne 1 ]
  then
    echo "Function [progress_start] expects exactly one argument."
    return 1
  fi

  local PIPE="$1"

  if [ ! -p "$PIPE" ]
  then
    echo "The file [$PIPE] does not exist."
    return 1
  fi

  _progress_start "$PIPE"&
}
