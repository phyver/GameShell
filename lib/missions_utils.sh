#!/bin/bash

[ -z "$GSH_ROOT" ] && export GSH_ROOT="$(dirname "$BASH_SOURCE")/.." && source "$GSH_ROOT"/lib/common.sh

# create a script to call a mission executable with appropriate context:
# correct TEXTDOMAIN (for translations) and MISSION_DIR (to use data files)
copy_bin() {
  if [ "${#@}" -ne 2 ]
  then
    echo "Error: copy_bin requires 2 arguments." >&2
    return 1
  fi
  local source=$1
  case "$source" in
    "$GSH_MISSIONS"/* )
      local MISSION_DIR=$(dirname "$(REALPATH "$source")")
      local TEXTDOMAIN="$(textdomainname "$MISSION_DIR")"
      ;;
    *)
      echo "Error: source of copy_bin does not live in a mission directory." >&2
      return 1
      ;;
  esac
  if ! [ -f "$target" ] || ! [ -x "$target" ]
  then
    echo "Error: source of copy_bin is not an executable file." >&2
    return 1
  fi
  local target=$2
  if [ -d "$target" ]
  then
    target=$target/$(basename "$source")
  elif [ -e "$target" ]
  then
    echo "Error: target of copy_bin already exists." >&2
    return 1
  fi
  cat > "$target" <<EOH
#!/bin/bash
export MISSION_DIR=$MISSION_DIR
export TEXTDOMAIN=$DOMAIN
exec $source "\$@"
EOH
  chmod +x "$target"
}
export -f copy_bin

# add a hash to check for simple tampering on a file
# the hash signs the content of the file, a random number (added with the
# hash), and the file name (except when the option -noname is given)
# TODO: add possibility of giving a $source / $target to copy the result
# directly: ``sign_file source target``
sign_file() {
  local name="name"
  if [ "$1" = "-noname" ]
  then
    name=""
    shift
  fi
  if [ "${#@}" -ne 1 ] && [ "${#@}" -ne 2 ]
  then
    echo "Error: sign_file requires 1 or 2 arguments." >&2
    return 1
  fi
  local source=$1
  local target tempfile
  if [ "${#@}" -eq 2 ]
  then
    target=$2
    tempfile=$2
  else
    target=$source
    tempfile=$(mktemp --tmpdir="$(dirname "$source")" -t tmp-XXXXXX)
  fi
  local rd=$RANDOM
  local sum=$(sed "1i${name:+$(basename "$target")}#$rd" "$source" | checksum)
  sed "1i$sum#$rd" "$source" > "$tempfile"
  if [ "$tempfile" != "$target" ]
  then
    cat "$tempfile" > "$target"
    rm -f "$tempfile"
  fi
}
export -f sign_file


# check the hash on the first line of a file
# the hash is expected to sign the content of the file, a random number (given
# with the hash), and the file name (except when the option -noname is given)
check_file() {
  local name="name"
  if [ "$1" = "-noname" ]
  then
    name=""
    shift
  fi
  if [ "${#@}" -ne 1 ]
  then
    echo "Error: check_file requires 1 argument." >&2
    return 1
  fi
  local filename=$1
  if ! [ -r "$filename" ]
  then
    echo "Error: check_file argument is not a readable file." >&2
    return 1
  fi
  local filename=$1
  local rd=$(head -n1 "$filename" | cut -d'#' -f 2)
  local sum=$(head -n1 "$filename" | cut -d'#' -f 1)
  local check=$(sed "1c${name:+$(basename "$filename")}#$rd" "$filename" | checksum)
  [ "$sum" = "$check" ]
}
export -f check_file


# Print a progress bar as a flying bat: each character received on
# [stdin] makes the bat move forward. The animation stops when the
# end of file is reached.
progress_bat () {
  local BAT=('\b\b\b \,/' '\b\b\b \,/' '\b\b\b \,/' '\b\b\b \,/'
             '\b\b\b /`\' '\b\b\b /`\' '\b\b\b /`\' '\b\b\b /`\')

  # Print initial message.
  echo "While you are waiting, a bat flies by..."

  # Make progress for each character read on [stdin].
  local COUNT
  local L=${#BAT[@]}
  while read -rn1 C
  do
    echo -en "${BAT[$COUNT]}"
    COUNT=$(((COUNT+1)%L))
    # Slow down the animation a little bit.
    sleep 0.1
  done
  echo
}
export -f progress_bat

# vim: shiftwidth=2 tabstop=2 softtabstop=2
