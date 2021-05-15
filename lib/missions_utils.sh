#!/usr/bin/env bash

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
#!/usr/bin/env bash
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
  if ! [ -f "$source" ] || ! [ -r "$source" ]
  then
    echo "Error: sign_file file $source doesn't exist, or is not readable." >&2
    return 1
  fi

  local target tempfile
  if [ "${#@}" -eq 2 ]
  then
    target=$2
    [ -d "$target" ] && target=$target/$(basename "$source")
    tempfile=$target
  else
    target=$source
    tempfile=$(mktemp -t sign_file-XXXXXX)
  fi
  local rd=$RANDOM
  if [ -s "$source" ]
  then
    # POSIX sed requires '\' and a newline after "i" command
    local sum=$(sed -e $'1i\\\n'"${name:+$(basename "$target")}#$rd" "$source" | CHECKSUM)
    sed -e $'1i\\\n'"$sum#$rd" "$source" > "$tempfile"
  else
    local sum=$(echo "${name:+$(basename "$target")}#$rd" | CHECKSUM)
    echo -n "$sum#$rd" > "$tempfile"
  fi
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
    # POSIX sed requires '\' and a newline after "c" command
  local check=$(sed -e $'1c\\\n'"${name:+$(basename "$filename")}#$rd" "$filename" | CHECKSUM)
  [ "$sum" = "$check" ]
}
export -f check_file


# Print a progress bar. Each character received on [stdin] advances the
# animation. The animation stops when the end of file is reached. If no
# argument is provided, a random animal-themed progress bar is picked.
# Otherwise, the name of a specific progress bar can be passed as the
# first (and only) argument. Examples of value are 'bat' or 'snake'.
progress_bar () {
  local ANIMALS=('bat' 'snake' 'centipede' 'ant' 'fish' 'large-fish'
                 'fish-back-and-forth')
  local CHOICE

  local STR
  local PRE
  local POST
  local MSG

  if [ -z "$1" ]
  then
    # Pick a random animal-base progress bar.
    CHOICE=${ANIMALS[$RANDOM % ${#ANIMALS[@]} ]}
  else
    # Use specified progress bar.
    CHOICE="$1"
  fi

  case $CHOICE in
    "dots")
      # simple dots
      STR=('.')
      PRE=''
      POST='\n'
      MSG=''
      ;;

    "rotation")
      # rotating bar
      STR=('\b|' '\b/' '\b-' '\b\\')
      PRE='-'
      POST='\b \b'
      MSG=""
      ;;

    "bat")
      # flying bat
      STR=('\b\b\b \,/' '\b\b\b \,/' '\b\b\b \,/' '\b\b\b \,/'
           '\b\b\b /`\' '\b\b\b /`\' '\b\b\b /`\' '\b\b\b /`\')
      PRE='   '
      POST='\b\b\b   \r'
      MSG="$(gettext "While you are waiting, a bat flies by...")\n"
      ;;

    "snake")
      # slithering snake
      STR=('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b __/\__/\__/\<:>'
           '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b _/\__/\__/\_<:>'
           '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b /\__/\__/\__<:>'
           '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b \__/\__/\__/<:>'
           '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b \__/\__/\__/<:>')
      PRE='\__/\__/\__/<:>'
      POST='\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b               \r'
      MSG="$(gettext "While you are waiting, a snake slithers by...")\n"
      ;;

    "centipede")
      # crawling centipede
      STR=('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b ,`,`,`,`,`,`,`(:)'
           '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b `,`,`,`,`,`,`,(:)')
      PRE='`,`,`,`,`,`,`,(:)'
      POST='\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b                  \r'
      MSG="$(gettext "While you are waiting, a centipede crawls by...")\n"
      ;;

    "ant")
      # crawling ant
      STR=('\b\b\b\b\b >|<()')
      PRE='>|<()'
      POST='\b\b\b\b\b     \r'
      MSG="$(gettext "While you are waiting, an ant crawls by...")\n"
      ;;

    "fish")
      # Swimming fish (small)
      STR=('\b\b\b ><>')
      PRE='><>'
      POST='\b\b\b   \r'
      MSG="$(gettext "While you are waiting, a fish swims by...")\n"
      ;;

    "fish-back-and-forth")
      # Swimming fish (small) going back and forth
      STR=('\b\b\b ><>' '\b\b\b ><>' '\b\b\b ><>' '\b\b\b ><>'
           '\b\b\b ><>' '\b\b\b ><>' '\b\b\b ><>' '\b\b\b ><>'
           '\b\b\b   \b\b\b\b<><' '\b\b\b   \b\b\b\b<><'
           '\b\b\b   \b\b\b\b<><' '\b\b\b   \b\b\b\b<><'
           '\b\b\b   \b\b\b\b<><' '\b\b\b   \b\b\b\b<><'
           '\b\b\b   \b\b\b\b<><' '\b\b\b   \b\b\b\b<><')
      PRE='><>'
      POST='\b\b\b   \r'
      MSG="$(gettext "While you are waiting, you see a fish swimming in circles...")\n"
      ;;

    "large-fish")
      # Swimming fish (large)
      STR=("\b\b\b\b\b\b\b\b ><(((('>")
      PRE="><(((('>"
      POST='\b\b\b\b\b\b\b\b        \r'
      MSG="$(gettext "While you are waiting, a large fish swims by...")\n"
      ;;

    *)
      echo "Unknown progress kind."
      return 1
      ;;
  esac

  # Hide cursor.
  tput civis 2> /dev/null

  # Print initial message.
  echo -en "$MSG"

  # Make progress for each character read on [stdin].
  local COUNT
  local L=${#STR[@]}
  echo -en "$PRE"
  while read -rn1 C
  do
    echo -en "${STR[$COUNT]}"
    COUNT=$(((COUNT+1)%L))
    # Slow down the animation a little bit.
    sleep 0.1
  done
  echo -en "$POST"

  # Show cursor.
  tput cnorm 2> /dev/null
}
export -f progress_bar

random_string() {
  local n=$1
awk -v n=${n:-32} -v seed=$RANDOM 'BEGIN {
  srand(seed);
  chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  s = "";
  for(i=0;i<n;i++) {
    s = s "" substr(chars, int(rand()*62), 1);
  }
  print s
}'
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
