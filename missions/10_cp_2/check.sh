ENTRANCE="$(eval_gettext "\$GASH_HOME/Castle/Entrance")"
CABIN="$(eval_gettext "\$GASH_HOME/Forest/Cabin")"

check () {
  if [ ! -d "$ENTRANCE" ]
  then
    echo "$(gettext "Where is the castle's entrance?!")"
    return 1
  fi

  if [ ! -d "$CABIN" ]
  then
    echo "$(gettext "Where is the cabin?!")"
    return 1
  fi

  if ! diff -q "$GASH_TMP/entrance_contents" <(command ls "$ENTRANCE" | sort) > /dev/null
  then
    echo "$(gettext "You changed the contents of the entrance!")"
    return 1
  fi

  if command ls "$CABIN" | grep -Eq "_$(gettext "hay")|_$(gettext "gravel")|_$(gettext "garbage")"
  then
    echo "$(gettext "I only wanted the ornaments!")"
    return 1
  fi

  if ! diff -q <(grep "_$(gettext "ornament")" "$GASH_TMP/entrance_contents") \
    <(command ls "$CABIN" | sort | grep "_${ornement}") > /dev/null
  then
    echo "$(gettext "I wanted all the ornements!")"
    return 1
  fi

  return 0
}

if check
then
  rm -f "$GASH_TMP/entrance_contents"
  unset -f check
  unset ENTRANCE CABIN
  true
else
  rm -f "$GASH_TMP/entrance_contents"


  find "$ENTRANCE" \( -name "*$(gettext "ornament")" \
                   -o -name "*$(gettext "garbage")" \
                   -o -name "*$(gettext "gravel")" \
                   -o -name "*$(gettext "hay")" \) -print0 | xargs -0 rm -f

  if [ -d "$CABIN" ]
  then
  find "$CABIN"    \( -name "*$(gettext "ornament")" \
                   -o -name "*$(gettext "garbage")" \
                   -o -name "*$(gettext "gravel")" \
                   -o -name "*$(gettext "hay")" \) -print0 | xargs -0 rm -f
  fi

  unset -f check
  unset ENTRANCE CABIN
  false
fi

