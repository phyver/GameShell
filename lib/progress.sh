#!/bin/bash

BAT1='\,/'
BAT2='/`\'
COUNT=0

printf "While you are waiting, a bat flies by...\n"

# Move the bat on each character input until 'e' is read.
while read -rn1 C
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

# Clear the bat.
printf "\r"
for I in $(seq 0 "$((COUNT+4))")
do
  printf " "
done
printf "\r"
