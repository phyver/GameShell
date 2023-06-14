#!/usr/bin/env sh

_compile() (

  if ! command -v pstree >/dev/null
  then
    echo "$(eval_gettext "The command 'pstree' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'psmisc')")" >&2
    return 1
  fi

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
    if [ "$GSH_MODE" != DEBUG ] || [ -z "$GSH_VERBOSE_DEBUG" ]
    then
      exec 1>/dev/null
      exec 2>/dev/null
    fi

    # under BSD, libintl is installed in /usr/local
    {
      echo "GSH: compiling process.c, first try" >&2
      echo $CC $CFLAGS "$MISSION_DIR/process.c" -o "$GSH_TMP/$(gettext "nice_fairy")"
      $CC $CFLAGS "$MISSION_DIR/process.c" -o "$GSH_TMP/$(gettext "nice_fairy")"
      echo $CC $CFLAGS "$MISSION_DIR/process.c" -o "$GSH_TMP/$(gettext "mischievous_imp")"
      $CC $CFLAGS "$MISSION_DIR/process.c" -o "$GSH_TMP/$(gettext "mischievous_imp")"
    } ||
    {
      echo "GSH: compiling process.c, second try"
      echo $CC $CFLAGS -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/process.c" -lintl -o "$GSH_TMP/$(gettext "nice_fairy")"
      $CC $CFLAGS -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/process.c" -lintl -o "$GSH_TMP/$(gettext "nice_fairy")"
      echo $CC $CFLAGS -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/process.c" -lintl -o "$GSH_TMP/$(gettext "mischievous_imp")"
      $CC $CFLAGS -I/usr/local/include/ -L/usr/local/lib "$MISSION_DIR/process.c" -lintl -o "$GSH_TMP/$(gettext "mischievous_imp")"
    } || { echo "compilation failed" >&2; return 1; }

    mkdir -p "$GSH_TMP/fairy/"
    $CC $CFLAGS -D WHO=FAIRY "$MISSION_DIR/spell.c" -lpthread -o "$GSH_TMP/fairy/$(gettext "spell")"

    mkdir -p "$GSH_TMP/imp/"
    $CC $CFLAGS -D WHO=IMP "$MISSION_DIR/spell.c" -lpthread -o "$GSH_TMP/imp/$(gettext "spell")"
  )

)

_install_script() (

  if ! [ -e "$MISSION_DIR/deps.sh" ] || ! command -v my_ps >/dev/null
  then
    # FIXME
    echo "missing dummy mission!"
    return 1
  fi
  mission_source "$MISSION_DIR/deps.sh" || return 1

  # we need to make sure the shebang is an actual path the a shell, otherwise
  # the process name will not be the filename
  sh=$(command -v sh)

  echo "#! $sh" > "$GSH_TMP/$(gettext "nice_fairy")"
  cat "$MISSION_DIR/nice_fairy.sh" >> "$GSH_TMP/$(gettext "nice_fairy")"
  chmod 755 "$GSH_TMP/$(gettext "nice_fairy")"

  mkdir -p "$GSH_TMP/fairy/"
  echo "#! $sh" > "$GSH_TMP/fairy/$(gettext "spell")"
  cat "$MISSION_DIR/fairy/spell.sh" >> "$GSH_TMP/fairy/$(gettext "spell")"
  chmod 755 "$GSH_TMP/fairy/$(gettext "spell")"

  echo "#! $sh" > "$GSH_TMP/$(gettext "mischievous_imp")"
  cat "$MISSION_DIR/mischievous_imp.sh" >> "$GSH_TMP/$(gettext "mischievous_imp")"
  chmod 755 "$GSH_TMP/$(gettext "mischievous_imp")"

  mkdir -p "$GSH_TMP/imp/"
  echo "#! $sh" > "$GSH_TMP/imp/$(gettext "spell")"
  cat "$MISSION_DIR/imp/spell.sh" >> "$GSH_TMP/imp/$(gettext "spell")"
  chmod 755 "$GSH_TMP/imp/$(gettext "spell")"
)


if _compile || _install_script
then
  unset -f _compile _install_script

  [ -n "$GSH_NON_INTERACTIVE" ] || set +o monitor  # do not monitor background processes
  # FIXME: for some unknown reason, this doesn't work if we start with this
  # mission directly!

  "$GSH_TMP/$(gettext "nice_fairy")" &
  echo $! > "$GSH_TMP/fairy.pid"

  "$GSH_TMP/$(gettext "mischievous_imp")" &
  echo $! > "$GSH_TMP/imp.pid"
else
  unset -f _compile _install_script
  false
fi
