#!/bin/bash

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


function test_REALPATH() {
  local tmp=$(mktemp -d)
  cd "$tmp"
  touch a
  local rpa=$(REALPATH ./a)
  if [ -z "$rpa" ]
  then
    echo "Error: REALPATH returned the empty string." >&2
    return 1
  fi

  case "$rpa" in
    "$(REALPATH "$tmp")"* )
      ;;
    * )
    echo "Error: REALPATH didn't give an absolute path." >&2
    return 1
    ;;
  esac

  ln -s a b
  local rpb=$(REALPATH b)
  if [ "$rpa" != "$rpb" ]
  then
    echo "Error: REALPATH doesn't resolve symbolic links." >&2
    return 1
  fi

  rm -rf "$tmp"
  return 0
}

test_CHECKSUM() {
  case "$(CHECKSUM "gsh" 2> /dev/null)" in
    ae9fa6d4a2de36b4477d0381b9f0b795)
      # md5
      ;;
    b88968dc60b003b9c188cc503a457101b4087109)
      # sha1
      ;;
    1823761416)
      # cksum (POSIX)
      ;;
    *)
    echo "Error: CHECKSUM doesn't return a correct checksum." >&2
    return 1
    ;;
  esac
  return 0
}

test_mktemp && test_REALPATH && test_CHECKSUM
