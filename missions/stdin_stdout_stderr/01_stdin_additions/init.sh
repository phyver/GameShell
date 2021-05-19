#!/bin/bash

_mission_init() {
  local results=$GSH_VAR/additions.txt
  rm -f "$results"
  local questions=$GSH_VAR/arith.txt
  rm -f "$questions"

  for _ in $(seq 5)
  do
    local a=$((1+RANDOM%100))
    local b=$((1+RANDOM%100))
    local r=$((a + b))
    echo $r >> "$results"
    echo "$a + $b = ?? |$r" >> "$questions"
  done
}

_mission_init
