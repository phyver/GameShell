#!/bin/bash

### test the various utilities in GSH_ROOT/bin/ directory

function test_mktemp() {
  local tmp
  if ! tmp=$(mktemp 2> /dev/null)
  then
    echo "Error: command 'mktemp' not working." >&2
    return 1
  fi
  if [ -z "$tmp" ]
  then
    echo "Error: command 'mktemp' returned the empty string." >&2
    return 1
  fi
  rm -f "$tmp"
}


function test_realpath() {
  local tmp=$(mktemp -d)
  cd "$tmp"
  touch a
  local rpa=$(realpath ./a)
  if [ -z "$rpa" ]
  then
    echo "Error: realpath returned the empty string." >&2
    return 1
  fi

  case "$rpa" in
    "$(realpath "$tmp")"* )
      ;;
    * )
    echo "Error: realpath didn't give an absolute path." >&2
    return 1
    ;;
  esac

  ln -s a b
  local rpb=$(realpath b)
  if [ "$rpa" != "$rpb" ]
  then
    echo "Error: realpath doesn't resolve symbolic links." >&2
    return 1
  fi

  rm -rf "$tmp"
  return 0
}

test_checksum() {
  s=$(checksum "gsh" 2> /dev/null)
  case "$s" in
    458d35da7471f475ed925a8191fdd7f8) # md5
      return 0
      ;;
    868823a35f2107344c92f63751317a814860dbe8) # sha1
      return 0
      ;;
    3614433770) # cksum (POSIX)
      return 0
      ;;
    *)
      echo "Error: checksum doesn't return a correct checksum. (got '$s')" >&2
      return 1
    ;;
  esac
}

test_mktemp && test_realpath && test_checksum
