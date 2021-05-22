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
  case "$(checksum "gsh" 2> /dev/null)" in
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
    echo "Error: checksum doesn't return a correct checksum." >&2
    return 1
    ;;
  esac
  return 0
}

test_mktemp && test_realpath && test_checksum
