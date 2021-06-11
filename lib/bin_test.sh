#!/bin/sh

### test the various utilities in GSH_ROOT/bin/ directory

test_mktemp() (
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
)


test_realpath() (
  tmp=$(mktemp -d)
  cd "$tmp"
  touch a
  rpa=$(realpath ./a)
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
  rpb=$(realpath b)
  if [ "$rpa" != "$rpb" ]
  then
    echo "Error: realpath doesn't resolve symbolic links." >&2
    return 1
  fi

  rm -rf "$tmp"
  return 0
)

test_checksum() {
  s=$(checksum "gsh" 2> /dev/null)
  case "$s" in
    b88968dc60b003b9c188cc503a457101b4087109) # sha1
      return 0
      ;;
    *)
      echo "Error: checksum doesn't return a correct checksum. (got '$s')" >&2
      return 1
    ;;
  esac
}

test_sign() (
  tmp=$(mktemp)
  echo "$(RANDOM)" > "$tmp"
  sign_file "$tmp"
  if ! check_file "$tmp"
  then
    echo "Error: inplace check_file didn't work on" >&2
    echo "<<<" >&2
    cat "$tmp" >&2
    echo ">>>" >&2
    rm -f "$tmp"
    return 1
  fi

  echo "$(RANDOM)" > "$tmp"
  tmp2=$(mktemp)
  sign_file "$tmp" "$tmp2"
  if ! check_file "$tmp2"
  then
    echo "Error: check_file didn't work on" >&2
    echo "<<<" >&2
    cat "$tmp" >&2
    echo "===" >&2
    cat "$tmp2" >&2
    echo ">>>" >&2
    rm -f "$tmp" "$tmp2"
    return 1
  fi

  rm -f "$tmp" "$tmp2"
  return 0
)

test_mktemp && test_realpath && test_checksum && test_sign
