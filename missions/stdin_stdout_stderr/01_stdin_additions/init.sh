#!/bin/sh

_mission_init() (
  results=$GSH_VAR/additions.txt
  rm -f "$results"
  questions=$GSH_VAR/arith.txt
  rm -f "$questions"

  for _ in $(seq 5)
  do
    a=$((1+$(RANDOM)%100))
    b=$((1+$(RANDOM)%100))
    r=$((a + b))
    echo $r >> "$results"
    echo "$a + $b = ?? |$r" >> "$questions"
  done
)

_mission_init
