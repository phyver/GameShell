#!/bin/bash

# generate an index of missions
parse_index() {
  local index_file=$(REALPATH "$1")
  local dir
  local short_index_file

  case "$index_file" in
    "$GASH_MISSIONS"* )
      dir=$(dirname "$index_file")
      short_index_file="\$GASH_MISSIONS/${index_file#$GASH_MISSIONS/}"
      ;;
    *)
      dir=$GASH_MISSIONS
      short_index_file="$index_file"
      ;;
  esac

  echo "# start of index file $short_index_file"
  cat "$index_file" | while read MISSION_DIR
  do
    case $MISSION_DIR in
      "" | "#"* )
        continue
        ;;
    esac
    path="$dir/$MISSION_DIR"
    if [ -d "$path" ] && [ -f "$path/check.sh" ]
    then
      echo "${path#$GASH_MISSIONS/}"
    elif [ -f "$path" ]
    then
      parse_index "$path"
    else
      echo "        wrong MISSION_DIR (parse_index): $path" >&2
    fi
  done
  echo "# end of index file $short_index_file"
}

make_index() {
  if [ "$#" -eq 0 ]
  then
    parse_index "$GASH_MISSIONS/index.txt"
  fi

  while [ "$#" -gt 0 ]
  do
    local arg=$(REALPATH "$1")
    if [ -d "$arg" ] && [ -f "$arg/check.sh" ]
    then
      echo "${arg#$GASH_MISSIONS/}"
    elif [ -f "$arg" ]
    then
      parse_index "$arg"
    elif  [ -d "$arg" ] && [ -f "$arg/index.txt" ]
    then
      parse_index "$arg/index.txt"
    else
      echo "        wrong arg (make_index): $arg" >&2
    fi
    shift
  done
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
