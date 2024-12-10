#!/usr/bin/env sh

_compile() (
  if command -v gcc >/dev/null
  then
    CC=gcc
    if [ "$GSH_MODE" = DEBUG ]
    then
      CFLAGS="-std=c99 -Wall -Wextra -pedantic"
    fi
  elif command -v clang >/dev/null
  then
    CC=clang
    if [ "$GSH_MODE" = DEBUG ]
    then
      CFLAGS="-std=c99 -Wall -Wextra -pedantic"
    fi
  elif command -v c99 >/dev/null
  then
    CC=c99
  elif command -v cc >/dev/null
  then
    CC=cc
  else
    return 1
  fi

  (
      # in debug mode, don't hide messages
      if [ "$GSH_MODE" != DEBUG ] || [ -z "$GSH_VERBOSE_DEBUG" ]
      then
        exec 1>/dev/null
        exec 2>/dev/null
      fi
      $CC $CFLAGS "$MISSION_DIR/spell.c" -o "$GSH_TMP/$(gettext "spell")"
  ) || { echo "compilation failed" >&2; return 1; }
  return 0
)

_install_script() (
  if ! [ -e "$MISSION_DIR/deps.sh" ] || ! command -v my_ps >/dev/null
  then
    # FIXME
    echo "missing dummy mission!"
    return 1
  fi
  mission_source "$MISSION_DIR/deps.sh" || return 1

  # make sure the shebang for the spell.sh script is a real path to sh
  # otherwise, ps will not use the filename as the process name...
  sh=$(command -v sh)
  echo "#! $sh" > "$GSH_TMP/$(gettext "spell")"
  cat "$MISSION_DIR/spell.sh" >> "$GSH_TMP/$(gettext "spell")"
  chmod +x "$GSH_TMP/$(gettext "spell")"
)

if _compile || _install_script
then
  unset -f _compile _install_script

  [ -n "$GSH_NON_INTERACTIVE" ] || set +o monitor  # do not monitor background processes
  # FIXME: for some unknown reason, this doesn't work if we start with this
  # mission directly!

  # set +b 2>/dev/null    # POSIX, but not supported by zsh

  "$GSH_TMP/$(gettext "spell")" &
  echo $! > "$GSH_TMP"/spell.pid
else
  unset -f _compile _install_script
  false
fi
