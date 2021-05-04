#!/bin/bash

# parse a single mission
parse_mission() {
  local MISSION_DIR=$1
  case $MISSION_DIR in
     # "dummy" mission: it will only be used during the initialisation phase
    "!"*)
      DUMMY="!"
      MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
      ;;

    # standard mission
    *)
      DUMMY=""
      ;;
  esac

  # if the mission is in fact a file, we assume it is an index file,
  # we call parse_index recursively
  if [ -f "$MISSION_DIR" ]
  then
    parse_index "$MISSION_DIR"
  elif [ -d "$MISSION_DIR" ]
  then
    # if a directory contains index.txt, call parse_index recursively
    if  [ -f "$MISSION_DIR/index.txt" ]
    then
      parse_index "$MISSION_DIR/index.txt"

    # if a directory contains a check.sh script, it is a standard mission
    elif  [ -f "$MISSION_DIR/check.sh" ] || [ -n "$DUMMY" ]
    then
      echo "$DUMMY${MISSION_DIR#$GASH_MISSIONS/}"

    # when given a directory containing either a "bin" directory or a
    # "static.sh" script, this is a dummy mission. Just print the path
    # prefixed with a "!"
    elif [ -f "$MISSION_DIR/static.sh" ] || [ -d "$MISSION_DIR/bin" ]
    then
      echo "!${MISSION_DIR#$GASH_MISSIONS/}"

    else
      echo "        invalid argument (parse_mission): $MISSION_DIR" >&2
    fi
  else
    echo "        invalid argument (parse_mission): $MISSION_DIR" >&2
  fi
}


# generate an index of missions
# parse_index take a single argument: a path to an index file
parse_index() {
  local index_file=$(REALPATH "$1")
  local dir DUMMY

  case "$index_file" in
    "$GASH_MISSIONS"* )
      # if the index file lives under $GASH_MISSIONS, the "current root
      # directory" for missions is just dirname $index_file: all missions read
      # from the file will be relative to $dir
      dir=$(dirname "$index_file")
      ;;
    *)
      # otherwise, we assume all the missions in the file are given relative to
      # $GASH_MISSIONS
      dir=$GASH_MISSIONS
      ;;
  esac

  cat "$index_file" | while read MISSION_DIR
  do
  case $MISSION_DIR in
    # ignore comments and empty lines
    "" | "#"* )
      continue
      ;;

     # "dummy" mission: it will only be used during the initialisation phase
    "!"*)
      DUMMY="!"
      MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
      ;;

    # standard mission
    *)
      DUMMY=""
      ;;
  esac
  parse_mission "$DUMMY$(REALPATH "$dir/$MISSION_DIR")"
  done
}

make_index() {
  if [ "$#" -eq 0 ]
  then
    # without argument, use the default index file
    parse_index "$GASH_MISSIONS/index.txt"
    return 0
      # when given a directory containing either a "bin" directory or a
      # "static.sh" script, this is a dummy mission. Just print the path
      # prefixed with a "!"
  fi

  while [ "$#" -gt 0 ]
  do
    local MISSION_DIR=$(REALPATH "$1")
    parse_mission "$MISSION_DIR"
    shift
  done
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
