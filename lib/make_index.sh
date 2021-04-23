#!/bin/bash

# generate an index of missions
parse_index() {
  local index_file=$1
  local dir

  case "$index_file" in
    "$GASH_MISSIONS"* )
      dir=$(dirname "$index_file")
      ;;
    *)
      dir=$(dirname "$index_file")
      dir=$GASH_MISSIONS
      ;;
  esac

  cat "$index_file" | while read line
  do
    path="$dir/$line"
    if [ -d "$path" ] && [ -f "$path/check.sh" ]
    then
      echo "$path"
    elif [ -f "$path" ]
    then
      parse_index "$path"
    else
      echo "        wrong line (parse_index): $path" >&2
    fi
  done
}

make_index() {
  GASH_MISSIONS="$1"
  shift
  if [ "$#" -eq 0 ]
  then
    parse_index "$GASH_MISSIONS/index.txt"
  fi

  while [ "$#" -gt 0 ]
  do
    local arg=$1
    if [ -d "$arg" ] && [ -f "$arg/check.sh" ]
    then
      echo "$arg"
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
